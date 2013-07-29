class League < ActiveRecord::Base
  has_many :teams
  validates :name, :presence => true, :uniqueness => true
  validate :future_draft_date
  
  def set_draft_time(date, time)
    self.draft_time = "#{date} #{time}"
  end
  
  def get_standings
    self.teams.order("total_points DESC")
  end
  
  # make sure the draft date is in the future
  def future_draft_date
    if self.draft_time.past?
      errors.add(:draft_time, "must be in the future")
    end
  end
  
end
