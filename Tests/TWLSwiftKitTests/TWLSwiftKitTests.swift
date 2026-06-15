import Testing
import UIKit
@testable import TWLSwiftKit

@Test func stringRangesAndSubstringsHandleBoundaries() {
    #expect("aaaa".twl.ranges(of: "aa").count == 2)
    #expect("abc".twl.ranges(of: "").isEmpty)
    #expect("Swift".twl.substring(at: 1, length: 3) == "wif")
    #expect("Swift".twl.substring(at: -1, length: 1) == nil)
    #expect("Swift".twl.substring(at: 1, length: -1) == nil)
    #expect("Swift".twl.substring(at: 5, length: 0) == "")
}

@Test @MainActor func invalidHexAndUnsetLayerColorsAreSafe() {
    #expect(UIColor.twl.from(hex: "#GGGGGG") == nil)
    #expect(UIColor.twl.from(hex: "#12345") == nil)
    #expect(UIColor.twl.from(hex: "#112233") != nil)

    let view = TWLView()
    let imageView = TWLImageView()
    let button = TWLButton()
    let configurableButton = TWLConfButton()

    view.layer.borderColor = nil
    view.layer.shadowColor = nil
    imageView.layer.borderColor = nil
    button.layer.borderColor = nil
    configurableButton.layer.shadowColor = nil

    #expect(view.borderColor == nil)
    #expect(view.shadowColor == nil)
    #expect(imageView.borderColor == nil)
    #expect(button.borderColor == nil)
    #expect(configurableButton.shadowColor == nil)
}

@Test @MainActor func attributedLabelAcceptsMismatchedStyleArrays() {
    let label = TWLLabel()
    label.text = "one two"
    label.setAttributedText(
        ["one", "two"],
        colors: [.red],
        fonts: [.systemFont(ofSize: 12)],
        underline: true
    )
    #expect(label.attributedText?.string == "one two")
}

@Test @MainActor func currencyFieldNormalizesPastedInput() {
    let field = TWLCurrencyField()
    field.maxIntegerLength = 4
    field.maxDecimalLength = 2
    field.text = "00123.45.67"
    field.sendActions(for: .editingChanged)
    #expect(field.text == "123.45")

    field.maxDecimalLength = -1
    #expect(field.maxDecimalLength == 0)
}

@Test @MainActor func gradientConfigurationRemainsPubliclyMutable() {
    var radii = TWLCornerRadii(all: 4)
    radii.topLeft = 8
    #expect(radii.topLeft == 8)

    var gradient = TWLGradientConfig(colors: [.black, .white])
    gradient.endPoint = CGPoint(x: 0.5, y: 1)
    #expect(gradient.colors.count == 2)
}

@Test func nonPositiveSleepReturnsImmediately() async {
    await twlTaskSleep(seconds: -1)
}
