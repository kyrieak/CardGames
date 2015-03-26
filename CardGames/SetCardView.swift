//
//  SetCardView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 3/20/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetCardView: UIView {
  var rgbColor: [CGFloat]
  var shape: String
  var number: Int
  var shading: String
  var drawingBounds = CGRectZero
  
  // MARK: - Initializers -
  
  init(frame: CGRect, attrs: SetCardAttributes) {
    self.number   = attrs.number
    self.shape    = attrs.shape
    self.shading  = attrs.shading
    self.rgbColor = attrs.color
    
    super.init(frame: frame)
  }
  
  
  required init(coder aDecoder: NSCoder) {
    self.shape = "square"
    self.number = 1
    self.rgbColor = [0, 0, 0, 0]
    self.shading = "solid"
    
    super.init(coder: aDecoder)
  }
  
  // - MARK: - Public -
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let color = CGColorCreate(colorSpace, rgbColor)

    CGContextSetLineWidth(context, 2.0)
    CGContextSetStrokeColorWithColor(context, color)
    CGContextSetFillColor(context, rgbColor)
    CGContextSaveGState(context) // --- Context Saved ---
    
    var insetX = rect.width * 0.2
    var insetY = insetX
    var dist: CGFloat = 0

    let innerBounds = CGRectInset(rect, insetX, insetY)
    let shapeSize = calcShapeSize(innerBounds.size)

    if (shapeSize.width < innerBounds.width) {
      insetX += ((innerBounds.width - shapeSize.width) / 2)
    }
    
    if (number == 1) {
      insetY += ((innerBounds.height - shapeSize.height) / 2)
    } else {
      dist = (innerBounds.height - shapeSize.height) / CGFloat(number - 1)
    }
    
    drawingBounds = CGRectInset(rect, insetX, insetY)

    CGContextTranslateCTM(context, insetX, insetY)
    
    for i in 1...number {
      if (i > 1) {
        CGContextTranslateCTM(context, 0, dist)
      }

      drawShape(context, size: shapeSize)
    }
    
    CGContextRestoreGState(context) // --- Context Restored ---
  }
  

  
  // - MARK: - Private -
  
  private func calcShapeSize(bounds: CGSize) -> CGSize {
    let dividedHeight = bounds.height / CGFloat(number)
    let maxHeight = dividedHeight * 0.7
    
    var w, h: CGFloat
    
    h = min((bounds.width * 0.5), maxHeight)
    w = min((h * 2), bounds.width)
    
    return CGSizeMake(w, h)
  }

  
  private func drawShape(context: CGContextRef, size: CGSize) {
    CGContextSaveGState(context) // --- Context Saved ---
    
    switch(shape) {
      case "diamond":
        drawDiamond(size)
      case "oval":
        drawOval(size)
      case "squiggle":
        CGContextSetLineCap(context, kCGLineCapRound)
        drawSquiggle(size)
      default:
        NSLog("shape is \(shape)")
    }
    
    CGContextRestoreGState(context) // --- Context Restored ---
  }
  
  
  private func drawDiamond(size: CGSize) {
    let path = UIBezierPath()
    let midX = size.width / 2
    let midY = size.height / 2
    
    path.moveToPoint(CGPointMake(midX, 0))
    path.addLineToPoint(CGPointMake(size.width, midY))
    path.addLineToPoint(CGPointMake(midX, size.height))
    path.addLineToPoint(CGPointMake(0, midY))
    path.closePath()
    
    path.stroke()
    path.addClip()
    
    if (shading == "solid") {
      path.fill()
    } else if (shading == "striped") {
      drawStripes(size)
    }
  }

  
  private func drawOval(size: CGSize) {
    var path = UIBezierPath(roundedRect: CGRect(origin: CGPointZero, size: size), cornerRadius: (size.height / 2))

    path.stroke()
    path.addClip()
    
    if (shading == "solid") {
      path.fill()
    } else if (shading == "striped") {
      drawStripes(size)
    }
  }
  
  private func circlePoint(point: CGPoint, r: CGFloat) {
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSaveGState(context)
    
    CGContextSetStrokeColor(context, [1.0, 0.0, 0.0, 2.0])
    
    var path = UIBezierPath()
    path.moveToPoint(point)

    path.addArcWithCenter(point, radius: r, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
    path.stroke()
    
    CGContextRestoreGState(context)
  }
  
  
  private func drawSquiggle2(size: CGSize) {
    let path = UIBezierPath()
    
    var xInc = size.width / 12
    var yInc = size.height / 6
    
    let midX = xInc * 6
    let midY = yInc * 3
    
    let startingPoint = CGPoint(x: 0, y: yInc * 5)
    
    path.moveToPoint(startingPoint)

    //==========================================
    // A0
    var c1 = CGPoint(x: 0, y: yInc * 3)
    var c2 = CGPoint(x: xInc * 2, y: yInc)
    var ep = CGPoint(x: xInc * 4, y: yInc / 2)
    
    path.addCurveToPoint(ep, controlPoint1: c1, controlPoint2: c2)
    
    // A
    c1 = CGPoint(x: xInc * 6, y: yInc / 2)
    c2 = CGPoint(x: xInc * 6, y: yInc * 2)
    ep = CGPoint(x: xInc * 8, y: yInc * 2)

    path.addCurveToPoint(ep, controlPoint1: c1, controlPoint2: c2)
    
    // B
    c1 = CGPoint(x: xInc * 10, y: yInc * 2)
    c2  = CGPoint(x: xInc * 10, y: yInc)
    ep = CGPoint(x: size.width, y: yInc)

    path.addCurveToPoint(ep, controlPoint1: c1, controlPoint2: c2)

//    // C
//    c1 = CGPoint(x: size.width, y: yInc)
//    c2 = CGPoint(x: size.width, y: yInc * 2)
//    ep = CGPoint(x: size.width, y: yInc * 3)
//    
//    path.addCurveToPoint(ep, controlPoint1: c1, controlPoint2: c2)
    
    // last point of first half must end in starting point's transform
    //    epT = CGPoint(x: size.width, y: yInc)

//    // D
//    c1 = CGPoint(x: size.width, y: yInc * 4)
//    c2 = CGPoint(x: xInc * 11, y: size.height)
//    ep = CGPoint(x: xInc * 8, y: size.height)
//
//    path.addCurveToPoint(ep, controlPoint1: c1, controlPoint2: c2)
//
//    // E
//    c1 = CGPoint(x: xInc * 6, y: size.height)
//    c2 = CGPoint(x: xInc * 5.5, y: yInc * 4)
//    ep = CGPoint(x: xInc * 4, y: yInc * 4)
//    
//    path.addCurveToPoint(ep, controlPoint1: c1, controlPoint2: c2)
//    
//    // F
//    c1 = CGPoint(x: xInc * 3, y: yInc * 4)
//    c2 = CGPoint(x: xInc * 2, y: size.height)
//    ep = CGPoint(x: xInc, y: size.height)
//
//    path.addCurveToPoint(ep, controlPoint1: c1, controlPoint2: c2)
//    
//    // G
//    c1 = CGPoint(x: 0, y: size.height)
//    c2 = CGPoint(x: 0, y: yInc * 5)
//    ep = startingPoint
//    
//    path.addCurveToPoint(ep, controlPoint1: c1, controlPoint2: c2)

    //==========================================

    // A0'
    var c1T = CGPoint(x: size.width, y: yInc * 3)
    var c2T = CGPoint(x: xInc * 10, y: yInc * 5)
    var epT = CGPoint(x: xInc * 8, y: yInc * 5.5)

    path.addCurveToPoint(epT, controlPoint1: c1T, controlPoint2: c2T)


    // A'
    c1T = CGPoint(x: xInc * 6, y: yInc * 5.5)
    c2T = CGPoint(x: xInc * 6, y: yInc * 4)
    epT = CGPoint(x: xInc * 4, y: yInc * 4)

    path.addCurveToPoint(epT, controlPoint1: c1T, controlPoint2: c2T)

    // B'
    c1T = CGPoint(x: xInc * 2, y: yInc * 4)
    c2T = CGPoint(x: xInc * 2, y: yInc * 5)
        epT = startingPoint
//    epT = CGPoint(x: xInc, y: yInc * 5)
//
//    path.addCurveToPoint(epT, controlPoint1: c1T, controlPoint2: c2T)

//    // C'
//    c1T = CGPoint(x: 0, y: yInc * 5)
//    c2T = CGPoint(x: 0, y: yInc * 4)
//    epT = CGPoint(x: 0, y: yInc * 3)

    path.addCurveToPoint(epT, controlPoint1: c1T, controlPoint2: c2T)
    
//    // D'
//    c1T = CGPoint(x: 0, y: yInc * 2)
//    c2T = CGPoint(x: xInc, y: 0)
//    epT = CGPoint(x: xInc * 4, y: 0)
//    
//    // E'
//    c1T = CGPoint(x: xInc * 6, y: 0)
//    c2T = CGPoint(x: xInc * 6.5, y: yInc * 2)
//    epT = CGPoint(x: xInc * 8, y: yInc * 2)
//    
//    // F'
//    c1T = CGPoint(x: xInc * 9, y: yInc * 2)
//    c2T = CGPoint(x: xInc * 10, y: 0)
//    epT = CGPoint(x: xInc * 11, y: 0)
//    
//    // G'
//    c1T = CGPoint(x: size.width, y: 0)
//    c2T = CGPoint(x: size.width, y: yInc)
//    epT = CGPoint(x: size.width, y: yInc)
//    //==========================================
    
    
    
    
    path.closePath()
    
    path.stroke()
    path.addClip()
    
    if (shading == "solid") {
      path.fill()
    } else if (shading == "striped") {
      drawStripes(size)
    }
  }
  
  
  private func freeform(size: CGSize) {
    var xInc = size.width / 12
    var yInc = size.height / 6
    
    let midX = xInc * 6
    let midY = yInc * 3
    
    var startingPoint = CGPoint(x: 0, y: yInc * 5)
    
    var sp = startingPoint
    var c1 = CGPoint(x: 0, y: yInc * 3)
    var c2 = CGPoint(x: xInc * 2, y: yInc)
    var ep = CGPoint(x: xInc * 4, y: yInc / 2)

    var spT = CGPoint(x: size.width, y: yInc)
    var c1T = CGPoint(x: size.width, y: yInc * 3)
    var c2T = CGPoint(x: xInc * 10, y: yInc * 5)
    var epT = CGPoint(x: xInc * 8, y: yInc * 5.5)

    //==========================================
    
    c1 = CGPoint(x: xInc * 6, y: yInc / 2)
    c2 = CGPoint(x: xInc * 6, y: yInc * 2)
    ep = CGPoint(x: xInc * 8, y: yInc * 2)

    c1T = CGPoint(x: xInc * 6, y: yInc * 5.5)
    c2T = CGPoint(x: xInc * 6, y: yInc * 4)
    epT = CGPoint(x: xInc * 4, y: yInc * 4)
//==========================================
    c1 = CGPoint(x: xInc * 10, y: yInc * 2)
    c2  = CGPoint(x: xInc * 10, y: yInc)
    ep = CGPoint(x: xInc * 11, y: yInc)

    c1T = CGPoint(x: xInc * 2, y: yInc * 4)
    c2T = CGPoint(x: xInc * 2, y: yInc * 5)
    epT = CGPoint(x: xInc, y: yInc * 5)
    //==========================================
    
    c1 = CGPoint(x: size.width, y: yInc)
    c2 = CGPoint(x: size.width, y: yInc * 2)
    ep = CGPoint(x: size.width, y: yInc * 3)

    c1T = CGPoint(x: 0, y: yInc * 5)
    c2T = CGPoint(x: 0, y: yInc * 4)
    epT = CGPoint(x: 0, y: yInc * 3)
    //==========================================
    
    c1 = CGPoint(x: size.width, y: yInc * 4)
    c2 = CGPoint(x: xInc * 11, y: size.height)
    ep = CGPoint(x: xInc * 8, y: size.height)
    
    
    c1T = CGPoint(x: 0, y: yInc * 2)
    c2T = CGPoint(x: xInc, y: 0)
    epT = CGPoint(x: xInc * 4, y: 0)
    //==========================================

    c1 = CGPoint(x: xInc * 6, y: size.height)
    c2 = CGPoint(x: xInc * 5.5, y: yInc * 4)
    ep = CGPoint(x: xInc * 4, y: yInc * 4)

    
    c1T = CGPoint(x: xInc * 6, y: 0)
    c2T = CGPoint(x: xInc * 6.5, y: yInc * 2)
    epT = CGPoint(x: xInc * 8, y: yInc * 2)
    //==========================================

    c1 = CGPoint(x: xInc * 3, y: yInc * 4)
    c2 = CGPoint(x: xInc * 2, y: size.height)
    ep = CGPoint(x: xInc, y: size.height)

    
    c1T = CGPoint(x: xInc * 9, y: yInc * 2)
    c2T = CGPoint(x: xInc * 10, y: 0)
    epT = CGPoint(x: xInc * 11, y: 0)
    //==========================================

    c1 = CGPoint(x: 0, y: size.height)
    c2 = CGPoint(x: 0, y: yInc * 5)
    ep = startingPoint

    c1T = CGPoint(x: size.width, y: 0)
    c2T = CGPoint(x: size.width, y: yInc)
    epT = CGPoint(x: size.width, y: yInc)
    //==========================================
  }

  
  private func drawSquiggle(size: CGSize) {
    let path = UIBezierPath()
    let squiggle = Squiggle(size: size)

    path.moveToPoint(squiggle.startingPoint)
    
    for arc in squiggle.arcs {
      path.addCurveToPoint(arc.ep, controlPoint1: arc.cp1, controlPoint2: arc.cp2)
    }
    
    path.closePath()
    
    path.stroke()
    path.addClip()
    
    if (shading == "solid") {
      path.fill()
    } else if (shading == "striped") {
      drawStripes(size)
    }
  }
//  
//  private func drawSquiggle(size: CGSize) {
//    let path = UIBezierPath()
//    var sp = CGPoint(x: (size.width * 3 / 16), y: 0)
//    var ep = CGPointZero
//    
//    var xInc = size.width / 12
//    var yInc = size.height / 6
//    
//    path.moveToPoint(CGPoint(x: 0, y: yInc * 5))
//    path.addLineToPoint(CGPoint(x: 0, y: yInc * 3))
//    path.addLineToPoint(CGPoint(x: xInc * 2, y: yInc))
//    path.addLineToPoint(CGPoint(x: xInc * 4, y: 0))
//    path.addLineToPoint(CGPoint(x: xInc * 5, y: 0))
//    path.addLineToPoint(CGPoint(x: xInc * 7, y: yInc * 2))
//    path.addLineToPoint(CGPoint(x: xInc * 8, y: yInc * 2))
//    path.addLineToPoint(CGPoint(x: xInc * 10, y: 0))
//    path.addLineToPoint(CGPoint(x: xInc * 11, y: 0))
//    path.addLineToPoint(CGPoint(x: size.width, y: yInc))
//    path.addLineToPoint(CGPoint(x: size.width, y: yInc * 3))
//    path.addLineToPoint(CGPoint(x: xInc * 10, y: yInc * 5))
//    path.addLineToPoint(CGPoint(x: xInc * 8, y: yInc * 6))
//    path.addLineToPoint(CGPoint(x: xInc * 7, y: yInc * 6))
//    path.addLineToPoint(CGPoint(x: xInc * 5, y: yInc * 4))
//    path.addLineToPoint(CGPoint(x: xInc * 4, y: yInc * 4))
//    path.addLineToPoint(CGPoint(x: xInc * 2, y: size.height))
//    path.addLineToPoint(CGPoint(x: xInc, y: size.height))
//
//    path.closePath()
//    
//    path.stroke()
//    path.addClip()
//    
//    if (shading == "solid") {
//      path.fill()
//    } else if (shading == "striped") {
//      drawStripes(size)
//    }
//  }
  
  
  private func drawStripes(size: CGSize) {
    var path = UIBezierPath()
    var xi: CGFloat = 1
    
    while (xi < size.width) {
      path.moveToPoint(CGPoint(x: xi, y: 0))
      path.addLineToPoint(CGPoint(x: xi, y: size.height))
      xi += 3
    }
    
    path.stroke()
  }
}

////    // C'
////    c1T = CGPoint(x: 0, y: yInc * 5)
////    c2T = CGPoint(x: 0, y: yInc * 4)
////    epT = CGPoint(x: 0, y: yInc * 3)
//
//path.addCurveToPoint(epT, controlPoint1: c1T, controlPoint2: c2T)


struct Squiggle {
  let startingPoint: CGPoint
  let arcs: [(cp1: CGPoint, cp2: CGPoint, ep: CGPoint)]
  
  init(size: CGSize) {
    var defin = Squiggle.defineCurves(size)
    startingPoint = defin.0
    arcs = defin.1
  }

  private static func defineCurves(size: CGSize) -> (CGPoint, [(cp1: CGPoint, cp2: CGPoint, ep: CGPoint)]) {
    let xInc = size.width / 12
    let yInc = size.height / 6
    
    var A, B, C, AT, BT, CT: CGPoint

    A  = CGPoint(x: 0, y: yInc * 5)
    B  = CGPoint(x: xInc * 4, y: yInc / 2)
    C  = CGPoint(x: xInc * 8, y: yInc * 2)
    AT = CGPoint(x: size.width, y: yInc)
    BT = CGPoint(x: xInc * 8, y: yInc * 5.5)
    CT = CGPoint(x: xInc * 4, y: yInc * 4)

    var arcB = (cp1: CGPoint(x: 0, y: yInc * 3),
                cp2: CGPoint(x: xInc * 2, y: yInc),
                 ep: B)
    
    var arcC = (cp1: CGPoint(x: xInc * 6, y: yInc / 2),
                cp2: CGPoint(x: xInc * 6, y: yInc * 2),
                 ep: C)
    
    var arcAT = (cp1: CGPoint(x: xInc * 10, y: yInc * 2),
                 cp2: CGPoint(x: xInc * 10, y: yInc),
                  ep: AT)

    var arcBT = (cp1: CGPoint(x: size.width, y: yInc * 3),
                 cp2: CGPoint(x: xInc * 10, y: yInc * 5),
                  ep: BT)

    var arcCT = (cp1: CGPoint(x: xInc * 6, y: yInc * 5.5),
                 cp2: CGPoint(x: xInc * 6, y: yInc * 4),
                  ep: CT)
    
    var arcA = (cp1: CGPoint(x: xInc * 2, y: yInc * 4),
                cp2: CGPoint(x: xInc * 2, y: yInc * 5),
                 ep: A)
    
    return (A, [arcB, arcC, arcAT, arcBT, arcCT, arcA])
  }
}
