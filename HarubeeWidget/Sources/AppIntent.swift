//
//  AppIntent.swift
//  HarubeeWidget
//
//  Created by 이정동 on 11/20/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource { "Configuration" }
  static var description: IntentDescription { "This is an example widget." }
  
  // An example configurable parameter.
  @Parameter(title: "Favorite Emoji", default: "😃")
  var favoriteEmoji: String
}
