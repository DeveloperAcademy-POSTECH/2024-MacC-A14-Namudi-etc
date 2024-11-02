//
//  FixedExpenseListView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

struct FixedExpenseListView: View {
  @State var mode: Mode = .add
  @State private var showingSheet = false
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text("내역")
          .font(.pretendardSemibold_16)
        
        Spacer()
        
        Button {
          mode = .add
          showingSheet.toggle()
        } label: {
          Image(systemName: "plus")
            .frame(width: 19, height: 21)
        }
        .sheet(isPresented: $showingSheet) {
          FixedExpenseManageView(mode: mode)
            .presentationDetents([.fraction(0.8)])
            .presentationCornerRadius(20)
        }
      }
      .foregroundStyle(Color.textBlack)
      .padding(.leading, 22)
      .padding(.trailing, 18)
      
      FixedExpenseList(mode: $mode)
        .padding(.top, 16)
    }
  }
}

private struct FixedExpenseList: View {
  @State private var showingSheet = false
  @State private var items: [String] = ["지출 항목 1", "지출 항목 2"]
  @Binding var mode: Mode
  
  var body: some View {
    VStack(spacing: 0) {
      ForEach(items.indices, id: \.self) { index in
        ListItemView(showingSheet: $showingSheet, mode: $mode)
        
        if index < items.count - 1 {
          Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color.textBrighter)
        }
      }
    }
    .background(
      ZStack {
        RoundedRectangle(cornerRadius: 5)
          .fill(Color.whiteDefault)
        RoundedRectangle(cornerRadius: 5)
          .stroke(lineWidth: 1)
          .foregroundStyle(Color.textBrighter)
      }
    )
    .padding(.horizontal, 16)
  }
}

private struct ListItemView: View {
  @Binding var showingSheet: Bool
  @Binding var mode: Mode
  
  var body: some View {
    Button {
      mode = .modify
      showingSheet.toggle()
    } label: {
      HStack(spacing: 0) {
        Text("매달 12일")
          .font(.pretendardMedium_16)
          .foregroundStyle(Color.textBlack)
          .padding(.vertical, 6)
          .padding(.horizontal, 11)
          .background(
            RoundedRectangle(cornerRadius: 6)
              .foregroundStyle(Color.textBrighter30)
          )
        
        Spacer()
        
        Text("청약")
          .font(.pretendardMedium_20)
          .foregroundStyle(Color.textBlack)
          .padding(.trailing, 10)
        Text("100,000원")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.textBlack)
          .padding(.trailing, 6)
      }
      .padding(.vertical, 10)
      .padding(.horizontal, 6)
    }
    .sheet(isPresented: $showingSheet) {
      FixedExpenseManageView(mode: mode)
        .presentationDetents([.fraction(0.8)])
        .presentationCornerRadius(20)
    }
  }
}

#Preview {
  FixedExpenseListView()
}
