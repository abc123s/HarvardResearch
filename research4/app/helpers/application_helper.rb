module ApplicationHelper

  # A helper for the website logo
  def logo
     image_tag("logo.png", :alt => "HarvardResearch", :class => "round")
  end

end
