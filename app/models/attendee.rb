class Attendee < ActiveRecord::Base
  validates :user_id, presence: true
  validates :event_id, presence: true

  belongs_to :users
  belongs_to :events
end
