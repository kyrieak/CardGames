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
  let rgbColor: [CGFloat]
  let shape: String
  let count: Int
//  required init(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
//
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//  }
  
  init(frame: CGRect, rgbColor: [CGFloat], shape: String, count: Int) {
    self.shape = shape
    self.count = count
    self.rgbColor = rgbColor
    super.init(frame: frame)
  }

  init(frame: CGRect, color: UIColor, shape: String, count: Int) {
    self.shape = shape
    self.count = count
    self.rgbColor = SetCardView.toRGB(color)

    super.init(frame: frame)
  }
  
  class func toRGB(color: UIColor) -> [CGFloat] {
    var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    color.getRed(&r, green: &g, blue: &b, alpha: &a)

    return [r, g, b, a]
  }

  required init(coder aDecoder: NSCoder) {
    self.shape = "square"
    self.count = 1
    self.rgbColor = [0, 0, 0, 0]
    
    super.init(coder: aDecoder)
  }
  
  func diamondSize(bounds: CGSize) -> CGSize {
    let dividedHeight = bounds.height / CGFloat(count)
    
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
    
    let inset = rect.width * 0.2
    let innerBounds = CGRectInset(rect, inset, inset)
    let shapeSize = getShapeSize(innerBounds)
    
    if (shapeSize.width < innerBounds.width) {
      var insetX = inset + ((innerBounds.width - shapeSize.width) / 2)

      CGContextTranslateCTM(context, insetX, inset)
    } else {
      CGContextTranslateCTM(context, inset, inset)
    }
    
    drawShape(shapeSize)
    
    if (count > 1) {
      let dist = ((innerBounds.height - shapeSize.height) / CGFloat(count - 1))
      
      for i in 2...count {
        CGContextTranslateCTM(context, 0, dist)
        drawShape(shapeSize)
      }
    }
        
    CGContextRestoreGState(context) // --- Context Restored ---
  }

  func drawShape(size: CGSize) {
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
  }
  
  func drawOval(size: CGSize) {}
  func drawSquiggle(size: CGSize) {}
  
  func getShapeSize(bounds: CGRect) -> CGSize {
    let dividedHeight = bounds.height / CGFloat(count)
    let maxHeight = dividedHeight * 0.7
    
    var w, h: CGFloat

    switch(shape) {
    case "diamond":
      h = min((bounds.width * 0.5), maxHeight)
      w = min((h * 2), bounds.width)
    default:
      w = bounds.width
      h = maxHeight
    }
    
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
    
    path.fill()
    path.stroke()
  }
}