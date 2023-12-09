//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 05/12/2023.
//

import CoreLocation

final class AppTabViewModel: NSObject, ObservableObject  {
    @Published var isShowingOnboardView: Bool = false
    @Published var alertItem: AlertItem?
    
    var deviceLocationManager: CLLocationManager?
    let kHasSeenOnboardView = "hasSeenOnboardView"
    var hasSeenOnboardView: Bool {
        return UserDefaults.standard.bool(forKey: kHasSeenOnboardView) // defaults to false
    }
    
    func runStartupChecks() {
        if !hasSeenOnboardView {
            isShowingOnboardView = true
            UserDefaults.standard.set(true, forKey: kHasSeenOnboardView)
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
}

extension AppTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
