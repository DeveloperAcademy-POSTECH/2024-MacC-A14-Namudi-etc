//
//  AnalyticsUseCaseImpl.swift
//  Harubee
//
//  Created by namdghyun on 1/18/25.
//

import Foundation

final class AnalyticsUseCaseImpl: AnalyticsUseCase {
  private let analyticsService: AnalyticsService
  
  init(analyticsService: AnalyticsService) {
    self.analyticsService = analyticsService
  }
  
  func trackEvent(event: AnalyticsEvent) {
    analyticsService.logEvent(event.name, parameters: event.parameters)
  }
}
