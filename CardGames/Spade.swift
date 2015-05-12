//
//  Spade.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 5/7/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit


struct Spade: Shape {
  var center: CGPoint
  var size: CGSize
  
  var bounds: CGRect {
    return CGRect(ctrPoint: self.center, size: self.size)
  }
  
  init(ctrPoint: CGPoint, size: CGSize) {
    self.center = ctrPoint
    self.size   = size
  }
  
  func getCurve() -> Curve {
    let headBounds = Spade.getHeadBounds(bounds)
    let qtrSize    = CGSize(width: headBounds.width / 4, height: headBounds.height / 4)
    let cuspPoint  = CGPoint(x: headBounds.midX, y: headBounds.maxY - qtrSize.height)
    let endPoint   = CGPoint(x: headBounds.midX, y: headBounds.minY)

    var _ep, _cp1, _cp2: CGPoint
    var curve = Curve(startingPoint: cuspPoint)
    
    let dx = qtrSize.width / 2
    let dy = qtrSize.height / 2
    
    // i = 0
    _cp1 = cuspPoint
    _ep  = CGPoint(x: cuspPoint.x - qtrSize.width, y: cuspPoint.y + qtrSize.height)
    _cp2 = CGPoint(x: cuspPoint.x - dx, y: cuspPoint.y + qtrSize.height)
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    
    // i = 1
    _cp1 = CGPoint(x: headBounds.minX + dx, y: cuspPoint.y + qtrSize.height)
    _ep  = CGPoint(x: headBounds.minX, y: cuspPoint.y)
    _cp2 = CGPoint(x: headBounds.minX, y: cuspPoint.y + dy)
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    
    // i = 2
    _cp1 = CGPoint(x: headBounds.minX, y: cuspPoint.y - qtrSize.height)
    _ep  = endPoint
    _cp2 = CGPoint(x: endPoint.x, y: endPoint.y + dy)
    
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
  
  
  func getStemCurve() -> Curve {
    return getStem().getCurve()
  }
  
  func getStem() -> Stem {
    let bPoint = CGPoint(x: center.x, y: bounds.maxY)
    let bWidth = bounds.size.width / 4.5
    return Stem(basePoint: bPoint, baseWidth: bWidth, height: bWidth * 4)
  }
  
  static func getHeadBounds(bounds: CGRect) -> CGRect {
    let d = min(bounds.width, bounds.height)
    let inset = d * 0.1
    
    var hBounds = CGRectInset(bounds, inset, inset)
    hBounds.origin.y -= inset
    
    return hBounds
  }
}
