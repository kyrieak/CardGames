//
//  ViewController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 12/27/14.
//  Copyright (c) 2014 Kyrie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var discardsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
}

