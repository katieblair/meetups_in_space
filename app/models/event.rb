class Event < ActiveRecord::Base
  has_many :attendees
  has_many :users, through: :attendees
  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
end
