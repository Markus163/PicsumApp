//
//  ImageStorageService.swift
//  PicsumApp
//
//  Created by Марк Михайлов on 26.03.2023.
//

import UIKit

final class ImageStorageService {
 
    func store(image: UIImage, forKey key: String) {
        if let jpgRepresentation = image.jpegData(compressionQuality: 90) {
            if let filePath = filePath(forKey: key) {
                do {
                    try jpgRepresentation.write(to: filePath, options: .atomic)
                } catch let err {
                    print("Saving results in error: ", err)
                }
            }
        }
    }
    
    func readImage(forKey key: String) -> UIImage? {
        if let filePath = self.filePath(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
        return nil
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first else {
                                                    return nil
        }
        return documentURL.appendingPathComponent(key + ".jpg")
    }
}
