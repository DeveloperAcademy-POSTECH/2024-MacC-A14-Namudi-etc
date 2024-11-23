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
  
  private enum identifiers {
    static let harubeeNotification = "harubeeNotification"
    static let expenseNotification = "expenseNotification"
  }
  
  //MARK: 유저 알림 권한 요청
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
            print("Failed to enroll Aniyah with error: \(error)")
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
        let content = UNMutableNotificationContent()
        content.title = "알림 제목입니다."
        content.body = "알림 바디입니다."
        content.sound = .default
        content.badge = 1
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(
          [.hour, .minute], from: time
        )
        
        let trigger = UNCalendarNotificationTrigger(
          dateMatching: dateComponents, repeats: true
        )
        
        let identifier: String = {
            switch notificationType {
            case .harubee:
                return identifiers.harubeeNotification
            case .expense:
                return identifiers.expenseNotification
            }
        }()
        
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
    
    let identifier: String = {
        switch notificationType {
        case .harubee:
            return identifiers.harubeeNotification
        case .expense:
            return identifiers.expenseNotification
        }
    }()
    
    UNUserNotificationCenter.current().removeDeliveredNotifications(
      withIdentifiers: [identifier]
    )
  }
}
