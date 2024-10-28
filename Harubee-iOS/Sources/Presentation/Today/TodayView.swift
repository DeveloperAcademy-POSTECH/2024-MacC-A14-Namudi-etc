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
      ZStack(alignment: .top) {
        Color.blue.ignoresSafeArea()
        
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

#Preview {
  TodayView()
}

