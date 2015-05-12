//
//  Heart.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 5/7/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit


struct Heart: Shape {
  var center: CGPoint
  var size: CGSize

  var bounds: CGRect {
    return CGRect(ctrPoint: center, size: size)
  }
  
  private(set) lazy var curve: Curve = {
    return Heart.makeCurveFrom(self.bounds)
  }()
  
  init(ctrPoint: CGPoint, size: CGSize) {
    self.center = ctrPoint
    self.size = size
  }
  
  mutating func resize(_size: CGSize) {
    size  = _size
    curve = Heart.makeCurveFrom(bounds)
  }
  
  mutating func move(dx: CGFloat, dy: CGFloat) {
    center = center.offsetPoint(dx, dy: dy)
    curve.move(dx, dy: dy)
  }
  
  static func makeCurveFrom(bounds: CGRect) -> Curve {
    let cuspPoint = CGPoint(x: bounds.midX, y: bounds.midY - (bounds.height / 4))
    let endPoint  = CGPoint(x: bounds.midX, y: bounds.maxY)
    
    let qtrW = bounds.width / 4
    let qtrH = bounds.height / 4
    let dx   = qtrW / 2
    let dy   = qtrH / 2
    
    var curve = Curve(startingPoint: cuspPoint)
    
    var _ep, _cp1, _cp2: CGPoint
    
    // i = 0
    _cp1 = CGPoint(x: cuspPoint.x, y: cuspPoint.y - dy)
    _ep  = CGPoint(x: cuspPoint.x - qtrW, y: bounds.minY)
    _cp2 = CGPoint(x: cuspPoint.x - dx, y: bounds.minY)
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    
    // i = 1
    _cp1 = CGPoint(x: bounds.minX + dx, y: bounds.minY)
    _ep  = CGPoint(x: bounds.minX, y: cuspPoint.y)
    _cp2 = CGPoint(x: bounds.minX, y: cuspPoint.y - dy)
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    
    // i = 2
    _cp1 = CGPoint(x: bounds.minX, y: cuspPoint.y + qtrH)
    _ep  = endPoint
    _cp2 = endPoint
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    
    for i in 0...2 {
      var connect = curve.connections[2 - i]
      
      if (i == 2) {
        _ep = curve.startingPoint
      } else {
        _ep = curve.connections[1 - i].ep.xReflectedPoint(cuspPoint.x)
      }
      
      _cp1 = connect.cp2.xReflectedPoint(cuspPoint.x)
      _cp2 = connect.cp1.xReflectedPoint(cuspPoint.x)
      
      curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    }
    
    return curve
  }
}