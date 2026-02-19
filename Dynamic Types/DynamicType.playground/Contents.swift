import UIKit

/**
 Dynamic Type is a feature provided by Apple.
 It allows you to scale your app’s interface (texts and images) and adapt your layouts based on the user’s preference.

 A user can define a preferred text size to use across the system in Settings → Accessibility → Display & Text Size → Larger Text.
 iOS ecosystem and every app should adapt according to the chosen size.
 */
// If you are using custom fonts in your app and want them to scale properly, this is the basic approach:
let label = UILabel()
if let customFont = UIFont(name: "CustomFont-Light", size: 16) {
    label.font = UIFontMetrics.default.scaledFont(for: customFont)
    label.adjustsFontForContentSizeCategory = true
}
/*
 You use UIFontMetrics.default.scaledFont(for:) method to get a version of your font scaled to the current Dynamic Type size.
 You set adjustsFontForContentSizeCategory to true to allow the font to update when the size category changes.
 */

// We have created a TextStyle struct that will be used to define each of our text styles.
struct TextStyle {
    let size: CGFloat
    let emphasis: Emphasis
    let name: Name
    
    typealias Name = String
    
    init(size: CGFloat, emphasis: Emphasis = .none, name: Name = .ptSans) {
        self.size = size
        self.emphasis = emphasis
        self.name = name
    }
    
    // We created an Emphasis enum to specify if the text style should be in bold, italic or stay regular. We chose to not use directly UIFontDescriptor.SymbolicTraits and all its values because we don’t need them (so far). So we created this enum with only the cases we need, to be more clean.
    enum Emphasis {
        case none, bold, italic
        
        var symbolicTraits: UIFontDescriptor.SymbolicTraits? {
            switch self {
            case .none:
                return nil
            case .bold:
                return .traitBold
            case .italic:
                return .traitItalic
            }
        }
    }
}

extension TextStyle.Name {
    static let montserrat: TextStyle.Name = "Montserrat-Regular"
    static let ptSans: TextStyle.Name = "PTSans-Regular"
}

extension TextStyle {
    // Headings
    static let h1 = TextStyle(size: 24, emphasis: .bold, name: .montserrat)
    static let h2 = TextStyle(size: 20, emphasis: .bold, name: .montserrat)
    static let h3 = TextStyle(size: 18, emphasis: .bold, name: .montserrat)
    static let h4 = TextStyle(size: 16, emphasis: .bold, name: .montserrat)
    static let h5 = TextStyle(size: 14, emphasis: .bold, name: .montserrat)
    static let h6 = TextStyle(size: 13, emphasis: .bold, name: .montserrat)
    
    // Text Button
    static func buttonLarge(emphasis: Emphasis) -> TextStyle {
        TextStyle(size: 16, emphasis: emphasis)
    }
    
    static func buttonSmall(emphasis: Emphasis) -> TextStyle {
        TextStyle(size: 14, emphasis: emphasis)
    }
    
    // Text
    static let text18 = TextStyle(size: 18)
    static let text16 = TextStyle(size: 16)
    static let text13 = TextStyle(size: 13)
    static let text14 = TextStyle(size: 14)
    
    // Text highlights
    static let textHighlight24 = TextStyle(size: 24, emphasis: .bold)
    static let textHighlight20 = TextStyle(size: 20, emphasis: .bold)
}

protocol TextStyleAdjustable: UIContentSizeCategoryAdjusting {
    func setFont(_ font: UIFont)
    func apply(with textStyle: TextStyle) -> Self
}

extension TextStyleAdjustable {
    @discardableResult
    func apply(with textStyle: TextStyle) -> Self {
        let font = UIFont.preferredFont(forTextStyle: .body)
        setFont(font)
        setFont(.scalabeFont(style: textStyle))
        return self
    }
}
