//
//  SetGameController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/27/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetGameController: UICollectionViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView!.allowsMultipleSelection = true
  }
}