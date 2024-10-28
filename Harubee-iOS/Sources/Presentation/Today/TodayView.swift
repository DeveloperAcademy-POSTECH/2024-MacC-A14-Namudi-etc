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
  var body: some View {
    NavigationStack {
      ZStack {
        Color.blue.ignoresSafeArea()
        
        TodayPrimaryLayerView()
        
        TodaySecondaryLayerView()
        
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
  var body: some View {
    Text("This is Today Primary Layer View")
      .foregroundStyle(.white)
  }
}

// MARK: - TodaySecondaryLayerView
private struct TodaySecondaryLayerView: View {
  var body: some View {
    VStack {
      
      TodayHeaderView()
      
      Spacer()
      
      TodayFooterView()
      
    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}

// MARK: - TodayHeaderView
private struct TodayHeaderView: View {
  var body: some View {
    HStack {
      Text("2024년 10월 8일 (화)")
        .bold()
        .foregroundStyle(.white)
    }.frame(maxWidth: .infinity, alignment: .trailing)
      .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 16))
  }
}

// MARK: - TodayFooterView
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
    .frame(maxWidth: .infinity, maxHeight: 182, alignment: .top)
    .padding(.horizontal, 18)
    .background(.white)
  }
}

// MARK: - CalendarStreakView
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
              StreakCellView()
              Spacer()
              StreakCellView()
              Spacer()
              StreakCellView()
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
                .frame(width:20, height: 20)
                .foregroundStyle(.white)
            }
          }
          
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .frame(maxWidth: .infinity, maxHeight: 65)
            HStack {
              StreakCellView()
              Spacer()
              StreakCellView()
              Spacer()
              StreakCellView()
            }.padding(.horizontal, 8)
          }
        }
      }.padding(.top, 10)
    })
  }
}

private struct StreakCellView: View {
  var body: some View {
    VStack(spacing: 5) {
      Text("19(일)")
        .font(Font.system(size: 12))
        .foregroundStyle(.white)
      
      Image(systemName: "hexagon")
        .resizable()
        .frame(width:20, height: 20)
        .foregroundStyle(.white)
    }
  }
}



#Preview {
  TodayView()
}

