//
//  ContentView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

public struct ContentView: View {
  public init() {}
  
  public var body: some View {
    Text("Hello, World!")
      .foregroundStyle(Color.redDefault)
      .padding()
    
    Button {
      print("Hello, World")
    } label: {
      Text("Hello, World")
    }
  }
}

#Preview {
  ContentView()
}
