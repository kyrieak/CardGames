//
//  Club.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 5/7/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit


struct Club: Shape {
  var center: CGPoint
  var size: CGSize
  
  var bounds: CGRect {
    return CGRect(ctrPoint: center, size: size)
  }
  var r: CGFloat
  
  init(ctrPoint: CGPoint, size: CGSize) {
    self.center = ctrPoint
    self.size   = size
    self.r      = size.width / 4.5
  }
  
  func getStem() -> Stem {
    let bPoint = CGPoint(x: center.x, y: bounds.maxY)
    
    return Stem(basePoint: bPoint, baseWidth: r, height: r * 3)
  }
  
  func getStemCurve() -> Curve {
    return getStem().getCurve()
  }
  

  func getLeafCurves() -> [Curve] {
    var top, left, right: Curve
    var _ep, _cp1, _cp2: CGPoint
    
    let headBounds = getHeadBounds()
    
    let r = min(headBounds.height, headBounds.width) / 2
    let a = r / 2
    let b = a * sqrt(3)
    let h = r + a
    
    let halfLeafW = r / 2.4
    
    let dx = r / 4
    let dy = r / 2
    
    let startingPoint = CGPoint(x: headBounds.midX, y: headBounds.minY + r)
    
    top = Curve(startingPoint: startingPoint)
    
    // a -> b
    _cp1 = startingPoint
    _ep  = CGPoint(x: headBounds.midX - halfLeafW, y: headBounds.minY + (r * 0.4))
    _cp2 = CGPoint(x: _ep.x, y: _ep.y + dy)
    
    top.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    // b -> c
    _cp1 = CGPoint(x: _ep.x, y: _ep.y - dx)
    _ep  = CGPoint(x: headBounds.midX, y: headBounds.minY)
    _cp2 = CGPoint(x: _ep.x - dx, y: _ep.y)
    
    top.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    // c -> b'
    _cp1 = CGPoint(x: _ep.x + dx, y: _ep.y)
    _ep  = CGPoint(x: headBounds.midX + halfLeafW, y: headBounds.minY + (r * 0.4))
    _cp2 = CGPoint(x: _ep.x, y: _ep.y - dx)
    
    top.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    // b' -> a
    _cp1 = CGPoint(x: _ep.x, y: _ep.y + dy)
    _ep  = startingPoint
    _cp2 = startingPoint
    
    top.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    left = Curve(startingPoint: startingPoint)
    var angle = (M_PI * 15 / 24)
    
    for connect in top.connections {
      _cp1 = connect.cp1.rotatedPoint(top.startingPoint, rotationAngle: angle)
      _ep  = connect.ep.rotatedPoint(top.startingPoint, rotationAngle: angle)
      _cp2 = connect.cp2.rotatedPoint(top.startingPoint, rotationAngle: angle)
      
      left.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    }

    right = Curve(startingPoint: startingPoint)
    angle *= -1
    
    for connect in top.connections {
      _cp1 = connect.cp1.rotatedPoint(top.startingPoint, rotationAngle: angle)
      _ep  = connect.ep.rotatedPoint(top.startingPoint, rotationAngle: angle)
      _cp2 = connect.cp2.rotatedPoint(top.startingPoint, rotationAngle: angle)
      
      right.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    }
    
    return [top, left, right]
  }
  
  func getHeadBounds() -> CGRect {
    let d = min(bounds.width, bounds.height)
    let inset = d * 0.05
    
    var hBounds = CGRectInset(bounds, 0, inset)
    hBounds.origin.y -= inset
    
    return hBounds
  }
}