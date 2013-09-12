class User < ActiveRecord::Base
  has_secure_password

  
  has_many :event_attendances

  has_many :created_events , class_name: "Event", foreign_key: "user_id"  
  has_many :attended_events, through: :event_attendances, :source => :event

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validate :email_format

  def email_format
    if email.match(/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/) == nil
    	errors.add(:email, "must be a valid email address (* @ *.*)")
    end
  end

end
