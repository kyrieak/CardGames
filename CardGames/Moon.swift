//
//  Moon.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 11/7/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

struct Moon {
  let r: CGFloat
  let startAngle = CGFloat(M_PI_4 * 6)
  let endAngle   = CGFloat(M_PI_4 * 3)

  let outerStartPoint: CGPoint
  let outerEndPoint: CGPoint
  
  let innerCP1, innerCP2: CGPoint
  let ctrPoint: CGPoint
  
  var innerStartPoint: CGPoint {
    return outerEndPoint
  }
  
  var innerEndPoint: CGPoint {
    return outerStartPoint
  }
  
  
  init(bounds: CGRect) {
    r = min(bounds.width, bounds.height) / 2.0
    
    ctrPoint        = CGPoint(x: bounds.midX, y: bounds.midY)
    outerStartPoint = CGPoint(x: r, y: 0)
    outerEndPoint   = CGPoint(x: r - r * cos(CGFloat(M_PI_4)),
                              y: r + r * sin(CGFloat(M_PI_4)))
    
    innerCP1 = CGPoint(x: outerEndPoint.x + r / 1.5, y: outerEndPoint.y)
    innerCP2 = CGPoint(x: outerStartPoint.x + r / 1.5, y: outerStartPoint.y + r / 1.5)
  }
  
  func makePath() -> UIBezierPath {
    let path = UIBezierPath()
    
    path.addArcWithCenter(ctrPoint, radius: r, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    path.addCurveToPoint(innerEndPoint, controlPoint1: innerCP1, controlPoint2: innerCP2)

    path.closePath()
    
    return path
  }
}