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

class LoginViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var imageConstraints: [NSLayoutConstraint]!


    // MARK: Properties

    let locationManager = CLLocationManager()
    let imageTime = 6.0
    let fadeTime = 1.0
    let constraintVariance: Int32 = 50
    let images = [R.image.login1(), R.image.login2(), R.image.login3(), R.image.login4(), R.image.login5()]

    var currentImage = 0
    var timer: NSTimer?


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up a few things
        requestLocationPermissionIfNeeded()
        setUpNotificationCenter()
        setUpCycleImage()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Cycle the
        timer = NSTimer.scheduledTimerWithTimeInterval(imageTime, target: self, selector: #selector(cycleImage), userInfo: nil, repeats: true)

        // Call this for the first image
        doKenBurnsEffect()
    }


    // MARK: IBActions

    @IBAction func facebookButtonTapped(sender: UIButton) {
        let vc = SFSafariViewController(URL: NSURL(string: "https://grove-api.herokuapp.com/login/facebook")!)
        presentViewController(vc, animated: true, completion: nil)
    }


    // MARK: Helpers

    // Listen for login or login failed notifications
    func setUpNotificationCenter() {
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(login), name: AppDelegate.loginNotification, object: nil)
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(loginFailed), name: AppDelegate.loginFailedNotification, object: nil)
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
        view.layoutIfNeeded()
    }

    // Animates the image changes
    func cycleImage() {

        doKenBurnsEffect()

        currentImage += 1

        UIView.transitionWithView(imageView, duration: fadeTime, options: .TransitionCrossDissolve,
            animations: { _ in
                self.imageView.image = self.images[self.currentImage % self.images.count]
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

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
