//
//  SGHeaderView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 9/8/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SGHeaderView: UIView {
  let titleTag: Int  = 1
  let deckTag: Int   = 2
  let gearTag: Int   = 3
  
  lazy var titleLabel: UILabel = {
    return self.viewWithTag(self.titleTag)! as! UILabel
    }()
  
  lazy var deckButton: UIButton = {
    return self.viewWithTag(self.deckTag)! as! UIButton
  }()
  
  lazy var gearButton: UIButton = {
    return self.viewWithTag(self.gearTag)! as! UIButton
  }()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    if (screenIsPortrait && (minScreenDim > 376) && (minScreenDim < 415)) {
      for c in constraints {
        if (c.firstAttribute == NSLayoutAttribute.Height) {
          c.constant = CGFloat(132 + 50)
        }
      }
    }
  }
}