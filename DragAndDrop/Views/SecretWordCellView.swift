//
//  SecretWordCellViewCollectionViewCell.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 08/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

struct CellViewColorItem {
    static let RED_LIGHT =  UIColor.hexaToUIColor(hexa:"FFCCCC")
    static let BORDEAUX =  UIColor.hexaToUIColor(hexa: "b30059")
    static let GRAY = UIColor.hexaToUIColor(hexa: "666666")
    static let LIGHT_GRAY = UIColor.hexaToUIColor(hexa: "#E9E9E9")
    static let RED_BORDEAUX = UIColor.hexaToUIColor(hexa: "990000")

}

protocol SecretWordCellViewWordSecretDelegate {
    func didTapWord(indexPath: IndexPath)
}

protocol SecretWordCellViewProtocol{
    var secretWord:String { get set }
    var numberWordIncrement: Int { get set }
    
    
    func dragBegin()
    func dragEnd()
}

class SecretWordCellView: UICollectionViewCell {
    
    private let HEIGHT_INCREMENT_VIEW: CGFloat = 25
    
    var incrementViewHeightAnchor: NSLayoutConstraint?
    
    var delegate: SecretWordCellViewWordSecretDelegate?
    var indexPath: IndexPath = IndexPath()
    
    //MARK: Accessors -SecretWordCellViewProtocol
    var secretWord: String = ""{
        didSet{
            updateSecretWord()
        }
    }
    
    var numberWordIncrement: Int = 0{
        didSet{
            updateNumber()
        }
    }
    
    //MARK: Setup Widgets
    
    let containerIncrementView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = CellViewColorItem.RED_LIGHT
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let numberWordIncrementLabel: UILabel = {
        let label = UILabel()
        label.textColor = CellViewColorItem.BORDEAUX
        label.font = FontApp.fontForInputText(withSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secretWordLabel: UILabel = {
        let secretTxt = UILabel()
        secretTxt.textColor = CellViewColorItem.GRAY
        secretTxt.font = FontApp.fontForInputText(withSize: 16)
        secretTxt.isUserInteractionEnabled = true
        secretTxt.translatesAutoresizingMaskIntoConstraints = false
        return secretTxt
    }()
    
    @objc func didTapedLabel(_ sender: Any?){
        if let delegate = self.delegate{
            delegate.didTapWord(indexPath: self.indexPath)
        }
    }
    
    var dotimageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "dot"))
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
 
    //MARK: Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCellView()
        makeBorder()
        makeShadow()
    
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.secretWordLabel.text = nil
        
        self.toogleRedBorder(show: false)
        self.backgroundColor = .white
        self.secretWordLabel.textColor = CellViewColorItem.GRAY
        
        self.dotimageView.image = UIImage(named: "dot")
        self.resetIncrementView()
    }
    
    private func showIncrementView(_ show: Bool){
        
        if show{
            self.incrementViewHeightAnchor?.constant = HEIGHT_INCREMENT_VIEW
        }else{
            self.incrementViewHeightAnchor?.constant = 0
        }
        
        UIView.animate(withDuration: 0.1, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .showHideTransitionViews,animations: {
            self.layoutIfNeeded()
        })
    }
    
    private func resetIncrementView(){
        self.incrementViewHeightAnchor?.constant = HEIGHT_INCREMENT_VIEW
        self.numberWordIncrementLabel.text = nil
        self.numberWordIncrementLabel.textColor = CellViewColorItem.BORDEAUX
        self.containerIncrementView.backgroundColor = CellViewColorItem.RED_LIGHT
    }
    
    private func updateSecretWord(){
        self.secretWordLabel.text = secretWord
    }
    
    private func updateNumber(){
        self.numberWordIncrementLabel.text = String(format:"%02d.",numberWordIncrement)
    }
    
    private func setupCellView(){
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        self.backgroundColor = UIColor.white
        // setup View Increment
        addViewForIncrementWord()
        // setup Label Secret Word
        addSecretWordLabel()
        // Setup Dot ImageView
        addDotImageView()
    }
    
    func setupForNewWord(){
        
        toogleRedBorder(show: true, CellViewColorItem.BORDEAUX)
        
        self.numberWordIncrementLabel.textColor = CellViewColorItem.GRAY
        self.containerIncrementView.backgroundColor = CellViewColorItem.LIGHT_GRAY
        
        self.incrementViewHeightAnchor?.isActive = true
        self.incrementViewHeightAnchor?.constant = HEIGHT_INCREMENT_VIEW * 2
        
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseIn,animations: {
            
            self.layoutIfNeeded()
            
        })
        
      }
    
    private func addViewForIncrementWord(){
        
        addSubview(self.containerIncrementView)
        
        // Add ContainerView and UILabel Increment Word
        self.containerIncrementView.addSubview(self.numberWordIncrementLabel)
        
        // Setup Constraint For View Container And UILabel Increment Word
        
        self.incrementViewHeightAnchor = self.containerIncrementView.heightAnchor.constraint(equalToConstant: HEIGHT_INCREMENT_VIEW)
        self.incrementViewHeightAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            self.containerIncrementView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            self.containerIncrementView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            self.containerIncrementView.widthAnchor.constraint(equalToConstant: 23),
            self.numberWordIncrementLabel.leftAnchor.constraint(equalTo: containerIncrementView.leftAnchor, constant: 2),
            self.numberWordIncrementLabel.rightAnchor.constraint(equalTo: containerIncrementView.rightAnchor, constant: 0),
            self.numberWordIncrementLabel.bottomAnchor.constraint(equalTo: containerIncrementView.bottomAnchor, constant: -2)
        ])
        
    }
    
    private func addSecretWordLabel(){
        
        addSubview(self.secretWordLabel)
        
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapedLabel(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.secretWordLabel.addGestureRecognizer(tapGesture)
        
        
        self.secretWordLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        self.secretWordLabel.leftAnchor.constraint(equalTo: self.numberWordIncrementLabel.leftAnchor, constant: 10).isActive = true
        self.secretWordLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 5).isActive = true
    }
    
    private func addDotImageView(){
        addSubview(self.dotimageView)
        
        self.dotimageView.centerYAnchor.constraint(equalTo: self.secretWordLabel.centerYAnchor, constant: 0).isActive = true
        
        self.dotimageView.rightAnchor.constraint(equalTo: self.secretWordLabel.leftAnchor, constant: 0).isActive = true
        
        self.dotimageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        self.dotimageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}

//MARK: SecretWordCellViewProtocol
extension SecretWordCellView: SecretWordCellViewProtocol{
    
    func dragBegin(){
        self.toogleRedBorder(show: true,CellViewColorItem.BORDEAUX)
        self.backgroundColor = CellViewColorItem.RED_BORDEAUX
        self.secretWordLabel.textColor = .white
        self.dotimageView.image = UIImage(named: "dot_white")
        // add Anchor Height
        self.frame.size = CGSize(width: self.frame.width, height: self.frame.size.height/2)
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y+8)
        UIView.animate(withDuration: 0.2) {
            self.setNeedsLayout()
        }
        self.showIncrementView(false)
    }
    
    func dragEnd(){
        self.toogleRedBorder(show: false)
        self.backgroundColor = .white
        self.secretWordLabel.textColor = CellViewColorItem.GRAY
        self.dotimageView.image = UIImage(named: "dot")
        self.secretWordLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        self.showIncrementView(true)
    }
    
}

extension SecretWordCellView: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self), let uiLabel = gestureRecognizer.view as? UILabel, uiLabel == self.secretWordLabel{
            return true
        }
        return false
    }
}
