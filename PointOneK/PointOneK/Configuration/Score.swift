//
//  Score.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/6/23.
//
//

import Foundation
import SwiftData


@Model public class Score {
    var value: Int16? = 0
    var item: Item?
    var quality: Quality?
    
    public init() { }
}
