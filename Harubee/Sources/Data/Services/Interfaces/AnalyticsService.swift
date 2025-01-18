//
//  AnalyticsService.swift
//  Harubee
//
//  Created by namdghyun on 1/18/25.
//

import Foundation

protocol AnalyticsService {
  func logEvent(_ name: String, parameters: [String: Any])
}
