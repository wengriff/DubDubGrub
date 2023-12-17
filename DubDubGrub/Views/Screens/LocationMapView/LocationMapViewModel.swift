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
        
        @MainActor
        func getLocations(for locationManager: LocationManager) {
            
            Task {
                do {
                    locationManager.locations = try await CloudKitManager.shared.getLocations()
                } catch {
                    alertItem = AlertContext.unableToGetLocations
                }
            }
            
            // Old Way
            //            CloudKitManager.shared.getLocations {  result in
            //                DispatchQueue.main.async { [self]
            //                    switch result {
            //                    case .success(let locations):
            //                        locationManager.locations = locations
            //                    case .failure(_):
            //                        self.alertItem = AlertContext.unableToGetLocations
            //                    }
            //                }
            //            }
        }
        
        @MainActor
        func getCheckedInCount() {
            
            Task {
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
                } catch {
                    alertItem = AlertContext.checkedInCount
                }
            }
        }
        
        func toggleDetailView() {
            isShowingDetailView.toggle()
        }
        
        @MainActor
        @ViewBuilder func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View {
            if dynamicTypeSize >= .accessibility3 {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
            } else {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            }
        }
    }
}

