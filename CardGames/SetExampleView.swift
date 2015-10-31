//
//  SetExampleView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/30/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetExampleView: UIView {
  let tags = SetExampleView.sectionTags()

  let control1: SetCardAttrs = SetCardAttrs(number: 1, shape: .Diamond, shading: .Solid, color: .Red)
  let control2: SetCardAttrs = SetCardAttrs(number: 2, shape: .Oval, shading: .Open, color: .Green)
  let control3: SetCardAttrs = SetCardAttrs(number: 3, shape: .Squiggle, shading: .Striped, color: .Purple)

  let cardSize: CGSize
  
  required init?(coder aDecoder: NSCoder) {
    cardSize = (deviceInfo.screenDims.min < 500) ? CGSize(width: 46, height: 64) : CGSize(width: 75, height: 100)

    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    switch(self.tag) {
      case tags.number:
        loadNumberExample()
      case tags.shape:
        loadShapeExample()
      case tags.shading:
        loadShadingExample()
      case tags.color:
        loadColorExample()
      default:
        break
    }
  }
  
  
  func loadNumberExample() {
    if (self.subviews.count < 2) {
      let cardSize: CGSize = (deviceInfo.screenDims.min < 500) ? CGSize(width: 46, height: 64) : CGSize(width: 75, height: 100)
      
      let originL = CGPoint(x: 0, y: bounds.height - cardSize.height)
      let originR = CGPoint(x: bounds.width - (cardSize.width * 3 * 1.1), y: originL.y)

      let listL = CardListView(frame: CGRect(origin: originL, size: CGSize(width: 0, height: cardSize.height)))
      let listR = CardListView(frame: CGRect(origin: originR, size: CGSize(width: 0, height: cardSize.height)))
      
      listL.addCardWith(control1)
      listL.addCardWith(SetCardAttrs(number: 1, shape: .Oval, shading: .Open, color: .Green))
      listL.addCardWith(SetCardAttrs(number: 1, shape: .Squiggle, shading: .Striped, color: .Purple))
      
      listR.addCardWith(control1)
      listR.addCardWith(control2)
      listR.addCardWith(control3)
      
      for card in listL.subviews { applyCardStyle(card) }
      for card in listR.subviews { applyCardStyle(card) }

      addSubview(listL)
      addSubview(listR)
    }
  }
  
  func applyCardStyle(cardView: UIView) {
    cardView.backgroundColor = UIColor.whiteColor()
    cardView.layer.borderColor = appGlobals.styleGuide.theme.bgColor1.getShade(-0.15).CGColor
    cardView.layer.borderWidth = 1.0
  }
  
  func loadShapeExample() {
    if (self.subviews.count < 2) {
      let originL = CGPoint(x: 0, y: bounds.height - cardSize.height)
      let originR = CGPoint(x: bounds.width - (cardSize.width * 3 * 1.1), y: originL.y)

      let listL = CardListView(frame: CGRect(origin: originL, size: CGSize(width: 0, height: cardSize.height)))
      let listR = CardListView(frame: CGRect(origin: originR, size: CGSize(width: 0, height: cardSize.height)))
      
      listL.addCardWith(control1)
      listL.addCardWith(SetCardAttrs(number: 2, shape: .Diamond, shading: .Open, color: .Green))
      listL.addCardWith(SetCardAttrs(number: 3, shape: .Diamond, shading: .Striped, color: .Purple))

      listR.addCardWith(control1)
      listR.addCardWith(control2)
      listR.addCardWith(control3)

      
      for card in listL.subviews { applyCardStyle(card) }
      for card in listR.subviews { applyCardStyle(card) }

//      appGlobals.styleGuide.applyLayerStyle(.CardFront, views: listL.subviews)
//      appGlobals.styleGuide.applyLayerStyle(.CardFront, views: listR.subviews)
      
      addSubview(listL)
      addSubview(listR)
    }
  }
  
  func loadShadingExample() {
    if (self.subviews.count < 2) {
      let originL = CGPoint(x: 0, y: bounds.height - cardSize.height)
      let originR = CGPoint(x: bounds.width - (cardSize.width * 3 * 1.1), y: originL.y)

      let listL = CardListView(frame: CGRect(origin: originL, size: CGSize(width: 0, height: cardSize.height)))
      let listR = CardListView(frame: CGRect(origin: originR, size: CGSize(width: 0, height: cardSize.height)))

      listL.addCardWith(control1)
      listL.addCardWith(SetCardAttrs(number: 2, shape: .Oval, shading: .Solid, color: .Green))
      listL.addCardWith(SetCardAttrs(number: 3, shape: .Squiggle, shading: .Solid, color: .Purple))

      listR.addCardWith(control1)
      listR.addCardWith(control2)
      listR.addCardWith(control3)

      
      for card in listL.subviews { applyCardStyle(card) }
      for card in listR.subviews { applyCardStyle(card) }

//      appGlobals.styleGuide.applyLayerStyle(.CardFront, views: listL.subviews)
//      appGlobals.styleGuide.applyLayerStyle(.CardFront, views: listR.subviews)
      
      addSubview(listL)
      addSubview(listR)
    }
  }
  
  func loadColorExample() {
    if (self.subviews.count < 2) {
      let originL = CGPoint(x: 0, y: bounds.height - cardSize.height)
      let originR = CGPoint(x: bounds.width - (cardSize.width * 3 * 1.1), y: originL.y)

      let listL = CardListView(frame: CGRect(origin: originL, size: CGSize(width: 0, height: cardSize.height)))
      let listR = CardListView(frame: CGRect(origin: originR, size: CGSize(width: 0, height: cardSize.height)))

      listL.addCardWith(control1)
      listL.addCardWith(SetCardAttrs(number: 2, shape: .Oval, shading: .Open, color: .Red))
      listL.addCardWith(SetCardAttrs(number: 3, shape: .Squiggle, shading: .Striped, color: .Red))

      listR.addCardWith(control1)
      listR.addCardWith(control2)
      listR.addCardWith(control3)
//
//      appGlobals.styleGuide.applyLayerStyle(.CardFront, views: listL.subviews)
//      appGlobals.styleGuide.applyLayerStyle(.CardFront, views: listR.subviews)

      for card in listL.subviews { applyCardStyle(card) }
      for card in listR.subviews { applyCardStyle(card) }

      
      addSubview(listL)
      addSubview(listR)
    }
  }
  
  class func sectionTags() -> (number: Int, shape: Int, shading: Int, color: Int) {
    return (number: 1, shape: 2, shading: 3, color: 4)
  }
}