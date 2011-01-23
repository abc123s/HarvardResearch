module ApplicationHelper

  # A helper for the website logo
  def logo
     image_tag("logo.png", :alt => "HarvardResearch", :class => "round")
  end

  # Helper for sorting tables
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current
      #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction ==
      "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => 
      direction, :page => nil), {:class => css_class}
  end

end
