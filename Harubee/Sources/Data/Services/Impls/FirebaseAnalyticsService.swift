//
//  FirebaseAnalyticsService.swift
//  Harubee
//
//  Created by namdghyun on 1/18/25.
//

import Foundation
import FirebaseAnalytics

final class FirebaseAnalyticsService: AnalyticsService {
  func logEvent(_ name: String, parameters: [String : Any]) {
    Analytics.logEvent(name, parameters: parameters)
  }
}
