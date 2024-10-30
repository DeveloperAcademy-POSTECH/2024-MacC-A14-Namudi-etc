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
  
  @Environment(TodayViewModel.self) var todayViewModel
  
  var body: some View {
    NavigationStack {
      ZStack {
        //TODO: 디자인 시스템 적용
        Color(red: 88/255, green: 73/255, blue: 228/255, opacity: 1)
          .ignoresSafeArea()
        
        TodayPrimaryLayerView()
        
        TodaySecondaryLayerView(todayViewModel: todayViewModel)
        
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            print("setting Button Tapped")
          }, label: {
            Image(systemName: "gearshape")
              .resizable()
              .frame(width: 25, height: 25)
              .foregroundStyle(.white)
          })
        }
      }
    }
  }
}

// MARK: - TodayPrimaryLayerView
private struct TodayPrimaryLayerView: View {
  
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  
  var body: some View {
    ZStack(alignment: .top) {
      
      Honeycomb(screenWidth: screenWidth, screenHeight: screenHeight)
      
      LinearGradient(
        //TODO: 디자인 시스템 적용
        gradient: Gradient(colors: [Color(red: 88/255, green: 73/255, blue: 228/255, opacity: 1), Color(red: 88/255, green: 73/255, blue: 228/255, opacity: 1), Color(red: 88/255, green: 73/255, blue: 228/255, opacity: 0)]),
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
  
  let screenWidth: CGFloat
  let screenHeight: CGFloat
  
  let hexgonSize: CGFloat
  let honeycombSpace: CGFloat
  
  init(screenWidth: CGFloat, screenHeight: CGFloat) {
    self.screenWidth = screenWidth
    self.screenHeight = screenHeight
    self.hexgonSize = (screenHeight - 100)/3
    self.honeycombSpace = -10.0
  }
  
  let hexGrid: [[Bool]] = [
    [true, false],
    [false, true, true],
    [false, true]
  ]
  
  var body: some View {
    VStack(spacing: honeycombSpace - (hexgonSize/(4 * sqrt(3)))) {
      ForEach(hexGrid.indices, id: \.self) { row in
        HStack(spacing: honeycombSpace - 2) {
          ForEach(hexGrid[row].indices, id: \.self) { col in
            if row == 1 && col == 1 {
              HarubeeHexagon(hexgonSize: hexgonSize)
            } else if row == 2 && col == 1 {
              AverageHarubeeHexagon(hexgonSize: hexgonSize)
            } else {
              RoundedHexagon()
                .stroke(hexGrid[row][col] ? .white: .clear, lineWidth: 1.5)
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
  
  @State private var xOffset = 0.0
  let hexgonSize: CGFloat
  
  init(hexgonSize: CGFloat) {
    self.hexgonSize = hexgonSize
  }
  
  var body: some View {
    Button(action: {
      print("오늘의 하루비 Tapped")
    }, label: {
      ZStack {
        RoundedHexagon()
          .fill(.clear)
          .stroke(.white, lineWidth: 1.5)
          .frame(width: hexgonSize, height: hexgonSize)
          .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 10)
        
        Wave(xOffset: xOffset, fillPercentage: 0.6)
          .fill(.white)
          .frame(width: hexgonSize, height: hexgonSize)
          .clipShape(RoundedHexagon())
          .onAppear {
            withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
              xOffset = hexgonSize
            }
          }
        VStack {
          Text("오늘의 하루비")
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .frame(width: 148, height: 39)
            Text("36,000원")
              .foregroundStyle(.white)
          }
        }
      }
    })
  }
}

// MARK: - AverageHarubeeHexagon(Primary Layer)
private struct AverageHarubeeHexagon: View {
  
  @State private var firstWaveOffset: CGFloat
  @State private var secondWaveOffset: CGFloat
  let hexgonSize: CGFloat
  
  init(hexgonSize: CGFloat) {
    self.firstWaveOffset = hexgonSize / 2
    self.secondWaveOffset = hexgonSize / 2
    self.hexgonSize = hexgonSize
  }
  
  var body: some View {
    ZStack {
      RoundedHexagon()
        .stroke(.white, lineWidth: 1.5)
        .frame(width: hexgonSize, height: hexgonSize)
      
      Wave(xOffset: firstWaveOffset, fillPercentage: 0.4)
        .fill(Color(red: 33/255, green: 33/255, blue: 46/255, opacity: 0.1))
        .frame(width: hexgonSize - 1, height: hexgonSize - 1)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(Animation.linear(duration: 7).repeatForever(autoreverses: false)) {
            firstWaveOffset = hexgonSize / 2 * 3
          }
        }
      
      Wave(xOffset: secondWaveOffset, fillPercentage: 0.4)
        .fill(Color(red: 137/255, green: 142/255, blue: 235/255, opacity: 1))
        .frame(width: hexgonSize - 1, height: hexgonSize - 1)
        .clipShape(RoundedHexagon())
        .onAppear {
          withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
            secondWaveOffset = hexgonSize / 2 * 3
          }
        }
      
      VStack {
        Text("평균 하루비")
        Text("55,000원")
        
      }
    }
  }
}


// MARK: - TodaySecondaryLayerView
private struct TodaySecondaryLayerView: View {
  
  let todayViewModel: TodayViewModel
  
  init(todayViewModel: TodayViewModel) {
    self.todayViewModel = todayViewModel
  }
  
  var body: some View {
    VStack {
      
      TodayHeaderView(todayViewModel: todayViewModel)
      
      Spacer()
      
      TodayFooterView()
      
    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}

// MARK: - TodayHeaderView(Secondary Layer)
private struct TodayHeaderView: View {
  
  let todayViewModel: TodayViewModel
  
  init(todayViewModel: TodayViewModel) {
    self.todayViewModel = todayViewModel
  }
  
  var body: some View {
    HStack {
      Text(todayViewModel.viewState.todayDate.toKoreanFullDateString)
        .bold()
        .foregroundStyle(.white)
    }.frame(maxWidth: .infinity, alignment: .trailing)
      .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 16))
  }
}

// MARK: - TodayFooterView(Secondary Layer)
private struct TodayFooterView: View {
  var body: some View {
    VStack(spacing: 0) {
      CalendarStreakView()
      
      Button(action: {
        print("실제 지출 입력하기 버튼 Tapped")
      }, label: {
        Text("실제 지출 및 수입 입력하기")
          .bold()
          .foregroundColor(.white)
          .frame(maxWidth: .infinity, maxHeight: 56)
          .background(Color.blue)
          .cornerRadius(10)
      })
      .padding(.top, 17)
      .frame(maxWidth: .infinity, minHeight: 50)
    }
    .frame(maxWidth: .infinity, maxHeight: 190, alignment: .top)
    .padding(.horizontal, 18)
    .background(.white)
  }
}

// MARK: - CalendarStreakView(Secondary Layer)
private struct CalendarStreakView: View {
  var body: some View {
    Button(action: {
      print("Calendar View로 이동")
    }, label: {
      VStack {
        HStack {
          Text("캘린더")
          Spacer()
          Image(systemName: "chevron.right")
            .resizable()
            .frame(width: 8, height: 12)
        }
        
        HStack(spacing: 7) {
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .frame(maxWidth: .infinity, maxHeight: 65)
            HStack {
              StreakCell()
              Spacer()
              StreakCell()
              Spacer()
              StreakCell()
            }.padding(.horizontal, 8)
          }
          
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .frame(maxWidth: 44, maxHeight: 65)
            VStack {
              Text("오늘")
                .font(Font.system(size: 12))
                .foregroundStyle(.white)
              
              Image(systemName: "hexagon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:20, height: 20)
                .foregroundStyle(.white)
            }
          }
          
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .frame(maxWidth: .infinity, maxHeight: 65)
            HStack {
              StreakCell()
              Spacer()
              StreakCell()
              Spacer()
              StreakCell()
            }.padding(.horizontal, 8)
          }
        }
      }.padding(.top, 10)
    })
  }
}

// MARK: - StreakCell(Secondary Layer)
private struct StreakCell: View {
  var body: some View {
    VStack(spacing: 5) {
      Text("19(일)")
        .font(Font.system(size: 12))
        .foregroundStyle(.white)
      
      Image(systemName: "hexagon")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width:20, height: 20)
        .foregroundStyle(.white)
    }
  }
}


#Preview {
  TodayView()
    .environment(TodayViewModel())
}

