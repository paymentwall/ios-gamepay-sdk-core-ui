//
//  GPThemeStore.swift
//  GamePaySDKCoreUIDemo
//
//  Created by henry on 7/24/25.
//

import UIKit

public enum GPThemeStore {
    public static let defaultTheme = GPTheme(
        colors: .init(
            colorAccent: UIColor(hex: "#1253E0"),
            icColorInfo: UIColor(hex: "#098DE5"),
            icColorWarning: UIColor(hex: "#FF9900"),
            icColorError: UIColor(hex: "#FF3A3A"),
            icColorSuccess: UIColor(hex: "#00B85F"),
            bgDefaultLight: UIColor(hex: "#FFFFFF"),
            bgDefaultDark: UIColor(hex: "#060B14"),
            bgPressPrimary: UIColor(hex: "#B5CAF5"),
            bgInactive: UIColor(hex: "#D6E4FF"),
            bgInfo: UIColor(hex: "#E0F3FF"),
            bgWarning: UIColor(hex: "#FFFFE5"),
            bgSuccess: UIColor(hex: "#DAF7E9"),
            bgError: UIColor(hex: "#FFF5E5"),
            bgPressSecondary: UIColor(hex: "#000000"),
            bgPaymentDark: UIColor(hex: "#000000"),
            borderPayment: UIColor(hex: "#D6E4FF"),
            borderSubtle: UIColor(hex: "#D6E4FF"),
            borderPrimary: UIColor(hex: "#060B14"),
            borderError: UIColor(hex: "#FF3A3A"),
            borderKeyboardPrimary: UIColor(hex: "#098DE5"),
            borderKeyboardSeconday: UIColor(hex: "#E0F3FF"),
            borderMobile: UIColor(hex: "#D6E4FF"),
            textPrimary: UIColor(hex: "#060B14"),
            textSecondary: UIColor(hex: "#3E527A"),
            textButtonLight: UIColor(hex: "#FFFFFF"),
            textButtonDark: UIColor(hex: "#060B14"),
            textButtonInactivePrimary: UIColor(hex: "#D6E4FF"),
            textButtonInactiveSecondary: UIColor(hex: "#3E527A"),
            textError: UIColor(hex: "#FF3A3A")
        ),
        typography: .init(
            heading1: .systemFont(ofSize: 40, weight: .bold), // 700
            heading2: .systemFont(ofSize: 32, weight: .semibold), // 590
            heading3: .systemFont(ofSize: 24, weight: .semibold), // 590
            heading4: .systemFont(ofSize: 20, weight: .bold), // 700
            heading5: .systemFont(ofSize: 20, weight: .semibold), // 590
            label1: .systemFont(ofSize: 14, weight: .medium), // 510
            label2: .systemFont(ofSize: 12, weight: .regular), // 400
            button1: .systemFont(ofSize: 18, weight: .semibold), // 590
            button2: .systemFont(ofSize: 14, weight: .medium), // 510
            body1: .systemFont(ofSize: 16, weight: .regular), // 400
            bodyMedium1: .systemFont(ofSize: 16, weight: .bold), // 700
            body2: .systemFont(ofSize: 20, weight: .regular), // 400
            bodyMedium2: .systemFont(ofSize: 20, weight: .bold), // 700
            bodyCompact1: .systemFont(ofSize: 14, weight: .regular) // 400
        ),
        appearance: .init(
            formInsets: .init(top: 16, left: 16, bottom: 16, right: 16),
            sectionSpacing: 24,
            rowSpacing: 16,
            cornerRadius: 8,
            padding: 16,
            borderWidth: 1
        )
    )
}
