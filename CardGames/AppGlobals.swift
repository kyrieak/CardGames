//
//  AppConstants.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/12/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit


struct AppGlobals {
  let styleGuide = SGStyleGuide(theme: Theme.sea())
  
  var gameSettings = GameSettings(players: Player.makeNumberedPlayers(1))
  var gameIsActive = false
  
  var gameOptions: GameOptions {
    return self.gameSettings.options
  }
  
  var numPlayers: Int {
    return self.gameSettings.numPlayers
  }
  
  mutating func setOptions(options: GameOptions) {
    self.gameSettings.options = options
  }
}


struct DeviceInfo {
  let screenDims: (min: CGFloat, max: CGFloat)
  let isMobile: Bool

  init() {
    screenDims = UIScreen.mainScreen().bounds.getMinMaxDims()
    isMobile = screenDims.min < 415
  }
  
  func screenIsPortrait() -> Bool {
    return {(bounds: CGRect) -> Bool in
              return (bounds.width < bounds.height)
            }(UIScreen.mainScreen().bounds)
  }
}

var appGlobals = AppGlobals()
let deviceInfo = DeviceInfo()
