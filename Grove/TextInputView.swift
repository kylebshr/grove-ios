//
//  TextInputView.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import Async

class TextInputView: UIView, UITextViewDelegate {


    // MARK: IBOutlets

    @IBOutlet private var textField: UITextField!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var countLabel: UILabel!
    @IBOutlet private var sendButton: UIButton!
    @IBOutlet weak var sendButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!


    // MARK: Properties

    private let separator = UIView()
    private let numberOfCharactersAllowed = 180
    private var loading = false
    private var loadingIndicatorBlock: Async?
    private let autoLayoutEdgeHeight: CGFloat = 8

    var text: String {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
            // this doesn't get called when we set .text
            textViewDidChange(textView)
        }
    }


    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        // Disable by default
        sendButton.enabled = false

        // For autoresizing
        autoresizingMask = .FlexibleHeight
        translatesAutoresizingMaskIntoConstraints = false

        // Set the delegate so we can keep track of changes
        textView.delegate = self

        // This is annoying to to in IB (can't set height to 0.5)
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        separator.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        separator.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        separator.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(0.5).active = true
        separator.backgroundColor = .separatorColor()
    }

    override func updateConstraints() {

        let oldText = textView.text

        textView.text = "Aa"
        sendButtonHeightConstraint.constant = textViewHeight()
        textView.text = oldText

        super.updateConstraints()
    }


    // MARK: Helpers

    // Calculate a size based on the textview
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: self.bounds.width, height: textViewHeight())
    }

    // Pass forward a target for the send button
    func addTarget(target: AnyObject?, action: Selector) {
        sendButton.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }

    // Show the loading indicator
    func setLoading(loading: Bool) {

        loadingIndicatorBlock?.cancel()

        self.loading = loading

        // Show with a delay - if we're done loading after .3 seconds, the spinner won't flicker on and off
        loadingIndicatorBlock = Async.main(after: 0.3) { [weak self] in
            self?.sendButton.hidden = loading
            loading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }

    func textViewHeight() -> CGFloat {
        return textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.max)).height + autoLayoutEdgeHeight
    }

    // MARK: UITextViewDelegate

    func textViewDidChange(textView: UITextView) {

        // Enable based on text
        sendButton.enabled = textView.text.stringByRemovingWhiteSpace() != ""

        // Update the count label
        countLabel.text = "\(textView.text.characters.count)/\(numberOfCharactersAllowed)"

        // Show or hide the placeholder
        textField.placeholder = textView.text == "" ? "Comment" : nil

        // Thise scroll enabled/disabled nonsense fixes the text offset being funky
        textView.scrollEnabled = true
        invalidateIntrinsicContentSize()
        textView.scrollEnabled = false
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        // If we're in a loading state, input is disabled
        if loading {
            return false
        }
        // Limit the number of characters
        if (textView.text.characters.count + text.characters.count) > numberOfCharactersAllowed {
            return false
        }

        return true
    }
}
