//
//  TWLTextField.swift
//

import UIKit

open class TWLTextField: UITextField {
 
    @IBInspectable
    open var maxLength: Int = 0 {
        didSet {
            maxLength = max(0, maxLength)
        }
    }
    
    open var placeholderFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            showPlaceholderInfo()
        }
    }
    
    open var placeholderColor: UIColor? = UIColor.black {
        didSet {
            showPlaceholderInfo()
        }
    }
    
    var textDidChange: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }


    @objc private func editingChanged() {
        guard maxLength > 0, let text = self.text, text.count > maxLength else {
            textDidChange?(self.text ?? "")
            return
        }

        self.text = String(text.prefix(maxLength))

        textDidChange?(self.text ?? "")
    }

    private func showPlaceholderInfo() {
        let color = placeholderColor ?? UIColor.black
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: placeholderFont
        ]

        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: attributes
        )
    }
}
