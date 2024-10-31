//
//  SwiftUIView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - TodayView
struct TodayView: View {
  
  @Environment(TodayViewModel.self) var todayViewModel
  
  var body: some View {
    GeometryReader { proxy in
      NavigationStack {
        ZStack {
          Color.main.ignoresSafeArea()
          
          TodayPrimaryLayerView(todayViewModel: todayViewModel, proxy: proxy)
          
          TodaySecondaryLayerView(todayViewModel: todayViewModel)
          
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
              print("setting Button Tapped")
            }, label: {
              Image(systemName: "gearshape")
                .font(Font.system(size: 18, weight: .regular))
                .foregroundStyle(Color.whiteDefault)
            })
          }
        }
      }
    }.ignoresSafeArea()
  }
}

// MARK: - TodayPrimaryLayerView
private struct TodayPrimaryLayerView: View {
  
  private let todayViewModel: TodayViewModel
  private let screenWidth: CGFloat
  private let screenHeight: CGFloat
  
  init(todayViewModel: TodayViewModel, proxy: GeometryProxy) {
    self.todayViewModel = todayViewModel
    self.screenWidth = proxy.size.width
    self.screenHeight = proxy.size.height
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      
      Honeycomb(todayViewModel: todayViewModel,
                screenWidth: screenWidth,
                screenHeight: screenHeight)
      
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
  
  private let hexGrid: [[Bool]] = [
    [true, false],
    [false, true, true],
    [false, true]
  ]
    
  init(todayViewModel: TodayViewModel, screenWidth: CGFloat, screenHeight: CGFloat) {
    self.todayViewModel = todayViewModel
    self.screenWidth = screenWidth
    self.screenHeight = screenHeight
    self.hexgonSize = (screenHeight - 100)/3
    self.honeycombSpace = -10.0
  }
  
  
  
  var body: some View {
    VStack(spacing: honeycombSpace - (hexgonSize/(4 * sqrt(3)))) {
      ForEach(hexGrid.indices, id: \.self) { row in
        HStack(spacing: honeycombSpace - 2) {
          ForEach(hexGrid[row].indices, id: \.self) { col in
            if row == 1 && col == 1 {
              HarubeeHexagon(todayViewModel: todayViewModel, hexgonSize: hexgonSize)
            } else if row == 2 && col == 1 {
              AverageHarubeeHexagon(todayViewModel: todayViewModel, hexgonSize: hexgonSize)
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
  
  private let todayViewModel: TodayViewModel
  private let hexgonSize: CGFloat
  private let fillPercentage: Double
  
  init(todayViewModel: TodayViewModel, hexgonSize: CGFloat) {
    self.firstWaveOffset = 0.0
    self.secondWaveOffset = 0.0
    
    self.todayViewModel = todayViewModel
    self.hexgonSize = hexgonSize
    self.fillPercentage = 0.7
  }
  
  var body: some View {
    ZStack {
      RoundedHexagon()
        .fill(Color.main)
        .frame(width: hexgonSize, height: hexgonSize)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 10)
      
      Wave(xOffset: firstWaveOffset, fillPercentage: fillPercentage)
        .fill(Color.textBrighter30)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
            firstWaveOffset = hexgonSize
          }
        }
      
      Wave(xOffset: secondWaveOffset, fillPercentage: fillPercentage)
        .fill(Color.whiteDefault)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
            secondWaveOffset = hexgonSize
          }
        }
      
      RoundedHexagon()
        .fill(.clear)
        .stroke(Color.whiteDefault, lineWidth: 1.5)
        .frame(width: hexgonSize, height: hexgonSize)
      
      VStack(spacing: 9) {
        Text("오늘의 하루비")
          .foregroundStyle(Color.textBlack)
          .font(.pretendardSemibold_20)
        ZStack {
          RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(Color.mainBrighter60)
            .frame(width: 148, height: 39)
          Text(todayViewModel.state.todayHarubee.decimalWithWon)
            .foregroundStyle(Color.main)
            .font(.pretendardSemibold_24)
        }
      }
    }
  }
}


// MARK: - AverageHarubeeHexagon(Primary Layer)
private struct AverageHarubeeHexagon: View {
  
  @State private var firstWaveOffset: CGFloat
  @State private var secondWaveOffset: CGFloat
  
  private let todayViewModel: TodayViewModel
  private let hexgonSize: CGFloat
  private let fillPercentage: Double
  
  init(todayViewModel: TodayViewModel, hexgonSize: CGFloat) {
    self.firstWaveOffset = hexgonSize / 2
    self.secondWaveOffset = hexgonSize / 2
    
    self.todayViewModel = todayViewModel
    self.hexgonSize = hexgonSize
    self.fillPercentage = 0.4
  }
  
  var body: some View {
    ZStack {

      Wave(xOffset: firstWaveOffset, fillPercentage: fillPercentage)
        .fill(Color.textBlack10)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
            firstWaveOffset = hexgonSize / 2 * 3
          }
        }
      
      Wave(xOffset: secondWaveOffset, fillPercentage: fillPercentage)
        .fill(Color.mainBright)
        .frame(width: hexgonSize, height: hexgonSize)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
            secondWaveOffset = hexgonSize / 2 * 3
          }
        }
      
      RoundedHexagon()
        .stroke(Color.whiteDefault, lineWidth: 1.5)
        .frame(width: hexgonSize, height: hexgonSize)
      
      VStack(spacing: 4) {
        Text("평균 하루비")
          .font(.pretendardSemibold_16)
          .foregroundStyle(Color.whiteDeep50)
        Text(todayViewModel.state.averageHarubee.decimalWithWon)
          .font(.pretendardSemibold_20)
          .foregroundStyle(Color.whiteDefault)
      }
    }
  }
}


// MARK: - TodaySecondaryLayerView
private struct TodaySecondaryLayerView: View {
  
  private let todayViewModel: TodayViewModel
  
  init(todayViewModel: TodayViewModel) {
    self.todayViewModel = todayViewModel
  }
  
  var body: some View {
    VStack {
      
      TodayHeaderView(todayViewModel: todayViewModel)
      
      Spacer()
      
      TodayFooterView(todayViewModel: todayViewModel)
      
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
      .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 16))
  }
}

// MARK: - TodayFooterView(Secondary Layer)
private struct TodayFooterView: View {
  
  private let todayViewModel: TodayViewModel
  
  init(todayViewModel: TodayViewModel) {
    self.todayViewModel = todayViewModel
  }
  
  var body: some View {
    VStack(spacing: 16) {
      
      CalendarStreakView(todayViewModel: todayViewModel)
      
      Button(action: {
        print("실제 지출 입력하기 버튼 Tapped")
      }, label: {
        Text("실제 지출 및 수입 입력하기")
          .font(.pretendardSemibold_18)
          .foregroundColor(Color.whiteDefault)
          .frame(maxWidth: .infinity, maxHeight: 56)
          .background(Color.main)
          .cornerRadius(10)
      })
      .frame(maxWidth: .infinity, minHeight: 50)
    }
    .frame(maxWidth: .infinity, maxHeight: 196, alignment: .top)
    .padding(.horizontal, 18)
    .background(Color.whiteDefault)
  }
}

// MARK: - CalendarStreakView(Secondary Layer)
private struct CalendarStreakView: View {
  
  private let todayViewModel: TodayViewModel
  private let firstStreakGroup: [String]
  private let secondStreakGroup: [String]
  
  init(todayViewModel: TodayViewModel) {
    self.todayViewModel = todayViewModel
    self.firstStreakGroup = Array(todayViewModel.state.tempWeeklyStreaks.prefix(3))
    self.secondStreakGroup = Array(todayViewModel.state.tempWeeklyStreaks.suffix(3))
  }
  
  var body: some View {
    VStack {
      HStack {
        Text("캘린더")
          .font(.pretendardSemibold_14)
          .foregroundStyle(Color.textBlack)
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .font(Font.system(size: 12, weight: .semibold))
          .foregroundStyle(Color.textBlack)
          .frame(width: 10, height: 14)
      }
      
      HStack(spacing: 7) {
        
        StreakGroupView(streaks: firstStreakGroup)
        
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.mainBright, lineWidth: 2)
            .foregroundStyle(Color.whiteDeep50)
            .frame(maxWidth: 44, maxHeight: 65)
          
          VStack(spacing: 15) {
            Text("오늘")
              .font(.pretendardSemibold_12)
              .foregroundStyle(Color.main)
            
            Image(systemName: "hexagon")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 23, height: 23)
              .foregroundStyle(Color.main30)
          }
        }
       
        StreakGroupView(streaks: secondStreakGroup)
        
      }
    }.padding(.top, 10)
  }
}

// MARK: - StreakGroupView
private struct StreakGroupView: View {
  
  private let streaks: [String]
  
  init(streaks: [String]) {
    self.streaks = streaks
  }
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .foregroundStyle(Color.whiteDeep50)
        .frame(maxWidth: .infinity, maxHeight: 65)
      HStack {
        StreakCell(date: streaks[0])
        Spacer()
        StreakCell(date: streaks[1])
        Spacer()
        StreakCell(date: streaks[2])
      }.padding(.horizontal, 8)
    }
  }
}


// MARK: - StreakCell(Secondary Layer)
private struct StreakCell: View {
  
  private let date: String
  
  init(date: String) {
    self.date = date
  }
  
  var body: some View {
    VStack(spacing: 15) {
      Text(date)
        .font(.pretendardSemibold_12)
        .foregroundStyle(Color.textBright)
      
      Image(systemName: "hexagon")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width:23, height: 23)
        .foregroundStyle(Color.main30)
    }
  }
}


#Preview {
  TodayView()
    .environment(TodayViewModel())
}

