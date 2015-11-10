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
  private var shapeSize = CGSizeZero

  // MARK: - Initializers -
  
  init(frame: CGRect, attrs: SetCardAttrs) {
    cardAttrs = attrs    
    rgbColor = SetCardView.rgbColor(attrs.color)

    super.init(frame: frame)
    
    accessibilitySetup()
    backgroundColor = UIColor.whiteColor()
    setLayoutMeasurements()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    cardAttrs = SetCardAttrs(number: 1,
                               shape: SGShape.Cloud,
                                 shading: SGShading.Solid,
                                   color: SGColor.Yellow)
    self.rgbColor = [0, 0, 0, 0]
    
    super.init(coder: aDecoder)
    
    accessibilitySetup()
    backgroundColor = UIColor.whiteColor()
    setLayoutMeasurements()
  }
  
  func accessibilitySetup() {
    isAccessibilityElement = true
    accessibilityLabel = cardAttrs.toString()
  }
  
  
  // - MARK: - Public -
  
  override func drawRect(rect: CGRect) {
    NSLog("starting rectangle: \n\(rect)")
    let context = UIGraphicsGetCurrentContext()
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let number = cardAttrs.number
    let color = CGColorCreate(colorSpace, rgbColor)

    CGContextSaveGState(context) // --- Context Saved ---

    CGContextSetLineWidth(context, 2.0)
    CGContextSetStrokeColorWithColor(context, color)
    CGContextSetFillColor(context, rgbColor)
    
    CGContextSaveGState(context) // --- Context Saved ---

    if (rect.width > rect.height) {
      CGContextTranslateCTM(context, CGFloat(0), rect.height)
      CGContextRotateCTM(context, CGFloat(M_PI_2 * 3))
    }

    let shapeBounds = CGRect(origin: CGPointZero, size: shapeSize)
    
    CGContextTranslateCTM(context, drawingBounds.origin.x, drawingBounds.origin.y)

    let num = CGFloat(cardAttrs.number)
    for i in 1...number {
      if (i > 1) {
        let dx = drawingBounds.width - shapeSize.width
        let dy  = shapeSize.height + (drawingBounds.height - shapeSize.height * num) / (num - 1)

        if (i == 2) {
          CGContextTranslateCTM(context, dx, dy)
        } else {
          CGContextTranslateCTM(context, -1 * dx, dy)
        }
      }
      
      drawShape(context!, bounds: shapeBounds)
    }
    
    CGContextRestoreGState(context) // --- Context Restored ---
    CGContextRestoreGState(context) // --- Context Restored ---
  }

  
  // - MARK: - Private -
  
  private func setLayoutMeasurements() {
    let num = cardAttrs.number

    var insetX, insetY: CGFloat
    
    if (num == 1) {
      insetX = bounds.width * 0.2
      shapeSize = calcShapeSize(CGRectInset(bounds, insetX, insetX).size)
      insetY = ((bounds.height - shapeSize.height) / 2)
      drawingBounds = CGRectInset(bounds, insetX, insetY)
    } else {
      insetX = bounds.width * 0.15
      insetY = insetX
      drawingBounds = CGRectInset(bounds, insetX, insetY)
      shapeSize = calcShapeSize(drawingBounds.size)
    }
  }
  
  private func calcShapeSize(bounds: CGSize) -> CGSize {
    let dividedHeightMin = bounds.height / CGFloat(2)
    let dividedHeight = max((bounds.height / CGFloat(cardAttrs.number)), dividedHeightMin)
    
    var w, h: CGFloat
    
    if (cardAttrs.number == 1) {
      h = bounds.width
    } else {
      h = dividedHeight * 0.7
    }
    
    if (cardAttrs.shape == .Cloud) {
      w = ((cardAttrs.number > 1) ? (bounds.width * 0.66) : bounds.width)
    } else {
      w = h
    }
    
    return CGSizeMake(w, h)
  }

  
  private func drawShape(context: CGContextRef, bounds: CGRect) {
    CGContextSaveGState(context) // --- Context Saved ---
    
    switch(cardAttrs.shape) {
      case .Cloud:
        drawCloud(bounds)
      case .Sun:
        drawSun(bounds)
      case .Moon:
        drawMoon(bounds)
    }
    
    CGContextRestoreGState(context) // --- Context Restored ---
  }
  
  
  private func drawSun(bounds: CGRect) {
    let paths = Sun(bounds: bounds).makePath()
    
    paths.outer.stroke()
    paths.inner.stroke()

    applyShading(paths.outer, bounds: bounds)
  }
  
  
  private func drawMoon(bounds: CGRect) {
    let path = Moon(bounds: bounds).makePath()
    
    path.stroke()
    
    applyShading(path, bounds: bounds)
  }
  
  private func drawCloud(bounds: CGRect) {
    let path  = Cloud(bounds: bounds).makePath()
    
    path.stroke()
    
    applyShading(path, bounds: bounds)
  }
  
  
  private func applyShading(path: UIBezierPath, bounds: CGRect) {
    let shading = cardAttrs.shading
    
    if (shading == .Solid) {
      path.fill()
    } else if (shading == .Spotted) {
      path.addClip()
      
      drawSpots(bounds)
    }
  }
  
  private func circlePoint(point: CGPoint, r: CGFloat) {
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSaveGState(context)
    
    CGContextSetStrokeColor(context, [1.0, 0.0, 0.0, 2.0])
    
    let path = UIBezierPath()
    path.moveToPoint(point)

    path.addArcWithCenter(point, radius: r, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
    path.stroke()
    
    CGContextRestoreGState(context)
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
    } else if (shading == .Spotted) {
      drawSpots(bounds)
    }
  }
  
  
  private func drawOval(size: CGSize) {
    let path = UIBezierPath(roundedRect: CGRect(origin: CGPointZero, size: size), cornerRadius: (size.height / 2))
    
    path.stroke()
    path.addClip()
    
    let shading = cardAttrs.shading
    
    if (shading == .Solid) {
      path.fill()
    } else if (shading == .Spotted) {
      drawSpots(bounds)
    }
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
    } else if (shading == .Spotted) {
      drawSpots(bounds)
    }
  }
  
  
  private func drawSpots(bounds: CGRect) {
    var xi: CGFloat = bounds.minX - 0.5
    var yi: CGFloat = bounds.minY - 0.5
    
    var spot = CGRect(origin: CGPoint(x: xi, y: yi), size: CGSize(width: 1, height: 1))
    var path = UIBezierPath(roundedRect: spot, cornerRadius: 0.5)

    while (xi < bounds.width) {
      while(yi < bounds.height) {
        path = UIBezierPath(roundedRect: spot, cornerRadius: 0.5)
        path.fill()
        yi += 2

        spot = CGRect(origin: CGPoint(x: xi, y: yi), size: spot.size)
      }
      yi = -0.5
      xi += 2
    }
  }
  
  
  private func drawStripes(bounds: CGRect) {
    let path = UIBezierPath()
    var xi: CGFloat = bounds.minX + 1
    
    while (xi < bounds.width) {
      path.moveToPoint(CGPoint(x: xi, y: 0))
      path.addLineToPoint(CGPoint(x: xi, y: bounds.height))
      xi += 3
    }
    
    path.stroke()
  }
  
  
  class func rgbColor(color: SGColor) -> [CGFloat] {
    switch(color) {
      case .Yellow:
        // yellow
        return [1.0, 0.7, 0.0, 1.0]
      case .Blue:
        // blue
        return [0.3, 0.5, 1.0, 1.0]
      case .Red:
        return [1.0, 0.2, 0.2, 1.0]
    }
  }
  
  /* Set Classic Colors:
  
     Red    = [0.875, 0.259, 0.302, 1.0]
     Purple = [0.286, 0.2, 0.565, 1.0]
     Green  = [0.102, 0.694, 0.365, 1.0]
  */
}