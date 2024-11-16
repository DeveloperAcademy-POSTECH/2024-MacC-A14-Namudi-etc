//
//  SwiftUIView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI


// MARK: - TodayView
struct TodayView: View {
  
  @State private var todayViewModel: TodayViewModel
  @State private var isInfoBubbleVisible = false
  @State private var navigateToSettingView = false
  private var screenSize: CGRect
  
  init(todayViewModel: TodayViewModel) {
    self.todayViewModel = todayViewModel
    
    guard
      let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
    else {
      self.screenSize = .zero
      return
    }
    
    self.screenSize = window.screen.bounds
  }
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      
      Color.main.ignoresSafeArea()
      
      TodayPrimaryLayerView(
        isInfoBubbleVisible: $isInfoBubbleVisible,
        todayViewModel: todayViewModel,
        screenSize: screenSize
      )
      
      TodaySecondaryLayerView(
        todayViewModel: todayViewModel,
        isInfoBubbleVisible: $isInfoBubbleVisible
      )
      
      if isInfoBubbleVisible {
        Color.clear
          .contentShape(Rectangle())
          .ignoresSafeArea()
          .onTapGesture {
            isInfoBubbleVisible.toggle()
          }
      }
    }
    .onAppear {
      todayViewModel.send(.viewDidLoad)
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Image(systemName: "questionmark.circle")
          .font(Font.system(size: 18, weight: .regular))
          .foregroundStyle(Color.whiteDefault)
          .tapFeedback {
            isInfoBubbleVisible.toggle()
          }
          .padding(.trailing, 8)
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        Image(systemName: "gearshape")
          .font(Font.system(size: 18, weight: .regular))
          .foregroundStyle(Color.whiteDefault)
          .navigationDestination(isPresented: $navigateToSettingView) {
            SettingView(
              settingViewModel: DIContainer.shared.makeSettingViewModel(
                salaryBudget: todayViewModel.state.salaryBudget
                ?? SalaryBudget.default
              )
            )
          }
          .tapFeedback {
            navigateToSettingView = true
          }
      }
    }
    .navigationBarStyle(.clear(title: "", backTitle: ""))
  }
}

// MARK: - TodayPrimaryLayerView
private struct TodayPrimaryLayerView: View {
  
  @Binding var isInfoBubbleVisible: Bool
  let todayViewModel: TodayViewModel
  let screenSize: CGRect
  
  var body: some View {
    
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height
    
    ZStack(alignment: .top) {
      
      Honeycomb(
        isInfoBubbleVisible: $isInfoBubbleVisible,
        todayViewModel: todayViewModel,
        screenWidth: screenWidth,
        screenHeight: screenHeight
      )
      
      LinearGradient(
        gradient: Gradient(colors: [Color.main, Color.main, .clear]),
        startPoint: .top,
        endPoint: .bottom
      )
      .frame(width: screenWidth, height: 130)
    }
    .frame(maxWidth: screenWidth, maxHeight: screenHeight, alignment: .top)
    .ignoresSafeArea()
  }
}

// MARK: - Honeycomb(Primary Layer)
private struct Honeycomb: View {
  
  // MARK: Public Properties
  @Binding var isInfoBubbleVisible: Bool
  let todayViewModel: TodayViewModel
  let screenWidth: CGFloat
  let screenHeight: CGFloat
  
  // MARK: Internal Properties
  @State private var isPresented: Bool = false
  private let hexGrid: [[Bool]] = [
    [true, false],
    [false, true, true],
    [false, true]
  ]
  
  var body: some View {
    
    let hexgonSize = (screenHeight - 100)/3
    let honeycombSpace = -10.0
    
    VStack(spacing: honeycombSpace - (hexgonSize/(4 * sqrt(3)))) {
      ForEach(hexGrid.indices, id: \.self) { row in
        HStack(spacing: honeycombSpace - 2) {
          ForEach(hexGrid[row].indices, id: \.self) { col in
            if row == 1 && col == 1 {
              HarubeeHexagon(
                isInfoBubbleVisible: $isInfoBubbleVisible,
                 todayViewModel: todayViewModel,
                 isTodayHarubee: true,
                 hexgonSize: hexgonSize
              )
              .tapFeedback(tappedBackgroundColor: .clear) {
                self.isPresented = true
              }
            } else if row == 2 && col == 1 {
              HarubeeHexagon(
                isInfoBubbleVisible: $isInfoBubbleVisible,
                todayViewModel: todayViewModel,
                isTodayHarubee: false,
                hexgonSize: hexgonSize
              )
            } else {
              RoundedHexagon()
                .stroke(hexGrid[row][col] ? Color.whiteDefault : .clear, lineWidth: 1.5)
                .frame(width: hexgonSize, height: hexgonSize)
            }
          }
        }
      }
    }
    .offset(x: honeycombSpace - hexgonSize/5, y: -hexgonSize/5)
    .sheet(isPresented: $isPresented) {
      todayViewModel.send(.viewDidLoad)
    } content: {
      HarubeeAdjustView(
        viewModel: DIContainer.shared.makeHarubeeAdjustViewModel(
          salaryBudget: todayViewModel.state.salaryBudget!,
          dailyBudget: todayViewModel.state.todayDailyBudget!
        )
      )
      .presentationDetents([.height(623)])
    }
  }
}


// MARK: - HarubeeHexagon(Primary Layer)
private struct HarubeeHexagon: View {
  
  // MARK: Public Properties
  @Binding var isInfoBubbleVisible: Bool
  let todayViewModel: TodayViewModel
  let isTodayHarubee: Bool
  let hexgonSize: CGFloat
  
  // MARK: Internal Properties
  @State private var firstWaveOffset: CGFloat
  @State private var secondWaveOffset: CGFloat
  private let fillPercentage: Double
  private let isTodayExpenseEntered: Bool
  
  
  init(
    isInfoBubbleVisible: Binding<Bool>,
    todayViewModel: TodayViewModel,
    isTodayHarubee: Bool,
    hexgonSize: CGFloat
  ) {
    self._isInfoBubbleVisible = isInfoBubbleVisible
    self.todayViewModel = todayViewModel
    self.isTodayHarubee = isTodayHarubee
    self.hexgonSize = hexgonSize
    
    self.firstWaveOffset = isTodayHarubee ? 0 : hexgonSize / 2
    self.secondWaveOffset = isTodayHarubee ? 0 : hexgonSize / 2
    self.fillPercentage = isTodayHarubee
    ? todayViewModel.state.todayHarubeePercentage
    : todayViewModel.state.todayBalancePercentage
    self.isTodayExpenseEntered = (
      todayViewModel.state.todayDailyBudget?.expense != nil
    )
  }
  
  var body: some View {
    
    let hexagonLabel: Text = {
        let hexagonText = isTodayHarubee
            ? (isTodayExpenseEntered ? "오늘의 남은 하루비" : "오늘의 하루비")
            : "쓸 수 있는 돈"
        
        let textColor = isTodayHarubee
            ? (fillPercentage <= 0.5 ? Color.whiteDefault : Color.textBlack)
            : Color.whiteDeep50
        
        return Text(hexagonText)
            .font(isTodayHarubee
                  ? .pretendardSemibold_20
                  : .pretendardSemibold_16)
            .foregroundStyle(textColor)
    }()
    
    let infoBubbleText: Text = {
      Text(isTodayHarubee
           ? "오늘의 하루비를\n바로 조정할 수 있어요"
           : "평균 하루비는 하루비 조정과 상관없이 잔액을\n다음 수입일까지 남은 일로 나눈 금액을 의미해요")
      .font(.pretendardSemibold_12)
      .foregroundStyle(Color.textBlack)
    }()
    
    let harubeeNumberContainer: some View = {
      
      let isIncludedInWave = fillPercentage <= 0.33
      
      return HStack {
        (isIncludedInWave ? Image(.harubeeWhite) : Image(.harubeeMain))
          .resizable()
          .frame(width: 20, height: 20)
        
        Text((todayViewModel.state.todayHarubee.decimalWithWon))
          .foregroundStyle(isIncludedInWave ? Color.whiteDefault : Color.main)
          .font(.pretendardSemibold_24)
      }
      .fixedSize()
      .padding(EdgeInsets(top: 4, leading: 9, bottom: 6, trailing: 10)
      )
      .background(
        RoundedRectangle(cornerRadius: 8)
          .foregroundStyle(Color.mainBrighter60)
      )
    }()
    
    ZStack {
      RoundedHexagon()
        .fill(Color.main)
        .frame(width: hexgonSize, height: hexgonSize)
        .shadow(color: Color.textBlack.opacity(0.3), radius: 7, x: 1, y: 4)
      
      Wave(xOffset: firstWaveOffset, fillPercentage: fillPercentage)
        .fill(isTodayHarubee ? Color.textBrighter : Color.textBlack30)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(
            Animation.spring(duration: 6).repeatForever(autoreverses: false)
          ) {
            firstWaveOffset = isTodayHarubee
            ? hexgonSize
            : hexgonSize / 2 * 3
          }
        }
      
      Wave(xOffset: secondWaveOffset, fillPercentage: fillPercentage)
        .fill(isTodayHarubee ? Color.whiteDefault :  Color.mainBright)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(
            Animation.linear(duration: 5).repeatForever(autoreverses: false)
          ) {
            secondWaveOffset = isTodayHarubee
            ? hexgonSize
            : hexgonSize / 2 * 3
          }
        }
      
      RoundedHexagon()
        .stroke(Color.whiteDefault, lineWidth: 1.5)
        .frame(width: hexgonSize, height: hexgonSize)
      
      VStack(spacing: isTodayHarubee ? 9 : 2) {
        
        hexagonLabel
          .infoBubble(isVisible: $isInfoBubbleVisible) {
            infoBubbleText
          }
        
        if isTodayHarubee {
          
          harubeeNumberContainer
          
        } else {
          Text(todayViewModel.state.todayBalance.decimalWithWon)
            .font(.pretendardSemibold_20)
            .foregroundStyle(Color.whiteDefault)
        }
      }
    }
  }
}


// MARK: - TodaySecondaryLayerView
private struct TodaySecondaryLayerView: View {
  
  let todayViewModel: TodayViewModel
  @Binding var isInfoBubbleVisible: Bool
  
  var body: some View {
    VStack {
      
      TodayHeaderView(todayViewModel: todayViewModel)
      
      Spacer()
      
      TodayFooterView(
        todayViewModel: todayViewModel,
        isInfoBubbleVisible: $isInfoBubbleVisible
      )
      
    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}

// MARK: - TodayHeaderView(Secondary Layer)
private struct TodayHeaderView: View {
  
  let todayViewModel: TodayViewModel
  
  var body: some View {
    HStack {
      Text(todayViewModel.state.todayDate.formattedDateToString(.fullDate_kr))
        .font(.pretendardSemibold_14)
        .foregroundStyle(Color.whiteDefault)
    }.frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.trailing, 16)
      .padding(.top, 6)
  }
}

// MARK: - TodayFooterView(Secondary Layer)
private struct TodayFooterView: View {
  
  // MARK: Public Properties
  let todayViewModel: TodayViewModel
  @Binding var isInfoBubbleVisible: Bool
  
  // MARK: Internal Properties
  @State private var isPresented: Bool = false
  
  var body: some View {
    VStack(spacing: 16) {
      
      CalendarStreakView(
        todayViewModel: todayViewModel,
        isInfoBubbleVisible: $isInfoBubbleVisible
      )
      
      MainColorButton(title: "실제 지출 및 수입 입력하기", cornerRadius: 10) {
        self.isPresented = true
      }
      .infoBubble(isVisible: $isInfoBubbleVisible) {
        VStack(alignment: .leading, spacing: 2) {
          Text("실제 지출 및 수입을 매일 입력해야")
          Text("더 정확한 하루비를 확인할 수 있어요")
        }
        .font(.pretendardSemibold_12)
        .foregroundStyle(Color.textBlack)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: 196, alignment: .top)
    .padding(.horizontal, 16)
    .background(Color.whiteDefault)
    .sheet(isPresented: $isPresented) {
      todayViewModel.send(.viewDidLoad)
    } content: {
      TransactionInputView(
        viewModel: DIContainer.shared.makeTransactionInputViewModel(
          salaryBudget: todayViewModel.state.salaryBudget!,
          dailyBudget: todayViewModel.state.todayDailyBudget!
        ),
        isFocusedExpense: true
      )
      .presentationDetents([.height(623)])
    }
  }
}

// MARK: - CalendarStreakView(Secondary Layer)
private struct CalendarStreakView: View {
  
  // MARK: Public Properties
  let todayViewModel: TodayViewModel
  @Binding var isInfoBubbleVisible: Bool
  
  // MARK: Internal Properties
  @State private var navigateToCalendarView: Bool = false
  
  
  var body: some View {
    
    let weeklyStreaks = todayViewModel.state.weeklyStreaks ?? []
    let firstStreakGroup = Array(weeklyStreaks.prefix(3))
    let secondStreakGroup = Array(weeklyStreaks.suffix(3))
    let todayStreak = weeklyStreaks.indices.contains(3)
    ? weeklyStreaks[3]
    : nil
    
    var hexagonImage: Image {
      switch(todayStreak?.isOverHarubee) {
      case .none:
        return Image(.hexagonNone)
      case .some(true):
        return Image(.hexagonBad)
      case .some(false):
        return Image(.hexagonGood)
      }
    }
    
    VStack {
      HStack {
        Text("캘린더")
          .font(.pretendardSemibold_14)
          .foregroundStyle(Color.textBlack)
          .infoBubble(isVisible: $isInfoBubbleVisible, alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 2) {
              Text("캘린더에서 다른 날짜들의")
              Text("하루비를 확인하고 조정해요")
            }
            .font(.pretendardSemibold_12)
            .foregroundStyle(Color.textBlack)
          }
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .font(Font.system(size: 12, weight: .semibold))
          .foregroundStyle(Color.textBlack)
          .frame(width: 10, height: 14)
      }
      .padding(.horizontal, 4)
      
      HStack(spacing: 7) {
        
        StreakGroupView(streaks: firstStreakGroup)
        
        ZStack {
          RoundedRectangle(cornerRadius: 8)
            .fill(Color.whiteDeep50)
            .stroke(Color.mainBright, lineWidth: 2)
            .foregroundStyle(Color.whiteDeep50)
            .frame(maxWidth: 50, maxHeight: 72)
          
          VStack(spacing: 15) {
            Text("오늘")
              .font(.pretendardSemibold_12)
              .foregroundStyle(Color.main)
            
            hexagonImage
              .resizable()
              .frame(width: 23, height: 23)
          }
        }
        
        StreakGroupView(streaks: secondStreakGroup)
        
      }
      .tapFeedback {
        navigateToCalendarView = true
      }
    }
    .padding(.top, 10)
    .contentShape(Rectangle())
    .navigationDestination(isPresented: $navigateToCalendarView) {
      PeriodlyCalendarView(
        viewModel: DIContainer.shared.makeCalendarViewModel()
      )
    }
    .onTapGesture {
      navigateToCalendarView = true
    }
  }
}

// MARK: - StreakGroupView
private struct StreakGroupView: View {
  
  let streaks: [DailyStreak]
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(Color.whiteDeep50)
        .frame(maxWidth: .infinity, maxHeight: 72)
      HStack {
        ForEach(streaks.indices, id: \.self) { index in
          StreakCell(dailyStreak: streaks[index])
          if index < streaks.count - 1 {
            Spacer()
          }
        }
      }.padding(.horizontal, 8)
    }
  }
}


// MARK: - StreakCell(Secondary Layer)
private struct StreakCell: View {
  
  let dailyStreak: DailyStreak
  
  var hexagonImage: Image {
    switch(dailyStreak.isOverHarubee) {
    case .none:
      return Image(.hexagonNone)
    case .some(true):
      return Image(.hexagonBad)
    case .some(false):
      return Image(.hexagonGood)
    }
  }
  
  var body: some View {
    VStack(spacing: 15) {
      ViewThatFits {
        Text(dailyStreak.date.formattedDateToString(.dayWeekday))
          .font(.pretendardSemibold_12)
        
        Text(dailyStreak.date.formattedDateToString(.dayWeekday))
          .font(.pretendardSemibold_11)
      }
      .foregroundStyle(Color.textBright)
      .frame(width: 33, height: 14)
      
      if dailyStreak.isAfterToday {
        ViewThatFits {
          Text(dailyStreak.harubee.decimal)
            .font(.pretendardMedium_12)
          
          Text(dailyStreak.harubee.decimal)
            .font(.pretendardMedium_11)
          
          Text(dailyStreak.harubee.formattedAsTenThousandWon)
            .font(.pretendardMedium_11)
        }.padding(.vertical, 5)
          .foregroundStyle(Color.main)
      } else {
        hexagonImage
          .resizable()
          .frame(width: 23, height: 23)
      }
    }
  }
}


#Preview {
  NavigationStack {
    TodayView(todayViewModel: DIContainer.shared.makeTodayViewModel())
  }
}
