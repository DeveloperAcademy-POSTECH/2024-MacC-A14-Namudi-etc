//
//  AppDelegate.swift
//  Harubee
//
//  Created by namdghyun on 1/18/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
#if DEBUG
    // Debug 환경의 GoogleService-Info.plist 설정
    guard let filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist"),
          let options = FirebaseOptions(contentsOfFile: filePath)
    else { return false }
    
    FirebaseApp.configure(options: options)
#else
    print("is RELEASE")
    // Release 환경의 GoogleService-Info.plist 설정
    guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
          let options = FirebaseOptions(contentsOfFile: filePath)
    else { return false }
    
    FirebaseApp.configure(options: options)
#endif
    
    return true
  }
}
