//
//  HarubeeWidgetEntryView.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/21/24.
//

import SwiftUI
import WidgetKit

struct HarubeeWidgetEntryView : View {
  @Environment(\.widgetFamily) private var widgetFamily
  var entry: Provider.Entry
  
  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      SystemSmallWidgetView(entry: entry)
    case .systemMedium:
      SystemMediumWidgetView(entry: entry)
    default:
      EmptyView()
    }
  }
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

