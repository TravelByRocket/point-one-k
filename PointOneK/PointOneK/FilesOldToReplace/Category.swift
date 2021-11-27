//
//  Category.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import Foundation

class Category: ObservableObject, Codable {
    @Published var ideas: [Idea] = []

    func sortByTotalScore () {
        ideas.sort(by: {$0.totalScore > $1.totalScore})
    }

    enum CodingKeys: CodingKey {
        case ideas
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(ideas, forKey: .ideas)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        ideas = try container.decode([Idea].self, forKey: .ideas)
    }

    init() { }

    func saveToUserDefaults() {
        guard let settingsData = try? JSONEncoder().encode(self) else {return}
        UserDefaults.standard.set(settingsData, forKey: "settings")
    }

    static let impactDesc = """
                            1) 10s of people
                            2) 100s of people
                            3) 1000s of people
                            4) 10,000s of people
                            """

    static let effortDesc = """
                            1) 1000s of hours + help
                            2) 1000s of hours
                            3) 100s of hours
                            4) 10s of hours
                            Subtract 1 if help needed
                            """
    static let visionDesc = """
                            1) Weeks
                            2) Months
                            3) Years
                            4) Decades
                            """

    static let profitDesc = """
                            1) $10s/month
                            2) $100s/month
                            3) $1000s/month
                            4) $10k/month
                            """
}
