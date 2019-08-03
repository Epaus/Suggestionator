//
//  UIColor.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

extension UIColor {
    // making a test comment to see it reflected in the remote repo.
    static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    static func hexToColor(hexString: String, alpha: CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(UIColor.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    static let pink: UIColor = .hexToColor(hexString: "#FA027E")
    static let backgroundPink: UIColor = .hexToColor(hexString: "#FFC9E4")
    static let backgroundBlue: UIColor = .hexToColor(hexString: "#007AFF")
    static let softGray: UIColor = .hexToColor(hexString: "#8E8E93")
    static let cellGray: UIColor = .hexToColor(hexString: "#FFFFFF")
    static let medicalCityBlue: UIColor = .hexToColor(hexString: "#0C233F")
    static let medicalCityRed: UIColor = .hexToColor(hexString: "#CF0A2C")
    static let backgroundGray: UIColor = .hexToColor(hexString: "#D8D8D6")
    static let collectionViewCellBorderGray: UIColor = .hexToColor(hexString: "#979797")
    static let shadowBlack: UIColor = .hexToColor(hexString: "#000000", alpha: 0.5)
    static let hyperLinkBlue: UIColor = .hexToColor(hexString: "#00558C")
    static let detailGray: UIColor = .hexToColor(hexString: "#8C8C8C")
    static let iconGray: UIColor = .hexToColor(hexString: "#7995A3")
    static let veryLightGray: UIColor = .hexToColor(hexString: "#F4F4F4")
   
    
}
