//
//  HundredDollarStartup.swift
//  PointOneK
//
//  Created by Bryan Costanza on 9 Mar 2022.
//

import CoreData
import Foundation

// swiftlint:disable line_length
enum HundredDollarStartup {
    static var project: ProjectV2 {
        let project = ProjectV2()
        project.title = "$100 Startup Ideas"
        project.closed = false
        project.detail = "Have lots of business ideas but can't figure out which one to pursue? Use this template to score them and see what floats to the top. Inspired by the book \"The $100 Startup\"."
        return project
    }

    static var qualities: [QualityV2] {
        [
            impact,
            effort,
            vision,
            profitability,
        ]
    }

    static var effort: QualityV2 {
        let quality = QualityV2()
        quality.title = "Ease"
        quality.isReversed = true
        quality.note = """
        How easy is this project? Easier the better! And don't try too hard, the easy way is hard enough
        1) I can do this task in my sleep, like singing happy birthday. Or it takes little time or resources. <10s of hours for a project.
        2) I have to gather resources, maybe depend on others a little bit, or put in some effort to completing the task. 100s of hours for a project.
        3) This will take substantial effort, studying, resources, or coordination. 1000s of hours for a project.
        4) Huge amounts of resources. Many 1000s of hours for a project.
        """
        return quality
    }

    static var impact: QualityV2 {
        let quality = QualityV2()
        quality.title = "Impact"
        quality.note = """
        How much of an impact will this have on customers? Your community? The world?
        4) Huge; lots of people or very impactful on some
        3) Good; noticed by many or helpful in some ways
        2) Some; nothing amazing but appreciable and positive
        1) Little; not much going for it in this category
        """
        return quality
    }

    static var vision: QualityV2 {
        let quality = QualityV2()
        quality.title = "Vision"
        quality.note = """
        How closely does this align with your vision of your ideal work?
        4) It's exactly what I want to do for as long I can imagine
        3) Has elements I would change or I could see doing this a few years
        2) It has elements of my perfect vision and is a stepping stone
        1) There's not much I am excited to be getting experience in
        """
        return quality
    }

    static var profitability: QualityV2 {
        let quality = QualityV2()
        quality.title = "Profitability"
        quality.note = """
        How much moola potential is there here?
        4) Pays my salary
        3) Pays for rent
        2) Pays for utilities
        1) Pays for really fancy ketchup
        """
        return quality
    }
}
