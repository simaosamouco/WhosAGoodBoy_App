# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end

target 'SwordHealthChallenge' do
 
  use_frameworks!

  
	pod 'Alamofire', '5.7.1'
	pod 'SnapKit', '~> 5.6.0'
	pod 'RxSwift', '6.5.0'
	pod 'RxCocoa', '6.5.0'
	pod 'RealmSwift', '10.42.0'

  target 'SwordHealthChallengeTests' do
    inherit! :search_paths
	pod 'RealmSwift', '10.42.0'
  end

  

end