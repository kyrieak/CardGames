//
//  CGGeometryExtensions.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 4/20/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
  func getDistance(toPoint: CGPoint) -> CGPoint {
    return CGPoint(x: (toPoint.x - x), y: (toPoint.y - y))
  }
}

struct Curve {
  var startingPoint: CGPoint
  var connections: [CurveConnector]
  
  init(startingPoint: CGPoint) {
    self.startingPoint = startingPoint
    self.connections = []
  }
  
  mutating func addConnection(connector: CurveConnector) {
    connections.append(connector)
  }
}

struct CurveConnector {
  var ep, cp1, cp2: CGPoint
  
  init(ep: CGPoint, cp1: CGPoint, cp2: CGPoint) {
    self.ep = ep
    self.cp1 = cp1
    self.cp2 = cp2
  }
}


struct Squiggle {
  let curve: Curve
  
  var startingPoint: CGPoint {
    return curve.startingPoint
  }
  
  var connections: [CurveConnector] {
    return curve.connections
  }
  
  init(size: CGSize) {
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

struct Heart {
  var cuspPoint, endPoint: CGPoint
  private var qtrSize: CGSize
  
  init(ctrPoint: CGPoint, size: CGSize) {
    qtrSize = CGSize(width: size.width / 4, height: size.height / 4)
    
    cuspPoint = CGPoint(x: ctrPoint.x, y: ctrPoint.y - qtrSize.height)
    endPoint  = CGPoint(x: ctrPoint.x, y: ctrPoint.y + (size.height / 2))
  }
  
  func getLeftCurve() -> Curve {
    var ePoint, cPoint1, cPoint2: CGPoint
    var curve = Curve(startingPoint: cuspPoint)
    
    ePoint  = CGPoint(x: cuspPoint.x - qtrSize.width, y: cuspPoint.y - qtrSize.height)
    cPoint1 = ePoint
    cPoint2 = ePoint
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    ePoint  = CGPoint(x: ePoint.x - qtrSize.width, y: cuspPoint.y)
    cPoint1 = ePoint
    cPoint2 = ePoint
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    ePoint  = endPoint
    cPoint1 = ePoint
    cPoint2 = ePoint
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    return curve
  }
  
  
  func getRightCurve() -> Curve {
    var ePoint, cPoint1, cPoint2: CGPoint
    var curve = Curve(startingPoint: cuspPoint)
    
    ePoint  = CGPoint(x: cuspPoint.x + qtrSize.width, y: cuspPoint.y - qtrSize.height)
    cPoint1 = ePoint
    cPoint2 = ePoint
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    ePoint  = CGPoint(x: ePoint.x + qtrSize.width, y: cuspPoint.y)
    cPoint1 = ePoint
    cPoint2 = ePoint
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    ePoint  = endPoint
    cPoint1 = ePoint
    cPoint2 = ePoint
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    return curve
  }
}
