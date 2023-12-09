//
//  UIImage+Ext.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 11/11/2023.
//

import CloudKit
import UIKit

extension UIImage {
    func convertToCKAsset() -> CKAsset? {
        
        // get our apps base document dir url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        // append UID for our profile img
        let fileUrl = urlPath.appendingPathComponent("selectedAvatarImage")
        
        // write the img data to the location the address points to
        guard let imageData = jpegData(compressionQuality: 0.25) else { return nil }

        // create our ckasset with that file url
        do {
            try imageData.write(to: fileUrl)
            return CKAsset(fileURL: fileUrl)
        } catch {
            return nil
        }
    }
}

