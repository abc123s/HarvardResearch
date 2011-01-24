class Job < ActiveRecord::Base
  # Jobs have many applications but belong to a "user" (professor)
  has_many :submissions
  has_many :favorites
  belongs_to :user
  
  #named_scope :with_department, lambda {|department| { :conditions => {User.find(:user_id).department => department} } }

  # validations for inputs
  attr_accessible :title, :funding, :position, :location, :duration, :description, :user_id
  
  # search method for description
  def self.searchdescription(search)
    if search
      where('description LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
     validates :funding, :length => { :maximum => 200 }
     validates_length_of :position, :maximum => 50
     validates :location, :length => { :maximum => 50 }
     validates :duration, :length => { :maximum => 50 }
     validates :description, :presence => true
     validates_length_of :description, :allow_blank => true, :maximum => 5000
     validates_length_of :title, :allow_blank => true, :maximum => 50
     validates :title, :presence => true
end
