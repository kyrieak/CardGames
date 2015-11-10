//
//  Cloud.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 11/8/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

struct Cloud {
  var bounds: CGRect
  let r: CGFloat
  
  let leftStartAngle  = CGFloat(M_PI_4)
  let leftEndAngle    = CGFloat(M_PI_4 * -1)
  let rightStartAngle = CGFloat(M_PI_4 * 5)
  let rightEndAngle   = CGFloat(M_PI_4 * 3)

  let leftArcCenter, rightArcCenter: CGPoint
  
  var topCurveStartPoint: CGPoint {
    return CGPoint.getPointFrom(self.leftArcCenter, r: self.r, angle: self.leftEndAngle)
  }
  
  var topCurveEndPoint: CGPoint {
    return CGPoint.getPointFrom(self.rightArcCenter, r: self.r, angle: self.rightStartAngle)
  }

  var botCurveStartPoint: CGPoint {
    return CGPoint.getPointFrom(self.rightArcCenter, r: self.r, angle: self.rightEndAngle)
  }
  
  var botCurveEndPoint: CGPoint {
    return CGPoint.getPointFrom(self.leftArcCenter, r: self.r, angle: self.leftStartAngle)
  }
  
  init(bounds: CGRect) {
    self.bounds = bounds
    self.r      = abs(bounds.size.width / 6)
    
    leftArcCenter  = CGPoint(x: bounds.minX + r, y: bounds.midY)
    rightArcCenter = CGPoint(x: bounds.maxX - r, y: bounds.midY)
  }
  
  
  func makePath() -> UIBezierPath {
    let path = UIBezierPath()
    var cp1 = CGPoint(x: topCurveStartPoint.x + r, y: bounds.midY - 1.5 * r)
    var cp2 = CGPoint(x: topCurveEndPoint.x - r, y: cp1.y)

    path.moveToPoint(botCurveEndPoint)
    
    path.addArcWithCenter(leftArcCenter, radius: r, startAngle: leftStartAngle, endAngle: leftEndAngle, clockwise: true)
    path.addCurveToPoint(topCurveEndPoint, controlPoint1: cp1, controlPoint2: cp2)
    path.addArcWithCenter(rightArcCenter, radius: r, startAngle: rightStartAngle, endAngle: rightEndAngle, clockwise: true)

    cp1 = CGPoint(x: botCurveStartPoint.x - r, y: bounds.midY + 1.5 * r)
    cp2 = CGPoint(x: botCurveEndPoint.x + r, y: cp1.y)

    path.addCurveToPoint(botCurveEndPoint, controlPoint1: cp1, controlPoint2: cp2)
    path.closePath()

    return path
  }
}