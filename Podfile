# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'Marvel' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'FSPagerView', '~> 0.8'

  
  post_install do |installer|
      installer.generated_projects.each do |project|
        project.targets.each do |target|
          target.build_configurations.each do |config|
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          end
        end
      end
    end

  target 'MarvelTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MarvelUITests' do
    # Pods for testing
  end

end
