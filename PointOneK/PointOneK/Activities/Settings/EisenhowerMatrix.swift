//
//  EisenhowerMatrix.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/31/24.
//

enum EisenhowerMethod {
    static var project: ProjectV2 {
        let project = ProjectV2()
        project.title = "Eisenhower Method"
        project.detail = """
        Urgent + Important: Do Now
        Important: Schedule
        Urgent: Delegate
        Neither: Do Not Do
        """
        return project
    }

    static var qualities: [QualityV2] {
        [
            urgency,
            importance,
        ]
    }

    static var urgency: QualityV2 {
        let quality = QualityV2()
        quality.title = "Urgency"
        return quality
    }

    static var importance: QualityV2 {
        let quality = QualityV2()
        quality.title = "Importance"
        return quality
    }
}
