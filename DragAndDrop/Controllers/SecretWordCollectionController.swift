//
//  ViewController.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 07/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

class SecretWordCollectionController: UIViewController, StoryBoarded{
    
    private var items = ["🍎","💨","🥑","🍅","🥓","🍮","🏀","🥋","🏋🏻‍♀️","🏂"]
    
    static func instantiate() -> Self {
           let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
           
           let vc = storyBoard.instantiateViewController(withIdentifier: String(describing: SecretWordCollectionController.self))
           
        return vc as! Self
       }
    
    private let reuseIdentifier = "SecretWordCellView"

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "SecretWordCellView", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        self.collectionView.dragInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }

}

// Protocol

protocol OrderProtocol {
    func reorder(collectionView: UICollectionView, _ destinationIndexPath: IndexPath,_ coordinator: UICollectionViewDropCoordinator)
}

extension SecretWordCollectionController: OrderProtocol{
    func reorder(collectionView: UICollectionView, _ destinationIndexPath: IndexPath,_ coordinator: UICollectionViewDropCoordinator) {
        if let item = coordinator.items.first{
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    self.items.remove(at: sourceIndexPath.item)
                    if let localObject = item.dragItem.localObject{
                        self.items.insert(localObject as! String, at: destinationIndexPath.item)
                    }
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                    
                }, completion: nil)
                
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
}


extension SecretWordCollectionController: UICollectionViewDropDelegate {
 
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal{
        
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent:.insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator){
       
        var destinationIndexPath = coordinator.destinationIndexPath
        
        if destinationIndexPath == nil {
            let row = collectionView.numberOfItems(inSection:0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
            
        }
        
        if let indexPath = destinationIndexPath, coordinator.proposal.operation == .move {
            self.reorder(collectionView: collectionView, indexPath, coordinator)
        }
    }
    
}

extension SecretWordCollectionController: UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]{
    
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(item: item as NSSecureCoding, typeIdentifier: "iden")
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
}


// MARK: extension UICollectionViewDataSource
extension SecretWordCollectionController : UICollectionViewDataSource{
    // MARK: UICollectionViewDataSource
    
        func numberOfSections(in collectionView: UICollectionView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }


        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of items
            return items.count
       }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
       
            let item = items[indexPath.row]
            
           // Configure the cell
           if let secretCell = cell as? SecretWordCellView{
            secretCell.secretWord = item
            secretCell.imageName = item
            return secretCell
           }
       
           return cell
       }

}


// MARK: extension UICollectionViewDelegate
extension SecretWordCollectionController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("sourceIndexPath \(sourceIndexPath.row)")
        print("destinationIndexPath \(destinationIndexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

// MARK: extension UICollectionViewDelegateFlowLayout
extension SecretWordCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 184,height: 156)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

