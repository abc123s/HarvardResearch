class Favorite < ActiveRecord::Base
belongs_to :user
belongs_to :job

attr_accessible :favorite, :job_id, :user_id

end
