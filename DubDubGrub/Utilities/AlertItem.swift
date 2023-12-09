//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 16/10/2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    // MARK: -- MapView Errors
    static let unableToGetLocations             = AlertItem(title: Text("Location Error"),
                                                message: Text("Unable to retrieve locations at this time.\n Please try again later."),
                                                dismissButton: .default(Text("Ok")))
    
    static let locationRestricted               = AlertItem(title: Text("Location Restricted"),
                                                message: Text("Your location is restricted, this may be due to parental control."),
                                                dismissButton: .default(Text("Ok")))
    
    static let locationDenied                   = AlertItem(title: Text("Location Denied"),
                                                message: Text("DubDubGrub does not have permission to access your location. To change that go to your phone's Settings > DubDubGrub > Location"),
                                                dismissButton: .default(Text("Ok")))
    
    static let locationDisabled                 = AlertItem(title: Text("Location Service Disabled"),
                                                message: Text("Your phone's location services are disabled. To change that go to your phone's Settings > Privacy > Location Services"),
                                                dismissButton: .default(Text("Ok")))
    // MARK: -- ProfileView Errors
    static let invalidProfile                   = AlertItem(title: Text("Invalid Profile"),
                                                message: Text("All fields are required as well as a profile photo. Your bio must be less than 100 characters.\nPlease try again."),
                                                dismissButton: .default(Text("Ok")))
    
    static let noUserRecord                     = AlertItem(title: Text("No User Record"),
                                                message: Text("You must log in into iCloud on your phone in order to utilize DubDubGrub's profile."),
                                                dismissButton: .default(Text("Ok")))
    
    static let createProfileSuccess             = AlertItem(title: Text("Profile Created"),
                                                message: Text("Your profile has successfully been created."),
                                                dismissButton: .default(Text("Ok")))
    
    static let createProfileFailure             = AlertItem(title: Text("Failed to Create Profile"),
                                                message: Text("We were unable to create your profile at this time.\nPlease try again later."),
                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetProfile               = AlertItem(title: Text("Unable To Retrieve Profile"),
                                                message: Text("We were  unable to retrieve your profile at this time.\nPlease try again later."),
                                                dismissButton: .default(Text("Ok")))
    
    static let updateProfileSuccess             = AlertItem(title: Text("Profile Updated!"),
                                                message: Text("Your DubDubGrub profile was updated."),
                                                dismissButton: .default(Text("Ok")))
    
    static let updateProfileFailure             = AlertItem(title: Text("Unable to Update Profile"),
                                                message: Text("We were  unable to update your profile at this time.\nPlease try again later."),
                                                dismissButton: .default(Text("Ok")))
    
    // MARK: -- LocationDetailView Errors
    static let invalidPhoneNumber               = AlertItem(title: Text("Invalid Phone Number"),
                                                message: Text("The phone number for the location is invalid.\nPlease look up the phone number yourself."),
                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetCheckInStatus         = AlertItem(title: Text("Server Error"),
                                                message: Text("Unable to retrieve checked in status of the current user.\nPlease try again later."),
                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetCheckInOrOut          = AlertItem(title: Text("Server Error"),
                                                message: Text("Unable to checkin/out at this time.\nPlease try again later."),
                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetCheckedInProfiles      = AlertItem(title: Text("Server Error"),
                                                message: Text("Unable to get users checked in into this location.\nPlease try again later."),
                                                dismissButton: .default(Text("Ok")))

    
}
