import Foundation
import UIKit


class MemoryGameController: UICollectionViewController, UICollectionViewDelegate {  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView!.allowsMultipleSelection = true
  }

  @IBAction func startNewRound(sender: UIButton) {
    var game = getGame()
    
    game.startNewRound(game.numberOfCardPositions())
    collectionView!.reloadData()
    getDelegate().selectIdxPaths = []
  }

  private func getGame() -> MemoryGame {
    return (collectionView!.dataSource! as! MemoryGameDataSource).game
  }

  private func getDelegate() -> MemoryGameDelegate {
    return (collectionView!.delegate! as! MemoryGameDelegate)
  }
  
  func getGameHistory() -> [String] {
    return getDelegate().getGameStatuses()
  }
  
  func clearOldHistory() {
    getDelegate().clearOldStatuses()
  }
}