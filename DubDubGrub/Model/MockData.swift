//
//  MockData.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 10/10/2023.
//

import CloudKit

struct MockData {
    
    static var location: CKRecord {
        let record                          = CKRecord(recordType: RecordType.location)
        record[DDGLocation.kName]           = "Adrian's Bar and Grill"
        record[DDGLocation.kAddress]        = "123 Main Street"
        record[DDGLocation.kDescription]    = "This is a test description. It should be awesome and very looooong."
        record[DDGLocation.kWebsiteURL]     = "https://www.apple.com"
        record[DDGLocation.kLocation]       = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber]    = "111-111-1111"
        return record
    }
    
    static var profile: CKRecord {
        let record                          = CKRecord(recordType: RecordType.profile)
        record[DDGProfile.kFirstName]       = "Adrian"
        record[DDGProfile.kLastName]        = "Somor"
        record[DDGProfile.kCompanyName]     = "Apple"
        record[DDGProfile.kBio]             = "Great bio! I hope this is long enough to check everything!"
        return record
    }
}
