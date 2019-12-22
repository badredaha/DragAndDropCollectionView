//
//  ServiceSecretWord.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 22/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import Foundation

class ServiceSecretWord{
    
    var words = ["_"]
    
    func isNewWord(at index: Int) -> Bool{
         if self.words.count > index, self.words[index] == "_" {
             return true
         }
         return false
     }
    
    func addNewWord(_ newWord: String){
        if let index = self.words.firstIndex(of: "_"){
            self.words.remove(at: index)
            self.words.insert(newWord, at: index)
            self.words.append("_")
        }
    }
    
}
