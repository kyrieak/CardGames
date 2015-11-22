//
//  InstructionsViewController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/29/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class InstructionsViewController: UIViewController {
  let theme: Theme = appGlobals.styleGuide.theme
  let sg: SGStyleGuide = appGlobals.styleGuide
  
  
  override func viewWillLayoutSubviews() {
    applyStyleToViews()
  }
  
  
  
  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.Portrait
  }
  
  
  
  func applyStyleToViews() {
    let scrollView = self.view.subviews.first!
    
    view.backgroundColor       = theme.bgColor2
    scrollView.backgroundColor = theme.bgLight
    scrollView.layer.borderColor = view.backgroundColor!.getShade(-0.1).CGColor
    scrollView.layer.borderWidth = 1

    
    for sv in scrollView.subviews {
      let text = sv as? UILabel
      
      if (text != nil) {
        text!.textColor = theme.fontColor3
      }
    }

    let doneBtn = view.viewWithTag(20)!
    
    sg.applyLayerStyle(.Status, views: [doneBtn])
  }
  
  
  @IBAction func respondToHorizontalSwipe(sender: UISwipeGestureRecognizer) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  @IBAction func doneAction(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
//
//  @IBAction func doneAction(sender: UIButton) {
//    self.dismissViewControllerAnimated(true, completion: nil)
//  }
}