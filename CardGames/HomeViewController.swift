//
//  GameSettingController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 8/31/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
  @IBOutlet var numPlayersLabel: UILabel!
  @IBOutlet var playBtn: UIButton!

  var style = styleGuide
  var themeID = styleGuide.themeID
  
  func viewsForLayerStyle(sel: ViewSelector) -> [UIView] {
    switch(sel) {
      case .MainContent:
        return [self.view]
      default:
        return []
    }
  }
  
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel] {
    return []
  }
  
  func applyStyleToViews() {
    //
  }
}