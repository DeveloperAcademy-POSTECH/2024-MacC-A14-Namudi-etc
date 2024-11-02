//
//  CalendarView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - Calendar View Description
///
/// `CalendarView`는 월급 기반 예산 관리 앱의 핵심 캘린더 인터페이스를 구현하는 View입니다.
/// 이 뷰는 사용자의 월급일을 기준으로 설정된 예산 기간을 캘린더 형식으로 표시하며,
/// 각 날짜별 하루비와 지출 현황을 시각적으로 보여줍니다.
///
/// ## View 계층 구조
///
/// ```
/// CalendarView
/// ├── ZStack (배경, 컬러)
/// └── VStack
///     ├── CalendarHeaderView (기간 네비게이션 관련)
///     └── TabView (페이징 가능한 기간별 캘린더)
///         └── PeriodPageView[] (SalaryBudget 개수만큼 있음)
///             └── CalendarGridView (달력 그리드)
///                 ├── WeekdayHeaderView (요일 헤더)
///                 └── CalendarCell[] (DailyBudget 개수만큼 있음)
/// ```
///
/// ## 주요 컴포넌트 설명
///
/// ### 1. CalendarHeaderView
/// - 현재 표시 중인 예산 기간의 연도와 기간(e.g., "2024", "9.20 - 10.19")을 표시
/// - 이전/다음 기간으로 이동할 수 있는 네비게이션 버튼 제공
/// - 기간 이동 가능 여부에 따라 버튼 활성화/비활성화
///
/// ### 2. TabView with PeriodPageView
/// - 여러 예산 기간을 페이징 방식으로 탐색 가능
/// - 각 PeriodPageView는 한 SalaryBudget 캘린더 페이지를 의미
/// - 스와이프 제스처로 기간 간 이동 지원
///
/// ### 3. CalendarGridView
/// - 주간 단위로 날짜를 그리드 형태로 표시
/// - WeekdayHeaderView로 요일 레이블 표시
/// - 예산 기간의 시작일에 따라 동적으로 그리드 생성
///
/// ### 4. CalendarCell
/// - 개별 날짜 정보를 표시하는 셀
/// - 표시 정보:
///   * 날짜 (월이 바뀌는 경우 "M/D" 형식으로 표시)
///   * 실제 지출 상태 표시 (실제 지출과 하루비의 차이를 비교해 HexagonIcon으로 표시)
///   * 하루비 금액 (기본 또는 조정된 금액인지 확인해 표시)
///   * 선택 상태와 오늘 날짜 하이라이트
///
/// ## 상태 관리
///
/// ### ViewModel State
/// ```swift
/// struct State {
///     var currentPeriod: Period        // 현재 표시 중인 예산 기간
///     var periodsCount: Int            // 총 예산 기간 수
///     var dayInfos: [DayInfo]          // 현재 기간의 일별 DailyBudget 정보
///     var selectedDate: Date?          // 선택된 날짜
///     var currentBudgetIndex: Int      // 현재 표시 중인 SalaryBudget 인덱스
///     var canMovePreviousPeriod: Bool  // 이전 기간 이동 가능 여부
///     var canMoveNextPeriod: Bool      // 다음 기간 이동 가능 여부
///     var error: Error?                // 에러 상태
/// }
/// ```
///
/// ### 주요 Action
/// - loadData: 초기 데이터 로드
/// - moveNextPeriod: 다음 예산 기간으로 이동
/// - movePreviousPeriod: 이전 예산 기간으로 이동
/// - onDateSelected: 특정 날짜 선택
///
/// ## 날짜 처리 로직
///
/// ### 1. 예산 기간 계산
/// - 사용자 설정 월급일 기준으로 예산 기간 결정
/// - 현재 날짜가 속한 예산 기간 자동 로드
///
/// ### 2. 캘린더 그리드 생성
/// - 예산 기간의 시작일 기준으로 첫 주 빈 셀 계산
/// - 기간 내 모든 날짜에 대한 셀 생성
/// - 마지막 주 빈 셀 추가로 그리드 완성
///
/// ## 특이사항
///
/// - 화면 진입 시 오늘 날짜 자동 선택
/// - 날짜 선택 해제 불가 (항상 하나의 날짜 선택 상태 유지. 단, 기간 이동 시 선택 해제됨)
/// - 과거/현재/미래 날짜에 따라 다른 정보 표시
///   * 과거: 실제 지출 정보
///   * 현재: 실시간 지출 현황
///   * 미래: 예정된(혹은 조정된) 하루비
///
// MARK: - Calendar View
struct CalendarView: View {
  @State private var viewModel: CalendarViewModel
  @State private var currentPageIndex: Int = 0
  
  init(viewModel: CalendarViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack {
      Color.whiteDefault
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        CalendarHeaderView(
          periodYearTitle: createYearTitle(
            from: viewModel.state.currentPeriod.start
          ),
          periodTitle: createPeriodTitle(
            start: viewModel.state.currentPeriod.start,
            end: viewModel.state.currentPeriod.end
          ),
          canMovePeriod: (
            previous: viewModel.state.canMovePreviousPeriod,
            next: viewModel.state.canMoveNextPeriod
          ),
          movePreviousPeriod: {
            viewModel.send(.movePreviousPeriod)
          },
          moveNextPeriod: {
            viewModel.send(.moveNextPeriod)
          }
        )
        
        TabView(selection: Binding(
          get: { viewModel.state.currentBudgetIndex },
          set: { newIndex in
            let oldIndex = viewModel.state.currentBudgetIndex
            if newIndex > oldIndex {
              if viewModel.state.canMoveNextPeriod {
                viewModel.send(.moveNextPeriod)
              }
            } else if newIndex < oldIndex {
              if viewModel.state.canMovePreviousPeriod {
                viewModel.send(.movePreviousPeriod)
              }
            }
          }
        )) {
          ForEach(0..<viewModel.state.periodsCount, id: \.self) { index in
            PeriodPageView(
              viewModel: viewModel
            )
            .tag(index)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
      }
    }
    .navigationTitle("캘린더")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      viewModel.send(.loadData)
    }
    .alert(
      "오류", isPresented: .constant(viewModel.state.error != nil)
    ) {
      Button("확인", role: .cancel) {
        fatalError()
      }
    } message: {
      Text(viewModel.state.error?.localizedDescription ?? "")
    }
  }
  
  // MARK: - Helper Methods
  private func createYearTitle(from date: Date) -> String {
    date.formatted(.dateTime.year().locale(Locale(identifier: "ko_KR")))
      .replacingOccurrences(of: "년", with: "년")
  }
  
  private func createPeriodTitle(start: Date, end: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M.d"
    return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
  }
  
  private func handlePageChange(oldValue: Int, newValue: Int) {
    if newValue > oldValue {
      if viewModel.state.canMoveNextPeriod {
        viewModel.send(.moveNextPeriod)
      }
    } else if newValue < oldValue {
      if viewModel.state.canMovePreviousPeriod {
        viewModel.send(.movePreviousPeriod)
      }
    }
  }
}

// MARK: - Preview
#Preview {
  NavigationView {
    CalendarView(viewModel: DIContainer.shared.makeCalendarViewModel()
    )
  }
}
