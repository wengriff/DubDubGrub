//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 13/12/2023.
//

import UIKit

struct HapticManager {
    static func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
