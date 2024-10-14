//
//  MonthlySection+SectionType.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/14/24.
//

import Foundation
import RxDataSources

struct MonthlySection {
    var firstDayOfMonth: Date
    var items: [DailyBudget]
}

extension MonthlySection: SectionModelType {
    init(original: MonthlySection, items: [DailyBudget]) {
        self = original
        self.items = items
    }
}
