//
//  TWLFlowView.swift
//  TWLSwiftKit
//

import UIKit

public protocol TWLFlowViewDataSouce: NSObjectProtocol {
    
    func numberOfViews(flowView: TWLFlowView) -> Int
    
    func viewForIndex(flowView: TWLFlowView, index: Int) -> UIView
}

open class TWLFlowView: UIView {
    
    open weak var dataSource: TWLFlowViewDataSouce? // 数据源优先于闭包
    
    open var useAutoLayout = false
    open var useContentsHeight = false     // 由内容撑起高度
    open var colCount = 0
    open var innerSpace: CGFloat = 0.0           // 元素间距
    open var lineSpace: CGFloat = 0.0            // 元素行距
    open var contentInset: UIEdgeInsets = .zero  // 内容边距
    open var showHeight: CGFloat = 0.0
    
    open var numberClosure:() -> Int = { return 0}
    open var viewClosure:(_ index: Int) -> UIView = { _ in return UIView()}
    
    private var count: Int = 0
    
    open func reloadViews() {
        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        if dataSource != nil {
            count = dataSource!.numberOfViews(flowView: self)
        } else {
            count = numberClosure()
        }
        
        if count == 0 {
            showHeight = 0.0
            twl.height = 0.0
            return
        }

        var top: CGFloat = contentInset.top
        var left: CGFloat = contentInset.left
        
        var preView: UIView?
        for index in 0..<count {
            var currentView: UIView!
            if dataSource != nil {
                currentView = dataSource!.viewForIndex(flowView: self, index: index)
            } else {
                currentView = viewClosure(index)
            }
            addSubview(currentView)
            if useAutoLayout {
                currentView.layoutIfNeeded()
                currentView.translatesAutoresizingMaskIntoConstraints = false
            }
            
            
            
            if colCount > 0 {
                // 固定列数
                if useAutoLayout {
                    if let preView = preView {
                        NSLayoutConstraint.activate([
                            currentView.widthAnchor.constraint(equalTo: preView.widthAnchor),
                        ])
                        
                        if index % colCount == 0 {
                            NSLayoutConstraint.activate([
                                currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInset.left),
                                currentView.topAnchor.constraint(equalTo: preView.bottomAnchor, constant: lineSpace),
                            ])
                        } else {
                            NSLayoutConstraint.activate([
                                currentView.leadingAnchor.constraint(equalTo: preView.trailingAnchor, constant: innerSpace),
                                currentView.topAnchor.constraint(equalTo: preView.topAnchor)
                            ])
                        }
                    } else {
                        NSLayoutConstraint.activate([
                            currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInset.left),
                            currentView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInset.top)
                            

                        ])
                        
                        if count < colCount {
                            // 不足一行，手动指定宽度
                            NSLayoutConstraint.activate([
                                // 宽度为父视图的三分之一
                                currentView.widthAnchor.constraint(equalTo: currentView.superview!.widthAnchor, multiplier: 1.0/CGFloat(colCount)),
                            ])
                        }
                    }
                    
                    if index % colCount == (colCount - 1) {
                        NSLayoutConstraint.activate([
                            currentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -contentInset.right),
                        ])
                    }
                    
                    if useContentsHeight && index == (count - 1) {
                        NSLayoutConstraint.activate([
                            currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInset.bottom)
                        ])
                    }
                } else {
                    let width = (twl.width - CGFloat(colCount - 1) * innerSpace - contentInset.left - contentInset.right) / CGFloat(colCount)
                    currentView.twl.width = width
                    currentView.twl.x = CGFloat(index % colCount) * (width + innerSpace) + contentInset.left
                    currentView.twl.y = floor(CGFloat(index) / CGFloat(colCount)) * (currentView.twl.height + lineSpace)
                    
                    if useContentsHeight {
                        twl.height = currentView.twl.y + currentView.twl.height + contentInset.bottom
                    }
                }
                
                preView = currentView
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
                    twl.height = showHeight
                }
            }
        }
        
        if useAutoLayout {
            layoutIfNeeded()
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

    }
    
    
    
}


