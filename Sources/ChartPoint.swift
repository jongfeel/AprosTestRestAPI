//
//  ChartPoint.swift
//  AprosTestRestAPI
//
//  Created by VIRNECT on 2017. 9. 25..
//
//

import Foundation

class ChartPoint {
    let datetime : Date
    let value : String
    
    init() {
        datetime = Date()
        value = ""
    }
    
    public func getValue() -> Float {
        return (self.value as NSString).floatValue;
    }
}
