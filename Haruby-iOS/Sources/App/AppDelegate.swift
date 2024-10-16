//
//  AppDelegate.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/3/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let disposeBag = DisposeBag()
        let salaryRepo = SalaryBudgetRepositoryImpl()
        let dailyRepo = DailyBudgetRepositoryImpl()
        
//        salaryRepo.create(mockSalaryBudget)
//            .subscribe { _ in
//                print("Finish create")
//            }
//            .disposed(by: disposeBag)
        return true
    }
}

import RxSwift
let mockSalaryBudget: SalaryBudget = SalaryBudget(
    startDate: .now.formattedDate,
    endDate: .now.addingTimeInterval(86400 * 30).formattedDate,
    fixedIncome: 1000000,
    fixedExpense: [
        TransactionItem(name: "월세", price: 300000),
        TransactionItem(name: "전기", price: 10000),
        TransactionItem(name: "가스", price: 10000)
    ],
    balance: 600000,
    defaultHaruby: 20000,
    dailyBudgets: [
        DailyBudget(
            date: .now.formattedDate,
            memo: "1번",
            expense: TransactionRecord(
                total: 13000,
                transactionItems: [
                    TransactionItem(name: "초콜릿", price: 3000),
                    TransactionItem(name: "택시비", price: 10000),
                ]
            ),
            income: TransactionRecord(
                total: 50000,
                transactionItems: [
                    TransactionItem(name: "용돈", price: 50000)
                ]
            )
        )
    ]
)
