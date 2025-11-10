//
//  TWLFlowView.swift
//  TWLSwiftKit
//

import UIKit

open class TWLAutoFlowView: UIView {

    public var useAutoLayout = true
    public var useContentsHeight = true     // 由内容撑起高度
    public var colCount = 0
    public var innerSpace: CGFloat = 0.0           // 元素间距
    public var lineSpace: CGFloat = 0.0            // 元素行距
    public var contentInset: UIEdgeInsets = .zero  // 内容边距
    public var showHeight: CGFloat = 0.0
    public var arrangedSubviews: [UIView] = []
    
    private var oldFrame: CGRect = .zero
    private var allConstraints: [NSLayoutConstraint] = []
    
    
    open func removeAllSubviews() {
        for subView in subviews {
            subView.removeFromSuperview()
        }
        arrangedSubviews = []
    }

    open func addArrangedSubview(_ currentView: UIView) {
        arrangedSubviews.append(currentView)
        addSubview(currentView)
        oldFrame = .zero
    }
    
    open func removeAllArrangedViews() {
        for subview in arrangedSubviews {
            subview.removeFromSuperview()
        }
        arrangedSubviews = []
        layoutSubviews()
    }
    
    
    open func updateSubviewsLayout() {
        TWLDPrint("[TWLAutoFlowView]开始自动处理布局...")
        
        var count: Int = arrangedSubviews.count
        var top: CGFloat = contentInset.top
        var left: CGFloat = contentInset.left
        var preView: UIView?
        
        for constranit in allConstraints {
            constranit.isActive = false
            removeConstraint(constranit)
        }
        allConstraints = []
        
        for (index, currentView) in arrangedSubviews.enumerated() {
            guard currentView.superview != nil else { continue }
            
            if useAutoLayout {
                currentView.translatesAutoresizingMaskIntoConstraints = false
            } else {
                currentView.translatesAutoresizingMaskIntoConstraints = true
                currentView.sizeToFit()
            }

            if colCount > 0 {
                // 固定列数
                if useAutoLayout {
                    if let preView = preView {
                        if colCount > 1 {
                            let constraint = currentView.widthAnchor.constraint(equalTo: preView.widthAnchor)
                            allConstraints.append(constraint)
                        }

                        if index % colCount == 0 {
                            // 最左侧
                            let constraint1 = currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInset.left)
                            let constraint2 = currentView.topAnchor.constraint(equalTo: preView.bottomAnchor, constant: lineSpace)
                            allConstraints.append(constraint1)
                            allConstraints.append(constraint2)
                        } else {
                            let constraint1 = currentView.leadingAnchor.constraint(equalTo: preView.trailingAnchor, constant: innerSpace)
                            let constraint2 = currentView.topAnchor.constraint(equalTo: preView.topAnchor)
                            allConstraints.append(constraint1)
                            allConstraints.append(constraint2)
                        }
                    } else {
                        // 第一个
                        let constraint1 = currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInset.left)
                        let constraint2 = currentView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInset.top)
                        allConstraints.append(constraint1)
                        allConstraints.append(constraint2)

                        if count < colCount {
                            // 不足一行，手动指定宽度
                            let constraint = currentView.widthAnchor.constraint(equalTo: currentView.superview!.widthAnchor, multiplier: 1.0 / CGFloat(colCount))
                            allConstraints.append(constraint)
                        }
                    }
                    
                    if index % colCount == (colCount - 1) {
                        // 最右侧
                        let constraint = currentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -contentInset.right)
                        allConstraints.append(constraint)
                    }
                    
                    if useContentsHeight && index == (count - 1) {
                        // 最后一个
                        let constraint = currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInset.bottom)
                        allConstraints.append(constraint)

                        showHeight = currentView.twl.y + currentView.twl.height + contentInset.bottom
                        twl.height = showHeight
                    }
                } else {
                    let width = (twl.width - CGFloat(colCount - 1) * innerSpace - contentInset.left - contentInset.right) / CGFloat(colCount)
                    currentView.twl.width = width
                    currentView.twl.x = CGFloat(index % colCount) * (width + innerSpace) + contentInset.left
                    currentView.twl.y = floor(CGFloat(index) / CGFloat(colCount)) * (currentView.twl.height + lineSpace) + contentInset.top
                    
                    if useContentsHeight && index == count - 1 {
                        showHeight = currentView.twl.y + currentView.twl.height + contentInset.bottom
                        twl.height = showHeight
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
                    let constraint1 = currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: left)
                    let constraint2 = currentView.topAnchor.constraint(equalTo: self.topAnchor, constant: top)
                    allConstraints.append(constraint1)
                    allConstraints.append(constraint2)
                } else {
                    currentView.twl.x = left
                    currentView.twl.y = top
                }
                
                left += currentView.twl.width
                
                if index == count - 1 {
                    showHeight = top + currentView.twl.height + contentInset.bottom
                    
                    if useContentsHeight {
                        if useAutoLayout {
                            let constraint = currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInset.bottom)
                            allConstraints.append(constraint)
                        }
                    
                        twl.height = showHeight
                    }
                }
            }
            
            NSLayoutConstraint.activate(allConstraints)
            preView = currentView
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if frame != oldFrame {
            oldFrame = frame
            updateSubviewsLayout()
        } else {
            TWLDPrint("TWLAutoFlowView 不用更新布局")
        }
    }
}


