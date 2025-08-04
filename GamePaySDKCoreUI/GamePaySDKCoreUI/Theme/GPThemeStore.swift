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
            colorAccent: GPCoreUIAssets.accentDarkBlue900.color,
            icColorInfo: GPCoreUIAssets.semanticBlue800.color,
            icColorWarning: GPCoreUIAssets.semanticYellow800.color,
            icColorError: GPCoreUIAssets.semanticRed800.color,
            icColorSuccess: GPCoreUIAssets.semanticGreen800.color,
            bgDefaultLight: GPCoreUIAssets.white000.color,
            bgDefaultDark: GPCoreUIAssets.steelBlue900.color,
            bgPressPrimary: GPCoreUIAssets.lavender200.color,
            bgInactive: GPCoreUIAssets.lavender100.color,
            bgInfo: GPCoreUIAssets.backgroundBlue700.color,
            bgWarning: GPCoreUIAssets.backgroundYellow700.color,
            bgSuccess: GPCoreUIAssets.backgroundGreen700.color,
            bgError: GPCoreUIAssets.backgroundRed700.color,
            bgPressSecondary: GPCoreUIAssets.backgroundBlack900.color,
            bgPaymentDark: GPCoreUIAssets.backgroundBlack900.color,
            borderPayment: GPCoreUIAssets.lavender100.color,
            borderSubtle: GPCoreUIAssets.lavender100.color,
            borderPrimary: GPCoreUIAssets.steelBlue900.color,
            borderError: GPCoreUIAssets.semanticRed800.color,
            borderKeyboardPrimary: GPCoreUIAssets.semanticBlue800.color,
            borderKeyboardSeconday: GPCoreUIAssets.backgroundBlue700.color,
            borderMobile: GPCoreUIAssets.lavender100.color,
            textPrimary: GPCoreUIAssets.steelBlue900.color,
            textSecondary: GPCoreUIAssets.steelBlue300.color,
            textButtonLight: GPCoreUIAssets.white000.color,
            textButtonDark: GPCoreUIAssets.steelBlue900.color,
            textButtonInactivePrimary: GPCoreUIAssets.steelBlue300.color,
            textButtonInactiveSecondary: GPCoreUIAssets.lavender300.color,
            textError: GPCoreUIAssets.semanticRed800.color
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
            bodyMedium1: .systemFont(ofSize: 16, weight: .medium), // 500
            body2: .systemFont(ofSize: 20, weight: .regular), // 400
            bodyMedium2: .systemFont(ofSize: 20, weight: .medium), // 500
            bodyCompact1: .systemFont(ofSize: 14, weight: .regular) // 400
        ),
        appearance: .init(
            formInsets: .init(top: 16, leading: 16, bottom: 16, trailing: 16),
            sectionSpacing: 24,
            rowSpacing: 16,
            cornerRadius: 8,
            padding: 16,
            borderWidth: 1
        )
    )
}
