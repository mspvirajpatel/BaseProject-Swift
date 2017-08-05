
use_frameworks!
target 'BaseProject’ do
pod 'Alamofire’, '~> 4.0'
pod 'Kingfisher', '~> 3.2'
pod 'Toast-Swift', '~> 2.0'

pod 'GRDB.swift'
pod 'DKImagePickerController'
pod 'LGDrawer'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
