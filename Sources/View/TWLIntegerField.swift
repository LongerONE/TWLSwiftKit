//
//  TWLIntegerField.swift
//

import UIKit

open class TWLIntegerField: TWLTextField {
    
    open var inputUpdate: (_ text: String?) -> Void = {_ in}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTextField()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initTextField()
    }
    
    private func initTextField() {
        keyboardType = .numberPad
        addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    }
    
    @objc private func handleTextChange() {
        guard let text = self.text else { return }
        
        let filteredText = text.filter { $0.isNumber }
        
        guard !filteredText.isEmpty else {
            self.text = ""
            inputUpdate(self.text)
            return
        }
        
        var processedText = String(filteredText.drop { $0 == "0" })
        if processedText.isEmpty {
            processedText = "0"
        }
        
        if maxLength > 0 {
            let trimmedText = String(processedText.prefix(maxLength))
            
            if trimmedText != self.text {
                self.text = trimmedText
            }
        } else {
            self.text = processedText
        }
        
        inputUpdate(self.text)
    }
}
