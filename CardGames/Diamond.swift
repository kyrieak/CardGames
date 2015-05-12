//
//  Diamond.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 5/12/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

struct Diamond: Shape {
  var center: CGPoint
  var size: CGSize
  
  var bounds: CGRect {
    return CGRect(ctrPoint: self.center, size: self.size)
  }
  
  init(ctrPoint: CGPoint, size: CGSize) {
    self.center = ctrPoint
    self.size = size
  }
  
  func getCurve() -> Curve {
    let _bounds = bounds
    let dx      = _bounds.width / 16
    let dy      = _bounds.height / 16
    
    let sPoint = CGPoint(x: _bounds.midX, y: _bounds.minY)
    
    var _ep, _cp1, _cp2: CGPoint
    
    var curve = Curve(startingPoint: sPoint)

    _cp1 = CGPoint(x: _bounds.midX, y: _bounds.minY + dy)
    _ep  = CGPoint(x: _bounds.minX, y: _bounds.midY)
    _cp2 = CGPoint(x: _bounds.minX + dx, y: _bounds.midY)
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    _cp1 = _cp2
    _ep  = CGPoint(x: _bounds.midX, y: _bounds.maxY)
    _cp2 = CGPoint(x: _bounds.midX, y: _bounds.maxY - dy)
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))

    _cp1 = _cp2
    _ep  = CGPoint(x: _bounds.maxX, y: _bounds.midY)
    _cp2 = CGPoint(x: _bounds.maxX - dx, y: _bounds.midY)
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))

    _cp1 = _cp2
    _ep  = sPoint
    _cp2 = CGPoint(x: sPoint.x, y: _bounds.minY + dy)

    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))

    return curve
  }
}