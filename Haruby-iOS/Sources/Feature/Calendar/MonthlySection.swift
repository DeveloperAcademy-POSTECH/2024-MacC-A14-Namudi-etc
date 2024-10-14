//
//  MonthlySection+SectionType.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/14/24.
//

import Foundation
import RxDataSources

struct MonthlySection: SectionModelType {
    var firstDayOfMonth: Date
    var items: [DailyBudget]
    
    init(original: MonthlySection, items: [DailyBudget]) {
        self = original
        self.items = items
    }
}
