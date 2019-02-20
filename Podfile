# Uncomment the next line to define a global platform for your project

project_target_version = '11.4'
platform :ios, :deployment_target => project_target_version

inhibit_all_warnings!

target 'Ubcoin' do
	pod 'AFNetworking'
    pod 'TTTAttributedLabel'
    pod 'Crashlytics'
    pod 'DGActivityIndicatorView'
    pod 'Fabric'
    pod 'MiniLayout'
    pod 'GoogleMaps'
    pod 'FBSDKCoreKit'
    pod 'ImageSlideshow'
    pod 'INTULocationManager'
    pod 'QRCodeReaderViewController'
    pod 'UBGeneralClasses', :git => 'https://github.com/ubank/ub_general_classes_iOS.git'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = project_target_version
        end
    end
end
