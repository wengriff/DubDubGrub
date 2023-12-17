//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 17/10/2023.
//

import MapKit
import SwiftUI
import CloudKit

extension LocationMapView {
    
    @MainActor
    final class LocationMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        
        @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
        @Published var isShowingDetailView = false
        @Published var alertItem: AlertItem?
        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516,
                                                                                      longitude: -121.891054),
                                                       span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let deviceLocationManager = CLLocationManager()
        
        override init() {
            super.init()
            deviceLocationManager.delegate = self
        }
        
        func requestAllowOnceLocationPermission() {
            deviceLocationManager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.last else { return }
            withAnimation {
                region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Did fail with error")
        }
        
        func getLocations(for locationManager: LocationManager) {
            CloudKitManager.shared.getLocations { [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let locations):
                        locationManager.locations = locations
                    case .failure(_):
                        self.alertItem = AlertContext.unableToGetLocations
                    }
                }
            }
        }
        
        func getCheckedInCount() {
            CloudKitManager.shared.getCheckedInProfilesCount { result in
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let checkedInProfiles):
                        self.checkedInProfiles = checkedInProfiles
                    case .failure(_):
                        self.alertItem = AlertContext.checkedInCount
                        break
                    }
                }
            }
        }
        
        func toggleDetailView() {
            isShowingDetailView.toggle()
        }
        
        @ViewBuilder func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View {
            if dynamicTypeSize >= .accessibility3 {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
            } else {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            }
        }
    }
}

