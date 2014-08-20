OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['SNL_FB_APP_ID'], ENV['SNL_FB_APP_SECRET'],
    :scope => 'email,public_profile', :display => 'popup'
end
