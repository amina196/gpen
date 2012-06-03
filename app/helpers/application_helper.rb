module ApplicationHelper
	include SessionsHelper

  # Returns the full title on a per-page basis.       			# Documentation comment
  def full_title(page_title)                          			# Method definition
    base_title = "Greater Philadelphia Environmental Network"  	# Variable assignment
    if page_title.empty?                              			# Boolean test
      base_title                                      			# Implicit return
    else
      "#{base_title} | #{page_title}"                 			# String interpolation
    end
  end
end

