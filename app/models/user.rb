class User < ActiveRecord::Base
  # Users can file many submissions and post many jobs (depending on status)
  has_many :submissions
  has_many :jobs

  # arrays for drop-down form lists
  YEARS = [2011, 2012, 2013, 2014]
  CONCENTRATIONS =  ["African and African American Studies", "Anthropology", "Applied Mathematics", "Astrophysics",
                    "Biomedical Engineering", "Chemical and Physical Biology", "Chemistry", "Chemistry and Physics",
                    "Classics", "Computer Science", "Earth and Planetary Science", "East Asian Studies", "Economics",
                    "Engineering Sciences", "English", "Environmental Science and Public Policy",
                    "Folklore and Mythology", "Germanic Languages and Literatures", "Government", "History",
                    "History and Literature", "History of Art and Architecture", "History of Science",
                    "Human Developmental and Regenerative Biology", "Human Evolutionary Biology", "Linguistics",
                    "Literature", "Mathematics", "Molecular and Cellular Biology", "Music",
                    "Near Eastern Languages and Civilizations", "Neurobiology", "Organismic and Evolutionary Biology",
                    "Philosophy", "Physics", "Psychology", "Comparative Study of Religion",
                    "Romance Languages and Literatures", "Sanskrit and Indian Studies",
                    "Slavic Languages and Literatures", "Social Studies", "Sociology", "Special Concentration",
                    "Statistics", "Visual and Environmental Studies", "Studies of Women, Gender, and Sexuality"]
  SECONDARYS = ["African and African American Studies", "Anthropology", "Archaeology", "Astrophysics",
               "Celtic Languages and Literatures", "Chemistry", "Classics", "Computer Science", "Dramatic Arts",
               "Earth and Planetary Science", "East Asian Studies", "Economics", "English",
               "Environmental Science and Public Policy", "Ethnic Studies", "Folklore and Mythology",
               "Germanic and Scandinavian Studies", "Global Health and Health Policy", "Government", "History",
               "History and Literature", "History of Art and Architecture", "History of Science",
               "Human Evolutionary Biology", "Linguistics", "Literature", "Mathematical Sciences", "Medieval Studies",
               "Microbial Sciences", "Mind/Brain/Behavior", "Molecular and Cellular Biology", "Music",
               "Near Eastern Languages and Civilizations", "Neurobiology", "Organismic and Evolutionary Biology",
               "Philosophy", "Physics", "Psychology", "Comparative Study of Religion",
               "Romance Languages and Literatures", "Russia, Eastern Europe, and Central Asia",
               "Sanskrit and Indian Studies", "Slavic Languages and Literatures", "Sociology", "Statistics",
               "Visual and Environmental Studies", "Studies of Women, Gender, and Sexuality"]

  # change display names of certain variables to "humanized" versions
  HUMANIZED_ATTRIBUTES = { :email => "E-mail address", :firstname => "First name", :lastname => "Last name",
                           :phone => "Phone number", :gpa => "GPA" }
  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end


  # make password a "virtual attribute", also make attributes accessible
  attr_accessor :password
  attr_accessible :firstname, :lastname, :email, :phone, :year, :concentration, :secondary, :gpa, :resume,
                  :location, :interests, :title, :department, :password, :password_confirmation, :usertype

    # Regular expression for email format verification
    email_regex = /\A[\w+\-.]+@(fas.harvard.edu|college.harvard.edu)/

    # Validations for attributes
    validates :firstname, :presence => true,
                          :length   => { :maximum => 50 }
    validates :lastname, :presence   => true,
                         :length     => { :maximum => 50 },
                         :uniqueness => { :scope => :firstname }
    validates :email, :presence   => true,
                      :uniqueness => { :case_sensitive => false },
                      :length     => { :maximum => 50 }
    validates_format_of :email, :allow_blank => true, :with => email_regex
    validates_numericality_of :phone, :allow_blank => true
    validates :phone, :length       => { :maximum => 15 }

    # Student-only validations
    validates_numericality_of :gpa, :allow_blank => true
    validates_length_of :resume, :maximum => 3000

    # Professor? method to determine if user is a professor
    def professor?
      :usertype == 1
    end

    # Professor-only validations
    validates_presence_of :title, :if => :professor?
    validates :title, :length => { :maximum => 300 }
    validates :location, :length => { :maximum => 300 }
    validates_presence_of :department, :if => :professor?
    validates :department, :length => { :maximum => 300 }
    validates :interests, :length => { :maximum => 3000}

    # Confirmation validations for password
    validates :password, :presence     => true,
                         :confirmation => true
    validates_length_of :password, :allow_blank => true, :within => 6..40

    before_save :encrypt_password
      # Return true if the user's password matches the submitted password (uses stored salt).
      def has_password?(submitted_password)
        encrypted == encrypt(submitted_password)
      end

      # Return nil if email not found, return user only if password is right, else auto-return nil
      def self.authenticate(email, submitted_password)
        user = find_by_email(email)
        return nil  if user.nil?
        return user if user.has_password?(submitted_password)
      end

      # Return user if user/salt matches the cookie, else returns nil
      def self.authenticate_with_salt(id, cookie_salt)
        user = find_by_id(id)
        (user && user.salt == cookie_salt) ? user : nil
      end

      private
        # Create salt if new user (via call to Active Record's method),
        # then encrypt password accordingly
        def encrypt_password
          self.salt = make_salt if new_record?
          self.encrypted = encrypt(password)
        end

        # Encrypt password with salt and inputted password
        def encrypt(string)
          secure_hash("#{salt}--#{string}")
        end

        # Creation of salt, unique string for user dependent on time of account creation and password
        def make_salt
          secure_hash("#{Time.now.utc}--#{password}")
        end

        # Use SHA2 hash function
        def secure_hash(string)
          Digest::SHA2.hexdigest(string)
        end
end
