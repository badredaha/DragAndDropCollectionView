//
//  ViewController.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 07/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit


class SecretWordCollectionController: UIViewController {
        
    lazy private var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        collectionViewLayout.itemSize = CGSize(width: 110, height: 80)
        collectionViewLayout.minimumLineSpacing = 10.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.hexaToUIColor(hexa: "#fafafa")
        collectionView.backgroundView?.isOpaque = false
        
        return collectionView
    }()
    
    private let reuseIdentifier = "SecretWordCellView"
    
    private var sericeSecretWord = ServiceSecretWord()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Add CollectionView
        self.view.addSubview(self.collectionView)
        
        // Add Constraint
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor,constant: 0).isActive = true
        self.collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor,constant: 0).isActive = true
        
        
        self.collectionView.register(SecretWordCellView.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.dragInteractionEnabled = true
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.collectionView.dragDelegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.dropDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let txtField = simulateUITextField()
        self.view.addSubview(txtField)
        txtField.becomeFirstResponder()
    }
    private func reloadCollectionViewWithoutAnimation(){
        
        //TODO Refacto Section 0 because min Section will be 1 Section
        
            self.collectionView.performBatchUpdates({
            collectionView.reloadSections(IndexSet(arrayLiteral: 0))
            }, completion: nil)
    }
}

// Protocol

protocol OrderWordProtocol {
    func reorder(collectionView: UICollectionView, _ destinationIndexPath: IndexPath,_ coordinator: UICollectionViewDropCoordinator)
}

// MARK: extension OrderWordProtocol
extension SecretWordCollectionController: OrderWordProtocol{
    func reorder(collectionView: UICollectionView, _ destinationIndexPath: IndexPath,_ coordinator: UICollectionViewDropCoordinator) {
        if let item = coordinator.items.first{
            if let sourceIndexPath = item.sourceIndexPath {
                
                collectionView.performBatchUpdates({
                    sericeSecretWord.words.remove(at: sourceIndexPath.item)
                    if let localObject = item.dragItem.localObject{
                        sericeSecretWord.words.insert(localObject as! String, at: destinationIndexPath.item)
                    }
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }) { (finish) in
                    self.reloadCollectionViewWithoutAnimation()
                }
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
}


// MARK: extension UICollectionViewDropDelegate
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
            if let secretCellView = collectionView.cellForItem(at: indexPath) as? SecretWordCellView{
                secretCellView.dragEnd()
            }
            
            self.reorder(collectionView: collectionView, indexPath, coordinator)
        }
    }
    
}

// MARK: extension UICollectionViewDragDelegate
extension SecretWordCollectionController: UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]{
        
        let word = self.sericeSecretWord.words[indexPath.item]
        if word != "_", indexPath.item > 1, let secretCellView = collectionView.cellForItem(at: indexPath) as? SecretWordCellView{
            secretCellView.dragBegin()
        }
        
        let item = self.sericeSecretWord.words[indexPath.row]
        let itemProvider = NSItemProvider(item: item as NSSecureCoding, typeIdentifier: "iden")
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
}


// MARK: extension UICollectionViewDataSource
extension SecretWordCollectionController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sericeSecretWord.words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let item = sericeSecretWord.words[indexPath.item]
        
        // Configure the cell
        if let secretCell = cell as? SecretWordCellView {
            secretCell.indexPath = indexPath
            secretCell.delegate = self
            secretCell.secretWord = item
            secretCell.numberWordIncrement = indexPath.item + 1
            if sericeSecretWord.isNewWord(at: indexPath.item) {
                secretCell.toogleRedBorder(show: true, CellViewColorItem.BORDEAUX)
            }
            
            return secretCell
        }
        
        return cell
    }
    
}

// MARK: extension UICollectionViewDelegateFlowLayout
extension SecretWordCollectionController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        if self.sericeSecretWord.isNewWord(at: indexPath.item){
            return CGSize(width: 110, height: 110)
        }
        return CGSize(width: 110, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

// MARK: extension SecretWordCellViewWordSecretDelegate
extension SecretWordCollectionController: SecretWordCellViewWordSecretDelegate{
    func didTapWord(indexPath: IndexPath){
        print("didTapWord at IndexPath : \(indexPath.item)")
    }
}

//MARK: Add InputView For KeyBoard
extension SecretWordCollectionController{
    
    private func simulateUITextField() -> UITextField{
        let txtField = UITextField()
        txtField.inputAccessoryView = keyboardInputView()
        return txtField
    }
    
    private func keyboardInputView() -> UIView{
        // Acd setup CustomView to The inputAccessoryView to TextFiled
        let customView = CustomInputView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
            customView.didClick = { txt in
                self.sericeSecretWord.addNewWord(txt)
                self.reloadCollectionViewWithoutAnimation()
        }
        return customView
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
}
