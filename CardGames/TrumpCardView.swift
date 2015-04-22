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
  }
  
  required init(coder aDecoder: NSCoder) {
    cardAttrs = TrumpCardAttributes(rank: 1, suit: NamedSuit.Hearts)

    super.init(coder: aDecoder)
  }
  
  override func drawRect(rect: CGRect) {
    let layout = TrumpCardViewLayout(viewRect: rect, attrs: cardAttrs)
    
    let context = UIGraphicsGetCurrentContext()
    CGContextSaveGState(context) // --- Context Saved -1 ---

    let color = suitColor.CGColor
    
    CGContextSetLineWidth(context, 2.0)
    CGContextSetStrokeColorWithColor(context, color)
    CGContextSetFillColorWithColor(context, color)
    CGContextSaveGState(context) // --- Context Saved 0 ---
    
    var origin = layout.drawArea.origin
    
//    drawColoredRect(context, rect: CGRect(origin: origin, size: CGSize(width: layout.flankWidth, height: layout.drawArea.size.height)),
//                             color: UIColor.purpleColor())
    
    CGContextTranslateCTM(context, origin.x, origin.y)
    CGContextSaveGState(context) // --- Context Saved padding ---

    drawFlank(context, flankWidth: layout.flankWidth, pipSize: layout.pipSize)
    
    CGContextTranslateCTM(context, layout.drawArea.width, layout.drawArea.height)
    CGContextRotateCTM(context, CGFloat(M_PI))

//    drawColoredRect(context, rect: CGRect(origin: CGPointZero, size: CGSize(width: layout.flankWidth, height: layout.drawArea.size.height)),
//      color: UIColor.purpleColor())
    
    drawFlank(context, flankWidth: layout.flankWidth, pipSize: layout.pipSize)
    CGContextRestoreGState(context) // --- Context Restored padding ---

    origin = origin.getDistance(layout.pipArea.origin)
    
    
    CGContextTranslateCTM(context, origin.x, origin.y)
    
//    drawColoredRect(context, rect: CGRect(origin: CGPointZero, size: CGSize(width: layout.pipArea.size.width, height: layout.pipArea.size.height)),
//                             color: UIColor.blueColor())

    drawPipArea(context, layout: layout)
    CGContextRestoreGState(context) // --- Context Restored 0 ---
    CGContextRestoreGState(context) // --- Context Restored -1 ---
  }
  
  func drawColoredRect(context: CGContextRef, rect: CGRect, color: UIColor) {
    var rectPath = UIBezierPath(rect: rect)
    
    CGContextSetFillColorWithColor(context, color.CGColor)
    rectPath.fill()
    CGContextSetFillColorWithColor(context, suitColor.CGColor)
  }
  
  func drawFlank(context: CGContextRef, flankWidth: CGFloat, pipSize: CGSize) {
    var rankText = addTextAttrs("\(cardAttrs.rank)")
    var posX, posY: CGFloat
    
    posX = (flankWidth - rankText.size().width) / 2

    rankText.drawAtPoint(CGPoint(x: posX, y: 0))
    
    posY = rankText.size().height + (pipSize.height / 2)

    drawPip(CGPoint(x: flankWidth / 2, y: posY), pipSize: pipSize)
  }
  
  func addTextAttrs(str: String) -> NSMutableAttributedString {
    var font = CTFontCreateWithName("Baskerville", 0.0, nil)
    
    var attrs: [NSObject: AnyObject] = [NSFontAttributeName: font,
      NSForegroundColorAttributeName: suitColor]
    
    return NSMutableAttributedString(string: str, attributes: attrs)
  }
  
  
  func drawPipArea(context: CGContextRef, layout: TrumpCardViewLayout) {
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
      var left = layout.topPipCenterPoint(PipColumn.Left)
      var right = layout.topPipCenterPoint(PipColumn.Right)
      
      for i in 1...layout.numPips.outer {
        drawPip(left, pipSize)
        drawPip(right, pipSize)
        left.y += dy
        right.y += dy
      }
    }
    
    if (numPips.inner > 0) {
      var mid = layout.topPipCenterPoint(PipColumn.Middle)
      
      for i in 1...layout.numPips.inner {
        drawPip(mid, pipSize)
        mid.y += dy
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
    var lCurve = heart.getLeftCurve()
    var rCurve = heart.getRightCurve()

    path.moveToPoint(heart.cuspPoint)
    
    for connect in lCurve.connections {
      path.addCurveToPoint(connect.ep, controlPoint1: connect.cp1, controlPoint2: connect.cp2)
    }
    
    path.closePath()
    path.fill()

    path.moveToPoint(heart.cuspPoint)

    for connect in rCurve.connections {
      path.addCurveToPoint(connect.ep, controlPoint1: connect.cp1, controlPoint2: connect.cp2)
    }

    path.closePath()
    path.fill()
  }
  
  func drawSpadePip(centerPoint: CGPoint, pipSize: CGSize) {
    var path = UIBezierPath()
    let halfW = pipSize.width / 2
    let halfH = pipSize.height / 2
    
    path = UIBezierPath(ovalInRect: CGRect(origin: CGPoint(x: centerPoint.x - halfW, y: centerPoint.y - halfH), size: pipSize))
    
//    path.moveToPoint(CGPoint(x: centerPoint.x, y: centerPoint.y - halfH))
//    path.addLineToPoint(CGPoint(x: centerPoint.x + halfW, y: centerPoint.y))
//    path.addLineToPoint(CGPoint(x: centerPoint.x, y: centerPoint.y + halfH))
//    path.addLineToPoint(CGPoint(x: centerPoint.x - halfW, y: centerPoint.y))
//    path.addLineToPoint(CGPoint(x: centerPoint.x, y: centerPoint.y - halfH))
//    path.closePath()
    path.fill()
  }
  
  func drawClubPip(centerPoint: CGPoint, pipSize: CGSize) {
    let club = Club(ctrPoint: centerPoint, size: pipSize)
    let stem = club.getStem()
    let leafCtrPoints = club.getLeafCenterPoints()

    for point in leafCtrPoints {
      var path = UIBezierPath(arcCenter: point, radius: club.r, startAngle: CGFloat(0), endAngle: CGFloat(M_2_PI), clockwise: false)
      path.closePath()
      path.fill()
    }
    
    let lCurve = stem.getLeftCurve()
    let rCurve = stem.getRightCurve()
    
    for curve in [lCurve, rCurve] {
      var stemPath = UIBezierPath()
      
      stemPath.moveToPoint(curve.startingPoint)
      
      for connect in curve.connections {
        stemPath.addCurveToPoint(connect.ep, controlPoint1: connect.cp1, controlPoint2: connect.cp2)
      }

      stemPath.addLineToPoint(stem.basePoint)
      stemPath.closePath()
      stemPath.fill()
    }
    
    var path = UIBezierPath(rect: club.bounds)
//    path.fill()
  }
  
  func drawDiamondPip(centerPoint: CGPoint, pipSize: CGSize) {
    var path = UIBezierPath()
    let halfW = pipSize.width / 2
    let halfH = pipSize.height / 2
    
    path.moveToPoint(CGPoint(x: centerPoint.x, y: centerPoint.y - halfH))
    path.addLineToPoint(CGPoint(x: centerPoint.x + halfW, y: centerPoint.y))
    path.addLineToPoint(CGPoint(x: centerPoint.x, y: centerPoint.y + halfH))
    path.addLineToPoint(CGPoint(x: centerPoint.x - halfW, y: centerPoint.y))
    path.addLineToPoint(CGPoint(x: centerPoint.x, y: centerPoint.y - halfH))
    path.closePath()
    path.fill()
  }
  
}