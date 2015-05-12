//
//  Squiggle.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 5/7/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit


struct Squiggle: Shape {
  var center: CGPoint
  var size: CGSize
  
  var bounds: CGRect {
    return CGRect(ctrPoint: self.center, size: self.size)
  }
  
  var curve: Curve
  
  var startingPoint: CGPoint {
    return curve.startingPoint
  }
  
  var connections: [CurveConnector] {
    return curve.connections
  }
  
  init(size: CGSize) {
    self.center = CGPoint(x: size.width / 2, y: size.height / 2)
    self.size   = size
    curve = Squiggle.defineCurve(size)
  }
  
  init(ctrPoint: CGPoint, size: CGSize) {
    self.center = ctrPoint
    self.size   = size
    curve = Squiggle.defineCurve(size)
  }
  
  private static func defineCurve(size: CGSize) -> Curve {
    let xInc = size.width / 12
    let yInc = size.height / 6
    
    var A, B, C, AT, BT, CT: CGPoint
    var ep, cp1, cp2: CGPoint
    
    A  = CGPoint(x: 0, y: yInc * 5)
    B  = CGPoint(x: xInc * 4, y: yInc / 2)
    C  = CGPoint(x: xInc * 8, y: yInc * 2)
    AT = CGPoint(x: size.width, y: yInc)
    BT = CGPoint(x: xInc * 8, y: yInc * 5.5)
    CT = CGPoint(x: xInc * 4, y: yInc * 4)
    
    var curve = Curve(startingPoint: A)
    
    curve.addConnection(CurveConnector(ep: B, cp1: CGPoint(x: 0, y: yInc * 3),
      cp2: CGPoint(x: xInc * 2, y: yInc)))
    
    curve.addConnection(CurveConnector(ep: C, cp1: CGPoint(x: xInc * 6, y: yInc / 2),
      cp2: CGPoint(x: xInc * 6, y: yInc * 2)))
    
    curve.addConnection(CurveConnector(ep: AT, cp1: CGPoint(x: xInc * 10, y: yInc * 2),
      cp2: CGPoint(x: xInc * 10, y: yInc)))
    
    curve.addConnection(CurveConnector(ep: BT, cp1: CGPoint(x: size.width, y: yInc * 3),
      cp2: CGPoint(x: xInc * 10, y: yInc * 5)))
    
    curve.addConnection(CurveConnector(ep: CT, cp1: CGPoint(x: xInc * 6, y: yInc * 5.5),
      cp2: CGPoint(x: xInc * 6, y: yInc * 4)))
    
    curve.addConnection(CurveConnector(ep: A, cp1: CGPoint(x: xInc * 2, y: yInc * 4),
      cp2: CGPoint(x: xInc * 2, y: yInc * 5)))
    
    return curve
  }
}