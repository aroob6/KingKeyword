//
//  Int.swift
//  TopKeyword
//
//  Created by bora on 2022/11/17.
//

import Foundation

extension Int {
    func numberFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
