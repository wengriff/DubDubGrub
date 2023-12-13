//
//  CKAsset+Ext.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 27/10/2023.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        
        guard let fileURL = self.fileURL else { return dimension.placeholder }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data) ?? dimension.placeholder
        } catch {
            return dimension.placeholder
        }
    }
}
