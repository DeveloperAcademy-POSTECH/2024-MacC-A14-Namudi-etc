//
//  CalendarCell.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/5/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct CalendarCell: View {
  // MARK: - Properties
  let date: Date
  let defaultHarubee: Int
  let dailyBudget: DailyBudget?
  let onSelect: (Date) -> Void
  private var isOnboardingPreviousDay: Bool {
    dailyBudget?.harubee == -1 && dailyBudget?.expense == -1
  }
  
  // MARK: - UI Components
  var body: some View {
    Button {
      onSelect(date)
    } label: {
      ZStack {
        Rectangle()
          .fill(Color.clear)
          .frame(maxWidth: .infinity)
        
        VStack(spacing: 0) {
          dateLabel
          if !isOnboardingPreviousDay {
            iconSection
            amountLabel
          }
          Spacer()
        }
      }
    }
    .buttonStyle(
      CustomButtonStyle(
        tappedBackgroundColor: .textSecondary.opacity(0.5),
        haptic: .tap
      )
    )
    .frame(height: 90)
    .background(cellBackground)
    .padding(.vertical, 10)
    .disabled(isOnboardingPreviousDay)
  }
  
  private var dateLabel: some View {
    Text(date.formattedDateToString(.emphasizedFirstDay))
      .font(.pretendardSemibold_14)
      .foregroundStyle(.textPrimary)
      .padding(.top, 5)
  }
  
  private var iconSection: some View {
    cellIcon
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 23, height: 23)
      .frame(maxHeight: .infinity)
  }
  
  private var amountLabel: some View {
    Text(displayAmount.amountFormat)
      .font(amountFont)
      .foregroundStyle(amountColor)
      .padding(.bottom, 5)
  }
  
  private var cellBackground: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(date.isToday ? .bgSecondary50 : .clear)
      .stroke(date.isToday ? .mainSecondary : Color.clear, lineWidth: 2)
      .padding(1)
  }
  
  // MARK: - Helper Properties
  private var displayAmount: Int {
    if date > Date() {
      // 미래: 하루비만 표시
      return dailyBudget?.harubee ?? defaultHarubee
    } else if date.isToday {
      // 오늘: 실제 지출이 있으면 지출 표시, 없으면 하루비 표시
      return dailyBudget?.expense ?? (dailyBudget?.harubee ?? defaultHarubee)
    } else {
      // 과거: 실제 지출만 표시 (지출이 없으면 0)
      return dailyBudget?.expense ?? 0
    }
  }
  
  private var amountFont: Font {
    if date > Date() {
      return dailyBudget?.harubee != nil
      ? .pretendardSemibold_11
      : .pretendardMedium_11
    }
    
    return .pretendardMedium_11
  }
  
  private var amountColor: Color {
    if date > Date() {
      // 미래: 하루비 조정 여부로 색상 결정
      return dailyBudget?.harubee != nil ? .mainText : .textPrimary
    } else if date.isToday {
      // 오늘: 실제 지출이 있으면 textBlack, 없으면 하루비 조정 여부로 색상 결정
      if dailyBudget?.expense != nil {
        return .textTertiary
      }
      return dailyBudget?.harubee != nil ? .mainText : .textPrimary
    } else {
      // 과거: 항상 연한 색상
      return .textTertiary
    }
  }
  
  private var cellIcon: Image {
    if date > Date() {
      // 미래: 아이콘 표시하지 않음
      return Image(uiImage: UIImage())
    }
    
    // 지출이 있는 경우 예산 초과 여부에 따라 아이콘 결정
    if let expense = dailyBudget?.expense {
      let budget = dailyBudget?.harubee ?? defaultHarubee
      if expense > budget {
        return Image(.hexagonBad)
      } else {
        return Image(.hexagonGood)
      }
    }
    
    // 지출이 없는 경우
    if date.isToday {
      // 오늘: hexagonNone 표시
      return Image(.hexagonNone)
    } else {
      // 과거: hexagonNone 표시
      return Image(.hexagonNone)
    }
  }
}

// MARK: - Preview
struct CalendarCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      // 오늘 - 지출 없음
      CalendarCell(
        date: Date(),
        defaultHarubee: 10000,
        dailyBudget: DailyBudget(
          date: Date(),
          harubee: 10000,
          memo: [],
          expense: nil,
          income: nil
        ),
        onSelect: { _ in }
      )
      .previewDisplayName("Today - No Expense")
      
      // 오늘 - 예산 초과
      CalendarCell(
        date: Date(),
        defaultHarubee: 10000,
        dailyBudget: DailyBudget(
          date: Date(),
          harubee: 10000,
          memo: [],
          expense: 12000,
          income: 1000
        ),
        onSelect: { _ in }
      )
      .previewDisplayName("Today - Over Budget")
      
      // 오늘 - 예산 이하
      CalendarCell(
        date: Date(),
        defaultHarubee: 10000,
        dailyBudget: DailyBudget(
          date: Date(),
          harubee: 10000,
          memo: [],
          expense: 8000,
          income: nil
        ),
        onSelect: { _ in }
      )
      .previewDisplayName("Today - Under Budget")
    }
    .frame(width: 50)
  }
}
