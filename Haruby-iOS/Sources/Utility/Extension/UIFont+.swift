//
//  UIFont+.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/13/24.
//

import UIKit

extension UIFont {
    // MARK: - Pretendard Weight Type
    enum PretendardWeight {
        case thin, extraLight, light, regular, medium, semiBold, bold, extraBold, black
        
        var fontConvertible: HarubyIOSFontConvertible {
            switch self {
            case .thin: return HarubyIOSFontFamily.Pretendard.thin
            case .extraLight: return HarubyIOSFontFamily.Pretendard.extraLight
            case .light: return HarubyIOSFontFamily.Pretendard.light
            case .regular: return HarubyIOSFontFamily.Pretendard.regular
            case .medium: return HarubyIOSFontFamily.Pretendard.medium
            case .semiBold: return HarubyIOSFontFamily.Pretendard.semiBold
            case .bold: return HarubyIOSFontFamily.Pretendard.bold
            case .extraBold: return HarubyIOSFontFamily.Pretendard.extraBold
            case .black: return HarubyIOSFontFamily.Pretendard.black
            }
        }
    }
    
    // MARK: Pretendard Semibold
    static let pretendardSemibold_36: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 36)
    static let pretendardSemibold_32: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 32)
    static let pretendardSemibold_28: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 28)
    static let pretendardSemibold_24: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 24)
    static let pretendardSemibold_20: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 20)
    static let pretendardSemibold_18: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 18)
    static let pretendardSemibold_14: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 14)
    static let pretendardSemibold_12: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 12)
    static let pretendardSemibold_11: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 11)

    // MARK: Pretendard Medium
    static let pretendardMedium_24: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 24)
    static let pretendardMedium_20: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 20)
    static let pretendardMedium_18: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 18)
    static let pretendardMedium_16: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 16)
    static let pretendardMedium_14: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 14)
    static let pretendardMedium_12: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 12)
    static let pretendardMedium_11: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 11)

    // MARK: Pretendard Regular
    static let pretendardRegular_24: UIFont = HarubyIOSFontFamily.Pretendard.regular.font(size: 24)
    static let pretendardRegular_20: UIFont = HarubyIOSFontFamily.Pretendard.regular.font(size: 20)
    
    // MARK: - Custom Pretendard
    static func pretendard(size: CGFloat, weight: PretendardWeight) -> UIFont {
        weight.fontConvertible.font(size: size)
    }
    
    // MARK: - Pretendard ExtraLight
    static func pretendardExtraLight_37() -> UIFont {
        HarubyIOSFontFamily.Pretendard.extraLight.font(size: 37)
    }
}
