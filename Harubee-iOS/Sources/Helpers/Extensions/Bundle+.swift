//
//  BundleIdentifier.swift
//  Shared
//
//  Created by 이정동 on 11/4/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation


extension Bundle {
  public static let app = Bundle(identifier: "etc.namudi.harubee-app")
  public static let domain = Bundle(identifier: "etc.namudi.harubee-domain")
  public static let data = Bundle(identifier: "etc.namudi.harubee-data")
  public static let shared = Bundle(identifier: "etc.namudi.harubee-shared")
}
