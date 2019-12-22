//
//  View.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 20/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

enum Corners{
    case all,left,right,leftTop, leftBottom, rightTop, rightBottom
}

extension Corners{
    
    func getCornerMask() -> CACornerMask{
        switch self {
        case .leftBottom:
            return [CACornerMask.layerMinXMinYCorner]
        case .leftTop:
            return [CACornerMask.layerMinXMaxYCorner]
        case .rightBottom:
            return [CACornerMask.layerMaxXMinYCorner]
        case .rightTop:
            return [CACornerMask.layerMaxXMaxYCorner]
        case .left:
            return [CACornerMask.layerMinXMinYCorner,CACornerMask.layerMinXMaxYCorner]
        case .right:
            return [CACornerMask.layerMaxXMinYCorner,CACornerMask.layerMaxXMaxYCorner]
        case .all:
            return [CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMinXMinYCorner,CACornerMask.layerMaxXMaxYCorner, CACornerMask.layerMaxXMinYCorner]
        }
    }
}

extension UIView {
    func roundCorners(corners: [Corners] = [Corners.all] , radius: CGFloat = 6) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
        corners.forEach { (corner) in
            self.layer.maskedCorners = corner.getCornerMask()
        }
    }
    
    func makeBorder(){
        self.roundCorners()
    }
    
    func toogleRedBorder(show: Bool, _ color: UIColor
    = .clear){
        let layer = self.layer
        layer.borderWidth = 1
        if show{
            //TDOD: Refacto Getting Color Grena
            layer.borderColor = color.cgColor
        }else{
            layer.borderColor = UIColor.lightGray.cgColor
            layer.borderWidth = 0.1
        }
        
    }
    
    func makeShadow(){
        let layer = self.layer
        self.layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
    }
}
