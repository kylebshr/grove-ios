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
        pod 'Digits'

    target 'GroveTests' do
        inherit! :search_paths

        pod 'Quick'
        pod 'Nimble'
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
end
