//
//  SceneDelegate.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/3/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        
        let reactor = CalculatorViewReactor(salaryBudget: mockSalaryBudget)
        let vc = CalculatorViewController()

        vc.reactor = reactor
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

let mockSalaryBudget: SalaryBudget = SalaryBudget(
    startDate: .now.formattedDate,
    endDate: .now.addingTimeInterval(86400 * 5).formattedDate,
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
