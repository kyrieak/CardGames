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