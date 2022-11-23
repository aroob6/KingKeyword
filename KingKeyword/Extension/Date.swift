//
//  Date.swift
//  TopKeyword
//
//  Created by bora on 2022/11/17.
//

import Foundation

extension Date {
    static var timestamp: Int64 {
        Int64(timeIntervalBetween1970AndReferenceDate*1000)
    }
}
