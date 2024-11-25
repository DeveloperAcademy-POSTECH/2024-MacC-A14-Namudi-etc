//
//  Bundle+.swift
//  Harubee
//
//  Created by seozero on 11/25/24.
//

import Foundation

extension Bundle {
  var shortVersionString: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
  }
}
