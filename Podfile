source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'CreditCardEntryView' do
  # Pods for CreditCardEntryView
  pod 'Stripe'
  pod 'CardIO'
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-CreditCardEntryView/Pods-`CreditCardEntryView-Acknowledgements.plist', 'Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
