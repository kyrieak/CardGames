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
    rgbColor = SetCardView.rgbColor(attrs.color)

    super.init(frame: frame)
    
    accessibilitySetup()
    backgroundColor = UIColor.whiteColor()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    cardAttrs = SetCardAttrs(number: 1,
                               shape: SGShape.Diamond,
                                 shading: SGShading.Solid,
                                   color: SGColor.Green)
    self.rgbColor = [0, 0, 0, 0]
    
    super.init(coder: aDecoder)
    
    accessibilitySetup()
    backgroundColor = UIColor.whiteColor()
  }
  
  func accessibilitySetup() {
    isAccessibilityElement = true
    accessibilityLabel = cardAttrs.toString()
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

    var _rect = rect
    
    if (rect.width > rect.height) {
      CGContextTranslateCTM(context, CGFloat(0), rect.height)
      CGContextRotateCTM(context, CGFloat(M_PI_2 * 3))
      
      _rect.size.width = rect.height
      _rect.size.height = rect.width
    }
    
    var insetX = ((cardAttrs.number < 2) ? (_rect.width * 0.2) : (_rect.width * 0.15))
    var insetY = insetX
    var dist: CGFloat = 0

    let innerBounds = CGRectInset(_rect, insetX, insetY)
    let shapeSize = calcShapeSize(innerBounds.size)
//
//    if (shapeSize.width < innerBounds.width) {
//      insetX += ((innerBounds.width - shapeSize.width) / 2)
//    }
    
    if (number == 1) {
      insetY += ((innerBounds.height - shapeSize.height) / 2)
    } else {
      dist = (innerBounds.height - shapeSize.height) / CGFloat(number - 1)
    }
    
    drawingBounds = CGRectInset(_rect, insetX, insetY)

    CGContextTranslateCTM(context, insetX, insetY)
    
    for i in 1...number {
      if (i > 1) {
        var dx: CGFloat = 0

        if (cardAttrs.shape != .Diamond) {
          dx = innerBounds.width - shapeSize.height
        }
        
        if (i == 2) {
          CGContextTranslateCTM(context, dx, dist)
        } else {
          CGContextTranslateCTM(context, -dx, dist)
        }
      }

      drawShape(context!, size: shapeSize)
    }
    
    CGContextRestoreGState(context) // --- Context Restored ---
  }
  

  
  // - MARK: - Private -
  
  private func calcShapeSize(bounds: CGSize) -> CGSize {
    let dividedHeightMin = bounds.height / CGFloat(2)
    let dividedHeight = max((bounds.height / CGFloat(cardAttrs.number)), dividedHeightMin)
    
    var w, h: CGFloat
    
    h = dividedHeight * 0.7
    w = min((h * 2), bounds.width)
    
    return CGSizeMake(w, h)
  }

  
  private func drawShape(context: CGContextRef, size: CGSize) {
    CGContextSaveGState(context) // --- Context Saved ---
    
    switch(cardAttrs.shape) {
      case .Diamond:
        drawDiamond(size)
      case .Oval:
//        drawOval(size)
        let d = min(size.width, size.height)
        drawSun(CGSize(width: d, height: d))
      case .Squiggle:
        let d = min(size.width, size.height)

        drawMoon(CGSize(width: d, height: d))
//        CGContextSetLineCap(context, CGLineCap.Round)
//        drawSquiggle(size)
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
    let path = UIBezierPath(roundedRect: CGRect(origin: CGPointZero, size: size), cornerRadius: (size.height / 2))

    path.stroke()
    path.addClip()
    
    let shading = cardAttrs.shading
    
    if (shading == .Solid) {
      path.fill()
    } else if (shading == .Striped) {
      drawStripes(size)
    }
  }
  
  private func drawRays(size: CGSize) {
    let shading = cardAttrs.shading

    let rayAnchor = CGRect(origin: CGPoint(x: size.width / 3, y: size.height / 3),
      size: CGSize(width: size.width / 3, height: size.width / 3))
    let rayPath = UIBezierPath()
    let p = ((size.height / 2 - 2) * 0.113)
    
    rayPath.moveToPoint(CGPoint(x: rayAnchor.minX, y: rayAnchor.minY))
    rayPath.addLineToPoint(CGPoint(x: rayAnchor.midX, y: -p))
    rayPath.addLineToPoint(CGPoint(x: rayAnchor.maxX, y: rayAnchor.minY))
    rayPath.addLineToPoint(CGPoint(x: size.width + p, y: rayAnchor.midY))
    rayPath.addLineToPoint(CGPoint(x: rayAnchor.maxX, y: rayAnchor.maxY))
    rayPath.addLineToPoint(CGPoint(x: rayAnchor.midX, y: size.height + p))
    rayPath.addLineToPoint(CGPoint(x: rayAnchor.minX, y: rayAnchor.maxY))
    rayPath.addLineToPoint(CGPoint(x: -p, y: rayAnchor.midY))
    rayPath.addLineToPoint(CGPoint(x: rayAnchor.minX, y: rayAnchor.minY))
    
    rayPath.closePath()
    rayPath.stroke()

    if (shading == .Solid) {
      rayPath.fill()
    }
  }
  
  private func drawMoon(size: CGSize) {
    let circlePath = UIBezierPath()
    let r = size.width / 2
    var center = CGPoint(x: r, y: r)
    
    circlePath.addArcWithCenter(center, radius: r, startAngle: CGFloat(M_PI_4 * 6), endAngle: CGFloat(M_PI_4 * 3), clockwise: true)
//    circlePath.stroke()
//    center = CGPoint(x: r / 2, y: r / 2)
//    circlePath.addArcWithCenter(center, radius: r, startAngle: CGFloat(M_PI_4 * 7), endAngle: CGFloat(M_PI_4 * 3), clockwise: true)
    let sp = CGPoint(x: r, y: 0)
    let ep = CGPoint(x: r - r * cos(CGFloat(M_PI_4)), y: r + r * sin(CGFloat(M_PI_4)))
    let cp1 = CGPoint(x: sp.x + r / 1.5, y: r / 1.5)
    let cp2 = CGPoint(x: ep.x + r / 1.5, y: ep.y)

//    circlePath.moveToPoint(sp)
    circlePath.addCurveToPoint(sp, controlPoint1: cp2, controlPoint2: cp1)
    circlePath.closePath()
//    circlePath.addCurveToPoint(ep, controlPoint1: cp1, controlPoint2: cp2)
//    circlePath.closePath()
    circlePath.stroke()

    if (cardAttrs.shading == .Solid) {
      circlePath.fill()
    } else if (cardAttrs.shading == .Striped) {
      circlePath.addClip()
      drawStripes(size)
    }
  }
  
  private func drawSun(size: CGSize) {
    let shading = cardAttrs.shading
    
    drawRays(size)
    
    let context = UIGraphicsGetCurrentContext()

    CGContextSaveGState(context)
    CGContextTranslateCTM(context, size.width / 2, -size.height / 4)
    CGContextRotateCTM(context, CGFloat(M_PI_4))
    drawRays(size)
    
    CGContextRestoreGState(context)
    
    let center = CGPoint(x: size.width / 2, y: size.height / 2)
    let r = size.height / 2.5
    let circlePath = UIBezierPath()
    
    circlePath.addArcWithCenter(center, radius: r, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
    circlePath.stroke()
    
    
    if (shading != .Solid) {
      CGContextSaveGState(context)
      CGContextSetFillColor(context, [1.0, 1.0, 1.0, 1.0])
      circlePath.fill()
      CGContextRestoreGState(context)

      if (shading == .Striped) {
        circlePath.addClip()
        drawStripes(size)
      }
    } else {
      circlePath.fill()
    }
//
//    if (shading == .Solid) {
//      path.fill()
//    } else if (shading == .Striped) {
//      drawStripes(size)
//    }
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
  
  
  private func drawSpots(size: CGSize) {
    var xi: CGFloat = -0.5
    var yi: CGFloat = -0.5
        
    var spot = CGRect(origin: CGPoint(x: xi, y: yi), size: CGSize(width: 1, height: 1))
    var path = UIBezierPath(roundedRect: spot, cornerRadius: 0.5)

    while (xi < size.width) {
      while(yi < size.height) {
        path = UIBezierPath(roundedRect: spot, cornerRadius: 0.5)
        path.fill()
        yi += 2

        spot = CGRect(origin: CGPoint(x: xi, y: yi), size: spot.size)
      }
      yi = -0.5
      xi += 2
    }
  }
  
  
  private func drawStripes(size: CGSize) {
    drawSpots(size)
  /*
    let path = UIBezierPath()
    var xi: CGFloat = 1
    
    while (xi < size.width) {
      path.moveToPoint(CGPoint(x: xi, y: 0))
      path.addLineToPoint(CGPoint(x: xi, y: size.height))
      xi += 3
    }
    
    path.stroke()*/
  }
  
  class func rgbColor(color: SGColor) -> [CGFloat] {
    switch(color) {
      case .Green:
        return [1.0, 0.2, 0.2, 1.0]
//        return [0.102, 0.694, 0.365, 1.0]
      case .Purple:
        return [0.3, 0.5, 1.0, 1.0]
//        return [0.286, 0.2, 0.565, 1.0]
      case .Red:
        return [1.0, 0.5, 0.0, 1.0]
//        return [0.875, 0.259, 0.302, 1.0]
    }
  }
}