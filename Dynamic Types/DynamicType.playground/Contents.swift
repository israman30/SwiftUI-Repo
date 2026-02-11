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

struct TextStyle {
    let size: CGFloat
    let emphasis: Emphasis
    let name: Name
    
    typealias Name = String
    
    init(size: CGFloat, emphasis: Emphasis, name: Name) {
        self.size = size
        self.emphasis = emphasis
        self.name = name
    }
    
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
