//
//  LoginViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/28/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import CoreLocation
import SafariServices
import DigitsKit

class LoginViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var imageConstraints: [NSLayoutConstraint]!


    // MARK: Properties

    let privacyURL = NSURL(string: "http://kylebashour.com/grove/privacy")!
    let termsURL = NSURL(string: "http://kylebashour.com/grove/terms")!
    let facebookURL = NSURL(string: "https://grove-api.herokuapp.com/login/facebook")!

    let locationManager = CLLocationManager()
    let imageTime = 4.5
    let fadeTime = 1.0
    let constraintVariance: Int32 = 50
    let imageNames: [String] = {
        return (1...10).map { "login\($0)" }
    }()

    var currentImageName: String = "login4"
    var timer: NSTimer?


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up a few things
        requestLocationPermissionIfNeeded()
        setUpNotificationCenter()
        setUpCycleImage()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        timer = NSTimer.scheduledTimerWithTimeInterval(imageTime, target: self, selector: #selector(cycleImage), userInfo: nil, repeats: true)

        imageView.image = nextRandomImage()
        doKenBurnsEffect()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        timer?.invalidate()
    }


    // MARK: IBActions

    @IBAction func facebookButtonTapped(sender: UIButton) {
        presentDigitsLogin()
    }

    @IBAction func privacyButtonTapped(sender: UIButton) {
        presentSafariVCWithURL(privacyURL)
    }

    @IBAction func termsButtonTapped(sender: UIButton) {
        presentSafariVCWithURL(termsURL)
    }


    // MARK: Helpers

    func presentSafariVCWithURL(url: NSURL) {
        let vc = SFSafariViewController(URL: url)
        presentViewController(vc, animated: true, completion: nil)
    }

    // Listen for login or login failed notifications
    func setUpNotificationCenter() {
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(login), name: AppDelegate.loginNotification, object: nil)
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(loginFailed), name: AppDelegate.loginFailedNotification, object: nil)
    }

    func presentDigitsLogin() {

        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        let appearance = DGTAppearance()

        appearance.accentColor = .darkerGreen()
        appearance.backgroundColor = .whiteColor()
        configuration.appearance = appearance

        Digits.sharedInstance().authenticateWithViewController(self, configuration: configuration) { (session, error) in
            if let error = error {
                print(error)
            } else if let session = session {
                print(session)
            }
        }
    }

    // Called by the login notification
    @objc func login() {
        dismissViewControllerAnimated(true) { [weak self] _ in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // Called by login failed notification
    @objc func loginFailed() {
        dismissViewControllerAnimated(true) { [weak self] _ in
            self?.showNetworkErrorAlert()
        }
    }

    // Ask for location use permission if not granted
    func requestLocationPermissionIfNeeded() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // For the initial set up of the first image
    func setUpCycleImage() {
        changeCycleImageConstraints()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    // Animates the image changes
    func cycleImage() {

        doKenBurnsEffect()

        UIView.transitionWithView(imageView, duration: fadeTime, options: .TransitionCrossDissolve,
            animations: { _ in
                self.imageView.image = self.nextRandomImage()
            }, completion: nil
        )
    }

    // Approximates kens burns by animating edge constraints
    func doKenBurnsEffect() {
        UIView.animateWithDuration(imageTime + fadeTime, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut],
            animations: { _ in
                self.changeCycleImageConstraints()
                self.view.layoutIfNeeded()
            }, completion: nil
        )
    }

    // Set all the constraints to random new ones
    func changeCycleImageConstraints() {
        imageConstraints.forEach {
            $0.constant = CGFloat(rand() % constraintVariance)
        }
    }

    func nextRandomImage() -> UIImage? {
        let filteredNames = imageNames.filter { $0 != currentImageName }
        currentImageName = filteredNames[Int(rand()) % filteredNames.count]
        return UIImage(named: currentImageName)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
