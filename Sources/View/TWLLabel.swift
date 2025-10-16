//
//  TWLLabel.swift
//  TWLSwiftKit
//
//

import UIKit


open class TWLLabel: UILabel {
    
    public var uuid: String?
    
    public var obj: Any?
    
    /// 设置 UILabel 中指定文本的字体颜色、字体大小、下划线等属性
    /// - Parameters:
    ///   - targetStrings: 需要设置不同属性的字符串数组
    ///   - color: 颜色
    ///   - font: 字体
    ///   - underline: 是否加下划线
    func setAttributedText(_ targetStrings: [String], colors: [UIColor], fonts: [UIFont], underline: Bool = false) {
        guard let fullText = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        for (index, targetString) in targetStrings.enumerated() {
            let ranges = fullText.twl.ranges(of: targetString)
            
            for range in ranges {
                let nsRange = NSRange(range, in: fullText)
                // 设置颜色
                attributedString.addAttribute(.foregroundColor, value: colors.count == 1 ? colors.first! : colors[index], range: nsRange)
                // 设置字体
                attributedString.addAttribute(.font, value: fonts.count == 1 ? fonts.first! : fonts[index], range: nsRange)
                // 设置下划线
                if underline {
                    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
                }
            }
        }
        
        self.attributedText = attributedString
    }
    
    /// 设置 UILabel 中指定文本行间距
    /// - Parameters:
    ///   - targetStrings: 需要设置不同属性的字符串数组
    ///   - color: 颜色
    ///   - font: 字体
    ///   - underline: 是否加下划线
    func setLineSpace(_ space: CGFloat) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        paragraphStyle.alignment = self.textAlignment
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
