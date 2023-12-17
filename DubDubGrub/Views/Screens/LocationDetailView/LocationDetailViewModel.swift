//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Sean Allen on 6/13/21.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus { case checkedIn, checkedOut }

final class LocationDetailViewModel: ObservableObject {
    
    @Published var checkedInProfiles: [DDGProfile] = []
    @Published var isShowingProfileModal = false
    @Published var isShowingProfileSheet = false
    @Published var isCheckedIn = false
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    var location: DDGLocation
    var selectedProfile: DDGProfile?
    var buttonColor: Color { isCheckedIn ? .grubRed : .brandPrimary }
    var buttonImageTitle: String { isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark" }
    var buttonA11yLabel: String { isCheckedIn ? "Check out of location" : "Check into location" }
    
    init(location: DDGLocation) { self.location = location }
    
    
    func determineColumns(for dynamicTypeSize: DynamicTypeSize) -> [GridItem] {
        let numberOfColumns = dynamicTypeSize >= .accessibility3 ? 1 : 3
        return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
    
    
    func getDirectionsToLocation() {
        let placemark   = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem     = MKMapItem(placemark: placemark)
        mapItem.name    = location.name
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    
    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    
    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                    case .success(let record):
                        if let reference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                            isCheckedIn = reference.recordID == location.id
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
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        showLoadingView()
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            switch result {
                case .success(let record):
                    switch checkInStatus {
                        case .checkedIn:
                            record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                            record[DDGProfile.kIsCheckedInNilCheck] = 1
                        case .checkedOut:
                            record[DDGProfile.kIsCheckedIn] = nil
                            record[DDGProfile.kIsCheckedInNilCheck] = nil
                    }
                    
                    CloudKitManager.shared.save(record: record) { result in
                        DispatchQueue.main.async { [self] in
                            hideLoadingView()
                            switch result {
                                case .success(let record):
                                    HapticManager.playSuccess()
                                    let profile = DDGProfile(record: record)
                                    switch checkInStatus {
                                        case .checkedIn:
                                            checkedInProfiles.append(profile)
                                        case .checkedOut:
                                            checkedInProfiles.removeAll(where:{ $0.id == profile.id })
                                    }
                                    
                                    isCheckedIn.toggle()
                                    
                                case .failure(_):
                                    alertItem = AlertContext.unableToGetCheckInOrOut
                            }
                        }
                    }
                    
                case .failure(_):
                    hideLoadingView()
                    alertItem = AlertContext.unableToGetCheckInOrOut
            }
        }
    }
    
    
    func getCheckedInProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { [self] result in
            DispatchQueue.main.async {
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
    
    
    func show(_ profile: DDGProfile, in dynamicTypeSize: DynamicTypeSize) {
        selectedProfile = profile
        if dynamicTypeSize >= .accessibility3 {
            isShowingProfileSheet = true
        } else {
            isShowingProfileModal = true
        }
    }
    
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
