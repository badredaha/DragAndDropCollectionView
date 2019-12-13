//
//  SecretWordCellViewCollectionViewCell.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 08/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

class SecretWordCellView: UICollectionViewCell {
    
    @IBOutlet var secretWordLabel: UILabel!
    @IBOutlet var numberWordIncrementLabel: UILabel!
    
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
    
    override func awakeFromNib() {
        makeBorder()
    }
    
    private func updateSecretWord(){
        self.secretWordLabel.text = secretWord
    }
    
    
    private func updateNumber(){
        self.numberWordIncrementLabel.text = String(format:"%02d.",numberWordIncrement)
    }
    
    
    private func makeBorder(){
   
        let layer = self.layer
        //TDOD: Refacto Getting Color Grena
        if let colorGrena = self.numberWordIncrementLabel.textColor {
            layer.borderColor = colorGrena.cgColor
        }
        
        layer.borderWidth = 2.0
        layer.cornerRadius = 10.0
        
    }
}
