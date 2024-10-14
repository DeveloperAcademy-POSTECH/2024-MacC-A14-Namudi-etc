//
//  AppDelegate.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/3/24.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults().setValue(15, forKey: "incomeDate") // 급여일 설정
        print(Date().formattedDateToStringforMainView, Date().formattedDate)
        let container = DIContainer.shared
        if let salaryBudgetRepository = container.resolve(SalaryBudgetRepository.self) {
            
            // UserDefaults에서 급여일(incomeDate)를 가져옵니다.
            if let incomeDate = UserDefaults.standard.object(forKey: "incomeDate") as? Int {
                
                let (startDate, endDate) =
                calculateBudgetPeriod(incomeDate: incomeDate)
                
                // 이 기간에 대한 SalaryBudget 모델이 이미 존재하는지 확인
                checkAndCreateSalaryBudget(repository: salaryBudgetRepository, startDate: startDate, endDate: endDate)
            }
            return true
        }
        return false
    }
    
    private func calculateBudgetPeriod(incomeDate: Int) -> (startDate: Date, endDate: Date) {
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: today)
        
        if incomeDate <= components.day! {
            // 케이스 1: 급여일이 오늘이거나 이번 달에 이미 지났을 경우
            let startDate = calendar.date(from: DateComponents(year: components.year, month: components.month, day: incomeDate))!
            let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
            return (startDate, endDate)
        } else {
            // 케이스 2: 급여일이 이번 달 미래인 경우
            let lastMonthIncomeDate = calendar.date(byAdding: .month, value: -1, to: calendar.date(from: DateComponents(year: components.year, month: components.month, day: incomeDate))!)!
            let endDate = calendar.date(byAdding: .day, value: -1, to: calendar.date(from: DateComponents(year: components.year, month: components.month, day: incomeDate))!)!
            return (lastMonthIncomeDate, endDate)
        }
    }
    
    private func checkAndCreateSalaryBudget(repository: SalaryBudgetRepository, startDate: Date, endDate: Date) {
        repository.read(startDate)
            .subscribe(onNext: { existingBudget in
                if let _ = existingBudget {
                    // SalaryBudget 존재
                    print("Salarybudget already exists")
                } else {
                    self.createAndSaveSalaryBudget(repository: repository, startDate: startDate, endDate: endDate)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func createAndSaveSalaryBudget(repository: SalaryBudgetRepository, startDate: Date, endDate: Date) {
        // 새로운 SalaryBudget과 DailyBudget 모델들을 생성합니다.
        var salaryBudget = SalaryBudget(startDate: startDate,
                                        endDate: endDate,
                                        fixedIncome: 0,
                                        fixedExpense: [],
                                        balance: 0,
                                        defaultHaruby: 0,
                                        dailyBudgets: [])
        
        // 해당 기간의 각 날짜에 대해 DailyBudget 모델을 생성합니다.
        createDailyBudgets(for: &salaryBudget, from: startDate, to: endDate)
        
        // 생성한 SalaryBudget을 저장합니다.
        repository.create(salaryBudget)
            .subscribe(onNext: .none)
            .disposed(by: disposeBag)
    }
    
    private func createDailyBudgets(for salaryBudget: inout SalaryBudget, from startDate: Date, to endDate: Date) {
        var currentDate = startDate
        while currentDate <= endDate {
            let dailyBudget = DailyBudget(date: currentDate, memo: "",
                                          expense: TransactionRecord(total: 0, transactionItems: []),
                                          income: TransactionRecord(total: 0, transactionItems: []))
            salaryBudget.dailyBudgets.append(dailyBudget)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }
}
