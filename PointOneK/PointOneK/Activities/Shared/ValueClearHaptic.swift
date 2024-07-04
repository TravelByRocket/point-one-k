//
//  ValueClearHaptic.swift
//  PointOneK
//
//  Created by Bryan Costanza on 14 Mar 2022.
//

import CoreHaptics
import Foundation

extension LevelSelector {
    func valueClearHaptic(engine: CHHapticEngine?) {
        do {
            try engine?.start()

            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)

            let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
            let end = CHHapticParameterCurve.ControlPoint(relativeTime: 0.2, value: 0)

            let parameter = CHHapticParameterCurve(
                parameterID: .hapticIntensityControl,
                controlPoints: [start, end],
                relativeTime: 0
            )

            let event1 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0
            )

            let event2 = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [sharpness, intensity],
                relativeTime: 0.125,
                duration: 1
            )

            let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)

        } catch {
            // failed to start
        }
    }
}
