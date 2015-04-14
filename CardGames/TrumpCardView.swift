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

  var suitColor: [CGFloat] {
    switch (cardAttrs.suit) {
      case .Diamonds, .Hearts:
        return [1, 0, 0, 0]
      case .Spades, .Clubs:
        return [0, 0, 0, 0]
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
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let color = CGColorCreate(colorSpace, suitColor)
    
    CGContextSetLineWidth(context, 2.0)
    CGContextSetStrokeColorWithColor(context, color)
    CGContextSetFillColor(context, suitColor)
    CGContextSaveGState(context) // --- Context Saved 0 ---

    var origin = layout.drawArea.origin
    
    CGContextTranslateCTM(context, origin.x, origin.y)

    drawFlank(layout.flankWidth, pipSize: layout.pipSize)

    CGContextSaveGState(context) // --- Context Saved 1 ---
    
    CGContextTranslateCTM(context, layout.drawArea.width, layout.drawArea.height)
    CGContextRotateCTM(context, CGFloat(M_PI))

    drawFlank(layout.flankWidth, pipSize: layout.pipSize)
    
    CGContextRestoreGState(context) // --- Context Restored 1 ---
    
    origin = layout.pipArea.origin
    
    CGContextTranslateCTM(context, origin.x, origin.y)
    drawPipArea(layout)
    CGContextRestoreGState(context) // --- Context Restored 0 ---
  }
  
  func drawFlank(flankWidth: CGFloat, pipSize: CGSize) {
    var rankText = addTextAttrs("\(cardAttrs.rank)")

    rankText.drawAtPoint(CGPoint(x: (flankWidth - rankText.size().width), y: 0))
    
    let pipCenter = CGPoint(x: pipSize.width / 2, y: rankText.size().height * 1.1)

    drawPip(pipCenter, pipSize: pipSize)
  }
  
  func addTextAttrs(str: String) -> NSAttributedString {
    let font = CTFontCreateWithName("Baskerville", 0.0, nil)
    
    return NSAttributedString(string: str, attributes: [kCTFontAttributeName: font,
      kCTStrokeWidthAttributeName: 0.0, kCTStrokeColorAttributeName: suitColor(cardAttrs.suit),
      kCTForegroundColorFromContextAttributeName: true])
  }
  
  func suitColor(suit: NamedSuit) -> CGColor {
    var color: CGColor
    switch suit {
      case .Hearts, .Diamonds:
        color = UIColor.redColor().CGColor
      case .Clubs, .Spades:
        color = UIColor.blackColor().CGColor
    }
    return color
  }

  
  func drawPipArea(layout: TrumpCardViewLayout) {
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
    drawDiamondPip(centerPoint, pipSize: pipSize)
  }
  
  func drawSpadePip(centerPoint: CGPoint, pipSize: CGSize) {
    drawDiamondPip(centerPoint, pipSize: pipSize)
  }
  
  func drawClubPip(centerPoint: CGPoint, pipSize: CGSize) {
    drawDiamondPip(centerPoint, pipSize: pipSize)
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
  
//  func drawPip(centerPoint: CGPoint) {
//  }
}

//
//
//class TrumpCardView: UIView {
//  private var rank: Int
//  private var suit: NamedSuit
//    
//  init(attrs: TrumpCardAttributes) {
//    rank = attrs.rank
//    suit = attrs.suit
//    
//    super.init()
//  }
//
//  required init(coder aDecoder: NSCoder) {
//    rank = 1
//    suit = NamedSuit.Hearts
//    
//    super.init(coder: aDecoder)
//  }
//  
//  override func drawRect(rect: CGRect) {
//    var pipSize = calcPipSize(rect.size)
//    
//  }
//  
//  func calcPipSize(cardSize: CGSize) -> CGSize {
//    return CGSizeZero
//  }
//  
//  func calcPipPositions(innerSize: CGSize) {
//    var colWidth = innerSize.width / 3
//  }
//  
//  func drawPips() {
//    var drawFunc: (CGPoint, CGSize) -> Void
//
//    switch(suit) {
//      case .Hearts:
//        drawFunc = drawHeart
//      case .Spades:
//        drawFunc = drawSpade
//      case .Clubs:
//        drawFunc = drawDiamond
//      case .Diamonds:
//        drawFunc = drawDefaultLabel
//    }
//  }
//  
//  func drawSpade(point: CGPoint, size: CGSize) {
//  }
//  
//  func drawHeart(point: CGPoint, size: CGSize) {
//  }
//  
//  func drawClub(point: CGPoint, size: CGSize) {
//  }
//  
//  func drawDiamond(point: CGPoint, size: CGSize) {
//    let rect = CGRect(origin: point, size: size)
//    
//    let (midX, midY) = (CGRectGetMidX(rect), CGRectGetMidY(rect))
//    let (maxX, maxY) = (CGRectGetMaxX(rect), CGRectGetMaxY(rect))
//    
//    var path = UIBezierPath()
//    
//    path.moveToPoint(CGPoint(x: midX, y: 0))
//    path.addLineToPoint(CGPoint(x: maxX, y: midY))
//    path.addLineToPoint(CGPoint(x: midX, y: maxY))
//    path.addLineToPoint(CGPoint(x: 0, y: midY))
//    path.closePath()
//    path.fill()
//  }
//  
//  func drawDefaultLabel(point: CGPoint, size: CGSize) {
//  }
//  
////  class func layoutPositions(innerRect: CGRect) {
////    var centerPoints: [CGPoint] = []
////    let colWidth = innerRect.width / 3
////    let ctrRect = CGRectInset(innerRect, colWidth / 2, colWidth / 2)
////    var midRect = CGRectInset(ctrRect, colWidth, 0)
////    var innerCol = 3
////    var outerPips = 3
////    
////    var vSpace = innerRect.height / CGFloat(outerPips - 1)
////    
////    if (outerPips > 1) {
////      centerPoints.append(CGPoint(x: ctrRect.minX, y: ctrRect.minY))
////      centerPoints.append(CGPoint(x: ctrRect.maxX, y: ctrRect.minY))
////      centerPoints.append(CGPoint(x: ctrRect.maxX, y: ctrRect.maxY))
////      centerPoints.append(CGPoint(x: ctrRect.minX, y: ctrRect.maxY))
////    }
////    
////    var midTop = CGPoint(x: ctrRect.midX, y: ctrRect.minY)
////    var midBot = CGPoint(x: ctrRect.midX, y: ctrRect.maxY)
////    
////    if (outerPips > 2) {
////      midTop.y += vSpace / 2
////      midBot.y -= vSpace / 2
////    }
////    
////    var outerSpan = innerRect.height - colWidth
////    var outerSpacing = outerSpan / CGFloat(outerPips - 1)
////    
////    if (innerCol == 3) {
////      var centerCol = CGRectInset(innerRect, colWidth, colWidth / 2)
////    } else if (innerCol == 2) {
////      var centerCol = CGRectInset(innerRect, colWidth, colWidth)
////    } else if (innerCol == 1) {
////      if (outerPips == 3) {
////        var centerCol = CGRectInset(innerRect, colWidth, colWidth)
////      } else if (outerPips == 4) {
////        var centerCol = CGRectInset(innerRect, colWidth, colWidth * 2.5)
////      }
////    }
////    
////  }
//  
//  func pipCenters(pipArea: CGRect, pipSize: CGSize) {
//    var centers: [CGPoint] = []
//    let (numOuter, vSpace) = pipLayout(pipArea.size, pipSize: pipSize)
//    
//    let outerGuide = outerColGuide(pipArea, pipSize: pipSize)
//    let innerGuide = innerColGuide(outerGuide, vSpace: vSpace)
//    
//    let numInner = rank - (numOuter * 2)
//    
//  }
//  
//  private func cornerPoints(rect: CGRect) -> [CGPoint] {
//    var points: [CGPoint] = []
//    
//    points.append(CGPoint(x: rect.minX, y: rect.minY))
//    points.append(CGPoint(x: rect.minX, y: rect.maxY))
//    points.append(CGPoint(x: rect.maxX, y: rect.minY))
//    points.append(CGPoint(x: rect.maxX, y: rect.maxY))
//    
//    return points
//  }
//  
//  private func outerColPoints(outerGuide: CGRect, dy: CGFloat, numOuter: Int) -> [CGPoint] {
//    if (numOuter > 1) {
//      var points = cornerPoints(outerGuide)
//      
//      var remainingPips = numOuter - 2
//
//      if (remainingPips > 0) {
//        var yPos = outerGuide.minY
//        
//        for i in 1...(remainingPips) {
//          yPos += dy
//          
//          points.append(CGPoint(x: outerGuide.minX, y: yPos))
//          points.append(CGPoint(x: outerGuide.maxX, y: yPos))
//        }
//      }
//      return points
//    } else {
//      return []
//    }
//  }
//  
//  private func addPoints(numPoints: Int, between: (top: CGPoint, bot: CGPoint), vSpace: CGFloat) {
//    var remainingPoints = numPoints
//
//    var points: [CGPoint] = []
//    
//    while (remainingPoints > 0) {
//      var dy = vSpace * CGFloat(numPoints - remainingPoints + 1)
//
//      points.append(offsetPointBelow(between.top, dy: dy))
//      remainingPoints -= 1
//      
//      if (remainingPoints > 0) {
//        points.append(offsetPointAbove(between.bot, dy: dy))
//        remainingPoints -= 1
//      }
//    }
//  }
//  
//  private func offsetPointBelow(point: CGPoint, dy: CGFloat) -> CGPoint {
//    return CGPoint(x: point.x, y: point.y + dy)
//  }
//
//  private func offsetPointAbove(point: CGPoint, dy: CGFloat) -> CGPoint {
//    return CGPoint(x: point.x, y: point.y - dy)
//  }
//  
//  private func innerColPoints(topPoint: CGPoint, botPoint: CGPoint, dy: CGFloat, numOuter: Int, numInner: Int) {
//    var points: [CGPoint] = []
//    
//    if (numInner > 1) {
//      points.append(topPoint)
//      points.append(botPoint)
//      
//      var remainingPips = numInner - 2
//      
//      while (remainingPips > 0) {
//        var offsetY = dy * CGFloat(numInner - remainingPips + 1)
//
//        points.append(offsetPointBelow(topPoint, dy: offsetY))
//        remainingPips -= 1
//        
//        if (remainingPips > 0) {
//          points.append(offsetPointAbove(botPoint, dy: offsetY))
//          remainingPips -= 1
//        }
//      }
//    } else if (numInner == 1) {
//      if ((numOuter % 2) == 0) {
//        var midY = (topPoint.y + botPoint.y) / 2
//        
//        points.append(CGPoint(x: topPoint.x, y: midY))
//      } else {
//        points.append(topPoint)
//      }
//    }
//  }
//  
//  private func drawHalf() {
//    
//  }
//  
//  private func outerColGuide(pipArea: CGRect, pipSize: CGSize) -> CGRect {
//    let halfPipHeight = pipSize.height / 2
//    let halfPipWidth  = pipSize.width / 2
//    
//    return CGRectInset(pipArea, halfPipWidth, halfPipHeight)
//  }
//  
//  private func innerColGuide(outerGuide: CGRect, vSpace: CGFloat) -> (top: CGPoint, bot: CGPoint) {
//    let halfVSpace = vSpace / 2
//    var midTop = CGPoint(x: outerGuide.midX, y: outerGuide.minY + halfVSpace)
//    var midBot = CGPoint(x: outerGuide.midX, y: outerGuide.maxY - halfVSpace)
//    
//    return (midTop, midBot)
//  }
//  
//  private func drawPipsProto(pipArea: CGRect, pipSize: CGSize) {
//    var layout = pipLayout(pipArea.size, pipSize: pipSize)
//    
//    var outerGuide = CGRectInset(pipArea, pipSize.width / 2, pipSize.height / 2)
//    
//    let (outer, inner) = (layout.numOuter, rank - (layout.numOuter * 2))
//
//    var midTop: CGPoint = CGPoint(x: outerGuide.midX, y: outerGuide.minY)
//    var midBot: CGPoint = CGPoint(x: outerGuide.midX, y: outerGuide.maxY)
//
//    if (outer > 0) {
//      drawSequencialPips(outer, topPoint: CGPoint(x: outerGuide.minX, y: outerGuide.minY), dy: layout.dy)
//      
//      drawSequencialPips(outer, topPoint: CGPoint(x: outerGuide.maxX, y: outerGuide.minY), dy: layout.dy)
//      
//      if (inner > 0) {
//        var inset = (layout.dy / 2)
//        
//        midTop.y += inset
//        midBot.y -= inset
//      }
//    }
//    
//    if (inner > 0) {
//      var remainingPips = inner
//      
//      if ((outer % 2) == 0) {
//        drawShape(CGPoint(x: midTop.x, y: outerGuide.midY))
//        remainingPips -= 1
//      }
//      
//      drawAlternatingPips(remainingPips, topPoint: midTop, botPoint: midBot, dy: layout.dy)
//    }
//  }
//  
//  private func drawSequencialPips(numPips: Int, topPoint: CGPoint, dy: CGFloat) {
//    var remainingPips = numPips
//    var offsetY: CGFloat = 0
//    
//    while (remainingPips > 0) {
//      drawShape(CGPoint(x: topPoint.x, y: topPoint.y + offsetY))
//      
//      offsetY += dy
//      remainingPips -= 1
//    }
//  }
//  
//  private func addSequencialPoints(inout points: [CGPoint], numPips: Int, topPoint: CGPoint, dy: CGFloat) {
//    var remainingPips = numPips
//    var offsetY: CGFloat = 0
//    
//    while (remainingPips > 0) {
//      points.append(CGPoint(x: topPoint.x, y: topPoint.y + offsetY))
//      
//      offsetY += dy
//      remainingPips -= 1
//    }
//  }
//  
//  private func getPipCenterPoints(pipArea: CGRect, pipSize: CGSize) -> [CGPoint] {
//    var layout = pipLayout(pipArea.size, pipSize: pipSize)
//    
//    var outerGuide = CGRectInset(pipArea, pipSize.width / 2, pipSize.height / 2)
//    
//    let (outer, inner) = (layout.numOuter, rank - (layout.numOuter * 2))
//    
//    var midTop: CGPoint = CGPoint(x: outerGuide.midX, y: outerGuide.minY)
//    var midBot: CGPoint = CGPoint(x: outerGuide.midX, y: outerGuide.maxY)
//    var points: [CGPoint] = []
//    
//    if (outer > 0) {
//      addSequencialPoints(&points, numPips: outer, topPoint: CGPoint(x: outerGuide.minX, y: outerGuide.minY), dy: layout.dy)
//
//      addSequencialPoints(&points, numPips: outer, topPoint: CGPoint(x: outerGuide.maxX, y: outerGuide.minY), dy: layout.dy)
//      
//      if (inner > 0) {
//        var inset = (layout.dy / 2)
//        
//        midTop.y += inset
//        midBot.y -= inset
//      }
//    }
//    
//    if (inner > 0) {
//      var remainingPips = inner
//       
//      if ((outer % 2) == 0) {
//        points.append(CGPoint(x: midTop.x, y: outerGuide.midY))
//        remainingPips -= 1
//      }
//      
//      if (remainingPips > 0) {
//        addAlternatingPoints(&points, numPips: remainingPips, topPoint: midTop, botPoint: midBot, dy: layout.dy)
//      }
//    }
//    
//    return points
//  }
//  
//  private func addAlternatingPoints(inout points: [CGPoint], numPips: Int, topPoint: CGPoint, botPoint: CGPoint, dy: CGFloat) {
//    var remainingPips = numPips
//    var offsetY: CGFloat = 0
//
//    while(remainingPips > 0) {
//      points.append(CGPoint(x: topPoint.x, y: topPoint.y + offsetY))
//      remainingPips -= 1
//      
//      if (remainingPips > 0) {
//        points.append(CGPoint(x: botPoint.x, y: botPoint.y - offsetY))
//        remainingPips -= 1
//      }
//      
//      offsetY += dy
//    }
//  }
//  
//  private func drawAlternatingPips(numPips: Int, topPoint: CGPoint, botPoint: CGPoint, dy: CGFloat) {
//    var path = UIBezierPath()
//    var remainingPips = numPips
//    var offsetY: CGFloat = 0
//
//    while(remainingPips > 0) {
//      path.moveToPoint(CGPoint(x: topPoint.x, y: topPoint.y + offsetY))
//      drawShape(path.currentPoint)
//      remainingPips -= 1
//      
//      if (remainingPips > 0) {
//        path.moveToPoint(CGPoint(x: botPoint.x, y: botPoint.y - offsetY))
//        drawShape(path.currentPoint)
//        remainingPips -= 1
//      }
//      
//      offsetY += dy
//    }
//  }
//  
//  private func drawShape(centerPoint: CGPoint) {
//    var path = UIBezierPath()
//    path.moveToPoint(centerPoint)
//    NSLog("draw here")
//  }
//  
//  private func getSpacing(numPips: Int, dy: CGFloat) -> CGFloat {
//    return dy / CGFloat(numPips - 1)
//  }
//  
//  private func pipLayout(pipArea: CGSize, pipSize: CGSize) -> (numOuter: Int, dy: CGFloat) {
//    var outer: Int
//    var v: CGFloat
//    
//    switch(rank) {
//      case 1, 2, 3:
//        outer = 0
//      case 4, 5:
//        outer = 2
//      case 6, 7:
//        outer = 3
//      case 8, 9, 10, 11:
//        outer = 4
//      default:
//        outer = (rank / 2)
//    }
//    
//    var spacing = (pipArea.height - pipSize.height) / CGFloat(outer - 1)
//    
//    return (numOuter: outer, dy: spacing)
//  }
//  
////  class func pipLayout(numPips: Int, height: CGFloat) -> (outerPips: Int, vSpacing: CGFloat){
////    switch(numPips) {
////    case 1:
////      return (outerCol: 0, innerCol: 1)
////    case 2:
////      return (outerCol: 0, innerCol: 2)
////    case 3:
////      return (outerCol: 0, innerCol: 3)
////    case 4:
////      return (outerCol: 2, innerCol: 0)
////    case 5:
////      return (outerCol: 2, innerCol: 1)
////    case 6:
////      return (outerCol: 3, innerCol: 0)
////    case 7:
////      return (outerCol: 3, innerCol: 1)
////    case 8:
////      return (outerCol: 4, innerCol: 0)
////    case 9:
////      return (outerCol: 4, innerCol: 1)
////    case 10:
////      return (outerCol: 4, innerCol: 2)
////    default:
////      return (outerCol: numPips / 2, innerCol: numPips % 2)
////    }
////  }
//}

enum Side {
  case Left, Right
}