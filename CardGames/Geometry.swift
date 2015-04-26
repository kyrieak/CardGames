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

extension CGRect {
  init(ctrPoint: CGPoint, size: CGSize) {
    let leftCorner = CGPoint(x: ctrPoint.x - (size.width / 2),
                             y: ctrPoint.y - (size.height / 2))
    
    self.init(origin: leftCorner, size: size)
  }


  init(basePoint: CGPoint, size: CGSize) {
    let origin = CGPoint(x: basePoint.x - (size.width / 2), y: basePoint.y - size.height)
    
    self.init(origin: origin, size: size)
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


protocol Shape {
  var center: CGPoint { get }
  var bounds: CGRect { get }
  
  init(ctrPoint: CGPoint, size: CGSize)
}

// =========== Shapes =========================================

struct Squiggle: Shape {
  var center: CGPoint
  var bounds: CGRect
  let curve: Curve
  
  var startingPoint: CGPoint {
    return curve.startingPoint
  }
  
  var connections: [CurveConnector] {
    return curve.connections
  }
  
  init(size: CGSize) {
    center = CGPoint(x: size.width / 2, y: size.height / 2)
    bounds = CGRect(origin: CGPointZero, size: size)
    curve = Squiggle.defineCurve(size)
  }
  
  init(ctrPoint: CGPoint, size: CGSize) {
    center = ctrPoint
    bounds = CGRect(ctrPoint: ctrPoint, size: size)
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


struct Heart: Shape {
  var center: CGPoint
  var bounds: CGRect
  var cuspPoint, endPoint: CGPoint
  private var qtrSize: CGSize
  
  init(ctrPoint: CGPoint, size: CGSize) {
    center = ctrPoint
    bounds = CGRect(ctrPoint: ctrPoint, size: size)
    qtrSize = CGSize(width: size.width / 4, height: size.height / 4)
    
    cuspPoint = CGPoint(x: ctrPoint.x, y: ctrPoint.y - qtrSize.height)
    endPoint  = CGPoint(x: ctrPoint.x, y: ctrPoint.y + (size.height / 2))
  }
  
  func getLeftCurve() -> Curve {
    var sPoint, ePoint, cPoint1, cPoint2: CGPoint
    var curve = Curve(startingPoint: cuspPoint)
    let dx = qtrSize.width / 2
    let dy = qtrSize.height / 2
    
    ePoint  = CGPoint(x: cuspPoint.x - qtrSize.width, y: cuspPoint.y - qtrSize.height)
    cPoint1 = CGPoint(x: cuspPoint.x, y: cuspPoint.y - dy)
    cPoint2 = CGPoint(x: ePoint.x + dx, y: ePoint.y)

    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    sPoint  = ePoint
    ePoint  = CGPoint(x: ePoint.x - qtrSize.width, y: cuspPoint.y)
    cPoint1 = CGPoint(x: sPoint.x - dx, y: sPoint.y)
    cPoint2 = CGPoint(x: ePoint.x, y: ePoint.y - dy)
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))

    sPoint = ePoint
    ePoint  = endPoint
    cPoint1 = CGPoint(x: sPoint.x, y: sPoint.y + qtrSize.height)
    cPoint2 = ePoint
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    return curve
  }
  
  
  func getRightCurve() -> Curve {
    var sPoint, ePoint, cPoint1, cPoint2: CGPoint
    var curve = Curve(startingPoint: cuspPoint)
    let dx = qtrSize.width / 2
    let dy = qtrSize.height / 2
    
    ePoint  = CGPoint(x: cuspPoint.x + qtrSize.width, y: cuspPoint.y - qtrSize.height)
    cPoint1 = CGPoint(x: cuspPoint.x, y: cuspPoint.y - dy)
    cPoint2 = CGPoint(x: ePoint.x - dx, y: ePoint.y)
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    sPoint = ePoint
    ePoint  = CGPoint(x: ePoint.x + qtrSize.width, y: cuspPoint.y)
    cPoint1 = CGPoint(x: sPoint.x + dx, y: sPoint.y)
    cPoint2 = CGPoint(x: ePoint.x, y: ePoint.y - dy)
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    sPoint = ePoint
    ePoint  = endPoint
    cPoint1 = CGPoint(x: sPoint.x, y: sPoint.y + qtrSize.height)
    cPoint2 = ePoint
    
    curve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    return curve
  }
}


struct Spade: Shape {
  var center: CGPoint
  var bounds: CGRect
  var cuspPoint, endPoint: CGPoint
  private var qtrSize: CGSize
  
  init(ctrPoint: CGPoint, size: CGSize) {
    center = ctrPoint
    bounds = CGRect(ctrPoint: ctrPoint, size: size)
    qtrSize = CGSize(width: size.width / 4, height: size.height / 4)
    
    cuspPoint = CGPoint(x: ctrPoint.x, y: bounds.midY)
    endPoint  = CGPoint(x: ctrPoint.x, y: bounds.minY)
  }
  
  func getLeftCurve() -> Curve {
    var ePoint, cPoint1, cPoint2: CGPoint
    var curve = Curve(startingPoint: cuspPoint)
    
    ePoint  = CGPoint(x: cuspPoint.x - qtrSize.width, y: cuspPoint.y + qtrSize.height)
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
    
    ePoint  = CGPoint(x: cuspPoint.x + qtrSize.width, y: cuspPoint.y + qtrSize.height)
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

  func getStem() -> Stem {
    let bPoint = CGPoint(x: center.x, y: bounds.maxY)
    let bWidth = bounds.size.width / 4.5
    return Stem(basePoint: bPoint, baseWidth: bWidth, height: bWidth * 3)
  }
}


struct Club: Shape {
  var center: CGPoint
  var bounds: CGRect
  var r: CGFloat
  
  init(ctrPoint: CGPoint, size: CGSize) {
    center = ctrPoint
    bounds = CGRect(ctrPoint: ctrPoint, size: size)
    r = size.width / 4.5
  }
  
  func getStem() -> Stem {
    let bPoint = CGPoint(x: center.x, y: bounds.maxY)
    
    return Stem(basePoint: bPoint, baseWidth: r, height: r * 3)
  }
  
  func getLeafCenterPoints() -> [CGPoint] {
    var ctrPoints: [CGPoint] = []
    var y0, y1: CGFloat
    
    y0 = bounds.minY + r
    y1 = y0 + (r * sqrt(CGFloat(2)))
    
    ctrPoints.append(CGPoint(x: bounds.midX, y: y0))
    ctrPoints.append(CGPoint(x: bounds.minX + r, y: y1))
    ctrPoints.append(CGPoint(x: bounds.maxX - r, y: y1))
    
    return ctrPoints
  }
}


struct Stem {
  var basePoint: CGPoint
  var bounds: CGRect
  
  private var baseWidth, height: CGFloat
  
  var topPoint: CGPoint {
    return CGPoint(x: basePoint.x, y: bounds.minY)
  }
  
  init(basePoint: CGPoint, baseWidth: CGFloat, height: CGFloat) {
    self.bounds = CGRect(basePoint: basePoint, size: CGSize(width: baseWidth, height: height))
    
    self.basePoint = basePoint
    self.baseWidth = baseWidth
    self.height = height
  }
  
  func getLeftCurve() -> Curve {
    var lCurve = Curve(startingPoint: topPoint)
    
    var ePoint  = CGPoint(x: bounds.minX, y: bounds.maxY)
    var cPoint1 = ePoint
    var cPoint2 = ePoint
    
    lCurve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    return lCurve
  }
  
  func getRightCurve() -> Curve {
    var rCurve = Curve(startingPoint: topPoint)
    
    var ePoint  = CGPoint(x: bounds.maxX, y: bounds.maxY)
    var cPoint1 = ePoint
    var cPoint2 = ePoint
    
    rCurve.addConnection(CurveConnector(ep: ePoint, cp1: cPoint1, cp2: cPoint2))
    
    return rCurve
  }
}

