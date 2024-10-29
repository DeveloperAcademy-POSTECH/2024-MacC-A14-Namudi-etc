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
  
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  let hexgonSize = (UIScreen.main.bounds.height - 100)/3
  let honeycombSpace = -10.0
  
  let hexGrid: [[Hexagon]] = [
    [Hexagon(isStroked: true), Hexagon(isStroked: false)],
    [Hexagon(isStroked: false), Hexagon(isStroked: true), Hexagon(isStroked: true)],
    [Hexagon(isStroked: false), Hexagon(isStroked: true)],
  ]
  
  var body: some View {
    ZStack {
      VStack(spacing: honeycombSpace - (hexgonSize/(4 * sqrt(3)))) {
        ForEach(hexGrid.indices, id: \.self) { index in
          HStack(spacing: honeycombSpace - 2) {
            ForEach(hexGrid[index], id: \.self) { item in
              RoundedHexagon()
                .stroke(item.isStroked ? .white: .clear, lineWidth: 1.5)
                .frame(width: hexgonSize, height: hexgonSize)
            }
          }
        }
      }
    }
    .offset(x: honeycombSpace - hexgonSize/5, y: -hexgonSize/5)
    .frame(maxWidth: screenWidth, maxHeight: screenHeight, alignment: .top)
    .ignoresSafeArea()
  }
  
  struct Hexagon: Hashable {
    var isStroked: Bool
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

private struct RoundedHexagon: Shape {
  
  private let cornerRadius: CGFloat = 15
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let centerX = rect.width / 2
    let centerY = rect.height / 2
    let radius = min(rect.width, rect.height) / 2
    
    var points: [CGPoint] = []
    
    for i in 0..<6 {
        let angle = (CGFloat(i) * (2 * .pi / 6)) - (.pi / 2)
        let x = centerX + radius * cos(angle)
        let y = centerY + radius * sin(angle)
        points.append(CGPoint(x: x, y: y))
    }
    
    path.move(to: CGPoint(x: points[5].x + CGFloat(sqrt(3) * 5), y: points[5].y - 5))
    
    path.addArc(tangent1End: points[0], tangent2End: points[1], radius: cornerRadius)
    path.addArc(tangent1End: points[1], tangent2End: points[2], radius: cornerRadius)
    path.addArc(tangent1End: points[2], tangent2End: points[3], radius: cornerRadius)
    path.addArc(tangent1End: points[3], tangent2End: points[4], radius: cornerRadius)
    path.addArc(tangent1End: points[4], tangent2End: points[5], radius: cornerRadius)
    path.addArc(tangent1End: points[5], tangent2End: points[0], radius: cornerRadius)
    
    path.closeSubpath()
    
    return path
  }
}

#Preview {
  TodayView()
}

