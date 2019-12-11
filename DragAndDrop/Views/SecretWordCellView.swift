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

    var numberWordIncrement: String = ""{
        didSet{
            updateNumber()
        }
    }
    
    private func updateSecretWord(){
        self.secretWordLabel.text = secretWord
    }
    
    
    private func updateNumber(){
        self.numberWordIncrementLabel.text = numberWordIncrement
    }
}
