//
//  SplashColor.swift
//  SplashDash
//
//  Created by Sabrina Ip on 3/1/17.
//  Copyright © 2017 SHT. All rights reserved.
//

import UIKit

extension UIColor {
    // Adopted from: http://crunchybagel.com/working-with-hex-colors-in-swift-3/
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: alpha
        )
    }
}

struct SplashColor {
    static let colorsDict = [
        "purple" : "673AB7",
        "teal" : "00BCD4",
        "green" : "4CAF50",
        "orange" : "FF5722"
    ]
    
    static func primaryColor(alpha: CGFloat = 1.0) -> UIColor {
        let defaults = UserDefaults()
        if let teamColor = defaults.string(forKey: "teamName") {
            return UIColor(hex: self.colorsDict[teamColor]!, alpha: alpha)
        }
        return UIColor.black
    }
    static func lightPrimaryColor(alpha: CGFloat = 1.0) -> UIColor {
        return .white
    }
    static func teamColor(for team: String, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hex: self.colorsDict[team]!, alpha: alpha)
    }
    static func teamColorArray(alpha: CGFloat = 1.0) -> [UIColor] {
        return [UIColor(hex: self.colorsDict["green"]!, alpha: alpha),
                UIColor(hex: self.colorsDict["teal"]!, alpha: alpha),
                UIColor(hex: self.colorsDict["orange"]!, alpha: alpha),
                UIColor(hex: self.colorsDict["purple"]!, alpha: alpha)]
    }
}
