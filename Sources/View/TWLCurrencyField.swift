import UIKit


open class TWLCurrencyField: TWLTextField {
    
    open var textDidChanged:(_ textField: TWLCurrencyField) -> Void = {_ in}
     
    open var maxIntegerLength = 0
    open var maxDecimalLength = 2

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }

    private func setupTextField() {
        keyboardType = .decimalPad
        addTarget(self, action: #selector(editingChangedAction), for: .editingChanged)
    }

    @objc private func editingChangedAction() {
        guard let text = self.text else { return }
        let originalPosition = selectedTextRange

        let processedText = processCurrencyInput(text)

        if processedText != text {
            self.text = processedText
        }
        
        textDidChanged(self)

        // 恢复光标位置
        restoreCursorPosition(originalPosition: originalPosition)
    }

    private func processCurrencyInput(_ input: String) -> String {
        // 步骤1：过滤非法字符
        let filtered = input.filter { $0.isNumber || $0 == "." }
        
        // 步骤2：拆分整数和小数部分
        let components = filtered.components(separatedBy: ".")
        
        // 处理多个小数点的情况
        guard components.count <= 2 else {
            return String(filtered.dropLast())
        }
        
        // 步骤3：处理各部分内容
        let integerPart = processIntegerPart(components.first ?? "")
        let decimalPart = processDecimalPart(components.count > 1 ? components[1] : "")
        
        // 特殊处理单独的小数点
        if filtered == "." {
            return ""
        }
        
        // 步骤4：组合最终结果
        return combineResults(integer: integerPart,
                              decimal: decimalPart,
                              hasDecimalPoint: components.count == 2)
    }

    private func processIntegerPart(_ part: String) -> String {
        // 处理前导零问题
        guard !part.isEmpty else { return "" }
        if part == "0" {
            return part
        }
        let trimmed = part.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        
        // 限制整数部分长度
        if maxIntegerLength > 0 {
            let limited = String(trimmed.prefix(maxIntegerLength))
            return limited.isEmpty ? "" : limited
        } else {
            return trimmed
        }
    }

    private func processDecimalPart(_ part: String) -> String {
        // 限制最多两位小数
        return String(part.prefix(maxDecimalLength))
    }

    private func combineResults(integer: String, decimal: String, hasDecimalPoint: Bool) -> String {
        // 根据是否存在小数点决定格式
        if hasDecimalPoint {
            return "\(integer).\(decimal)"
        }
        return integer
    }

    private func restoreCursorPosition(originalPosition: UITextRange?) {
        guard let original = originalPosition else { return }
        // 计算偏移量时考虑可能新增的小数点
        let offset = offset(from: beginningOfDocument, to: original.start)
        let newTextLength = text?.count ?? 0
        let newOffset = min(offset, newTextLength)
        if let newPosition = position(from: beginningOfDocument, offset: newOffset) {
            selectedTextRange = textRange(from: newPosition, to: newPosition)
        }
    }
}
