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
  private var cardAttrs: SetCardAttrs
  private var drawingBounds = CGRectZero
  
  // MARK: - Initializers -
  
  init(frame: CGRect, attrs: SetCardAttrs) {
    cardAttrs = attrs
    rgbColor = [1.0, 0, 0, 1.0]

    super.init(frame: frame)
    
    backgroundColor = UIColor.whiteColor()
  }
  
  
  required init(coder aDecoder: NSCoder) {
    cardAttrs = SetCardAttrs(number: 1,
                               shape: SGShape.Diamond,
                                 shading: SGShading.Solid,
                                   color: SGColor.Green)
    self.rgbColor = [0, 0, 0, 0]
    
    super.init(coder: aDecoder)
    backgroundColor = UIColor.whiteColor()
  }
  
  // - MARK: - Public -
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let number = cardAttrs.number
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
    let dividedHeight = bounds.height / CGFloat(cardAttrs.number)
    let maxHeight = dividedHeight * 0.7
    
    var w, h: CGFloat
    
    h = min((bounds.width * 0.5), maxHeight)
    w = min((h * 2), bounds.width)
    
    return CGSizeMake(w, h)
  }

  
  private func drawShape(context: CGContextRef, size: CGSize) {
    CGContextSaveGState(context) // --- Context Saved ---
    
    switch(cardAttrs.shape) {
      case .Diamond:
        drawDiamond(size)
      case .Oval:
        drawOval(size)
      case .Squiggle:
        CGContextSetLineCap(context, kCGLineCapRound)
        drawSquiggle(size)
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
    
    let shading = cardAttrs.shading
    
    if (shading == .Solid) {
      path.fill()
    } else if (shading == .Striped) {
      drawStripes(size)
    }
  }

  
  private func drawOval(size: CGSize) {
    var path = UIBezierPath(roundedRect: CGRect(origin: CGPointZero, size: size), cornerRadius: (size.height / 2))

    path.stroke()
    path.addClip()
    
    let shading = cardAttrs.shading
    
    if (shading == .Solid) {
      path.fill()
    } else if (shading == .Striped) {
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
    
    for connection in squiggle.connections {
      path.addCurveToPoint(connection.ep, controlPoint1: connection.cp1, controlPoint2: connection.cp2)
    }
    
    path.closePath()
    
    path.stroke()
    path.addClip()
    
    let shading = cardAttrs.shading
    
    if (shading == .Solid) {
      path.fill()
    } else if (shading == .Striped) {
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