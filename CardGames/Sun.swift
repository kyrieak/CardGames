//
//  Sun.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 11/9/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

struct Sun {
  let center: CGPoint
  let rInner, rOuter: CGFloat
  
  init(bounds: CGRect) {
    center = CGPoint(x: bounds.midX, y: bounds.midY)
    
    let d = min(bounds.width, bounds.height)
    
    rOuter = d / 2
    rInner = d / 2.5
  }

  func makePath() -> (outer: UIBezierPath, inner: UIBezierPath) {
    let path = UIBezierPath()
    let pi_12 = CGFloat(M_PI_4 / 3)
    
    path.moveToPoint(CGPoint.getPointFrom(center, r: rInner, angle: pi_12))
    
    path.addArcWithCenter(center, radius: rInner, startAngle: pi_12, endAngle: pi_12 * 2, clockwise: true)
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rOuter, angle: pi_12 * 3))
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rInner, angle: pi_12 * 4))
    
    path.addArcWithCenter(center, radius: rInner, startAngle: pi_12 * 4, endAngle: pi_12 * 5, clockwise: true)
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rOuter, angle: pi_12 * 6))
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rInner, angle: pi_12 * 7))
    
    path.addArcWithCenter(center, radius: rInner, startAngle: pi_12 * 7, endAngle: pi_12 * 8, clockwise: true)
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rOuter, angle: pi_12 * 9))
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rInner, angle: pi_12 * 10))
    
    path.addArcWithCenter(center, radius: rInner, startAngle: pi_12 * 10, endAngle: pi_12 * 11, clockwise: true)
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rOuter, angle: pi_12 * 12))
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rInner, angle: pi_12 * 13))
    
    path.addArcWithCenter(center, radius: rInner, startAngle: pi_12 * 13, endAngle: pi_12 * 14, clockwise: true)
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rOuter, angle: pi_12 * 15))
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rInner, angle: pi_12 * 16))
    
    path.addArcWithCenter(center, radius: rInner, startAngle: pi_12 * 16, endAngle: pi_12 * 17, clockwise: true)
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rOuter, angle: pi_12 * 18))
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rInner, angle: pi_12 * 19))
    
    path.addArcWithCenter(center, radius: rInner, startAngle: pi_12 * 19, endAngle: pi_12 * 20, clockwise: true)
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rOuter, angle: pi_12 * 21))
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rInner, angle: pi_12 * 22))
    
    path.addArcWithCenter(center, radius: rInner, startAngle: pi_12 * 22, endAngle: pi_12 * 23, clockwise: true)
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rOuter, angle: pi_12 * 24))
    path.addLineToPoint(CGPoint.getPointFrom(center, r: rInner, angle: pi_12))

    path.closePath()
    
    let pathInner = UIBezierPath(arcCenter: center, radius: rInner, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)

    pathInner.closePath()

    return (outer: path, inner: pathInner)
  }
}