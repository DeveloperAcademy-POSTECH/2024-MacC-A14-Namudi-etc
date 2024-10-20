//
//  MainViewConstants.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/16/24.
//

import UIKit

/// 메인 뷰의 기본값 상수
struct MainViewConstants {
    static let emptyAmountString = "0원"
    static let noDataTitle = "데이터 없음"
    static let todayHarubyTitle = "오늘의 하루비"
    static let remainingHarubyTitle = "오늘의 남은 하루비"
}

/// 실제 지출 값에 따른 상태를 조정하는 열거형
enum MainViewHarubyState {
    case initial, positive, negative
    
    var uiProperties: (boxColor: UIColor, labelColor: UIColor, image: UIImage) {
        switch self {
        case .initial:
            return (UIColor.Haruby.whiteDeep, UIColor.Haruby.main, .purpleHaruby)
        case .positive:
            return (UIColor.Haruby.green10, UIColor.Haruby.green, .greenHaruby)
        case .negative:
            return (UIColor.Haruby.red10, UIColor.Haruby.red, .redHaruby)
        }
    }
    
    var title: String {
        switch self {
        case .initial:
            return MainViewConstants.todayHarubyTitle
        case .positive, .negative:
            return MainViewConstants.remainingHarubyTitle
        }
    }
}
