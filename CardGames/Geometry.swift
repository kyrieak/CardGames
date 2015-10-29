//
//  CGGeometryExtensions.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 4/20/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

// - MARK: - CG Extensions ------------------------------------

extension CGPoint {
  func getDistance(toPoint: CGPoint) -> (dx: CGFloat, dy: CGFloat, abs: CGFloat) {
    let _dx  = toPoint.x - self.x
    let _dy  = toPoint.y - self.y
    let _abs = sqrt(pow(_dx, 2) + pow(_dy, 2))
    
    return (dx: _dx, dy: _dy, abs: _abs)
  }
  
  func rotatedPoint(aboutOrigin: CGPoint, rotationAngle: Double) -> CGPoint {
    let dist = aboutOrigin.getDistance(self)
    let r = Double(dist.abs)
    
    let theta = atan2(Double(dist.dy), Double(dist.dx)) + rotationAngle
    
    return CGPoint(x: aboutOrigin.x + CGFloat(r * cos(theta)),
                   y: aboutOrigin.y + CGFloat(r * sin(theta)))
  }
  

  func xReflectedPoint(axisX: CGFloat) -> CGPoint {
    let dx = self.x - axisX
    
    return CGPoint(x: (axisX - dx), y: self.y)
  }

  func yReflectedPoint(axisY: CGFloat) -> CGPoint {
    let dy = self.x - axisY
    
    return CGPoint(x: self.x, y: (axisY - dy))
  }
  
  func offsetPoint(dx: CGFloat, dy: CGFloat) -> CGPoint{
    return CGPoint(x: self.x + dx, y: self.y + dy)
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
  
  func getMinMaxDims() -> (min: CGFloat, max: CGFloat) {
    return size.getMinMaxDims()
  }
}

extension CGSize {
  func getMinMaxDims() -> (min: CGFloat, max: CGFloat) {
    return (min: min(width, height), max: max(width, height))
  }
}

extension UIEdgeInsets {
  init(tb: CGFloat, lr: CGFloat) {
    self.top    = tb
    self.bottom = tb
    self.left   = lr
    self.right  = lr
  }
}


// - MARK: - Curve ------------------------------------

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
  
  mutating func move(dx: CGFloat, dy: CGFloat) {
    startingPoint = startingPoint.offsetPoint(dx, dy: dy)
    
    for (var c) in connections {
      c.move(dx, dy: dy)
    }
  }
}

struct CurveConnector {
  var ep, cp1, cp2: CGPoint
  
  init(ep: CGPoint, cp1: CGPoint, cp2: CGPoint) {
    self.ep = ep
    self.cp1 = cp1
    self.cp2 = cp2
  }
  
  mutating func move(dx: CGFloat, dy: CGFloat) {
    ep  = ep.offsetPoint(dx, dy: dy)
    cp1 = cp1.offsetPoint(dx, dy: dy)
    cp2 = cp2.offsetPoint(dx, dy: dy)
  }
}

// - MARK: - Shape ------------------------------------

protocol Shape {
  var center: CGPoint { get }
  var size: CGSize { get }
  var bounds: CGRect { get }
  
  init(ctrPoint: CGPoint, size: CGSize)
}

// =========== Shapes =========================================

