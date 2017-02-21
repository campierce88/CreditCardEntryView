Pod::Spec.new do |s|

s.name         = "CreditCardEntryView"
s.version      = "0.1.1"
s.summary      = "A customizable view for entry of credit card information that uses Stripe for validation."
s.description  = "This pod creates a IBDesignable view for the entry and vadiation of credit card information. This pod depends on Stripe. You can customize the appearance of the entry fields."
s.homepage     = "https://github.com/campierce88/CreditCardEntryView.git"
s.license      = { :type => "Apache", :file => "LICENSE" }
s.author             = "Cameron Pierce"
s.social_media_url   = "http://twitter.com/campierce88"
s.platform     = :ios
s.ios.deployment_target = '9.0'
s.source       = { :git => "https://github.com/campierce88/CreditCardEntryView.git", :tag => "#{s.version}" }
s.source_files = "CreditCardEntryView/**/*.{swift}"
s.resources    = ['CreditCardEntryView/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,imageset,json}']
s.framework    = "UIKit"
s.dependency 'Stripe'

end
