//
//  UserDefaultsManager.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/17/24.
//


import Foundation

final class UserDefaultsManager {
    enum Key: String {
        case incomeDate
    }
    
    static func setIncomeDate(_ date: Int) {
        UserDefaults.standard.set(date, forKey: Key.incomeDate.rawValue)
    }
    
    static func getIncomeDate() -> Int {
        return UserDefaults.standard.integer(forKey: Key.incomeDate.rawValue)
    }
}
