//
//  ContentView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct ContentView: View {
  var body: some View {
    ZStack {
      Color.main
        .ignoresSafeArea()
      
      HarubeeLottie()
    }
  }
}

#Preview {
  ContentView()
}
