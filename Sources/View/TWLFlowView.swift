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
        
        for index in 0..<count {
            var currentView: UIView!
            if dataSource != nil {
                currentView = dataSource!.viewForIndex(flowView: self, index: index)
            } else {
                currentView = viewClosure(index)
            }
            currentView.layoutIfNeeded()
            currentView.sizeToFit()
            addSubview(currentView)
            layoutIfNeeded()
            
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
            
            
            currentView.twl.x = left
            currentView.twl.y = top

            left += currentView.twl.width
            
            if index == count - 1 {
                showHeight = top + currentView.twl.height + contentInset.bottom
                twl.height = showHeight
            }
        }
        
        layoutIfNeeded()
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


