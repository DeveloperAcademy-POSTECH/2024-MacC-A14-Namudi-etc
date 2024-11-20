//
//  NotificationManager.swift
//  Harubee-iOS
//
//  Created by 신승재 on 11/17/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import UserNotifications

// MARK: - Notification Manager
final class NotifiactionManager {
  static let shared = NotifiactionManager()
  
  private init() {}
  
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
  func scheduleNotification(hour: Int, minute: Int) -> Void {
    
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .authorized, .provisional:
        let content = UNMutableNotificationContent()
        content.title = "알림 제목입니다."
        content.body = "알림 바디입니다."
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(
          dateMatching: dateComponents, repeats: true
        )
        
        let request = UNNotificationRequest(
          identifier: UUID().uuidString,
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
}
