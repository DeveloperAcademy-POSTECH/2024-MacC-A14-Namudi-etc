//
//  CalendarDailyView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct CalendarDailyView: View {
  var body: some View {
    VStack(spacing: 30) {
      BodyView()
      FooterView()
    }
    .padding(.top, 26)
  }
  
}

private struct BodyView: View {
  @State private var showingSheet: Bool = false
  var body: some View {
    VStack(spacing: 0) {
      // MARK: 오늘의 하루비
      ZStack {
        RoundedRectangle(cornerRadius: 5)
          .stroke(lineWidth: 1)
          .frame(height: 53)
          .foregroundStyle(Color.mainBright)
        
        HStack(spacing: 0) {
          Text("오늘의 하루비")
            .font(.pretendardSemibold_16)
            .padding(.leading, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text("52,000원")
            .font(.pretendardSemibold_18)
            .foregroundStyle(Color.main)
            .padding(.trailing, 14)
        }
      }
      .padding(.horizontal, 16)
      
      HStack(spacing: 9) {
        // TODO: 공통 컴포넌트로 변경
        ZStack {
          RoundedRectangle(cornerRadius: 5)
            .fill(Color.textBrighter30)
          VStack(spacing: 16) {
            Text("수입")
              .font(.pretendardSemibold_16)
              .foregroundStyle(Color.textBlack)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal, 14)
            Text("- 원")
              .font(.pretendardSemibold_18)
              .foregroundStyle(Color.textBlack)
              .frame(maxWidth: .infinity, alignment: .trailing)
              .padding(.horizontal, 14)
          }
        }
        // TODO: 공통 컴포넌트로 변경
        ZStack {
          RoundedRectangle(cornerRadius: 5)
            .fill(Color.textBrighter30)
          VStack(spacing: 16) {
            Text("지출")
              .font(.pretendardSemibold_16)
              .foregroundStyle(Color.textBlack)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal, 14)
            Text("- 원")
              .font(.pretendardSemibold_18)
              .foregroundStyle(Color.textBlack)
              .frame(maxWidth: .infinity, alignment: .trailing)
              .padding(.horizontal, 14)
          }
        }
      }
      .frame(height: 84)
      .padding(.horizontal, 16)
      .padding(.top, 16)
      
      VStack(spacing: 8) {
        HStack(spacing: 0) {
          Text("메모")
            .font(.pretendardSemibold_16)
            .foregroundStyle(Color.textBlack)
          
          Spacer()
          
          Button {
            showingSheet.toggle()
          } label: {
            Image(systemName: "plus")
              .frame(width: 19, height: 21)
          }
          .foregroundStyle(Color.textBlack)
          .sheet(isPresented: $showingSheet) {
            DailyMemoAddView()
              .presentationDetents([.fraction(0.25)])
              .presentationCornerRadius(20)
          }
        }
        .padding(.leading, 6)
        .padding(.trailing, 2)
        
        ZStack {
          RoundedRectangle(cornerRadius: 5) // TODO: 메모 개수 늘어나면 리스트 형식, 수정 필요
            .stroke(lineWidth: 1)
            .frame(height: 52)
            .foregroundStyle(Color.textBrighter)
          Text("") // TODO: 메모 내용으로 넣어줘야 함
            .font(.pretendardMedium_16)
            .foregroundStyle(Color.textBlack)
        }
      }
      .padding(.horizontal, 16)
      .padding(.top, 49)
    }
  }
}

private struct FooterView: View {
  var body: some View {
    VStack(spacing: 0) {
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBlack10)
        .padding(.horizontal, 16)
      
      Text("예정된 고정 지출")
        .font(.pretendardSemibold_16)
        .foregroundStyle(Color.textBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 22)
        .padding(.top, 14)
      
      VStack(spacing: 14) {
        FixedExpenseListItem()
      }
      .padding(.top, 22)
    }
    .padding(.bottom, 44)
  }
}

private struct FixedExpenseListItem: View {
  var body: some View {
    HStack(spacing: 0) {
      // TODO: 데이터 받아와서 띄워줘야 함
      Text("월세")
        .font(.pretendardMedium_14)
        .foregroundStyle(Color.textBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
      Text("500,000원")
        .font(.pretendardSemibold_14)
        .foregroundStyle(Color.redDefault)
    }
    .padding(.horizontal, 22)
  }
}

#Preview {
  CalendarDailyView()
}
