require 'nokogiri'
require 'open-uri'

class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  
  # initialize all the top 100 players with stats
  def self.init_players
    Player.get_rankings
    Player.get_ytd_points(100)
    Player.get_ytd_points(200)
    Player.all_player_stats
  end

  # update the players stats, and get the new top 100
  def self.update_players
    Player.update_rankings
    Player.all_player_stats
    Player.get_ytd_points(100)
    Player.get_ytd_points(200)
  end
  
  # get the stats for all of the top 100 (using threads)
  def self.all_player_stats
    threads = []
    Player.find_each do |player|
      threads << Thread.new do
        this_thread = Thread.current
        this_thread[:content] = open("http://m.atpworldtour.com#{player.link_name}") { |page| page.read }
        this_thread[:player_id] = player.id
      end
    end
    threads.map do |thread|
      thread.join
      player = Player.find(thread[:player_id])
      player.get_stats(thread[:content])
    end
  end
  
  # get the year-to-date points for the top 100
  def self.get_ytd_points(ranks)
    if ranks == 100
      # get the top 100
      url = "http://m.atpworldtour.com/Rankings/YTD-Singles.aspx"
    elsif ranks == 200
      # get 101-200
      url = "http://m.atpworldtour.com/Rankings/YTD-Singles.aspx?r=101#"
    else
      puts "Invalid"
      return
    end
    
    page = Nokogiri::HTML(open(url))
    
    player_links = page.css(".playerName").css("a").map do |tag|
      tag["href"]
    end
    player_points = page.css(".playerPoints").map do |tag|
      Integer(tag.text.sub(',', ''))
    end
    
    data = player_links.zip(player_points)
    data.each do |row|
      player = Player.find_by_link_name(row[0])
      if player
        player.update_atp_points(row[1])
        player.save
      end
    end
    
  end
  
  # get the top 100 ranked players
  def self.get_rankings
    url = "http://m.atpworldtour.com/Rankings/Singles.aspx"
    page = Nokogiri::HTML(open(url))
    player_links = page.css(".playerName").css("a")
    player_countries = page.css(".playerNameNat").map { |el| el.text.delete('()') }
    player_links.each_with_index do |link, index|
      new_player = Player.new
      new_player.link_name = link["href"]
      new_player.country = player_countries[index]
      new_player.atp_points = 0
      new_player.save
      new_player
    end
  end
  
  # update the top 100
  def self.update_rankings
    url = "http://m.atpworldtour.com/Rankings/Singles.aspx"
    page = Nokogiri::HTML(open(url))
    player_links = page.css(".playerName").css("a")
    player_countries = page.css(".playerNameNat").map { |el| el.text.delete('()') }
    links = player_links.map do |link|
      link["href"]
    end
    
    # remove players no longer in the top 100
    Player.find_each do |player|
      if not links.include?(player.link_name)
        player.destroy
      end
    end
    
    # add new players in the top 100
    old_links = Player.all.map { |player| player.link_name }
    links.each_with_index do |link, index|
      if not old_links.include?(link)
        new_player = Player.new
        new_player.link_name = link
        new_player.country = player_countries[index]
        new_player.atp_points = 0
        new_player.save
      end
    end
    
  end
  
  # for the Player, get wins, losses, and rank from the ATP website
  def get_stats(html_page)
    #player_url = "http://m.atpworldtour.com#{self.link_name}"
    player_html = Nokogiri::HTML(html_page)
    
    player_name = player_html.css(".playerDetailsName")[0].css("strong").text
    
    table = player_html.css(".psdCurrent")
    
    # check which table is singles stats
    singles_table = table.select do |t|
      title = t.ancestors[3].previous_sibling.text
      title.downcase.include? "singles"
    end
    
    singles_table = singles_table[0]
    current_rank = Integer(singles_table.css(".psdrRank")[0].text)
    win_loss = singles_table.css(".psdWL")[0].text.split('-')
    season_wins = Integer(win_loss[0])
    season_losses = Integer(win_loss[1])
    
    self.name = player_name
    self.rank = current_rank
    self.wins = season_wins
    self.losses = season_losses
    self.save
  end
  
  # get the ATP points and add the total to teams
  def update_atp_points(points)
    if points == 0
      self.atp_points = 0
      self.save
      return
    end
    
    old_points = self.atp_points
    diff = points - old_points
    puts "Points diff for #{self.name}: #{diff}"
    self.atp_points = points
    self.save
    self.teams.each do |team|
      team.add_points(diff)
    end
  end
  
  def full_link
    "http://www.atpworldtour.com#{self.link_name}"
  end
  
end
