//
//  TWLFlowView.swift
//  TWLSwiftKit
//

import UIKit

open class TWLAutoFlowView: UIView {

    open var useAutoLayout = true
    open var useContentsHeight = true     // 由内容撑起高度
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
    
    
    open func updateSubviewsLayout() {
        TWLDPrint("[TWLAutoFlowView]开始自动处理布局...")
        
        var count: Int = subviews.count
        var top: CGFloat = contentInset.top
        var left: CGFloat = contentInset.left
        var preView: UIView?
                
        let allViews = subviews
        removeSubviews()
        for (index, currentView) in allViews.enumerated() {
            addSubview(currentView)
            
            if useAutoLayout {
                currentView.translatesAutoresizingMaskIntoConstraints = false
                currentView.layoutIfNeeded()
            } else {
                currentView.translatesAutoresizingMaskIntoConstraints = true
            }

            currentView.sizeToFit()
            
            if colCount > 0 {
                // 固定列数
                if useAutoLayout {
                    if let preView = preView {
                        if colCount > 1 {
                            NSLayoutConstraint.activate([
                                currentView.widthAnchor.constraint(equalTo: preView.widthAnchor)
                            ])
                        }

                        if index % colCount == 0 {
                            // 最左侧
                            NSLayoutConstraint.activate([
                                currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInset.left),
                                currentView.topAnchor.constraint(equalTo: preView.bottomAnchor, constant: lineSpace)
                            ])
                        } else {
                            NSLayoutConstraint.activate([
                                currentView.leadingAnchor.constraint(equalTo: preView.trailingAnchor, constant: innerSpace),
                                currentView.topAnchor.constraint(equalTo: preView.topAnchor)
                            ])
                            currentView
                        }
                    } else {
                        // 第一个
                        NSLayoutConstraint.activate([
                            currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInset.left),
                            currentView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInset.top)
                        ])

                        if count < colCount {
                            // 不足一行，手动指定宽度
                            NSLayoutConstraint.activate([
                                currentView.widthAnchor.constraint(equalTo: currentView.superview!.widthAnchor, multiplier: 1.0 / CGFloat(colCount))
                            ])
                        }
                    }
                    
                    if index % colCount == (colCount - 1) {
                        // 最右侧
                        NSLayoutConstraint.activate([
                            currentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -contentInset.right)
                        ])
                    }
                    
                    if useContentsHeight && index == (count - 1) {
                        // 最后一个
                        NSLayoutConstraint.activate([
                            currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInset.bottom)
                        ])

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
                    NSLayoutConstraint.activate([
                        currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: left),
                        currentView.topAnchor.constraint(equalTo: self.topAnchor, constant: top)
                    ])
                } else {
                    currentView.twl.x = left
                    currentView.twl.y = top
                }
                
                left += currentView.twl.width
                
                if index == count - 1 {
                    showHeight = top + currentView.twl.height + contentInset.bottom
                    
                    if useContentsHeight {
                        if useAutoLayout {
                            NSLayoutConstraint.activate([
                                currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInset.bottom)
                            ])
                        }
                    
                        twl.height = showHeight
                    }
                }
            }
            
            preView = currentView
        }
    }
    
}


