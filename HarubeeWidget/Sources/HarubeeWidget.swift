//
//  HarubeeWidget.swift
//  HarubeeWidget
//
//  Created by 이정동 on 11/20/24.
//

import WidgetKit
import SwiftUI
import SwiftData

// MARK: - Provider
struct Provider: TimelineProvider {
  
  func placeholder(in context: Context) -> HarubeeWidgetEntry {
    HarubeeWidgetEntry(
      date: .now,
      salaryBudget: SalaryBudget.default
    )
  }
  
  func getSnapshot(
    in context: Context,
    completion: @escaping (HarubeeWidgetEntry) -> Void
  ) {
    completion(HarubeeWidgetEntry(
      date: .now,
      salaryBudget: SalaryBudget.default
    ))
  }
  
  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<HarubeeWidgetEntry>) -> Void
  ) {
    // 1. 오늘 날짜
    let currentDate = Date()
    
    // 2. 현재 기간에 해당하는 SalaryBudget 가져오기
    let salaryBudget = WidgetManager.shared.fetchCurrentSalaryBudget()
    
    // 3. 엔트리 저장
    let entry = HarubeeWidgetEntry(
      date: currentDate,
      salaryBudget: salaryBudget
    )
    
    // 4. 업데이트 날짜
    let afterDate = Calendar.current.date(
      byAdding: .day,
      value: 1,
      to: currentDate.formattedDate
    )!
    
    // 5. 타임라인 엔트리 등록
    completion(Timeline(
      entries: [entry],
      policy: .after(afterDate)
    ))
  }
}

// MARK: - HarubeeWidget
struct HarubeeWidget: Widget {
  let kind: String = "HarubeeWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: kind,
      provider: Provider()
    ) { entry in
      HarubeeWidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("하루비")
    .description("하루비를 확인하고 실제 지출 입력에 빠르게 접근합니다.")
    .supportedFamilies([.systemSmall, .systemMedium])
    .contentMarginsDisabled()
  }
}

// MARK: - HarubeeWidgetEntry
struct HarubeeWidgetEntry: TimelineEntry {
  let date: Date
  let salaryBudget: SalaryBudget?
}


// MARK: - Preview
#Preview("SystemMedium", as: .systemMedium) {
  HarubeeWidget()
} timeline: {
  HarubeeWidgetEntry(date: .now, salaryBudget: SalaryBudget.default)
}

#Preview("SystemSmall", as: .systemSmall) {
  HarubeeWidget()
} timeline: {
  HarubeeWidgetEntry(date: .now, salaryBudget: SalaryBudget.default)
}
