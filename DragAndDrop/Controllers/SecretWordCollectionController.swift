//
//  ViewController.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 07/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit


class SecretWordCollectionController: UIViewController {
    
    var customViewKeyboardInput: CustomInputView?
    
    private let reuseIdentifier = "SecretWordCellView"
    
    private var serviceSecretWord = ServiceSecretWord()
    
    private var indexPathForEditCell: IndexPath?
    
    lazy private var collectionView: UICollectionView = {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.hexaToUIColor(hexa: "#fafafa")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundView?.isOpaque = true
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    lazy private var blurView:UIView = {
       
        let blur = UIView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.backgroundColor = self.collectionView.backgroundColor?.withAlphaComponent(0.7)
        blur.isOpaque = false
        blur.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBlureView(_:)))
        blur.addGestureRecognizer(tapGesture)
        return blur
    }()
    
    @objc private func tapBlureView(_ sender: Any?){
       valideEdit()
    }
    
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
        self.collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //add Delegate to SecretWordService
        self.serviceSecretWord.delegate = self
    
        if self.serviceSecretWord.isMaxWordAchieved(){
            addDragDropDelegate()
        }
        
        //MARK: setupKeyboardInputView
        setupKeyboardInputView()
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customViewKeyboardInput?.txtField.becomeFirstResponder()
    }
    
    private func reloadCollectionViewSection() {
        //TODO Refacto Section 0 because min Section will be 1 Section
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
        }
        
    }
    
    private func reloadDataWithAnimation(){
        UIView.transition(with: self.collectionView, duration: 0.6, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    
    @objc private func toogleBlureBelowView(show: Bool, at indexPath: IndexPath?){
        // Add Blur
        //Frame
        if !show {
            self.blurView.removeFromSuperview()
            return
        }

        self.view.addSubview(self.blurView)
        
        NSLayoutConstraint.activate([
        self.blurView.leftAnchor.constraint(equalTo: self.view.safeAreaLeftAnchor),
            self.blurView.rightAnchor.constraint(equalTo: self.view.safeAreaRightAnchor),
            self.blurView.topAnchor.constraint(equalTo: self.view.safeAreaTopAnchor),
            self.blurView.bottomAnchor.constraint(equalTo: self.view.safeAreaBottomAnchor)
        ])
        
        self.collectionView.addSubview(self.blurView)
        self.view.bringSubviewToFront(self.collectionView)
        self.blurView.layer.zPosition = -1
        //self.collectionView.layer.zPosition = 1
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
        
        if !self.serviceSecretWord.isWordPlaceHorlder(at: indexPath.item){
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
    
    private func addDragDropDelegate(){
         //set delegate
         self.collectionView.dragInteractionEnabled = true
         self.collectionView.dragDelegate = self
         self.collectionView.dropDelegate = self
     }
     
     private func resetDragDropDelegate(){
         self.collectionView.dragInteractionEnabled = false
         self.collectionView.dragDelegate = nil
         self.collectionView.dropDelegate = nil
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
            secretCell.indexPath = indexPath
            secretCell.numberWordIncrement = indexPath.item + 1
            
            if serviceSecretWord.isWordPlaceHorlder(at: indexPath.item){
                secretCell.setupCellStateOpen()
            }
            
            if indexPathForEditCell?.item == indexPath.item{
                secretCell.bringViewToPosition(position: .above)
                secretCell.setupCellStateOpen()
            }else{
                secretCell.bringViewToPosition(position: .below)
            }
            return secretCell
        }
        
        return cell
    }
    
}

// MARK: extension UICollectionViewDelegateFlowLayout
extension SecretWordCollectionController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if self.indexPathForEditCell?.item == indexPath.item || self.serviceSecretWord.isWordPlaceHorlder(at: indexPath.item){
            
            return CGSize(width: self.view.bounds.size.width/3 - 20, height: 120)
        }
        
        return CGSize(width: self.view.bounds.size.width/3 - 20, height: 80)
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
    
        self.customViewKeyboardInput?.isEditing = true
        self.customViewKeyboardInput?.txtField.text = self.serviceSecretWord.words[indexPath.item]
        self.indexPathForEditCell = indexPath
        self.collectionView.reloadItems(at: [indexPath])
        self.toogleBlureBelowView(show: true, at: indexPath)
        
        self.customViewKeyboardInput?.showRestoreButton(show: false)
        self.customViewKeyboardInput?.txtField.becomeFirstResponder()
        resetDragDropDelegate()
    }
}

//MARK: Add InputView For KeyBoard
extension SecretWordCollectionController{
    
    private func setupKeyboardInputView(){
        // Acd setup CustomView to The inputAccessoryView to TextFiled
        if customViewKeyboardInput == nil{
            customViewKeyboardInput = CustomInputView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        }
        
        customViewKeyboardInput?.didClick = { word in
            self.serviceSecretWord.addNewWord(word)
            self.reloadCollectionViewSection()
        }
        
        customViewKeyboardInput?.didConfirmEditing = { word in
            if let indexPath = self.indexPathForEditCell{
                self.toogleBlureBelowView(show: false, at: indexPath)
                self.serviceSecretWord.editWord(index: indexPath.item, word: word)
                self.customViewKeyboardInput?.isEditing = false
                self.customViewKeyboardInput?.resetTextField()
                
                self.indexPathForEditCell = nil
                self.collectionView.reloadItems(at: [indexPath])
                self.addDragDropDelegate()
            }
        }
        
        customViewKeyboardInput?.didClickRestore = {
            self.serviceSecretWord.resetWords()
            self.reloadDataWithAnimation()
            self.customViewKeyboardInput?.showRestoreButton(show: false)
            self.customViewKeyboardInput?.txtField.becomeFirstResponder()
        }
    }
    
    private func valideEdit(){
        if let indexPath = self.indexPathForEditCell{
            self.toogleBlureBelowView(show: false, at: indexPath)
            self.customViewKeyboardInput?.isEditing = false
            self.indexPathForEditCell = nil
            self.collectionView.reloadItems(at: [indexPath])
            self.addDragDropDelegate()
            
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return self.customViewKeyboardInput
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
     
    
}

extension SecretWordCollectionController: ServiceSecretWordDelegate{
    func maxWordsAuthorized() {
        self.customViewKeyboardInput?.showRestoreButton(show: true)
        self.customViewKeyboardInput?.txtField.resignFirstResponder()
    }
    
    func canWriteNewWord() {
        self.customViewKeyboardInput?.showRestoreButton(show: false)
    }
}
