//
//  ViewController.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 07/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit


class SecretWordCollectionController: UIViewController {
    
    var txtField: UITextField? = nil
    
    private let reuseIdentifier = "SecretWordCellView"
    
    private var serviceSecretWord = ServiceSecretWord()
    
    lazy private var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.hexaToUIColor(hexa: "#fafafa")
        collectionView.backgroundView?.isOpaque = false
        
        return collectionView
    }()
    
    convenience init() {
        self.init(nibName: nil, bundle:nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Add CollectionView
        self.view.addSubview(self.collectionView)
        
        self.collectionView.dragInteractionEnabled = true
        self.collectionView.register(SecretWordCellView.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Add Constraint
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor,constant: 0).isActive = true
        self.collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor,constant: 0).isActive = true
        
        
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        addDragDelegate()
        
        //add Delegate to SecretWordService
        self.serviceSecretWord.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtField = simulateUITextField()
        if let txt = self.txtField{
            self.view.addSubview(txt)
            txt.becomeFirstResponder()
        }
    }
    
    private func addDragDelegate(){
        //set delegate
        self.collectionView.dragInteractionEnabled = true
        self.collectionView.dragDelegate = self
        self.collectionView.dropDelegate = self
    }
    
    private func resetDragDelegate(){
        //set delegate
        self.collectionView.dragInteractionEnabled = false
        self.collectionView.dragDelegate = nil
        self.collectionView.dropDelegate = nil
    }
    
    private func reloadCollectionViewSection() {
        //TODO Refacto Section 0 because min Section will be 1 Section
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
        }
        
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
                    
                    serviceSecretWord.words.remove(at: sourceIndexPath.item)
                    if let localObject = item.dragItem.localObject{
                        serviceSecretWord.words.insert(localObject as! String, at: destinationIndexPath.item)
                    }
                    
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                    
                }){ (finished) in
                    

                }
                
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                
                self.reloadCollectionViewSection()

            }
            
                
        }
    
    }
    
}


// MARK: extension UICollectionViewDropDelegate
extension SecretWordCollectionController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: ["iden"])
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal{
        
        if session.localDragSession != nil {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator){
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        switch coordinator.proposal.operation {
        case .move:
            
            self.reorder(collectionView: collectionView, destinationIndexPath, coordinator)
            
        default: return
            
        }
        
    }
    
}

// MARK: extension UICollectionViewDragDelegate
extension SecretWordCollectionController: UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        self.reloadCollectionViewSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]{
        
        if !self.serviceSecretWord.isWordPlaceHorlder(at: indexPath.item), serviceSecretWord.isMaxWordAchieved(){
            if !session.hasItemsConforming(toTypeIdentifiers: ["iden"]){
              
                if let cell = collectionView.cellForItem(at: indexPath) as? SecretWordCellView{
                   cell.dragBegin()
               }
                
                let item = self.serviceSecretWord.words[indexPath.row]
                let itemProvider = NSItemProvider(item: item as NSSecureCoding, typeIdentifier: "iden")
                let dragItem = UIDragItem(itemProvider: itemProvider)
                dragItem.localObject = item
                
                return [dragItem]
            }
        }
        
        return []
        
    }
    
}


// MARK: extension UICollectionViewDataSource
extension SecretWordCollectionController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceSecretWord.words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let item = serviceSecretWord.words[indexPath.item]
        
        // Configure the cell
        if let secretCell = cell as? SecretWordCellView {
            secretCell.indexPath = indexPath
            secretCell.delegate = self
            secretCell.secretWord = item
            secretCell.numberWordIncrement = indexPath.item + 1
            if serviceSecretWord.isWordPlaceHorlder(at: indexPath.item) {
                secretCell.setupCellForNewWord()
            }
            
            return secretCell
        }
        
        return cell
    }
    
}

// MARK: extension UICollectionViewDelegateFlowLayout
extension SecretWordCollectionController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if self.serviceSecretWord.isWordPlaceHorlder(at: indexPath.item){
            return CGSize(width: self.view.bounds.size.width/3 - 20, height: 120)
        }
        
        return CGSize(width: self.view.bounds.size.width/3 - 20, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
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
        
        if let txtField = txtField{
            return txtField
        }
        
        let txtField = UITextField()
        txtField.inputAccessoryView = keyboardInputView()
        
        return txtField
        
    }
    
    private func keyboardInputView() -> UIView{
        // Acd setup CustomView to The inputAccessoryView to TextFiled
        let customView = CustomInputView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        customView.didClick = { txt in
            self.serviceSecretWord.addNewWord(txt)
            self.reloadCollectionViewSection()
        }
        return customView
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
}

extension SecretWordCollectionController: ServiceSecretWordDelegate{
    func maxWordsAuthorized() {
        print("maxWordsAuthorized")
    }
    
    func canWriteNewWord() {
        print("canWriteNewWord")
    }
}
