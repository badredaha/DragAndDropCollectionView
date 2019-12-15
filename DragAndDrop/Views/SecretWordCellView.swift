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
    static let BORDEAUX =  UIColor.hexaToUIColor(hexa: "660033")
    static let GRAY = UIColor.hexaToUIColor(hexa: "666666")
    static let RED_BORDEAUX = UIColor.hexaToUIColor(hexa: "990000")
}
protocol SecretWordCellViewProtocol{
    var secretWord:String { get set }
    var numberWordIncrement: Int { get set }
    
    func dragBegin()
    func dragEnd()
}

class SecretWordCellView: UICollectionViewCell, SecretWordCellViewProtocol {
    
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
        return containerView
    }()
    
    
    let numberWordIncrementLabel: UILabel = {
        let label = UILabel()
        label.textColor = CellViewColorItem.BORDEAUX
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secretWordLabel: UILabel = {
        let label = UILabel()
        label.textColor = CellViewColorItem.GRAY
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        toogleRedBorder(show: false)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.secretWordLabel.text = nil
        self.numberWordIncrementLabel.text = nil
        self.toogleRedBorder(show: false)
        self.backgroundColor = .white
        self.secretWordLabel.textColor = CellViewColorItem.GRAY
        self.containerIncrementView.isHidden = false
    }
    
    private func updateSecretWord(){
        self.secretWordLabel.text = secretWord
    }
    
    private func updateNumber(){
        self.numberWordIncrementLabel.text = String(format:"%02d.",numberWordIncrement)
    }
    
    func dragBegin(){
        self.toogleRedBorder(show: true)
        self.backgroundColor = CellViewColorItem.RED_BORDEAUX
        self.secretWordLabel.textColor = .white
        self.dotimageView.image = UIImage(named: "dot_white")
        
        self.frame.size = CGSize(width: self.frame.width, height: self.frame.size.height/2-5)
        self.containerIncrementView.isHidden = true
        self.setNeedsLayout()
    }
    
    func dragEnd(){
        self.toogleRedBorder(show: false)
        self.backgroundColor = .white
        self.secretWordLabel.textColor = CellViewColorItem.GRAY
        self.dotimageView.image = UIImage(named: "dot")
        self.frame.size = CGSize(width: self.frame.width, height: self.frame.size.height)
        self.containerIncrementView.isHidden = false
    }
    
}

//MARK: Setup UI
extension SecretWordCellView{
    
    private func makeBorder(){
        let layer = self.layer
        layer.cornerRadius = 6
    }
    
    private func toogleRedBorder(show: Bool){
        let layer = self.layer
        layer.borderWidth = 1
        if show{
            //TDOD: Refacto Getting Color Grena
            if let colorGrena = self.numberWordIncrementLabel.textColor {
                layer.borderColor = colorGrena.cgColor
            }
        }else{
            layer.borderColor = UIColor.lightGray.cgColor
            layer.borderWidth = 0.1
        }
        
    }
    
    private func makeShadow(){
        
        let layer = self.layer
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        
    }
    
    private func setupCellView(){
        self.backgroundColor = UIColor.white
        // setup View Increment
        addViewForIncrementWord()
        // setup Label Secret Word
        addUILabelForSecretWord()
        // Setup Dot ImageView
        addDotImageView()
    }
    
    private func addViewForIncrementWord(){
        
        addSubview(self.containerIncrementView)

        // Add ContainerView and UILabel Increment Word
        self.containerIncrementView.addSubview(self.numberWordIncrementLabel)
        
        // Setup Constraint For View Container And UILabel Increment Word
        
        self.containerIncrementView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerIncrementView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            self.containerIncrementView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            self.containerIncrementView.widthAnchor.constraint(equalToConstant: 23),
            self.containerIncrementView.heightAnchor.constraint(equalToConstant: 25),
            
            self.numberWordIncrementLabel.leftAnchor.constraint(equalTo: containerIncrementView.leftAnchor, constant: 2),
            self.numberWordIncrementLabel.rightAnchor.constraint(equalTo: containerIncrementView.rightAnchor, constant: 0),
            self.numberWordIncrementLabel.bottomAnchor.constraint(equalTo: containerIncrementView.bottomAnchor, constant: -2)
        ])
            
    }
    
    private func addUILabelForSecretWord(){
        
        addSubview(self.secretWordLabel)
        
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

