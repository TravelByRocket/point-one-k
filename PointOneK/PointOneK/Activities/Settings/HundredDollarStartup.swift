//
//  HundredDollarStartup.swift
//  PointOneK
//
//  Created by Bryan Costanza on 9 Mar 2022.
//

import Foundation
import CoreData

func makeHundredDollarStartup(_ dataController: DataController) {
    let managedObjectContext = dataController.container.viewContext

    let project = Project(context: managedObjectContext)
    project.title = "$100 Startup Ideas"
    project.closed = false
    project.detail = "Have lots of business ideas but can't figure out which one to pursue? Use this template to score them and see what floats to the top. Inspired by the book \"The $100 Startup\"."
    // swiftlint:disable:previous line_length

    let ease = Quality(context: managedObjectContext)
    ease.project = project
    ease.title = "Ease"
    ease.indicator = "e"
    ease.note = "How easy is this project? Easier the better! And don't try too hard, the easy way is hard enough"

    let impact = Quality(context: managedObjectContext)
    impact.project = project
    impact.title = "Impact"
    impact.indicator = "i"
    impact.note = "How much of an impact will this have on customers? Your community? The world?"

    let vision = Quality(context: managedObjectContext)
    vision.project = project
    vision.title = "Vision"
    vision.indicator = "v"
    vision.note = "How closely does this align with your vision of your ideak work?"

    let profitability = Quality(context: managedObjectContext)
    profitability.project = project
    profitability.title = "Profitability"
    profitability.indicator = "p"
    profitability.note = "How much moola potential is there here?"

    dataController.save()
}
