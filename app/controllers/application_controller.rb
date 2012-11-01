class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
 

	def default_url_options
		if Rails.env.production?
		{:host => "gpen.phillyecocity.com"}
		else  
		{}
		end
	end

  
end
