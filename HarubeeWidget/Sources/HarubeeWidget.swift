//
//  HarubeeWidget.swift
//  HarubeeWidget
//
//  Created by 이정동 on 11/20/24.
//

import WidgetKit
import SwiftUI

/*
 Harubee App Target 파일들 중 Widget Target을 추가한 파일 리스트
 
 Resources
  - Colors
  - Images
  > Fonts
    - semiBold
    - medium
 Sources
  > Helper
    > DesignSystem
      - Color+
      - Font+
    > Extensions
      - Int+
 */

struct Provider: AppIntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
  }
  
  func snapshot(
    for configuration: ConfigurationAppIntent,
    in context: Context
  ) async -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: configuration)
  }
  
  func timeline(
    for configuration: ConfigurationAppIntent,
    in context: Context
  ) async -> Timeline<SimpleEntry> {
    var entries: [SimpleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }
    
    return Timeline(entries: entries, policy: .atEnd)
  }
  
  //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
  //        // Generate a list containing the contexts this widget is relevant in.
  //    }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
}

struct HarubeeWidgetEntryView : View {
  @Environment(\.widgetFamily) private var widgetFamily
  var entry: Provider.Entry
  
  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      SystemSmallWidgetView(entry: entry)
    default:
      EmptyView()
    }
  }
}

struct SystemSmallWidgetView: View {
  let entry: Provider.Entry
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("오늘의 하루비")
        .font(.pretendardMedium_14)
        .foregroundStyle(.textBright)
        .padding(.horizontal, 19)
      
      ViewThatFits {
        bodyTextView(
          text: 99999.decimalWithWon,
          textFont: .pretendardSemibold_20,
          imageSize: 18
        )
        
        bodyTextView(
          text: 9999999.formattedAsTenThousandWon,
          textFont: .pretendardSemibold_18,
          imageSize: 16
        )
      }
      .padding(.top, 2)
      .padding(.horizontal, 19)
      .lineLimit(1)
      
      
      Spacer()
      
      // TODO: AppIntent로 수정 필요
      Button {
        
      } label: {
        Text("실제 지출 입력하기")
          .font(.pretendardSemibold_12)
          .foregroundStyle(.whiteDefault)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 13)
          .background(.main)
          .clipShape(RoundedRectangle(cornerRadius: 25))
      }
      .buttonStyle(.plain)
      .padding(.horizontal, 16)

    }
    .padding(.top, 24)
    .padding(.bottom, 16)
    
  }
  
  private func bodyTextView(
    text: String,
    textFont: Font,
    imageSize: CGFloat
  ) -> some View {
    HStack {
      Image(.harubeeMain)
        .resizable()
        .frame(width: imageSize, height: imageSize)
      
      Text(text)
        .font(textFont)
        .foregroundStyle(.main)
    }
  }
}



struct HarubeeWidget: Widget {
  let kind: String = "HarubeeWidget"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind,
      intent: ConfigurationAppIntent.self,
      provider: Provider()
    ) { entry in
      HarubeeWidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("하루비")
    .description("하루비 위젯입니다")
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabled()
  }
}

extension ConfigurationAppIntent {
  fileprivate static var smiley: ConfigurationAppIntent {
    let intent = ConfigurationAppIntent()
    intent.favoriteEmoji = "😀"
    return intent
  }
  
  fileprivate static var starEyes: ConfigurationAppIntent {
    let intent = ConfigurationAppIntent()
    intent.favoriteEmoji = "🤩"
    return intent
  }
}

#Preview(as: .systemSmall) {
  HarubeeWidget()
} timeline: {
  SimpleEntry(date: .now, configuration: .smiley)
  SimpleEntry(date: .now, configuration: .starEyes)
}
