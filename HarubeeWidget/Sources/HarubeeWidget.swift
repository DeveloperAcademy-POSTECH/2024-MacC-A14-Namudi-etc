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
    
    // TODO: 수정 필요
    let currentDate = Date()
    
    let salaryBudget = WidgetManager.shared.fetchSalaryBudget()
    
    var entries: [HarubeeWidgetEntry] = []
    
    for hourOffset in 0..<5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = HarubeeWidgetEntry(date: entryDate, salaryBudget: salaryBudget)
      entries.append(entry)
    }
    
    let policyDate = Calendar.current.date(
      byAdding: .day,
      value: 1,
      to: currentDate.formattedDate
    )!
    
    completion(Timeline(
      entries: entries,
      policy: .atEnd
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
    .description("하루비 위젯입니다")
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
