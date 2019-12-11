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
    @IBOutlet var imageView: UIImageView!
    
    var secretWord: String = ""{
        didSet{
            updateSecretWord()
        }
    }

    var imageName: String = ""{
        didSet{
            updateImage()
        }
    }
    
    private func updateSecretWord(){
        self.secretWordLabel.text = secretWord
    }
    
    
    private func updateImage(){
        self.imageView.image = UIImage(named: imageName)
    }
}
