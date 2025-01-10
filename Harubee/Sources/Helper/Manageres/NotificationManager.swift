//
//  NotificationManager.swift
//  Harubee-iOS
//
//  Created by 신승재 on 11/17/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import UserNotifications

// MARK: - Notification Manager
final class NotificationManager {
  static let shared = NotificationManager()
  
  private init() {}
  
  // MARK: 알림 별 identifiers
  private enum identifiers {
    static let harubeeNotification = "harubeeNotification"
    static let expenseNotification = "expenseNotification"
  }
  
  // MARK: 유저 알림 권한 요청
  func reqNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    
    center.getNotificationSettings { settings in
      switch settings.alertSetting {
      case .enabled:
        print("Notification Permission approved")
      default:
        print("not..!")
        Task {
          do {
            try await center.requestAuthorization(
              options: [.alert, .badge, .sound]
            )
          } catch {
            print("Failed to enroll with error: \(error)")
          }
          
        }
      }
    }
  }
  
  // MARK: - 푸시 알림 등록
  func scheduleNotification(
    time: Date,
    notificationType: NotificationType
  ) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .authorized, .provisional:
        
        var content: UNMutableNotificationContent {
          switch notificationType {
          case .harubee:
            let content = UNMutableNotificationContent()
            content.title = "오늘의 하루비를 확인해주세요!"
            content.body = "하루비와 함께 하루를 시작해볼까요?"
            content.sound = .default
            return content
            
          case .expense:
            let content = UNMutableNotificationContent()
            content.title = "오늘의 실제 지출을 입력하셨나요?"
            content.body = "정확한 하루비를 계산해드릴게요."
            content.sound = .default
            return content
          }
        }
        
        let dateComponents = time.getDateComponents([.hour, .minute])
        
        let trigger = UNCalendarNotificationTrigger(
          dateMatching: dateComponents, repeats: true
        )
        
        var identifier: String {
          switch notificationType {
          case .harubee:
            return identifiers.harubeeNotification
          case .expense:
            return identifiers.expenseNotification
          }
        }
        
        let request = UNNotificationRequest(
          identifier: identifier,
          content: content,
          trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
          guard error == nil else { return }
          print("scheduling notification with id:\(request.identifier)")
        }
        
      default:
        break
      }
    }
  }
  
  func deleteNotification(notificationType: NotificationType) {
    
    var identifier: String {
      switch notificationType {
      case .harubee:
        return identifiers.harubeeNotification
      case .expense:
        return identifiers.expenseNotification
      }
    }
    
    UNUserNotificationCenter.current().removePendingNotificationRequests(
      withIdentifiers: [identifier]
    )
    print("removed notification with id:\(identifier)")
  }
}
