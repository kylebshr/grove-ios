platform :ios, '9.0'
inhibit_all_warnings!

target 'Grove' do
    use_frameworks!

        pod 'Alamofire' # yes
        pod 'AlamofireNetworkActivityIndicator' # yes
        pod 'RealmSwift' # yes
        pod 'RealmMapView' # no
        pod 'ModelMapper'
        pod 'AsyncSwift'
        pod 'R.swift'
        pod 'Kingfisher'
        pod 'JLRoutes'
        pod 'SSKeychain'
        pod 'PKHUD'
        pod 'INTULocationManager'
        pod 'BNRDynamicTypeManager'
        pod 'SwiftyBeaver'
        pod 'Fabric'
        pod 'Crashlytics'
        pod 'Quick'
        pod 'Nimble'

    target 'GroveTests' do
        inherit! :search_paths
    end

    target 'GroveUITests' do
        inherit! :search_paths
    end

end

post_install do |installer|

    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-Grove/Pods-Grove-acknowledgements.plist', 'Grove/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

    # bitrise codesigning fix
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
    installer.aggregate_targets.each do |target|
        # Without this hack resources from module tests won't make it to the unit test bundle
        # See https://github.com/CocoaPods/CocoaPods/issues/4752
        if target.name == "Pods-GroveTests" then
            %x~ sed -i '' 's/CONFIGURATION_BUILD_DIR/TARGET_BUILD_DIR/g' '#{target.support_files_dir}/#{target.name}-resources.sh' ~
        end
    end
end
