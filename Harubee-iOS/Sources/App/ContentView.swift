//
//  ContentView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Lottie

public struct ContentView: View {
  @State private var isPresented: Bool = false
  
  public init() {}
  
  public var body: some View {
    VStack {
      Button {
        isPresented = true
      } label: {
        Text("Hello, World")
      }
    }
  }
}

#Preview {
  ContentView()
}
