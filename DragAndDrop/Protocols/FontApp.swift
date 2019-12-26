//
//  FontApp.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 19/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func fontForInputText(fontName: String = "HelveticaNeue-Medium", withSize: CGFloat) -> UIFont{
        return UIFont(name: fontName, size:withSize) ?? UIFont.systemFont(ofSize: withSize)
    }
}
