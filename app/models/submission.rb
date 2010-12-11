class Submission < ActiveRecord::Base
  # each submission belongs to an applicant as well as a job listing
  belongs_to :user
  belongs_to :job

  # change to "humanized" display version
  HUMANIZED_ATTRIBUTES = { :coverletter => "Cover letter" }
  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # validation for coverletter
  attr_accessible :coverletter, :job_id
    validates :coverletter, :length => { :maximum => 3000}
end
