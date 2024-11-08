//
//  DailyMemoView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/4/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

// MARK: - Daily Memo View
struct DailyMemoView: View {
  // MARK: - Mode
  private enum Mode {
    case add
    case edit(String)
    
    var title: String {
      switch self {
      case .add: return "메모 추가"
      case .edit: return "메모 수정"
      }
    }
  }
  
  // MARK: - Properties
  @Environment(\.dismiss) private var dismiss
  @State private var memo: String
  @State private var memoStringCount: Int
  
  private let mode: Mode
  private let onComplete: (String) -> Void
  
  // MARK: - Initialization
  init(
    existingMemo: String? = nil,
    onComplete: @escaping (String) -> Void
  ) {
    self.mode = existingMemo.map(Mode.edit) ?? .add
    self.onComplete = onComplete
    _memo = State(initialValue: existingMemo ?? "")
    _memoStringCount = State(initialValue: existingMemo?.count ?? 0)
  }
  
  // MARK: - View
  var body: some View {
    VStack(spacing: 0) {
      headerView
      memoInputSection
        .padding(.top, 38)
        .padding(.horizontal, 16)
      Spacer()
      saveButton
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.top, 20)
  }
  
  private var headerView: some View {
    ZStack {
      HStack(spacing: 0) {
        Button {
          dismiss()
        } label: {
          Text("닫기")
            .font(.pretendardMedium_18)
            .foregroundStyle(Color.main)
        }
        Spacer()
      }
      .padding(.horizontal, 16)
      
      Text(mode.title)
        .font(.pretendardSemibold_18)
        .foregroundStyle(Color.textBlack)
    }
  }
  
  private var memoInputSection: some View {
    ZStack(alignment: .topTrailing) {
      Text("(\(memoStringCount)/20)")
        .font(.pretendardMedium_12)
        .foregroundStyle(Color.textBlack)
        .frame(maxWidth: .infinity, alignment: .trailing)
      
      FloatingTitleTextField(
        title: "메모",
        text: $memo,
        shouldShowKeyboard: true
      )
      .onChange(of: memo) { _, newValue in
        memoStringCount = newValue.count
      }
    }
  }
  
  private var saveButton: some View {
    Button(action: handleSave) {
      Text("저장하기")
        .font(.pretendardMedium_18)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color.whiteDefault)
        .background(
          Color.main.opacity(memo.isEmpty ? 0.3 : 1)
        )
    }
    .disabled(memo.isEmpty)
  }
  
  // MARK: - Actions
  private func handleSave() {
    onComplete(memo)
    dismiss()
  }
}

// MARK: - Preview
#Preview {
  Group {
    DailyMemoView { memo in
      print("Added memo: \(memo)")
    }
    
    DailyMemoView(
      existingMemo: "기존 메모 내용"
    ) { memo in
      print("Updated memo: \(memo)")
    }
  }
}
