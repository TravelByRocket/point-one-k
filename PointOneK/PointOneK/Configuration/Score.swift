//
//  Score.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import SwiftData

@Model public class ScoreV2 {
    var value: Int16? = 0
    var item: ItemV2?
    var quality: QualityV2?

    public init() {}
}
