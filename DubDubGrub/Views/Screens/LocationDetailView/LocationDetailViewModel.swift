//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 13/11/2023.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus {
    case checkedIn, checkedOut
}

final class LocationDetailViewModel: ObservableObject {
    
    var location: DDGLocation
    var selectedProfile: DDGProfile?
    
    @Published var checkedInProfiles: [DDGProfile] = []
    @Published var alertItem: AlertItem?
    @Published var isShowingProfileModal = false
    @Published var isShowingProfileSheet = false
    @Published var isCheckedIn = false
    @Published var isLoading = false
    
    
    init(location: DDGLocation) {
        self.location = location
    }
    
    func determineColumns(for sizeCategory: ContentSizeCategory) -> [GridItem] {
        let numberOfColumns = sizeCategory >= .accessibilityMedium ? 1 : 3
        return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
    
    func getDirectionsToLocation() {
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                    
                case .success(let record):
                    if let reference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = reference.recordID == location.id // the same if as below
//                        if reference.recordID == location.id {
//                            isCheckedIn = true
//                        } else {
//                            isCheckedIn = false
//                        }
                        
                        
                    } else {
                        isCheckedIn = false
                    }
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckInStatus
                }
            }
        }

    }
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus) {
        // Retrieve the DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                // Create a reference to the location
                switch checkInStatus {
                case .checkedIn:
                    record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    record[DDGProfile.kIsCheckedInNilCheck] = Int64(1)
                case .checkedOut:
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kIsCheckedInNilCheck] = nil
                }
                // Save the updated profile to CK
                CloudKitManager.shared.save(record: record) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success(let record):
                            let profile = DDGProfile(record: record)
                            switch checkInStatus {
                            case .checkedIn:
                                checkedInProfiles.append(profile)
                            case .checkedOut:
                                checkedInProfiles.removeAll(where: {$0.id == profile.id})
                            }
                            isCheckedIn = checkInStatus == .checkedIn
                            // update checkedInProfiles array
                        case .failure(_):
                            alertItem = AlertContext.unableToGetCheckInOrOut
                        }
                    }
                }
            case .failure(_):
                alertItem = AlertContext.unableToGetCheckInOrOut
            }
            
        }
    }
    
    func getCheckedInProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let profiles):
                    checkedInProfiles = profiles
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckedInProfiles
                }
                hideLoadingView()
            }
        }
    }
    
    func show(profile: DDGProfile, in sizeCategory: ContentSizeCategory) {
        if sizeCategory >= .accessibilityMedium {
            isShowingProfileSheet = true
        } else {
            isShowingProfileModal = true
        }
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
