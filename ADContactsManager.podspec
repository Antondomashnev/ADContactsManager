Pod::Spec.new do |s|
  
  s.name         = 'ADContactsManager'
  s.version      = '1.0.0'
  s.summary      = "Easy-to-use wrapper for both Contacts and AddressBook frameworks"

  s.description  = <<-DESC
                    Easy-to-use wrapper for both Contacts and AddressBook frameworks written in objective-c
                   DESC

  s.license      = { :type => "MIT", :file => "LICENSE" }             
  s.homepage     = 'https://github.com/Antondomashnev/ADContactsManager'
  s.author       = { 'Anton Domashnev' => 'antondomashnev@gmail.com' }

  s.source       = { :git => "https://github.com/Antondomashnev/ADContactsManager.git", :tag => s.version.to_s}
  s.platform = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source_files = 'ADContactsManager/**/**/*.{h,m}'
  
end
