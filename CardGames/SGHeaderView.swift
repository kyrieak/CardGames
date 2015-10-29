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
  let titleTag: Int  = 11
  let deckTag: Int   = 12
  let gearTag: Int   = 13
  
  
  lazy var logoButton: UIButton = {
    return (self.viewWithTag(self.titleTag)! as! UIButton)
  }()
  
  lazy var deckButton: UIButton = {
    return self.viewWithTag(self.deckTag)! as! UIButton
  }()
  
  lazy var gearButton: UIButton = {
    return self.viewWithTag(self.gearTag)! as! UIButton
  }()  

  var titleLabel: UILabel {
    return logoButton.titleLabel!
  }
}