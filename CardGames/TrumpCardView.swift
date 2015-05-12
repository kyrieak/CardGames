//
//  TrumpCardView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 3/26/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class TrumpCardView: UIView {
  private var cardAttrs: TrumpCardAttributes
  var cardBack = UIView(frame: CGRectZero)

  let style = Style()
  
  var suitColor: UIColor {
    switch (cardAttrs.suit) {
      case .Diamonds, .Hearts:
        return UIColor.redColor()
      case .Spades, .Clubs:
        return UIColor.blackColor()
    }
  }
  
  init(frame: CGRect, attrs: TrumpCardAttributes) {
    cardAttrs = attrs

    super.init(frame: frame)

    style.applyShade(self.layer, color: style.liteShadeColor, thickness: 1)
    setupCardBackView()
  }
  
  required init(coder aDecoder: NSCoder) {
    cardAttrs = TrumpCardAttributes(rank: 1, suit: NamedSuit.Hearts, faceUp: false)

    super.init(coder: aDecoder)
    
    style.applyShade(self.layer, color: style.darkShadeColor, thickness: 1)
    setupCardBackView()
  }
  
  private func setupCardBackView() {
    cardBack.frame = CGRect(origin: CGPointZero, size: self.frame.size)
    style.applyCardBg(cardBack)
    
    if (cardAttrs.faceUp) {
      cardBack.hidden = true
    }
    
    self.addSubview(cardBack)
  }
  
  private func setupContext(context: CGContextRef) {
    let color = suitColor.CGColor
    
    CGContextSetLineWidth(context, 2.0)
    CGContextSetStrokeColorWithColor(context, color)
    CGContextSetFillColorWithColor(context, color)
  }
  
  
  func flipCard() {
    cardAttrs.faceUp = !cardAttrs.faceUp

    if (cardAttrs.faceUp) {
      cardBack.hidden = true
    } else {
      cardBack.hidden = false
    }
  }

  
  func displayCard(attrs: TrumpCardAttributes) {
    cardAttrs = attrs

    if (cardAttrs.faceUp) {
      cardBack.hidden = true
    } else {
      cardBack.hidden = false
    }
    
    self.setNeedsDisplay()
  }
  
  
  override func drawRect(rect: CGRect) {
    let layout = TrumpCardViewLayout(viewRect: rect, attrs: cardAttrs)
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSaveGState(context) // --- Context Saved -1 ---
    
    setupContext(context)
    
    CGContextSaveGState(context) // --- Context Saved 0 ---
    
    var offsetOrigin = layout.drawArea.origin

    drawFromOffsetOrigin(context, offset: offsetOrigin, drawFunc: {
      self.drawFlank(context, flankWidth: layout.flankWidth, pipSize: layout.pipSize)
    })
    
    offsetOrigin = CGPoint(x: layout.drawArea.maxX, y: layout.drawArea.maxY)
    
    drawFromOffsetOrigin(context, offset: offsetOrigin, drawFunc: {
      CGContextRotateCTM(context, CGFloat(M_PI))
      self.drawFlank(context, flankWidth: layout.flankWidth, pipSize: layout.pipSize)
    })
    
    offsetOrigin = layout.pipArea.origin
    
    drawFromOffsetOrigin(context, offset: offsetOrigin, drawFunc: {
      self.drawPipArea(context, layout: layout)
    })
    
    CGContextRestoreGState(context) // --- Context Restored 0 ---
    CGContextRestoreGState(context) // --- Context Restored -1 ---
  }
  
  func drawFromOffsetOrigin(context: CGContext, offset: CGPoint, drawFunc: () -> ()) {
    CGContextSaveGState(context)
    CGContextTranslateCTM(context, offset.x, offset.y)
    
    drawFunc()

    CGContextRestoreGState(context)
  }
  
  func drawColoredRect(context: CGContextRef, rect: CGRect, color: UIColor) {
    var rectPath = UIBezierPath(rect: rect)
    
    CGContextSetFillColorWithColor(context, color.CGColor)
    rectPath.fill()
    CGContextSetFillColorWithColor(context, suitColor.CGColor)
  }
  
  func drawFlank(context: CGContextRef, flankWidth: CGFloat, pipSize: CGSize) {
    var rankText = addTextAttrs(rankString(), fontSize: pipSize.height)
    var posX, posY: CGFloat

    posX = (flankWidth - rankText.size().width) / 2

    rankText.drawAtPoint(CGPoint(x: posX, y: 0))
    
    posY = rankText.size().height + (pipSize.height / 2)

    drawPip(CGPoint(x: flankWidth / 2, y: posY), pipSize: pipSize)
  }
  
  func addTextAttrs(str: String, fontSize: CGFloat) -> NSMutableAttributedString {
    var font = CTFontCreateWithName("Baskerville", fontSize, nil)
    
    var attrs: [NSObject: AnyObject] = [NSFontAttributeName: font,
      NSForegroundColorAttributeName: suitColor]
    
    return NSMutableAttributedString(string: str, attributes: attrs)
  }
  
  
  func drawPipArea(context: CGContextRef, layout: TrumpCardViewLayout) {
//    var origin = layout.drawArea.origin.getDistance(layout.pipArea.origin)
//    CGContextTranslateCTM(context, origin.x, origin.y)

    
    let numPips = layout.numPips
    let dy = layout.dy
    let pipSize = layout.pipSize

    var drawPip: (CGPoint, CGSize) -> Void

    switch cardAttrs.suit {
      case .Hearts:
        drawPip = drawHeartPip
      case .Clubs:
        drawPip = drawClubPip
      case .Diamonds:
        drawPip = drawDiamondPip
      case .Spades:
        drawPip = drawSpadePip
    }

    if (numPips.outer > 0) {
      let topLeft = layout.topPipCenterPoint(PipColumn.Left)
      let topRight = layout.topPipCenterPoint(PipColumn.Right)
      var (pipCenterL, pipCenterR) = (topLeft, topRight)

      var didReflect = false
      
      
      for i in 1...layout.numPips.outer {
        if (pipCenterL.y > layout.pipArea.midY) {
          CGContextSaveGState(context)
          CGContextTranslateCTM(context, 0, layout.pipArea.height)
          CGContextScaleCTM(context, 1.0, -1.0)
          pipCenterL.y = topLeft.y
          pipCenterR.y = topRight.y
          didReflect = true
        }
        
        drawPip(pipCenterL, pipSize)
        drawPip(pipCenterR, pipSize)
        pipCenterL.y += dy
        pipCenterR.y += dy
      }
      
      if (didReflect) {
        CGContextRestoreGState(context)
      }
    }

    if (numPips.inner > 0) {
      let topMid = layout.topPipCenterPoint(PipColumn.Middle)
      var pipCenterM = topMid
      var didReflect = false
      
      for i in 1...layout.numPips.inner {
        if (pipCenterM.y > layout.pipArea.midY) {
          CGContextSaveGState(context)
          CGContextTranslateCTM(context, 0, layout.pipArea.height)
          CGContextScaleCTM(context, 1.0, -1.0)
          pipCenterM.y = topMid.y
          didReflect = true
        }
        
        drawPip(pipCenterM, pipSize)
        pipCenterM.y += dy
      }
      
      if (didReflect) {
        CGContextRestoreGState(context)
      }
    }
  }
  
  func drawPip(centerPoint: CGPoint, pipSize: CGSize) {
    switch cardAttrs.suit {
      case .Hearts:
        drawHeartPip(centerPoint, pipSize: pipSize)
      case .Clubs:
        drawClubPip(centerPoint, pipSize: pipSize)
      case .Diamonds:
        drawDiamondPip(centerPoint, pipSize: pipSize)
      case .Spades:
        drawSpadePip(centerPoint, pipSize: pipSize)
    }
  }
  
  
  func drawHeartPip(centerPoint: CGPoint, pipSize: CGSize) {
    var path = UIBezierPath()
    let minY = centerPoint.y - (pipSize.height / 2)
    let minX = centerPoint.x - (pipSize.width / 2)
    
    var heart = Heart(ctrPoint: centerPoint, size: pipSize)
    var curve = heart.curve
    path.moveToPoint(curve.startingPoint)
    
    for connect in curve.connections {
      path.addCurveToPoint(connect.ep, controlPoint1: connect.cp1, controlPoint2: connect.cp2)
    }

    path.closePath()
    path.fill()
  }
  
  func drawSpadePip(centerPoint: CGPoint, pipSize: CGSize) {
    var path = UIBezierPath()
    let minY = centerPoint.y - (pipSize.height / 2)
    let minX = centerPoint.x - (pipSize.width / 2)
    
    var spade = Spade(ctrPoint: centerPoint, size: pipSize)
    var curve = spade.getCurve()
    
    path.moveToPoint(curve.startingPoint)
    
    for connect in curve.connections {
      path.addCurveToPoint(connect.ep, controlPoint1: connect.cp1, controlPoint2: connect.cp2)
    }
    
    path.closePath()
    path.fill()
    
    let stemCurve = spade.getStemCurve()
    var stemPath = UIBezierPath()

    stemPath.moveToPoint(stemCurve.startingPoint)

    for connect in stemCurve.connections {
      stemPath.addCurveToPoint(connect.ep, controlPoint1: connect.cp1, controlPoint2: connect.cp2)
    }

    stemPath.closePath()
    stemPath.fill()
  }
  
  func drawClubPip(centerPoint: CGPoint, pipSize: CGSize) {
    let club = Club(ctrPoint: centerPoint, size: pipSize)
    let leafCurves = club.getLeafCurves()
    let stemCurve  = club.getStemCurve()
    
    var path = UIBezierPath()
    
    for curve in leafCurves {
      path.moveToPoint(curve.startingPoint)
      
      for connect in curve.connections {
        path.addCurveToPoint(connect.ep, controlPoint1: connect.cp1, controlPoint2: connect.cp2)
      }
      
      path.closePath()
      path.fill()
    }
    
    var stemPath = UIBezierPath()
    
    stemPath.moveToPoint(stemCurve.startingPoint)
    
    for connect in stemCurve.connections {
      stemPath.addCurveToPoint(connect.ep, controlPoint1: connect.cp1, controlPoint2: connect.cp2)
    }
    
    stemPath.closePath()
    stemPath.fill()
  }
  
  func drawDiamondPip(centerPoint: CGPoint, pipSize: CGSize) {
    let diamond = Diamond(ctrPoint: centerPoint, size: pipSize)
    let curve = diamond.getCurve()
    
    var path = UIBezierPath()
//    let halfW = pipSize.width / 2
//    let halfH = pipSize.height / 2
    
    path.moveToPoint(curve.startingPoint)
    
    for connect in curve.connections {
      path.addCurveToPoint(connect.ep, controlPoint1: connect.cp1, controlPoint2: connect.cp2)
    }
    
    path.closePath()
    path.fill()
  }
  
  private func rankString() -> String {
    let rank = cardAttrs.rank
    
    switch(rank) {
      case 1:
        return "A"
      case 11:
        return "J"
      case 12:
        return "Q"
      case 13:
        return "K"
      default:
        return "\(rank)"
    }
  }
}