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
  @Environment(MainCoordinator.self) private var coordinator
  @State private var todayViewModel: TodayViewModel
  @State private var isInfoBubbleVisible = false
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
      NotificationManager.shared.reqNotificationPermission()
    }
    .onOpenURL { url in
      coordinator.popToRoot()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        coordinator.presentTransactionInputSheet(
          salaryBudget: todayViewModel.state.salaryBudget!,
          dailyBudget: todayViewModel.state.todayDailyBudget!,
          completion: { todayViewModel.send(.viewDidLoad) }
        )
      }
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
          .tapFeedback {
            coordinator.push(.setting(
              salaryBudget: todayViewModel.state.salaryBudget!
            ))
          }
      }
    }
    .navigationBarStyle(.clear)
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
  @Environment(MainCoordinator.self) private var coordinator
  
  // MARK: Public Properties
  @Binding var isInfoBubbleVisible: Bool
  let todayViewModel: TodayViewModel
  let screenWidth: CGFloat
  let screenHeight: CGFloat
  
  // MARK: Internal Properties
  private let hexGrid: [[Bool]] = [
    [true, false],
    [false, true, true],
    [false, true]
  ]
  
  var body: some View {
    
    let hexgonSize = (screenHeight - 114)/3
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
                coordinator.presentHarubeeAdjustSheet(
                  salaryBudget: todayViewModel.state.salaryBudget!,
                  dailyBudget: todayViewModel.state.todayDailyBudget!,
                  completion: { todayViewModel.send(.viewDidLoad) }
                )
              }
            } else if row == 2 && col == 1 {
              HarubeeHexagon(
                isInfoBubbleVisible: $isInfoBubbleVisible,
                todayViewModel: todayViewModel,
                isTodayHarubee: false,
                hexgonSize: hexgonSize
              )
              .tapFeedback(tappedBackgroundColor: .clear) {
                coordinator.presentBalanceAdjustSheet(
                  salaryBudget: todayViewModel.state.salaryBudget!,
                  dailyBudget: todayViewModel.state.todayDailyBudget!,
                  completion: { todayViewModel.send(.viewDidLoad) }
                )
              }
            } else {
              RoundedHexagon()
                .stroke(
                  hexGrid[row][col] ? Color.whiteDefault : .clear,
                  lineWidth: 1.5
                )
                .frame(width: hexgonSize, height: hexgonSize)
            }
          }
        }
      }
    }
    .offset(x: honeycombSpace - hexgonSize/5, y: -hexgonSize/5)
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
  @State private var animatedFillPercentage: CGFloat
  
  private let fillPercentage: Double
  private let isTodayExpenseEntered: Bool
  @State private var waveTimer = Timer.publish(
    every: 0.03, on: .main, in: .common
  ).autoconnect()

  
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
    self.animatedFillPercentage = fillPercentage
    self.isTodayExpenseEntered = (
      todayViewModel.state.todayDailyBudget?.expense != nil
    )
  }
  
  var body: some View {
    ZStack {
      RoundedHexagon()
        .fill(Color.main)
        .frame(width: hexgonSize, height: hexgonSize)
        .shadow(color: Color.textBlack.opacity(0.3), radius: 7, x: 1, y: 4)
      
      Wave(xOffset: firstWaveOffset, fillPercentage: animatedFillPercentage)
        .fill(isTodayHarubee ? Color.textBrighter : Color.textBlack30)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .animation(.easeInOut(duration: 1.5), value: animatedFillPercentage)
      
      Wave(xOffset: secondWaveOffset, fillPercentage: animatedFillPercentage)
        .fill(isTodayHarubee ? Color.whiteDefault :  Color.mainBright)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .animation(.easeInOut(duration: 1.5), value: animatedFillPercentage)
      
      RoundedHexagon()
        .stroke(Color.whiteDefault, lineWidth: 1.5)
        .frame(width: hexgonSize, height: hexgonSize)
      
      VStack(spacing: 0) {
        
        if !isTodayHarubee {
          Text(
            "다음 수입일(\(todayViewModel.state.nextIncomeDate.formattedDateToString(.monthDay_slash)))까지"
          )
            .font(.pretendardMedium_12)
            .foregroundStyle(.whiteDeep50)
            .infoBubble(isVisible: $isInfoBubbleVisible) {
              infoBubbleText
            }
        }
        
        if isTodayHarubee {
          hexagonLabel
            .padding(.top, isTodayHarubee ? 0 : 3)
            .animation(.easeInOut(duration: 1.5), value: animatedFillPercentage)
            .infoBubble(isVisible: $isInfoBubbleVisible) {
              infoBubbleText
            }
        } else {
          hexagonLabel
            .padding(.top, isTodayHarubee ? 0 : 3)
            .animation(.easeInOut(duration: 1.5), value: animatedFillPercentage)
        }
        
        if isTodayHarubee {
          harubeeNumberContainer
            .padding(.top, 11)
            .animation(.easeInOut(duration: 1.5), value: animatedFillPercentage)
        } else {
          balanceNumberContainer
            .padding(.top, 13)
        }
        
      }
    }
    .onAppear {
      self.waveTimer = Timer.publish(
        every: 0.03, on: .main, in: .common
      ).autoconnect()
    }
    .onDisappear {
      self.waveTimer.upstream.connect().cancel()
    }
    .onReceive(waveTimer) { _ in

      firstWaveOffset -= 1
      if firstWaveOffset < -hexgonSize {
        firstWaveOffset = 0
      }
      
      secondWaveOffset += 0.8
      if secondWaveOffset > hexgonSize {
        secondWaveOffset = 0
      }
    }
    .onChange(of: fillPercentage) { _, newPercentage in
      animatedFillPercentage = CGFloat(newPercentage)
    }
  }
  
  private var hexagonLabel: Text {
    let hexagonText = isTodayHarubee
    ? (isTodayExpenseEntered ? "오늘의 남은 하루비" : "오늘의 하루비")
    : "쓸 수 있는 돈"
    
    let textColor = isTodayHarubee
    ? (animatedFillPercentage <= 0.5
       ? Color.whiteDefault : Color.textBlack)
    : Color.whiteDefault
    
    return Text(hexagonText)
      .font(isTodayHarubee
            ? .pretendardSemibold_20
            : .pretendardSemibold_16)
      .foregroundStyle(textColor)
  }
  
  private var infoBubbleText: Text {
    Text(
      isTodayHarubee
      ? "오늘의 하루비를\n바로 조정할 수 있어요"
      : """
        쓸 수 있는 돈은 현재 잔액에서
        예정된 고정지출과 실제 지출을 뺀 금액이에요
        
        현재 잔액을 확인하고, 실제 잔액과 다르다면
        조정하여 더 정확한 하루비를 계산할 수 있어요
        """
    )
    .font(.pretendardSemibold_12)
    .foregroundStyle(Color.textBlack)
  }
  
  private var harubeeNumberContainer: some View {
    let isIncludedInWave = self.animatedFillPercentage <= 0.33
    return HStack {
      (isIncludedInWave ? Image(.harubeeWhite) : Image(.harubeeMain))
        .resizable()
        .frame(width: 20, height: 20)
      
      Text(todayViewModel.state.todayHarubee.decimalWithWon)
        .foregroundStyle(isIncludedInWave ? Color.whiteDefault : Color.main)
        .font(.pretendardSemibold_24)
    }
    .fixedSize()
    .padding(EdgeInsets(top: 4, leading: 9, bottom: 6, trailing: 10))
    .background(
      RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(Color.mainBrighter60)
    )
  }
  
  private var balanceNumberContainer: some View {
    HStack {
      Text(todayViewModel.state.todayBalance.decimalWithWon)
        .foregroundStyle(.whiteDefault)
        .font(.pretendardSemibold_20)
    }.fixedSize()
      .padding(EdgeInsets(top: 4, leading: 9, bottom: 6, trailing: 9))
      .background(
        RoundedRectangle(cornerRadius: 8)
          .foregroundStyle(Color.mainBrighter60)
      )
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
  @Environment(MainCoordinator.self) private var coordinator
  
  // MARK: Public Properties
  let todayViewModel: TodayViewModel
  @Binding var isInfoBubbleVisible: Bool
  
  var body: some View {
    VStack(spacing: 16) {
      
      CalendarStreakView(
        todayViewModel: todayViewModel,
        isInfoBubbleVisible: $isInfoBubbleVisible
      )
      .padding(.horizontal, 16)
      
      MainColorBottomButton(title: "실제 지출 및 수입 입력하기") {
        coordinator.presentTransactionInputSheet(
          salaryBudget: todayViewModel.state.salaryBudget!,
          dailyBudget: todayViewModel.state.todayDailyBudget!,
          completion: { todayViewModel.send(.viewDidLoad) }
        )
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
    .background(Color.whiteDefault)
  }
}

// MARK: - CalendarStreakView(Secondary Layer)
private struct CalendarStreakView: View {
  @Environment(MainCoordinator.self) private var coordinator
  
  // MARK: Public Properties
  let todayViewModel: TodayViewModel
  @Binding var isInfoBubbleVisible: Bool
  
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
          
          VStack {
            Text("오늘")
              .font(.pretendardSemibold_12)
              .foregroundStyle(Color.main)
              .padding(.top, 10)
            
            Spacer()
            
            hexagonImage
              .resizable()
              .frame(width: 23, height: 23)
              .padding(.bottom, 10)
          }
        }
        
        StreakGroupView(streaks: secondStreakGroup)
        
      }
      .tapFeedback {
        coordinator.push(.periodlyCalendar)
      }
    }
    .padding(.top, 10)
    .contentShape(Rectangle())
    .tapFeedback {
      coordinator.push(.periodlyCalendar)
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
      GeometryReader { proxy in
        HStack {
          ForEach(streaks.indices, id: \.self) { index in
            StreakCell(dailyStreak: streaks[index])
              .frame(width: (proxy.size.width - 16)/3)
          }
        }
      }
      .padding(.horizontal, 8)
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
    VStack {
        Text(dailyStreak.date.formattedDateToString(.dayWeekday))
          .font(.pretendardSemibold_12)
          .foregroundStyle(Color.textBright)
          .frame(width: 35, height: 14)
      
      Spacer()
      
      if dailyStreak.isAfterToday {
        
        Text(dailyStreak.harubee.amountFormat)
          .font(
            dailyStreak.isHarubeeAdjusted ? .pretendardSemibold_11
            : .pretendardMedium_11
          )
          .foregroundStyle(dailyStreak.isHarubeeAdjusted ? .main : .textBlack)
          .padding(.bottom, 14)
      } else {
        hexagonImage
          .resizable()
          .frame(width: 23, height: 23)
          .padding(.bottom, 10)
      }
    }
    .padding(.top, 10)
  }
}


#Preview {
  NavigationStack {
    TodayView(todayViewModel: DIContainer.shared.makeTodayViewModel())
  }
}
