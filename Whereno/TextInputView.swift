//
//  TextInputView.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class TextInputView: UIView {

    @IBOutlet private var textField: UITextField!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var sendButton: UIButton!

    private let separator = UIView()

    var text: String {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
            textViewDidChange(textView)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        autoresizingMask = .FlexibleHeight
        translatesAutoresizingMaskIntoConstraints = false

        textView.delegate = self

        // This is annoying to to in IB (can't set height to 0.5)
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        separator.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        separator.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        separator.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(0.5).active = true
        separator.backgroundColor = UIColor(hex: "#C8C7CC")
    }

    override func intrinsicContentSize() -> CGSize {
        let textSize = self.textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.max))
        return CGSize(width: self.bounds.width, height: textSize.height + 8)
    }

    func addTarget(target: AnyObject?, action: Selector) {
        sendButton.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
}

extension TextInputView: UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {

        textField.placeholder = textView.text == "" ? "Comment" : nil

        textView.scrollEnabled = true
        invalidateIntrinsicContentSize()
        textView.scrollEnabled = false
    }
}
