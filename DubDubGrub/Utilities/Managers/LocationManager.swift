//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 22/10/2023.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var locations: [DDGLocation] = []
    var selectedLocation: DDGLocation?
}
