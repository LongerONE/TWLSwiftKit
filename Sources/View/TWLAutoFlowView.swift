//
//  TWLFlowView.swift
//  TWLSwiftKit
//

import UIKit

open class TWLAutoFlowView: UIView {

    open var useAutoLayout = false
    open var useContentsHeight = false     // 由内容撑起高度
    open var colCount = 0
    open var innerSpace: CGFloat = 0.0           // 元素间距
    open var lineSpace: CGFloat = 0.0            // 元素行距
    open var contentInset: UIEdgeInsets = .zero  // 内容边距
    open var showHeight: CGFloat = 0.0

    private var allConstraints: [NSLayoutConstraint] = []
    
    open func removeSubviews() {
        for subView in subviews {
            subView.removeFromSuperview()
        }
    }

    open func addArrangedSubview(_ currentView: UIView) {
        addSubview(currentView)
    }
    
    
    open func updateSubviewLayout() {
        var count: Int = subviews.count
        var top: CGFloat = contentInset.top
        var left: CGFloat = contentInset.left
        var preView: UIView?
        
        for constraint in allConstraints {
            removeConstraint(constraint)
        }
        allConstraints = []
        
        for (index, currentView) in subviews.enumerated() {
            if colCount > 0 {
                // 固定列数
                if useAutoLayout {
                    if let preView = preView {
                        if colCount > 1 {
                            let widthConstraint = currentView.widthAnchor.constraint(equalTo: preView.widthAnchor)
                            allConstraints.append(widthConstraint)
                        }

                        if index % colCount == 0 {
                            let leadingConstraint = currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInset.left)
                            allConstraints.append(leadingConstraint)
                            let topConstraint = currentView.topAnchor.constraint(equalTo: preView.bottomAnchor, constant: lineSpace)
                            allConstraints.append(topConstraint)
                        } else {
                            let leadingConstraint = currentView.leadingAnchor.constraint(equalTo: preView.trailingAnchor, constant: innerSpace)
                            allConstraints.append(leadingConstraint)
                            let topConstraint = currentView.topAnchor.constraint(equalTo: preView.topAnchor)
                            allConstraints.append(topConstraint)
                        }
                    } else {
                        // 第一个
                        let leadingConstraint = currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInset.left)
                        allConstraints.append(leadingConstraint)
                        let topConstraint = currentView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInset.top)
                        allConstraints.append(topConstraint)
                        
                        if count < colCount {
                            // 不足一行，手动指定宽度
                            let widthConstraint = currentView.widthAnchor.constraint(equalTo: currentView.superview!.widthAnchor, multiplier: 1.0/CGFloat(colCount))
                            allConstraints.append(widthConstraint)
                        }
                    }
                    
                    if index % colCount == (colCount - 1) && count > 1 {
                        // 最右侧
                        let trailingConstrait = currentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -contentInset.right)
                        allConstraints.append(trailingConstrait)
                    }
                    
                    if useContentsHeight && index == (count - 1) {
                        // 最后一个
                        let bottomConstraint = currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInset.bottom)
                        allConstraints.append(bottomConstraint)
                    }
                } else {
                    let width = (twl.width - CGFloat(colCount - 1) * innerSpace - contentInset.left - contentInset.right) / CGFloat(colCount)
                    currentView.twl.width = width
                    currentView.twl.x = CGFloat(index % colCount) * (width + innerSpace) + contentInset.left
                    currentView.twl.y = floor(CGFloat(index) / CGFloat(colCount)) * (currentView.twl.height + lineSpace) + contentInset.top
                    
                    if useContentsHeight && index == count - 1 {
                        twl.height = currentView.twl.y + currentView.twl.height + contentInset.bottom
                    }
                }
            } else {
                // 按实际大小依次排
                if twl.width - left - innerSpace - contentInset.right < currentView.twl.width {
                    // 右边距离不够，换行
                    left = contentInset.left
                    top += currentView.twl.height
                    top += lineSpace
                } else {
                    if index != 0 {
                        left += innerSpace
                    }
                }
                
                if useAutoLayout {
                    let leadingConstraint = currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: left)
                    allConstraints.append(leadingConstraint)
                    let topConstraint = currentView.topAnchor.constraint(equalTo: self.topAnchor, constant: top)
                    allConstraints.append(topConstraint)
                } else {
                    currentView.twl.x = left
                    currentView.twl.y = top
                }
                
                
                left += currentView.twl.width
                
                if index == count - 1 {
                    if useContentsHeight {
                        if useAutoLayout {
                            let bottomConstraint = currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInset.bottom)
                            allConstraints.append(bottomConstraint)
                        } else {
                            showHeight = top + currentView.twl.height + contentInset.bottom
                            twl.height = showHeight
                        }
                    }
                }
            }
            
            preView = currentView
        }
        
        if useAutoLayout {
            NSLayoutConstraint.activate(allConstraints)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        updateSubviewLayout()
    }
}


