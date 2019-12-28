//
//  CustomView.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 22/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

class CustomInputView: UIView{
    
    //MARK: Closure Handle click
    var didClick: ((_ text: String)-> Void)?
    var didConfirmEditing: ((_ text: String)-> Void)?
    var didClickRestore: (()-> Void)?
    
    lazy var txtField: UITextField = {
        let txtfield = UITextField()
        txtfield.roundCorners(corners: [Corners.left], radius: 6)
        txtfield.textColor = .black
        txtfield.returnKeyType = .continue
        txtfield.font = UIFont.fontForInputText(withSize: 18)
        txtfield.backgroundColor = .white
        txtfield.makeShadow()
        txtfield.returnKeyType = .done
        txtfield.placeholder = "Input..."
        return txtfield
    }()
    
    lazy var buttonNext: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.fontForInputText(withSize: 18)
        button.backgroundColor = .black
        button.setTitle("Next", for: .normal)
        button.roundCorners(corners: [Corners.right], radius: 6)
        button.addTarget(self, action: #selector(didClickNextButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var restoreButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.fontForInputText(withSize: 18)
        button.backgroundColor = ColorItemApp.RED_BORDEAUX
        button.setTitle("Restore", for: .normal)
        button.roundCorners(corners: [Corners.all], radius: 6)
        button.addTarget(self, action: #selector(restore(_:)), for: .touchUpInside)
        return button
    }()
    
    var isEditing: Bool = false{
        didSet{
            changeTitleButton()
        }
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addButtonNext()
        // Add TextField Secret Text
        addTextField()
    }
    
    private func addButtonNext(){
        
        // Add TextField to CustomView
        self.addSubview(buttonNext)
        
        //Add Constraints Button Next
        buttonNext.translatesAutoresizingMaskIntoConstraints = false
        buttonNext.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonNext.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -15).isActive = true
        buttonNext.widthAnchor.constraint(equalToConstant: 100).isActive = true
        buttonNext.heightAnchor.constraint(equalTo: self.heightAnchor,constant: -20).isActive = true
        // Add Button Next
        
    }
    
    private func changeTitleButton(){
        buttonNext.setTitle(self.isEditing ? "Edit" : "Next", for: .normal)
    }
    
    func resetTextField(){
        self.txtField.text = ""
    }
    
    //MARK: didClick to Next Button
    @objc private func didClickNextButton(_ sender: Any?){
        if let txt = self.txtField.text, !txt.isEmpty, !txt.trimmingCharacters(in: .whitespaces).isEmpty{
            if self.isEditing {
                self.didConfirmEditing?(txt)
            }else{
                self.didClick?(txt)
            }
            
            self.txtField.text = ""
        }
    }
    
    //MARK: click restoreButton
    @objc private func restore(_ sender: Any?){
        self.didClickRestore?()
    }
    
    private func addTextField(){
        
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
        
    }
    
    func showRestoreButton(show: Bool){
        
        if show {
            self.txtField.isHidden = true
            self.buttonNext.isHidden = true
            
            self.restoreButton.isHidden = false
            self.addSubview(self.restoreButton)
            //Add Constraints  TextField Secret Text
            self.restoreButton.translatesAutoresizingMaskIntoConstraints = false
            self.restoreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            self.restoreButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.restoreButton.heightAnchor.constraint(equalTo: self.heightAnchor,constant: -15).isActive = true
            self.restoreButton.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -15).isActive = true
            
        }else{
            self.restoreButton.isHidden = true
            self.txtField.isHidden = false
            self.buttonNext.isHidden = false
        }
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
