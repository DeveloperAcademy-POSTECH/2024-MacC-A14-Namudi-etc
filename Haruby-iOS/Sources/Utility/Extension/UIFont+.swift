//
//  UIFont+.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/13/24.
//

import UIKit

extension UIFont {
    // MARK: - Pretendard
    static func pretendard(size: CGFloat, weight: PretendardWeight) -> UIFont {
        weight.fontConvertible.font(size: size)
    }
    
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
    static var pretendardSemibold_36: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 36)
    static var pretendardSemibold_32: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 32)
    static var pretendardSemibold_28: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 28)
    static var pretendardSemibold_24: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 24)
    static var pretendardSemibold_20: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 20)
    static var pretendardSemibold_18: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 18)
    static var pretendardSemibold_14: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 14)
    static var pretendardSemibold_12: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 12)
    static var pretendardSemibold_11: UIFont = HarubyIOSFontFamily.Pretendard.semiBold.font(size: 11)

    // MARK: Pretendard Medium
    static var pretendardMedium_24: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 24)
    static var pretendardMedium_20: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 20)
    static var pretendardMedium_18: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 18)
    static var pretendardMedium_16: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 16)
    static var pretendardMedium_14: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 14)
    static var pretendardMedium_12: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 12)
    static var pretendardMedium_11: UIFont = HarubyIOSFontFamily.Pretendard.medium.font(size: 11)

    // MARK: Pretendard Regular
    static var pretendardRegular_24: UIFont = HarubyIOSFontFamily.Pretendard.regular.font(size: 24)
    static var pretendardRegular_20: UIFont = HarubyIOSFontFamily.Pretendard.regular.font(size: 20)
}
