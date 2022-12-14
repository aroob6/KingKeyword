//
//  Color.swift
//  KingKeyword
//
//  Created by 이보라 on 2022/11/23.
//

import SwiftUI
 
extension Color {
    static let mainColor = Color(hex: "4D86DA")
    static let subColor = Color.init(hex: "B9A4E9")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
