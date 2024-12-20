//
//  Coordinator.swift
//  Harubee
//
//  Created by 이정동 on 12/18/24.
//

import SwiftUI

protocol Navigatable {
  associatedtype AppPage: Hashable
  associatedtype ContentView: View
  
  var path: [AppPage] { get set }
  
  func push(_ page: AppPage)
  func pop()
  func popToRoot()
  
  @ViewBuilder
  func buildPage(_ page: AppPage) -> ContentView
}

protocol SheetPresentable {
  associatedtype Sheet: Identifiable
  associatedtype SheetView: View
  
  var sheet: Sheet? { get set }
  
  func presentSheet(_ sheet: Sheet)
  func dismissSheet()
  
  @ViewBuilder
  func buildSheet(_ sheet: Sheet) -> SheetView
}
