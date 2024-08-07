//
//  Quality-ModelHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 28 Nov 2021.
//

extension QualityV2 {
    var qualityTitle: String {
        title ?? "New Quality"
    }

    var qualityNote: String {
        note ?? ""
    }

    var indicatorCharacter: Character? {
        guard let indicatorString = indicator else { return nil }
        guard let firstElement = indicatorString.first else { return nil }
        let firstCharacter = String(firstElement)
        return Character(firstCharacter)
    }

    var qualityIndicatorCharacter: Character {
        indicatorCharacter ?? defaultQualityIndicator
    }

    var defaultQualityIndicator: Character {
        qualityTitle.lowercased().first ?? "?"
    }

    /// All indicators for the project except for the indicator for this Quality instance
    var otherProjectIndicators: [Character] {
        project?.projectQualities
            .filter { $0 != self }
            .map(\.qualityIndicatorCharacter)
            ?? []
    }

    var hasUniqueIdentifier: Bool {
        !otherProjectIndicators.contains(qualityIndicatorCharacter)
    }

    var qualityScores: [ScoreV2] {
        scores ?? []
    }

    static var example: QualityV2 {
        let quality = QualityV2()
        quality.title = "Shiny Quality \(Int.random(in: 10 ... 99))"
        quality.note = """
        4) Amazing
        3) Great
        2) Good
        1) Acceptable
        """
        quality.indicator = ["a", "h", "r", "q", "n", "k", "y", "m", "w", "x"].randomElement() ?? "a"

        return quality
    }

    func score(for item: ItemV2) -> ScoreV2? {
        for score in qualityScores where score.item == item {
            return score
        }
        return nil
    }

    var possibleScores: [Int] {
        let scores = Array(1 ... 4)
        return isReversed ? scores.reversed() : scores
    }
}
