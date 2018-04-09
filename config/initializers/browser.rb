Rails.configuration.middleware.use Browser::Middleware do
	if browser.ie?([">10"])
		redirect_to browserupdate_path
	end
end