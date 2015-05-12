//
//  Stem.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 5/7/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

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
  
  func getCurve() -> Curve {
    let dx = baseWidth * 0.25
    let dy = baseWidth
    
    var curve = Curve(startingPoint: topPoint)
    
    var _cp1 = CGPoint(x: topPoint.x, y: topPoint.y + dy)
    var _ep  = CGPoint(x: bounds.minX, y: bounds.maxY)
    var _cp2 = CGPoint(x: _ep.x + dx, y: _ep.y)
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    _cp1 = _ep
    _ep  = CGPoint(x: bounds.maxX, y: bounds.maxY)
    _cp2 = _ep
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    _cp1 = CGPoint(x: _ep.x - dx, y: _ep.y)
    _ep  = topPoint
    _cp2 = CGPoint(x: topPoint.x, y: topPoint.y + dy)
    
    curve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    return curve
  }
  
  func getLeftCurve() -> Curve {
    let dx = baseWidth * 0.25
    let dy = baseWidth
    
    var lCurve = Curve(startingPoint: topPoint)
    
    var _cp1 = CGPoint(x: topPoint.x, y: topPoint.y + dy)
    var _ep  = CGPoint(x: bounds.minX, y: bounds.maxY)
    var _cp2 = CGPoint(x: _ep.x + dx, y: _ep.y)
    
    lCurve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    return lCurve
  }
  
  func getRightCurve() -> Curve {
    let dx = baseWidth * 0.25
    let dy = baseWidth
    
    var rCurve = Curve(startingPoint: topPoint)
    
    var _cp1 = CGPoint(x: topPoint.x, y: topPoint.y + dy)
    var _ep  = CGPoint(x: bounds.maxX, y: bounds.maxY)
    var _cp2 = CGPoint(x: _ep.x - dx, y: _ep.y)
    
    rCurve.addConnection(CurveConnector(ep: _ep, cp1: _cp1, cp2: _cp2))
    
    return rCurve
  }
}