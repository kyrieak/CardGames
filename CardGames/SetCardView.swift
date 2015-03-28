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
  private var rgbColor: [CGFloat]
  private var shape: String
  private var number: Int
  private var shading: String
  private var drawingBounds = CGRectZero
  
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
