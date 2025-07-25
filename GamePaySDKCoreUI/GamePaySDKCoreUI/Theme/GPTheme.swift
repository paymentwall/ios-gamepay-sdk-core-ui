import UIKit

public struct GPTheme {
    public var colors: Colors
    public var typography: Typography
    public var appearance: Appearance
    
    public init(colors: Colors, typography: Typography, appearance: Appearance) {
        self.colors = colors
        self.typography = typography
        self.appearance = appearance
    }
}

// MARK: - Colors
public extension GPTheme {
    struct Colors {
        public var colorAccent: UIColor
        public var icColorInfo: UIColor
        public var icColorWarning: UIColor
        public var icColorError: UIColor
        public var icColorSuccess: UIColor
        public var bgDefaultLight: UIColor
        public var bgDefaultDark: UIColor
        public var bgPressPrimary: UIColor
        public var bgInactive: UIColor
        public var bgInfo: UIColor
        public var bgWarning: UIColor
        public var bgSuccess: UIColor
        public var bgError: UIColor
        public var bgPressSecondary: UIColor
        public var bgPaymentDark: UIColor
        public var borderPayment: UIColor
        public var borderSubtle: UIColor
        public var borderPrimary: UIColor
        public var borderError: UIColor
        public var borderKeyboardPrimary: UIColor
        public var borderKeyboardSeconday: UIColor
        public var borderMobile: UIColor
        public var textPrimary: UIColor
        public var textSecondary: UIColor
        public var textButtonLight: UIColor
        public var textButtonDark: UIColor
        public var textButtonInactivePrimary: UIColor
        public var textButtonInactiveSecondary: UIColor
        public var textError: UIColor
        
        public init(
            colorAccent: UIColor,
            icColorInfo: UIColor,
            icColorWarning: UIColor,
            icColorError: UIColor,
            icColorSuccess: UIColor,
            bgDefaultLight: UIColor,
            bgDefaultDark: UIColor,
            bgPressPrimary: UIColor,
            bgInactive: UIColor,
            bgInfo: UIColor,
            bgWarning: UIColor,
            bgSuccess: UIColor,
            bgError: UIColor,
            bgPressSecondary: UIColor,
            bgPaymentDark: UIColor,
            borderPayment: UIColor,
            borderSubtle: UIColor,
            borderPrimary: UIColor,
            borderError: UIColor,
            borderKeyboardPrimary: UIColor,
            borderKeyboardSeconday: UIColor,
            borderMobile: UIColor,
            textPrimary: UIColor,
            textSecondary: UIColor,
            textButtonLight: UIColor,
            textButtonDark: UIColor,
            textButtonInactivePrimary: UIColor,
            textButtonInactiveSecondary: UIColor,
            textError: UIColor
        ) {
            self.colorAccent = colorAccent
            self.icColorInfo = icColorInfo
            self.icColorWarning = icColorWarning
            self.icColorError = icColorError
            self.icColorSuccess = icColorSuccess
            self.bgDefaultLight = bgDefaultLight
            self.bgDefaultDark = bgDefaultDark
            self.bgPressPrimary = bgPressPrimary
            self.bgInactive = bgInactive
            self.bgInfo = bgInfo
            self.bgWarning = bgWarning
            self.bgSuccess = bgSuccess
            self.bgError = bgError
            self.bgPressSecondary = bgPressSecondary
            self.bgPaymentDark = bgPaymentDark
            self.borderPayment = borderPayment
            self.borderSubtle = borderSubtle
            self.borderPrimary = borderPrimary
            self.borderError = borderError
            self.borderKeyboardPrimary = borderKeyboardPrimary
            self.borderKeyboardSeconday = borderKeyboardSeconday
            self.borderMobile = borderMobile
            self.textPrimary = textPrimary
            self.textSecondary = textSecondary
            self.textButtonLight = textButtonLight
            self.textButtonDark = textButtonDark
            self.textButtonInactivePrimary = textButtonInactivePrimary
            self.textButtonInactiveSecondary = textButtonInactiveSecondary
            self.textError = textError
        }
    }
}

// MARK: - Typography
public extension GPTheme {
    struct Typography {
        public var heading1: UIFont
        public var heading2: UIFont
        public var heading3: UIFont
        public var heading4: UIFont
        public var heading5: UIFont
        public var label1: UIFont
        public var label2: UIFont
        public var button1: UIFont
        public var button2: UIFont
        public var body1: UIFont
        public var bodyMedium1: UIFont
        public var body2: UIFont
        public var bodyMedium2: UIFont
        public var bodyCompact1: UIFont
        
        public init(
            heading1: UIFont,
            heading2: UIFont,
            heading3: UIFont,
            heading4: UIFont,
            heading5: UIFont,
            label1: UIFont,
            label2: UIFont,
            button1: UIFont,
            button2: UIFont,
            body1: UIFont,
            bodyMedium1: UIFont,
            body2: UIFont,
            bodyMedium2: UIFont,
            bodyCompact1: UIFont
        ) {
            self.heading1 = heading1
            self.heading2 = heading2
            self.heading3 = heading3
            self.heading4 = heading4
            self.heading5 = heading5
            self.label1 = label1
            self.label2 = label2
            self.button1 = button1
            self.button2 = button2
            self.body1 = body1
            self.bodyMedium1 = bodyMedium1
            self.body2 = body2
            self.bodyMedium2 = bodyMedium2
            self.bodyCompact1 = bodyCompact1
        }
    }
}

// MARK: - Spacing
public extension GPTheme {
    struct Appearance {
        public var formInsets: UIEdgeInsets
        public var sectionSpacing: CGFloat
        public var rowSpacing: CGFloat
        public var cornerRadius: CGFloat
        public var padding: CGFloat
        public var borderWidth: CGFloat
        
        public init(
            formInsets: UIEdgeInsets,
            sectionSpacing: CGFloat,
            rowSpacing: CGFloat,
            cornerRadius: CGFloat,
            padding: CGFloat,
            borderWidth: CGFloat
        ) {
            self.formInsets = formInsets
            self.sectionSpacing = sectionSpacing
            self.rowSpacing = rowSpacing
            self.cornerRadius = cornerRadius
            self.padding = padding
            self.borderWidth = borderWidth
        }
    }
} 
