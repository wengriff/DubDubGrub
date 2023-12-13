//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 05/12/2023.
//

import CoreLocation
import SwiftUI

extension AppTabView {
    
    final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate  {
        @Published var isShowingOnboardView: Bool = false
        @Published var alertItem: AlertItem?
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnboardView = hasSeenOnboardView }
        }
        
        var deviceLocationManager: CLLocationManager?
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        func runStartupChecks() {
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            } else {
                checkLocationAuthorization()
            }
        }
        
        func checkIfLocationServicesIsEnabled() {
            DispatchQueue.global().async { [self] in
                if CLLocationManager.locationServicesEnabled() {
                    deviceLocationManager = CLLocationManager()
                    //            deviceLocationManager?.desiredAccuracy = kCLLocationAccuracyBest // it's the default
                    deviceLocationManager!.delegate = self
                    checkLocationAuthorization()
                } else {
                    alertItem = AlertContext.locationDisabled
                }
            }
        }
        
        private func checkLocationAuthorization() {
            guard let deviceLocationManager = deviceLocationManager else { return }
            
            switch deviceLocationManager.authorizationStatus {
                
            case .notDetermined:
                deviceLocationManager.requestWhenInUseAuthorization()
            case .restricted:
                alertItem = AlertContext.locationRestricted
            case .denied:
                alertItem = AlertContext.locationDenied
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
    }
}

