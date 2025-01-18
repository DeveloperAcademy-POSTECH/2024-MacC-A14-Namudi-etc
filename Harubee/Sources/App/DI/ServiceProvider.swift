//
//  ServiceProvider.swift
//  Harubee
//
//  Created by namdghyun on 1/18/25.
//

import Foundation

final class ServiceProvider {
  lazy var analyticsService: AnalyticsService = {
    FirebaseAnalyticsService()
  }()
}
