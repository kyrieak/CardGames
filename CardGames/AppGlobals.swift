//
//  AppConstants.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/12/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

var styleGuide = SGStyleGuide(theme: Theme.green())
var gameSettings = GameSettings(players: Player.makeNumberedPlayers(1))
var minScreenDim = {(bounds: CGRect) -> CGFloat in
                      return min(bounds.width, bounds.height)
                   }(UIScreen.mainScreen().bounds)

func screenIsPortrait() -> Bool {
  return {(bounds: CGRect) -> Bool in
    return (bounds.width < bounds.height)
  }(UIScreen.mainScreen().bounds)
}