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
  let deckTag: Int  = 1
  let layerStyle = styleGuide.headerLayerStyle
  let fontSet    = styleGuide.headerFontSet
  
  var deckButton: UIButton {
    return self.viewWithTag(deckTag)! as! UIButton
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    let btnStyle = styleGuide.cardBackLayerStyle

    deckButton.backgroundColor = btnStyle.bgColor
    deckButton.layer.borderColor = btnStyle.borderColor.CGColor
    deckButton.layer.borderWidth = btnStyle.borderWidth
  }
}