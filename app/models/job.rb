class Job < ActiveRecord::Base
  # Jobs have many applications but belong to a "user" (professor)
  has_many :submissions
  belongs_to :user

  # validations for inputs
  attr_accessible :title, :funding, :position, :location, :duration, :description
     validates :funding, :length => { :maximum => 200 }
     validates_length_of :position, :maximum => 50
     validates :location, :length => { :maximum => 50 }
     validates :duration, :length => { :maximum => 50 }
     validates :description, :presence => true
     validates_length_of :description, :allow_blank => true, :maximum => 5000
     validates_length_of :title, :allow_blank => true, :maximum => 50
     validates :title, :presence => true
end
