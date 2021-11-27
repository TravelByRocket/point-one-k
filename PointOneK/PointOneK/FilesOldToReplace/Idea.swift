//
//  Idea.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import Foundation

class Idea: Identifiable, ObservableObject, Codable {
    var id: UUID = UUID()
    @Published var name: String = ""
    @Published var impact: Int = 0
    @Published var effort: Int = 0
    @Published var vision: Int = 0
    @Published var profitability: Int = 0
    @Published var notes: String = ""

    var totalScore: Int {
        impact + effort + vision + profitability
    }

    enum CodingKeys: CodingKey {
        case id, name, impact, effort, vision, profitability, notes
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(impact, forKey: .impact)
        try container.encode(effort, forKey: .effort)
        try container.encode(vision, forKey: .vision)
        try container.encode(profitability, forKey: .profitability)
        try container.encode(notes, forKey: .notes)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        impact = try container.decode(Int.self, forKey: .impact)
        effort = try container.decode(Int.self, forKey: .effort)
        vision = try container.decode(Int.self, forKey: .vision)
        profitability = try container.decode(Int.self, forKey: .profitability)
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
    }

    init() { }

    init(
        name: String? = "",
        impact: Int? = 0,
        effort: Int? = 0,
        vision: Int? = 0,
        profitability: Int? = 0,
        notes: String? = ""
    ) {
        if let name = name {self.name = name}
        if let impact = impact {self.impact = impact} else {self.impact = 0}
        if let effort = effort {self.effort = effort}
        if let vision = vision {self.vision = vision}
        if let profitability = profitability {self.profitability = profitability}
        if let notes = notes {self.notes = notes}
    }
}
