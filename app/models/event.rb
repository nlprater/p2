class Event < ActiveRecord::Base
  has_many :event_attendances  
  belongs_to :user
end
9