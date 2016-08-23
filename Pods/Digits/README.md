Part of [Twitter Fabric](https://www.fabric.io), [Digits](https://get.digits.com) empowers your users to sign up or sign in to your app using their phone numbers -- an identity that they already use everyday -- without the pain of dealing with passwords.

## Setup

1. Visit [https://fabric.io/sign_up](https://fabric.io/sign_up) to create your Fabric account and to download Fabric.app.

1. Open Fabric.app, login and select the Digits SDK.

    ![Fabric Plugin](https://docs.fabric.io/ios/cocoapod-readmes/cocoapods-fabric-plugin.png)

1. The Fabric app automatically detects when a project uses CocoaPods and gives you the option to install via the Podfile or Xcode.

	![Fabric Installation Options](https://docs.fabric.io/ios/cocoapod-readmes/cocoapods-pod-installation-option.png)

1. Select the Podfile option and follow the installation instructions to update your Podfile. **Note**: the TwitterCore pod will be automatically pulled in as a dependency for Digits.

	```
	pod 'Fabric'
	pod 'Digits'
	```

1. Run `pod install`

1. Add a Run Script Build Phase and build your app.

	![Fabric Run Script Build Phase](https://docs.fabric.io/ios/cocoapod-readmes/cocoapods-rsbp.png)

1. Initialize the SDK by inserting code outlined in the Fabric.app.

1. Run your app to finish the installation.

## Resources

* [Documentation](https://docs.fabric.io/ios/digits/index.html)
* [Forums](https://twittercommunity.com/c/fabric/digits)
* [Website](http://get.digits.com/)
* Follow us on Twitter: [@fabric](https://twitter.com/fabric) and [@digits](https://twitter.com/digits)
* Follow us on Periscope: [Fabric](https://periscope.tv/fabric) and [TwitterDev](https://periscope.tv/twitterdev)
