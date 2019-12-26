//
//  ServiceSecretWord.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 22/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import Foundation


protocol ServiceSecretWordDelegate{
    func maxWordsAuthorized()
    func canWriteNewWord()
}

class ServiceSecretWord{
    var maxWordAuthorized :Int {
        get {
            return 12
        }
    }
    var delegate:ServiceSecretWordDelegate?
    
    init(delegate:ServiceSecretWordDelegate? = nil) {
        self.delegate = delegate
    }
    
    //var words = ["🍎","💨","🥑","🍅","🥓","🍮","🏀","🥋","🏋🏻‍♀️","🏂"]
    var words = ["_"]
    
    func isNewWord(at index: Int) -> Bool{
        if self.words.last == "_" {
             return true
         }
         return false
    }
    
    func addNewWord(_ newWord: String){
        if let index = self.words.firstIndex(of: "_"){
            self.words.remove(at: index)
            self.words.insert(newWord, at: index)
            if self.words.count < self.maxWordAuthorized {
                self.words.append("_")
                self.delegate?.canWriteNewWord()
            }else{
                self.delegate?.maxWordsAuthorized()
            }
            
        }else{
            self.delegate?.maxWordsAuthorized()
        }
    }
    
}
