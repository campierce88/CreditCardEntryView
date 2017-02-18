//
//  CreditCardEntryView.swift
//  CreditCardEntryView
//
//  Created by Cameron Pierce on 2/18/17.
//  Copyright © 2017 Cameron Pierce. All rights reserved.
//

import UIKit
import Stripe

public enum SupportedCardType {
    case amex
    case discover
    case mastercard
    case visa
    case unknown
}

public protocol CreditCardEntryViewDelegate {
    func userInputted(cardParams: STPCardParams, thatAre valid: Bool)
    func startingTokenGeneration()
    func generated(_ token: String?)
}

@IBDesignable public class CreditCardEntryView: UIView {
    
    private var identifier: String = "CreditCardEntryView"
    
    override public var restorationIdentifier: String? {
        get {
            return identifier
        } set {
            identifier = restorationIdentifier ?? ""
        }
    }

    static let defaultSize = CGSize(width: UIScreen.main.bounds.width, height: 103.0)
    @IBInspectable public var cardImages: [SupportedCardType: UIImage?] = [
        .amex: UIImage(named: "amex", in: Bundle(for: CreditCardEntryView.classForCoder()), compatibleWith: nil),
        .discover: UIImage(named: "discover", in: Bundle(for: CreditCardEntryView.classForCoder()), compatibleWith: nil),
        .mastercard: UIImage(named: "mastercard", in: Bundle(for: CreditCardEntryView.classForCoder()), compatibleWith: nil),
        .visa: UIImage(named: "visa", in: Bundle(for: CreditCardEntryView.classForCoder()), compatibleWith: nil),
        .unknown: UIImage(named: "card-empty", in: Bundle(for: CreditCardEntryView.classForCoder()), compatibleWith: nil)
        ] {
        didSet{
            updateCardImage(for: brand)
        }
    }
    @IBInspectable public var autoGenerateToken: Bool = false
    @IBInspectable public var hasCardScanner: Bool = true {
        didSet {
            if containerStackView != nil {
                scannerButton.isHidden = !hasCardScanner
            }
        }
    }
    @IBInspectable public var scannerButtonImage: UIImage? = UIImage(named: "camera", in: Bundle(for: CreditCardEntryView.classForCoder()), compatibleWith: nil) {
        didSet {
            scannerButton.setImage(scannerButtonImage, for: UIControlState())
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
    public var cardParams: STPCardParams = STPCardParams()
    fileprivate var brand: STPCardBrand = .unknown {
        didSet {
            updateCardImage(for: brand)
        }
    }
    
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
            
            brand = .unknown
        }
    }
    
    func updateCardImage(for brand: STPCardBrand) {
        switch brand {
            case .amex:
                cardImageView.image = cardImages[SupportedCardType.amex] ?? nil
            case .discover:
                cardImageView.image = cardImages[SupportedCardType.discover] ?? nil
            case .masterCard:
                cardImageView.image = cardImages[SupportedCardType.mastercard] ?? nil
            case .visa:
                cardImageView.image = cardImages[SupportedCardType.visa] ?? nil
            default:
                cardImageView.image = cardImages[SupportedCardType.unknown] ?? nil
        }
    }

    func generateStripeToken() {
        isUserInteractionEnabled = false
        
        delegate?.startingTokenGeneration()
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let error = error {
                print("error getting stripe card token: \(error)")
            }
            
            self.isUserInteractionEnabled = true
            self.delegate?.generated(token?.tokenId)
        }
    }
    
    func validateCreditCard(for textField: UITextField) -> Bool {
        var isValid: STPCardValidationState = .incomplete
        if textField == numberTextField {
            let number = numberTextField.text ?? ""
            isValid = STPCardValidator.validationState(forNumber: number, validatingCardBrand: true)
            if isValid == .valid {
                cardParams.number = number
            }
        } else if textField == expTextField {
            let exp = expTextField.text ?? ""
            let month = exp.substring(to: exp.index(exp.startIndex, offsetBy: max(0, 2)))
            let year = exp.substring(from: exp.index(exp.startIndex, offsetBy: max(0, 3)))
            isValid = STPCardValidator.validationState(forExpirationYear: year, inMonth: month)
            if isValid == .valid {
                cardParams.expMonth = UInt(month) ?? 0
                cardParams.expYear = UInt(year) ?? 0
            }
        } else if textField == cvcTextField {
            let cvc = cvcTextField.text ?? ""
            isValid = STPCardValidator.validationState(forCVC: cvc, cardBrand: brand)
            if isValid == .valid {
                cardParams.cvc = cvc
            }
        } else if textField == zipTextField {
            isValid = .valid
            cardParams.addressZip = zipTextField.text
        }
        
        if let _ = cardParams.number, let _ = cardParams.cvc, let _ = cardParams.addressZip, cardParams.expMonth != 0, cardParams.expYear != 0 {
            delegate?.userInputted(cardParams: cardParams, thatAre: true)
            if autoGenerateToken {
                isValid = STPCardValidator.validationState(forCard: cardParams)
                generateStripeToken()
            }
        } else {
            delegate?.userInputted(cardParams: cardParams, thatAre: false)
        }
        
        return isValid == .valid
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
    
    fileprivate func clearCardParam(for textField: UITextField) {
        if textField == numberTextField {
            cardParams.number = nil
        } else if textField == expTextField {
            cardParams.expYear = 0
            cardParams.expMonth = 0
        } else if textField == cvcTextField {
            cardParams.cvc = nil
        } else if textField == zipTextField {
            cardParams.addressZip = nil
        }
        
        delegate?.userInputted(cardParams: cardParams, thatAre: false)
    }
    
    fileprivate func maxLength(for textField: UITextField) -> Int? {
        if textField == numberTextField {
            return 19
        } else if textField == expTextField {
            return 5
        } else if textField == cvcTextField {
            if brand == .amex {
                return 4
            } else {
                return 3
            }
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
            brand = STPCardValidator.brand(forNumber: newString)

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
        clearCardParam(for: textField)
        textField.text = format(textField, for: range, with: string)
        return shouldEdit
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return becomeNextResponder(given: textField)
    }
}
