//
//  TWLFlexStackView.swift
//

import UIKit

open class TWLFlexStackView: UIScrollView {

    open var stackView: UIStackView!

    public init(axis: NSLayoutConstraint.Axis) {
        super.init(frame: .zero)

        bounces = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never

        stackView = UIStackView()
        stackView.axis = axis
        addSubview(stackView)
        
        setupConstraints(axis: axis)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupConstraints(axis: NSLayoutConstraint.Axis) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentLayoutGuide = self.contentLayoutGuide
        let frameLayoutGuide = self.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor)
        ])
        
        if axis == .vertical {
            NSLayoutConstraint.activate([
                stackView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor)
            ])
        }
    }

    open func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
}
