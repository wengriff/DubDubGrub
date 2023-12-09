//
//  CKRecord+Ext.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 14/10/2023.
//

import CloudKit

extension CKRecord {
    func convertToDDGLocation() -> DDGLocation { return DDGLocation(record: self)  } // don't need the return
    func convertToDDGProfile() -> DDGProfile { return DDGProfile(record: self)  } // don't need the return

}
