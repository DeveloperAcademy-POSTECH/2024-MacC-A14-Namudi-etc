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
    static func pretendardSemibold_36() -> UIFont {
        HarubyIOSFontFamily.Pretendard.semiBold.font(size: 36)
    }
    
    static func pretendardSemibold_32() -> UIFont {
        HarubyIOSFontFamily.Pretendard.semiBold.font(size: 32)
    }
    
    static func pretendardSemibold_28() -> UIFont {
        HarubyIOSFontFamily.Pretendard.semiBold.font(size: 28)
    }
    
    static func pretendardSemibold_24() -> UIFont {
        HarubyIOSFontFamily.Pretendard.semiBold.font(size: 24)
    }
    
    static func pretendardSemibold_20() -> UIFont {
        HarubyIOSFontFamily.Pretendard.semiBold.font(size: 20)
    }
    
    static func pretendardSemibold_18() -> UIFont {
        HarubyIOSFontFamily.Pretendard.semiBold.font(size: 18)
    }
    
    static func pretendardSemibold_14() -> UIFont {
        HarubyIOSFontFamily.Pretendard.semiBold.font(size: 14)
    }
    
    static func pretendardSemibold_12() -> UIFont {
        HarubyIOSFontFamily.Pretendard.semiBold.font(size: 12)
    }
    
    static func pretendardSemibold_11() -> UIFont {
        HarubyIOSFontFamily.Pretendard.semiBold.font(size: 11)
    }
    
    // MARK: Pretendard Medium
    static func pretendardMedium_24() -> UIFont {
        HarubyIOSFontFamily.Pretendard.medium.font(size: 24)
    }
    
    static func pretendardMedium_20() -> UIFont {
        HarubyIOSFontFamily.Pretendard.medium.font(size: 20)
    }
    
    static func pretendardMedium_18() -> UIFont {
        HarubyIOSFontFamily.Pretendard.medium.font(size: 18)
    }
    
    static func pretendardMedium_16() -> UIFont {
        HarubyIOSFontFamily.Pretendard.medium.font(size: 16)
    }
    
    static func pretendardMedium_14() -> UIFont {
        HarubyIOSFontFamily.Pretendard.medium.font(size: 14)
    }
    
    static func pretendardMedium_12() -> UIFont {
        HarubyIOSFontFamily.Pretendard.medium.font(size: 12)
    }
    
    static func pretendardMedium_11() -> UIFont {
        HarubyIOSFontFamily.Pretendard.medium.font(size: 11)
    }
    
    // MARK: Pretendard Regular
    static func pretendardRegular_24() -> UIFont {
        HarubyIOSFontFamily.Pretendard.regular.font(size: 24)
    }
    
    static func pretendardRegular_20() -> UIFont {
        HarubyIOSFontFamily.Pretendard.regular.font(size: 20)
    }
}
