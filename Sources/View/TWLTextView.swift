//
//  TWLTextView.swift
//  TWLSwiftKit
//

import UIKit

open class TWLTextView: UITextView {
    
    public var maxLength: Int = 0
    public var lineSpace: CGFloat?
    public var placeHolder: String? {
        didSet {
            placeHolderLbl.isHidden = false
            placeHolderLbl.text = placeHolder
            placeHolderLbl.sizeToFit()
        }
    }
    public var placeHolderColor: UIColor? {
        didSet {
            placeHolderLbl.isHidden = false
            placeHolderLbl.textColor = placeHolderColor
        }
    }
    public var placeHolderFont: UIFont? {
        didSet {
            placeHolderLbl.isHidden = false
            placeHolderLbl.font = placeHolderFont
        }
    }
    public var placeHolderLeft: CGFloat? = 4 {
        didSet {
            placeHolderLbl.isHidden = false
            guard let placeHolderLeft = placeHolderLeft else { return }
            placeHolderLbl.twl.x = placeHolderLeft
        }
    }
    public var placeHolderTop: CGFloat? = 4 {
        didSet {
            placeHolderLbl.isHidden = false
            guard let placeHolderTop = placeHolderTop else { return }
            placeHolderLbl.twl.y = placeHolderTop
        }
    }
    
    
    
    public var contentsUpdate: (_ twlTextView: TWLTextView) -> Void = {_ in}

    private var placeHolderLbl: UILabel!
    
    public init() {
        super.init(frame: .zero, textContainer: nil)
        initViews()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    
    private func initViews() {
        placeHolderLbl = UILabel()
        placeHolderLbl.isHidden = true
        addSubview(placeHolderLbl)
        placeHolderLbl.twl.y = placeHolderTop ?? 0
        placeHolderLbl.twl.x = placeHolderLeft ?? 0
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textViewContentsDidChange(_:)),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    @objc private func textViewContentsDidChange(_ notification: Notification) {
        guard let tv = notification.object as? UITextView else { return }
        if maxLength > 0, tv.text.count > maxLength {
            let endIndex = tv.text.index(tv.text.startIndex, offsetBy: maxLength)
            tv.text = String(tv.text[..<endIndex])
        }
        
        if let lineSpace = lineSpace, var attributedText = self.attributedText?.mutableCopy() as? NSMutableAttributedString  {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            
            attributedText.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: attributedText.length)
            )
            
            self.attributedText = attributedText
        }
        
        placeHolderLbl.isHidden = tv.text.count > 0
        
        weak var weakSelf = self
        guard let outSelf = weakSelf else { return }
        contentsUpdate(outSelf)
    }
    
    
    
    
    
}
