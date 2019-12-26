//
//  CustomView.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 22/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

class CustomInputView: UIView{
    lazy var txtField: UITextField = UITextField()
    lazy var buttonNext: UIButton = UIButton()
    
    var didClick: ((_ text: String)-> Void)?
        
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addButtonNext()
        // Add TextField Secret Text
        addTextField()
        
        
    }
    private func addButtonNext(){
        buttonNext.setTitleColor(.white, for: .normal)
        buttonNext.titleLabel?.font = UIFont.fontForInputText(withSize: 18)
        buttonNext.backgroundColor = .black
        buttonNext.setTitle("Next", for: .normal)
        buttonNext.roundCorners(corners: [Corners.right], radius: 6)
        
        // Add TextField to CustomView
        self.addSubview(buttonNext)
        
        //Add Constraints Button Next
        buttonNext.translatesAutoresizingMaskIntoConstraints = false
        buttonNext.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonNext.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15).isActive = true
        buttonNext.widthAnchor.constraint(equalToConstant: 100).isActive = true
        buttonNext.heightAnchor.constraint(equalTo: self.heightAnchor,constant: -20).isActive = true
        // Add Button Next
        buttonNext.addTarget(self, action: #selector(didClickNextButton(_:)), for: .touchUpInside)
    }
   
    //MARK: didClick to Next Button
    @objc private func didClickNextButton(_ sender: Any?){
        if let txt = self.txtField.text, !txt.isEmpty, !txt.trimmingCharacters(in: .whitespaces).isEmpty{
            self.didClick?(txt)
            self.txtField.text = ""
        }
    }
    
    private func addTextField(){
        txtField.roundCorners(corners: [Corners.left], radius: 6)
        txtField.textColor = .black
        txtField.returnKeyType = .continue
        txtField.font = UIFont.fontForInputText(withSize: 18)
        txtField.backgroundColor = .white
        txtField.makeShadow()
        txtField.returnKeyType = .done
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 12 , height: 5))
        txtField.leftView = paddingView
        txtField.leftViewMode = .always
        
        // Add TextField to CustomView
        addSubview(txtField)
        
        //Add Constraints  TextField Secret Text
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.centerYAnchor.constraint(equalTo: buttonNext.centerYAnchor).isActive = true
        txtField.rightAnchor.constraint(equalTo: buttonNext.leftAnchor).isActive = true
        txtField.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15).isActive = true
        txtField.trailingAnchor.constraint(equalTo: buttonNext.leadingAnchor).isActive = true
        txtField.heightAnchor.constraint(equalTo: buttonNext.heightAnchor).isActive = true
         txtField.placeholder = "Input..."
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomInputView: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
   
}
