//
//  SecretWordCellViewCollectionViewCell.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 08/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

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
    
    var delegate: SecretWordCellViewWordSecretDelegate?
    var indexPath: IndexPath = IndexPath()
    
    //Constraint
    var incrementViewHeight: NSLayoutConstraint?
    
    var boottomSecretLabelConstraint: NSLayoutConstraint?
    
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
        self.secretWordLabel.textColor = ColorItemApp.GRAY
        
        self.dotimageView.tintColor = .gray
        
        self.incrementViewHeight?.constant = 25
        
        self.resetIncrementView()
    }
    
    //MARK: Setup Widgets
    
    let containerIncrementView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = ColorItemApp.RED_LIGHT
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let numberWordIncrementLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorItemApp.BORDEAUX
        label.font = UIFont.fontForInputText(withSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secretWordLabel: UILabel = {
        let secretTxt = UILabel()
        secretTxt.textColor = ColorItemApp.GRAY
        secretTxt.font = UIFont.fontForInputText(withSize: 16)
        secretTxt.isUserInteractionEnabled = true
        secretTxt.translatesAutoresizingMaskIntoConstraints = false
        return secretTxt
    }()
    
    var dotimageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "drag")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .gray
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
 
    
    private func showIncrementView(_ show: Bool){
        self.containerIncrementView.isHidden = !show
        UIView.animate(withDuration: 0.1, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .showHideTransitionViews,animations: {
            self.layoutIfNeeded()
        })
    }
    
    private func resetIncrementView(){
        self.numberWordIncrementLabel.text = nil
        self.numberWordIncrementLabel.textColor = ColorItemApp.BORDEAUX
        self.containerIncrementView.backgroundColor = ColorItemApp.RED_LIGHT
        self.containerIncrementView.isHidden = false
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
    
    func setupCellForNewWord(){
        setupCellStateOpen()
    }
    
    func setupCellForEditWord(){
        setupCellStateOpen()
    }
    
    func setupCellStateOpen(){
        toogleRedBorder(show: true, ColorItemApp.BORDEAUX)
        self.numberWordIncrementLabel.textColor = ColorItemApp.GRAY
        self.containerIncrementView.backgroundColor = ColorItemApp.LIGHT_GRAY
        self.incrementViewHeight?.constant = 45
        
       UIView.animate(withDuration: 0.5) {
    
        self.containerIncrementView.layoutIfNeeded()
        }
        
      }
    
    private func addViewForIncrementWord(){
        
        addSubview(self.containerIncrementView)
        
        // Add ContainerView and UILabel Increment Word
        self.containerIncrementView.addSubview(self.numberWordIncrementLabel)
        
        // Setup Constraint For View Container And UILabel Increment Word
        
        self.incrementViewHeight = self.containerIncrementView.heightAnchor.constraint(equalToConstant: 25)
        self.incrementViewHeight?.isActive = true
        
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
        self.addGestureRecognizer(tapGesture)
        
        self.secretWordLabel.leftAnchor.constraint(equalTo: self.numberWordIncrementLabel.leftAnchor, constant: 10).isActive = true
        self.secretWordLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 5).isActive = true
        
        self.boottomSecretLabelConstraint = self.secretWordLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        
        self.boottomSecretLabelConstraint?.isActive = true
    }
    
    @objc private func didTapedLabel(_ sender: Any?){
        if let delegate = self.delegate{
            delegate.didTapWord(indexPath: self.indexPath)
        }
      }
    
    private func addDotImageView(){
        addSubview(self.dotimageView)
        
        self.dotimageView.centerYAnchor.constraint(equalTo: self.secretWordLabel.centerYAnchor, constant: 0).isActive = true
        
        self.dotimageView.rightAnchor.constraint(equalTo: self.secretWordLabel.leftAnchor, constant: -5).isActive = true
    
        self.dotimageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.dotimageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    func bringViewToPosition(position: CellPosition){
        self.layer.zPosition = position.getValue()
    }
}

//MARK: SecretWordCellViewProtocol
extension SecretWordCellView: SecretWordCellViewProtocol{
    
    func dragBegin(){
        
        self.toogleRedBorder(show: true,ColorItemApp.BORDEAUX)
        
        self.backgroundColor = ColorItemApp.RED_BORDEAUX
        self.secretWordLabel.textColor = .white
        self.dotimageView.tintColor = .white
       
        // add Height
        let marge:CGFloat = 10
        let height = self.frame.size.height/1.6
        
        self.frame.size = CGSize(width: self.frame.width, height: height)
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + height/4)
        
        self.boottomSecretLabelConstraint?.constant = (-height/2) + marge
        
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .allowUserInteraction,animations: {
            self.layoutIfNeeded()
            self.setNeedsLayout()
        })
        
        self.showIncrementView(false)
    }
    
    func dragEnd(){
        
        self.toogleRedBorder(show: false)
        
        self.backgroundColor = .white
        self.secretWordLabel.textColor = ColorItemApp.GRAY
        self.dotimageView.tintColor = .none
        
        self.secretWordLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        
        self.showIncrementView(true)
        
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .allowUserInteraction,animations: {
                   self.layoutIfNeeded()
               })
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

//MARK: Cell Position
enum CellPosition {
    case above
    case below
    case none
}

extension CellPosition{
    func getValue() -> CGFloat{
        switch self {
        case .above:
            return 100
        case .below:
            return -1
        case .none:
            return 0
        }
    }
}
