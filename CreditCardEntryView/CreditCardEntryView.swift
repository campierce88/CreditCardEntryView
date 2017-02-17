//
//  CreditCardEntryView.swift
//  CreditCardEntryView
//
//  Created by Cameron Pierce on 2/18/17.
//  Copyright © 2017 Cameron Pierce. All rights reserved.
//

import UIKit

public protocol CreditCardEntryViewDelegate {
    func generated(_ token: String?)
}

@IBDesignable public class CreditCardEntryView: UIView {
    
    private var identifier: String = "CreditCardResignOnMissTextViewEntryView"
    
    override public var restorationIdentifier: String? {
        get {
            return identifier
        } set {
            identifier = restorationIdentifier ?? ""
        }
    }

    static let defaultSize = CGSize(width: UIScreen.main.bounds.width, height: 103.0)
    
    @IBInspectable public var hasCardScanner: Bool = true {
        didSet {
            if containerStackView != nil {
                scannerButton.isHidden = !hasCardScanner
            }
        }
    }
    @IBInspectable public var fieldBackgroundColor: UIColor = .white {
        didSet {
            if containerStackView != nil {
                numberTextField.backgroundColor = fieldBackgroundColor
                expTextField.backgroundColor = fieldBackgroundColor
                cvcTextField.backgroundColor = fieldBackgroundColor
                zipTextField.backgroundColor = fieldBackgroundColor
            }
        }
    }
    @IBInspectable public var hDividerColor: UIColor = .lightGray {
        didSet {
            if containerStackView != nil {
                topHDivider.backgroundColor = hDividerColor
                middleHDivider.backgroundColor = hDividerColor
                bottomHDivider.backgroundColor = hDividerColor
            }
        }
    }
    @IBInspectable public var vDividerColor: UIColor = .lightGray {
        didSet {
            if containerStackView != nil {
                cvcLeftVDivider.backgroundColor = vDividerColor
                cvcRightVDivider.backgroundColor = vDividerColor
            }
        }
    }
    @IBInspectable public var textColor: UIColor = .black {
        didSet {
            if containerStackView != nil {
                numberTextField.textColor = textColor
                expTextField.textColor = textColor
                cvcTextField.textColor = textColor
                zipTextField.textColor = textColor
            }
        }
    }
    @IBInspectable public var invalidTextColor: UIColor = .red
    @IBInspectable public var font: UIFont = .systemFont(ofSize: 16.0) {
        didSet {
            if containerStackView != nil {
                numberTextField.font = font
                expTextField.font = font
                cvcTextField.font = font
                zipTextField.font = font
            }
        }
    }
    @IBInspectable override public var tintColor: UIColor! {
        didSet {
            if containerStackView != nil {
                numberTextField.tintColor = tintColor
                expTextField.tintColor = tintColor
                cvcTextField.tintColor = tintColor
                zipTextField.tintColor = tintColor
            }
        }
    }
    override public func becomeFirstResponder() -> Bool {
        if containerStackView != nil {
            return numberTextField.becomeFirstResponder()
        } else {
            return false
        }
    }
    public var delegate: CreditCardEntryViewDelegate?

    @IBOutlet weak var containerStackView: UIView!
    @IBOutlet weak var topHDivider: UIView!
    @IBOutlet weak var middleHDivider: UIView!
    @IBOutlet weak var bottomHDivider: UIView!
    @IBOutlet weak var cvcLeftVDivider: UIView!
    @IBOutlet weak var cvcRightVDivider: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var scannerButton: UIButton!
    @IBOutlet weak var expTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBInspectable var viewSize: CGSize = CreditCardEntryView.defaultSize {
        didSet {
            frame.size = viewSize
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadFomNib()
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadFomNib()
        self.frame = frame
        self.viewSize = frame.size
        commonInit()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    func loadFomNib() {
        let bundle = Bundle(for: type(of: self))
        if let view = bundle.loadNibNamed("CreditCardEntryView", owner: self, options: nil)?[0] as? UIView {
            addSubview(view)
            addConstraints([
                NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
                ])
        }
    }
    
    func commonInit() {
        if containerStackView != nil {
            numberTextField.textColor = textColor
            numberTextField.tintColor = tintColor
            numberTextField.backgroundColor = fieldBackgroundColor
            numberTextField.font = font
            numberTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)

            expTextField.textColor = textColor
            expTextField.tintColor = tintColor
            expTextField.backgroundColor = fieldBackgroundColor
            expTextField.font = font
            expTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)

            cvcTextField.textColor = textColor
            cvcTextField.tintColor = tintColor
            cvcTextField.backgroundColor = fieldBackgroundColor
            cvcTextField.font = font
            cvcTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)

            zipTextField.textColor = textColor
            zipTextField.tintColor = tintColor
            zipTextField.backgroundColor = fieldBackgroundColor
            zipTextField.font = font
            zipTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)

            topHDivider.backgroundColor = hDividerColor
            middleHDivider.backgroundColor = hDividerColor
            bottomHDivider.backgroundColor = hDividerColor
            cvcRightVDivider.backgroundColor = vDividerColor
            cvcLeftVDivider.backgroundColor = vDividerColor
            
            scannerButton.isHidden = hasCardScanner
        }
    }

    func validateCreditCard(for textField: UITextField) -> Bool {
        return false
    }
    
    func textChanged(_ textField: UITextField) {
        if let characters = textField.text?.characters, characters.count == maxLength(for: textField) ?? 0 {
            if validateCreditCard(for: textField) {
                textField.textColor = textColor
                let _ = textFieldShouldReturn(textField)
            } else {
                textField.textColor = invalidTextColor
            }
        } else {
            textField.textColor = textColor
        }
    }
}

extension CreditCardEntryView: UITextFieldDelegate {
    
    fileprivate func maxLength(for textField: UITextField) -> Int? {
        if textField == numberTextField {
            return 19
        } else if textField == expTextField {
            return 5
        } else if textField == cvcTextField {
            return 4
        } else if textField == zipTextField {
            return 5
        } else {
            return nil
        }
    }
    
    fileprivate func becomeNextResponder(given textField: UITextField) -> Bool {
        if textField == numberTextField {
            expTextField?.becomeFirstResponder()
        } else if textField == expTextField {
            cvcTextField?.becomeFirstResponder()
        } else if textField == cvcTextField {
            zipTextField?.becomeFirstResponder()
        } else if textField == zipTextField {
            zipTextField.resignFirstResponder()
        } else {
            return false
        }
        
        return true
    }
    
    fileprivate func canEdit(_ textField: UITextField, for charactersInRange: NSRange, with replacementString: String, and limit: Int) -> Bool {
        let currentString = textField.text as NSString?
        let newString = currentString?.replacingCharacters(in: charactersInRange, with: replacementString)
        return newString?.characters.count ?? 0 <= limit
    }
    
    fileprivate func format(_ textField: UITextField, for charactersInRange: NSRange, with replacementString: String) -> String? {
        guard let text = textField.text, let newString = (text as NSString?)?.replacingCharacters(in: charactersInRange, with: replacementString), (textField == numberTextField || textField == expTextField) else {
             return textField.text
        }
        
        let count = text.characters.count
        
        if textField == numberTextField {
            if (count == 4 || count == 9 || count == 14) && count < newString.characters.count {
                return "\(text) "
            } else if (count == 6 || count == 11 || count == 16) && count > newString.characters.count {
                let endIndex = text.index(text.startIndex, offsetBy: max(0, count-1))
                return text.substring(to: endIndex)
            }
        } else if textField == expTextField {
            if count == 2 && count < newString.characters.count {
                return "\(text)/"
            } else if count == 4 && count > newString.characters.count {
                let endIndex = text.index(text.startIndex, offsetBy: max(0, count-1))
                return text.substring(to: endIndex)
            }
        }
        
        return textField.text
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let shouldEdit = canEdit(textField, for: range, with: string, and: maxLength(for: textField) ?? 0)
        textField.text = format(textField, for: range, with: string)
        return shouldEdit
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return becomeNextResponder(given: textField)
    }
}
