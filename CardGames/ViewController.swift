//
//  ViewController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 12/27/14.
//  Copyright (c) 2014 Kyrie. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
  
  @IBOutlet var discardsLabel: UILabel!
  let style = Style()

  override func viewDidLoad() {
    super.viewDidLoad()
    var pageButton = self.view.viewWithTag(1)!
    
    self.view.layer.insertSublayer(makeHeaderLayer(), below: pageButton.layer)
    self.view.layer.insertSublayer(makeFooterLayer(), below: discardsLabel.layer)
    
    style.applyShade(pageButton.layer, color: style.liteShadeColor, thickness: 1)
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//      println("sender")
//      println("\(sender)")
    
    if var vc = sender as? ViewController {
      if var dvc = segue.destinationViewController as? CardViewController {
        dvc.parentVC = vc
      }
    }
//    
//    println("segue dest")
//    println("\(segue.destinationViewController)")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func updateDiscardLabel<T: Card>(discard: Deck<T>) {
    self.discardsLabel.text = "Discards: \(discard.cards.count)"
  }
  
  private func makeHeaderLayer() -> CALayer {
    var headerLayer = CALayer()
    
    headerLayer.bounds = CGRect(origin: self.view.bounds.origin, size: CGSize(width: self.view.bounds.width, height: 115))
    headerLayer.frame.origin = self.view.frame.origin
    headerLayer.backgroundColor = style.medGreenColor
    style.applyShade(headerLayer)
    
    return headerLayer
  }
  
  private func makeFooterLayer() -> CALayer {
    var footerLayer = CALayer()
    var footerOrigin = CGPoint(x: 0, y:self.view.frame.height - 100)
    
    footerLayer.bounds = CGRect(origin: footerOrigin, size: CGSize(width: self.view.bounds.width, height: 50))
    footerLayer.frame.origin = footerOrigin
    footerLayer.backgroundColor = style.medBrownColor
    style.applyShade(footerLayer)
    
    return footerLayer
  }
}

