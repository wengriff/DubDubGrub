//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 14/10/2023.
//

import CloudKit

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    var userRecord: CKRecord?
    var profileRecordID: CKRecord.ID?
    let container = CKContainer.default()
    
    private init() {}
    
    // old way
//    func getUserRecord() {
//        
//        // Get UserRecordID from the Container
//        CKContainer.default().fetchUserRecordID { recordID, error in
//            guard let recordID = recordID, error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//            
//            // Get UserRecord from the Public Database
//            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
//                guard let userRecord = userRecord, error == nil else {
//                    print(error!.localizedDescription)
//                    return
//                }
//                
//                self.userRecord = userRecord
//                
//                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference {
//                    self.profileRecordID = profileReference.recordID
//                }
//            }
//        }
//    }
    
    func getUserRecord() async throws {
        
        let recordID = try await container.userRecordID()
        
        let record = try await container.publicCloudDatabase.record(for: recordID)
        
        userRecord = record
        
        if let profileReference = record["userProfile"] as? CKRecord.Reference {
            profileRecordID = profileReference.recordID
        }
    }
    
    // Old Way
//    func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void)  {
//        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
//        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
//        query.sortDescriptors = [sortDescriptor]
//        
//        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
//            guard let records = records, error == nil else {
//                completed(.failure(error!))
//                return
//            }
//            
//            //            var locations: [DDGLocation] = []
//            //
//            //            for record in records {
//            //                let location = DDGLocation(record: record)
//            //                locations.append(location)
//            //            }
//            
////            let locations = records.map { $0.convertToDDGLocation() } // instead of what's up there
//            let locations = records.map(DDGLocation.init) // instead of what's up there
//            
//            completed(.success(locations))
//        }
//    }
    
    func getLocations() async throws -> [DDGLocation]  {
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        let locations = records.map(DDGLocation.init)
        
        return locations
    }

    
    
    
    func batchSave(records: [CKRecord], completed: @escaping (Result<[CKRecord], Error>) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            guard let savedRecords = savedRecords, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            completed(.success(savedRecords))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func getCheckedInProfiles(for locationID: CKRecord.ID) async throws -> [DDGProfile] {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        let profiles = records.map(DDGProfile.init)
        
        return profiles
    }
    
    
    func getCheckedInProfilesDictionary(completed: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void) {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        //        operation.desiredKeys = [DDGProfile.kIsCheckedIn, DDGProfile.kAvatar] // optional
        
        var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        
        operation.recordFetchedBlock = { record in
            // Build dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        
        
        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            if let cursor = cursor {
                self.continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles) { result in
                    switch result {
                        
                    case .success(let profiles):
                        completed(.success(profiles))
                    case .failure(let error):
                        completed(.failure(error))

                    }
                }
            } else {
                completed(.success(checkedInProfiles))

            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func continueWithCheckedInProfilesDict(cursor: CKQueryOperation.Cursor,
                                           dictionary: [CKRecord.ID: [DDGProfile]],
                                           completed: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void) {
        
        var checkedInProfiles = dictionary
        let operation = CKQueryOperation(cursor: cursor)
        
        operation.recordFetchedBlock = { record in
            // Build dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            if let cursor = cursor {
                self.continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles) { result in
                    switch result {
                        
                    case .success(let profiles):
                        completed(.success(profiles))
                    case .failure(let error):
                        completed(.failure(error))

                    }
                }
            } else {
                completed(.success(checkedInProfiles))

            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func getCheckedInProfilesCount(completed: @escaping (Result<[CKRecord.ID: Int], Error>) -> Void) {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = [DDGProfile.kIsCheckedIn]
        
        var checkedInProfilesCount: [CKRecord.ID: Int] = [:]
        
        operation.recordFetchedBlock = { record in
            // Build dictionary
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            
            checkedInProfilesCount[locationReference.recordID, default: 0] += 1
            
            //            if let count = checkedInProfiles[locationReference.recordID] {
            //                checkedInProfiles[locationReference.recordID] = count + 1
            //            } else {
            //                checkedInProfiles[locationReference.recordID] = 1
            //            }
        }
        
        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            // Handle cursor
            
            completed(.success(checkedInProfilesCount))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func save(record: CKRecord, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
    }
    
    
    func fetchRecord(with id: CKRecord.ID, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
    }
}
