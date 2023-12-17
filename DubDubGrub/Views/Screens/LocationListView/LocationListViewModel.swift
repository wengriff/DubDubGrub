//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 26/11/2023.
//

import Foundation
import CloudKit
import SwiftUI
import Observation

extension LocationListView {
    
    @MainActor @Observable
    final class LocationListViewModel {
        
        var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        var alertItem: AlertItem?
        
        func getCheckedInProfilesDictionary() async {
            
            do {
                checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesDictionary()
                print("Called")
            } catch {
                alertItem = AlertContext.unableToGetAllCheckedInProfiles
            }
            
        }
        
        func createVoiceOverSummary(for location: DDGLocation) -> String {
            let count = checkedInProfiles[location.id, default: []].count
            let personPlurality = count == 1 ? "person" : "people"
            return "\(location.name) \(count) \(personPlurality) checked in."
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
