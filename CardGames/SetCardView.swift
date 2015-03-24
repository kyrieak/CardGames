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
  
  init(frame: CGRect, attrs: SetCardAttributes) {
    self.number   = attrs.number
    self.shape    = attrs.shape
    self.shading  = attrs.shading
    self.rgbColor = SetCardView.toRGB(attrs.color)
    
    super.init(frame: frame)
  }
  
  init(frame: CGRect, number: Int, shape: String, shading: String, rgbColor: [CGFloat]) {
    self.number   = number
    self.shape    = shape
    self.shading  = shading
    self.rgbColor = rgbColor
    
    super.init(frame: frame)
  }

  init(frame: CGRect, number: Int, shape: String, shading: String, uiColor: UIColor) {
    self.number   = number
    self.shape    = shape
    self.shading  = shading
    self.rgbColor = SetCardView.toRGB(uiColor)
    
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder) {
    self.shape = "square"
    self.number = 1
    self.rgbColor = [0, 0, 0, 0]
    self.shading = "solid"
    
    super.init(coder: aDecoder)
  }
  
  class func toRGB(color: UIColor) -> [CGFloat] {
    var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    color.getRed(&r, green: &g, blue: &b, alpha: &a)

    return [r, g, b, a]
  }

  func diamondSize(bounds: CGSize) -> CGSize {
    let dividedHeight = bounds.height / CGFloat(number)
    
    var w = bounds.width
    var h = min((bounds.width * 0.5), (dividedHeight * 0.9))
    
    if (w > (h * 2)) {
      w = h * 2
    }
    
    return CGSizeMake(w, h)
  }
  
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
    let innerBounds = CGRectInset(rect, insetX, insetY)
    let shapeSize = getShapeSize(innerBounds)
    
    
    if (shapeSize.width < innerBounds.width) {
      insetX += ((innerBounds.width - shapeSize.width) / 2)
    }
    
    if (number == 1) {
      insetY += ((innerBounds.height - shapeSize.height) / 2)
    }
    
    CGContextTranslateCTM(context, insetX, insetY)

    drawShape(context, size: shapeSize)
    
    if (number > 1) {
      let dist = ((innerBounds.height - shapeSize.height) / CGFloat(number - 1))

      for i in 2...number {
        CGContextTranslateCTM(context, 0, dist)
        drawShape(context, size: shapeSize)
      }
    }
    
    CGContextRestoreGState(context) // --- Context Restored ---
  }

  func drawShape(context: CGContextRef, size: CGSize) {
    CGContextSaveGState(context) // --- Context Saved ---
    
    switch(shape) {
      case "diamond":
        drawDiamond(size)
      case "oval":
        drawOval(size)
      case "squiggle":
        drawSquiggle(size)
      default:
        NSLog("shape is \(shape)")
    }
    
    CGContextRestoreGState(context) // --- Context Restored ---
  }
  
  func drawStripes(size: CGSize) {
    var path = UIBezierPath()
    var upperBound = Int(size.width) + Int(size.height)
    var i = 1

    while (i < upperBound) {
      path.moveToPoint(CGPoint(x: i, y: 0))
      path.addLineToPoint(CGPoint(x: 0, y: i))
      i += 4
    }
    
    path.stroke()
  }
  
  func drawOval(size: CGSize) {
    let path = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: size))
    
    path.stroke()
    path.addClip()
    
    if (shading == "solid") {
      path.fill()
    } else if (shading == "striped") {
      drawStripes(size)
    }
  }
  
  func drawSquiggle(size: CGSize) {
    let path = UIBezierPath()
    var sp = CGPoint(x: (size.width * 3 / 16), y: 0)
    var ep = CGPointZero
    
    var xInc = size.width / 12
    var yInc = size.height / 6
    
    path.moveToPoint(CGPoint(x: 0, y: yInc * 5))
    path.addLineToPoint(CGPoint(x: 0, y: yInc * 3))
    path.addLineToPoint(CGPoint(x: xInc * 2, y: yInc))
    path.addLineToPoint(CGPoint(x: xInc * 4, y: 0))
    path.addLineToPoint(CGPoint(x: xInc * 5, y: 0))
    path.addLineToPoint(CGPoint(x: xInc * 7, y: yInc * 2))
    path.addLineToPoint(CGPoint(x: xInc * 8, y: yInc * 2))
    path.addLineToPoint(CGPoint(x: xInc * 10, y: 0))
    path.addLineToPoint(CGPoint(x: xInc * 11, y: 0))
    path.addLineToPoint(CGPoint(x: size.width, y: yInc))
    path.addLineToPoint(CGPoint(x: size.width, y: yInc * 3))
    path.addLineToPoint(CGPoint(x: xInc * 10, y: yInc * 5))
    path.addLineToPoint(CGPoint(x: xInc * 8, y: yInc * 6))
    path.addLineToPoint(CGPoint(x: xInc * 7, y: yInc * 6))
    path.addLineToPoint(CGPoint(x: xInc * 5, y: yInc * 4))
    path.addLineToPoint(CGPoint(x: xInc * 4, y: yInc * 4))
    path.addLineToPoint(CGPoint(x: xInc * 2, y: size.height))
    path.addLineToPoint(CGPoint(x: xInc, y: size.height))

    path.closePath()
    
    path.stroke()
    path.addClip()
    
    if (shading == "solid") {
      path.fill()
    } else if (shading == "striped") {
      drawStripes(size)
    }
  }
  
  func getShapeSize(bounds: CGRect) -> CGSize {
    let dividedHeight = bounds.height / CGFloat(number)
    let maxHeight = dividedHeight * 0.7
    
    var w, h: CGFloat

    h = min((bounds.width * 0.5), maxHeight)
    w = min((h * 2), bounds.width)
    
    return CGSizeMake(w, h)
  }
  
  func drawDiamond(size: CGSize) {
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
}