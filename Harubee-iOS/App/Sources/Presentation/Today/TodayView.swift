//
//  SwiftUIView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared
import Domain


// MARK: - TodayView
struct TodayView: View {
  
  @State private var todayViewModel: TodayViewModel
  @State private var isInfoBubbleVisible = false
  private var screenSize: CGRect
  
  init(todayViewModel: TodayViewModel) {
    self.todayViewModel = todayViewModel
    
    guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      self.screenSize = .zero
      return
    }
    
    self.screenSize = window.screen.bounds
  }
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      
      Color.main.ignoresSafeArea()
      
      TodayPrimaryLayerView(todayViewModel: todayViewModel,
                            screenSize: screenSize,
                            isInfoBubbleVisible: $isInfoBubbleVisible)
      
      TodaySecondaryLayerView(todayViewModel: todayViewModel, isInfoBubbleVisible: $isInfoBubbleVisible)
      
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
        Button(action: {
          isInfoBubbleVisible.toggle()
        }, label: {
          Image(systemName: "questionmark.circle")
            .font(Font.system(size: 18, weight: .regular))
            .foregroundStyle(Color.whiteDefault)
        })
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          SettingView(
            settingViewModel: DIContainer.shared.makeSettingViewModel(
              salaryBudget: todayViewModel.state.salaryBudget ?? SalaryBudget.default
            )
          )
        } label: {
          Image(systemName: "gearshape")
            .font(Font.system(size: 18, weight: .regular))
            .foregroundStyle(Color.whiteDefault)
        }
      }
    }
    .navigationBarStyle(.clear(title: "", backTitle: ""))
  }
}

// MARK: - TodayPrimaryLayerView
private struct TodayPrimaryLayerView: View {
  
  private let todayViewModel: TodayViewModel
  private let screenWidth: CGFloat
  private let screenHeight: CGFloat
  
  @Binding private var isInfoBubbleVisible: Bool
  
  init(todayViewModel: TodayViewModel, screenSize: CGRect, isInfoBubbleVisible: Binding<Bool>) {
    self.todayViewModel = todayViewModel
    self._isInfoBubbleVisible = isInfoBubbleVisible
    
    self.screenWidth = screenSize.width
    self.screenHeight = screenSize.height
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      
      Honeycomb(todayViewModel: todayViewModel,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                isInfoBubbleVisible: $isInfoBubbleVisible)
      
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
  
  private let todayViewModel: TodayViewModel
  
  private let screenWidth: CGFloat
  private let screenHeight: CGFloat
  
  private let hexgonSize: CGFloat
  private let honeycombSpace: CGFloat
  
  @Binding private var isInfoBubbleVisible: Bool
  
  private let hexGrid: [[Bool]] = [
    [true, false],
    [false, true, true],
    [false, true]
  ]
  
  init(todayViewModel: TodayViewModel, screenWidth: CGFloat, screenHeight: CGFloat, isInfoBubbleVisible: Binding<Bool>) {
    self.todayViewModel = todayViewModel
    self.screenWidth = screenWidth
    self.screenHeight = screenHeight
    self.hexgonSize = (screenHeight - 100)/3
    self.honeycombSpace = -10.0
    
    self._isInfoBubbleVisible = isInfoBubbleVisible
  }
  
  
  
  var body: some View {
    VStack(spacing: honeycombSpace - (hexgonSize/(4 * sqrt(3)))) {
      ForEach(hexGrid.indices, id: \.self) { row in
        HStack(spacing: honeycombSpace - 2) {
          ForEach(hexGrid[row].indices, id: \.self) { col in
            if row == 1 && col == 1 {
              HarubeeHexagon(todayViewModel: todayViewModel,
                             isTodayHarubee: true,
                             hexgonSize: hexgonSize,
                             isInfoBubbleVisible: $isInfoBubbleVisible
              )
            } else if row == 2 && col == 1 {
              HarubeeHexagon(todayViewModel: todayViewModel,
                             isTodayHarubee: false,
                             hexgonSize: hexgonSize,
                             isInfoBubbleVisible: $isInfoBubbleVisible)
            } else {
              RoundedHexagon()
                .stroke(hexGrid[row][col] ? Color.whiteDefault: .clear, lineWidth: 1.5)
                .frame(width: hexgonSize, height: hexgonSize)
            }
          }
        }
      }
    }.offset(x: honeycombSpace - hexgonSize/5, y: -hexgonSize/5)
  }
}


// MARK: - HarubeeHexagon(Primary Layer)
private struct HarubeeHexagon: View {
  
  @State private var firstWaveOffset: CGFloat
  @State private var secondWaveOffset: CGFloat
  @Binding private var isInfoBubbleVisible: Bool
  
  
  private let todayViewModel: TodayViewModel
  private let isTodayHarubee: Bool
  private let hexgonSize: CGFloat
  private let fillPercentage: Double
  
  init(todayViewModel: TodayViewModel, isTodayHarubee: Bool, hexgonSize: CGFloat, isInfoBubbleVisible: Binding<Bool>) {
    self.firstWaveOffset = isTodayHarubee ? 0 : hexgonSize / 2
    self.secondWaveOffset = isTodayHarubee ? 0 : hexgonSize / 2
    
    self.todayViewModel = todayViewModel
    
    self.isTodayHarubee = isTodayHarubee
    self.hexgonSize = hexgonSize
    self.fillPercentage = todayViewModel.state.todayAverageHarubeePercentage
    
    self._isInfoBubbleVisible = isInfoBubbleVisible
  }
  
  var body: some View {
    ZStack {
      
      if isTodayHarubee {
        RoundedHexagon()
          .fill(Color.main)
          .frame(width: hexgonSize, height: hexgonSize)
          .shadow(color: Color.textBlack.opacity(0.3), radius: 7, x: 1, y: 4)
      }
      
      Wave(xOffset: firstWaveOffset, fillPercentage: fillPercentage)
        .fill(isTodayHarubee ? Color.textBrighter : Color.textBlack30)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(Animation.spring(duration: 6).repeatForever(autoreverses: false)) {
            firstWaveOffset = isTodayHarubee ? hexgonSize : hexgonSize / 2 * 3
          }
        }
      
      Wave(xOffset: secondWaveOffset, fillPercentage: fillPercentage)
        .fill(isTodayHarubee ? Color.whiteDefault :  Color.mainBright)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
            secondWaveOffset = isTodayHarubee ? hexgonSize : hexgonSize / 2 * 3
          }
        }
      
      RoundedHexagon()
        .stroke(Color.whiteDefault, lineWidth: 1.5)
        .frame(width: hexgonSize, height: hexgonSize)
      
      VStack(spacing: isTodayHarubee ? 9 : 2) {
        Text(isTodayHarubee ? "오늘의 남은 하루비" : "평균 하루비")
          .font(isTodayHarubee ? .pretendardSemibold_20 : .pretendardSemibold_16)
          .foregroundStyle(isTodayHarubee ? (fillPercentage <= 0.5 ? Color.whiteDefault : Color.textBlack) :  Color.whiteDeep50)
          .infoBubble(isVisible: $isInfoBubbleVisible) {
            VStack(alignment: .leading, spacing: 2) {
              Text(isTodayHarubee ? "오늘의 하루비를" : "평균 하루비는 하루비 조정과 상관없이 잔액을")
              Text(isTodayHarubee ? "바로 조정할 수 있어요" : "다음 수입일까지 남은 일로 나눈 금액을 의미해요")
            }
            .font(.pretendardSemibold_12)
            .foregroundStyle(Color.textBlack)
          }
        if isTodayHarubee {
          HStack {
            (fillPercentage <= 0.33 ? Image.harubeeWhite : Image.harubeeMain)
              .resizable()
              .frame(width: 20, height: 20)
            Text((todayViewModel.state.todayHarubee.decimalWithWon))
              .foregroundStyle(fillPercentage <= 0.33 ? Color.whiteDefault : Color.main)
              .font(.pretendardSemibold_24)
          }
          .fixedSize()
          .padding(EdgeInsets(top: 4,
                              leading: 9,
                              bottom: 6,
                              trailing: 10))
          .background(
            RoundedRectangle(cornerRadius: 8)
              .foregroundStyle(Color.mainBrighter60)
          )
        } else {
          Text(todayViewModel.state.averageHarubee.decimalWithWon)
            .font(.pretendardSemibold_20)
            .foregroundStyle(Color.whiteDefault)
        }
      }
    }
  }
}


// MARK: - TodaySecondaryLayerView
private struct TodaySecondaryLayerView: View {
  
  private let todayViewModel: TodayViewModel
  @Binding private var isInfoBubbleVisible: Bool
  
  init(todayViewModel: TodayViewModel, isInfoBubbleVisible: Binding<Bool>) {
    self.todayViewModel = todayViewModel
    self._isInfoBubbleVisible = isInfoBubbleVisible
  }
  
  var body: some View {
    VStack {
      
      TodayHeaderView(todayViewModel: todayViewModel)
      
      Spacer()
      
      TodayFooterView(todayViewModel: todayViewModel, isInfoBubbleVisible: $isInfoBubbleVisible)
      
    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}

// MARK: - TodayHeaderView(Secondary Layer)
private struct TodayHeaderView: View {
  
  private let todayViewModel: TodayViewModel
  
  init(todayViewModel: TodayViewModel) {
    self.todayViewModel = todayViewModel
  }
  
  var body: some View {
    HStack {
      Text(todayViewModel.state.todayDate.koreanFullDateString)
        .font(.pretendardSemibold_14)
        .foregroundStyle(Color.whiteDefault)
    }.frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.trailing, 16)
      .padding(.top, 6)
  }
}

// MARK: - TodayFooterView(Secondary Layer)
private struct TodayFooterView: View {
  
  private let todayViewModel: TodayViewModel
  @Binding private var isInfoBubbleVisible: Bool
  
  init(todayViewModel: TodayViewModel, isInfoBubbleVisible: Binding<Bool>) {
    self.todayViewModel = todayViewModel
    self._isInfoBubbleVisible = isInfoBubbleVisible
  }
  
  var body: some View {
    VStack(spacing: 16) {
      
      CalendarStreakView(todayViewModel: todayViewModel, isInfoBubbleVisible: $isInfoBubbleVisible)
      
      MainColorButton(title: "실제 지출 및 수입 입력하기") {
        print("실제 지출 및 수입 입력하기 버튼 Tapped")
      }
      .clipShape(RoundedRectangle(cornerRadius: 10))
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
  }
}

// MARK: - CalendarStreakView(Secondary Layer)
private struct CalendarStreakView: View {
  
  private let todayViewModel: TodayViewModel
  private let firstStreakGroup: [DailyStreak]
  private let secondStreakGroup: [DailyStreak]
  private let todayStreak: DailyStreak?
  
  @State private var navigateToCalendarView: Bool = false
  @Binding private var isInfoBubbleVisible: Bool
  
  init(todayViewModel: TodayViewModel, isInfoBubbleVisible: Binding<Bool>) {
    self.todayViewModel = todayViewModel
    let weeklyStreaks = todayViewModel.state.weeklyStreaks ?? []
    self.firstStreakGroup = Array(weeklyStreaks.prefix(3))
    self.secondStreakGroup = Array(weeklyStreaks.suffix(3))
    self._isInfoBubbleVisible = isInfoBubbleVisible
    self.todayStreak = weeklyStreaks.indices.contains(3) ? weeklyStreaks[3] : nil
  }
  
  var hexagonImage: Image {
    switch(todayStreak?.isOverHarubee) {
    case .none:
      return Image.hexagonNone
    case .some(true):
      return Image.hexagonBad
    case .some(false):
      return Image.hexagonGood
    }
  }
  
  var body: some View {
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
          RoundedRectangle(cornerRadius: 10)
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
      PeriodlyCalendarView(viewModel: DIContainer.shared.makeCalendarViewModel())
    }
    .onTapGesture {
      navigateToCalendarView = true
    }
  }
}

// MARK: - StreakGroupView
private struct StreakGroupView: View {
  
  private let streaks: [DailyStreak]
  
  init(streaks: [DailyStreak]) {
    self.streaks = streaks
  }
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
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
  
  private let dailyStreak: DailyStreak
  
  init(dailyStreak: DailyStreak) {
    self.dailyStreak = dailyStreak
  }
  
  var hexagonImage: Image {
    switch(dailyStreak.isOverHarubee) {
    case .none:
      return Image.hexagonNone
    case .some(true):
      return Image.hexagonBad
    case .some(false):
      return Image.hexagonGood
    }
  }
  
  var body: some View {
    VStack(spacing: 15) {
      ViewThatFits {
        Text(dailyStreak.date.koreanShortDateString)
          .font(.pretendardSemibold_12)
          
        Text(dailyStreak.date.koreanShortDateString)
          .font(.customFont(weight: .semiBold, size: 11))
      }
      .foregroundStyle(Color.textBright)
      .frame(width: 33, height: 14)
      
      if dailyStreak.isAfterToday {
        Text(dailyStreak.harubee.decimal)
          .font(.pretendardMedium_12)
          .foregroundStyle(Color.main)
          .padding(.vertical, 5)
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
