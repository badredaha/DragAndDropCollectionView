//
//  Color.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 14/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func hexaToUIColor (hexa:String) -> UIColor {
        var cString:String = hexa.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}