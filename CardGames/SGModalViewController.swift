//
//  SGModalViewController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/9/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class GameSettingController: UIViewController {
  var contentViewSize: CGSize = CGSizeZero
  
  @IBAction func tapDetection(segue: UIStoryboardSegue, sender: UITapGestureRecognizer) {
    let frame = segue.sourceViewController.view.frame
    let pt = sender.locationInView(nil)
    
    if ((pt.x < frame.minX) || (pt.x > frame.maxX) ||
      (pt.y < frame.minY) || (pt.y > frame.maxY)) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
}