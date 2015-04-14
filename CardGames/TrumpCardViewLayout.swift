//
//  TrumpCardViewLayout.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 4/7/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit


class TrumpCardViewLayout: NSObject {
  // MARK: - Properties -
  
  var drawArea, pipArea: CGRect
  var numPips: (outer: Int, inner: Int)
  var pipSize: CGSize
  var flankWidth, dy: CGFloat
  
  
  // MARK: - Initializers -
  
  init(viewRect: CGRect, attrs: TrumpCardAttributes) {
    drawArea   = TrumpCardViewLayout.paddedArea(viewRect)
    numPips    = TrumpCardViewLayout.pipDistribution(attrs.rank)
    flankWidth = TrumpCardViewLayout.flankWidthFor(drawArea)
    pipSize    = TrumpCardViewLayout.pipSizeFor(attrs.suit, width: flankWidth)
    pipArea    = TrumpCardViewLayout.pipAreaRectFor(drawArea)
    dy         = pipArea.height / CGFloat(max(numPips.outer, numPips.inner))
  }
  
  
  // MARK: - Instance Methods -
  
  func reset(viewRect: CGRect, attrs: TrumpCardAttributes) {
    drawArea   = TrumpCardViewLayout.paddedArea(viewRect)
    numPips    = TrumpCardViewLayout.pipDistribution(attrs.rank)
    flankWidth = TrumpCardViewLayout.flankWidthFor(drawArea)
    pipSize    = TrumpCardViewLayout.pipSizeFor(attrs.suit, width: flankWidth)
    pipArea    = TrumpCardViewLayout.pipAreaRectFor(drawArea)
    dy         = pipArea.height / CGFloat(max(numPips.outer, numPips.inner))
  }
  
  func topPipCenterPoint(column: PipColumn) -> CGPoint {
    var posX, posY: CGFloat
    let colWidth: CGFloat = pipArea.width / 3
    
    posY = pipSize.height * 0.5
    
    switch column {
      case .Left:
        posX = colWidth * 0.5
      case .Middle:
        posX = colWidth * 1.5
        
        if (numPips.outer > 0) {
          if ((numPips.inner == 1) && ((numPips.outer % 2) == 0)) {
            posY = pipArea.height * 0.5
          } else {
            posY += (dy * 0.5)
          }
        }
      case .Right:
        posX = colWidth * 2.5
    }
    
    return CGPoint(x: posX, y: posY)
  }
  
  
  // MARK: - Class Methods -
  
  class func paddedArea(rect: CGRect) -> CGRect {
    let pad = rect.width / 20
    
    return CGRectInset(rect, pad, pad)
  }
  
  
  class func flankWidthFor(drawArea: CGRect) -> CGFloat {
    return drawArea.width / 5
  }
  
  
  class func pipAreaRectFor(drawArea: CGRect) -> CGRect {
    let insetX = flankWidthFor(drawArea)
    let insetY = insetX / 2
    
    return CGRectInset(drawArea, insetX, insetY)
  }
  
  
  class func pipSizeFor(suit: NamedSuit, width: CGFloat) -> CGSize {
    return CGSize(width: width, height: width)
  }
  
  
  class func pipDistribution(numPipsTotal: Int) -> (outer: Int, inner: Int){
    var numOuter, numInner: Int
    
    switch(numPipsTotal) {
    case 1, 2, 3:
      numOuter = 0
    case 4, 5:
      numOuter = 2
    case 6, 7:
      numOuter = 3
    case 8, 9, 10, 11:
      numOuter = 4
    default:
      numOuter = (numPipsTotal / 2)
    }
    
    numInner = numPipsTotal - (2 * numOuter)
    
    return (outer: numOuter, inner: numInner)
  }
}


enum PipColumn {
  case Left, Middle, Right
}

