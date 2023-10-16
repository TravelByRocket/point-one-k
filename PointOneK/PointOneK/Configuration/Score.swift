//
//  Score.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import Foundation
import SwiftData


@Model public class Score2 {
    var value: Int16? = 0
    var item: Item2?
    var quality: Quality2?

    public init() { }
}
