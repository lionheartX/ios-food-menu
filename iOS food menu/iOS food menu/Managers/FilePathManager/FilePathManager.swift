//
//  FilePathManager.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-12.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit
enum EntityTypePrefix: String {
    case foodCategory = "foodCategory-"
    case foodItem = "foodItem-"
}

enum ImageTypeSuffix: String {
    case png = ".png"
}

class FilePathManager {
    static let shared = FilePathManager()
    
    let fileManager = FileManager.default
    
    /* Returns the path where the image is saved, returns nil if save fails, hashValue will be used as part of the image's name in path */
    func save(image: UIImage, hashValue: Int, entityType: EntityTypePrefix, imageType: ImageTypeSuffix = .png) -> String? {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let filePath = documentsURL.appendingPathComponent(entityType.rawValue + String(hashValue) + imageType.rawValue)
        
        do {
            if let data = image.pngData() {
                try data.write(to: filePath, options: .atomic)
                return filePath.path
            }
        } catch {
            fatalError("could not save image to disk")
        }
        
        return nil
    }
    
    func tryDelete(hashValue: Int, entityType: EntityTypePrefix, imageType: ImageTypeSuffix = .png) {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let documentsPath = documentsURL.path
        let fileToDelete = documentsURL.appendingPathComponent(entityType.rawValue + String(hashValue) + imageType.rawValue)
        if let files = try? FileManager.default.contentsOfDirectory(atPath: "\(documentsPath)") {
            for file in files {
                if "\(documentsPath)/\(file)" == fileToDelete.path {
                    try? fileManager.removeItem(at: fileToDelete)
                }
            }
        }
    }
    
    func tryDelete(urlString: String) {
        let url = URL(fileURLWithPath: urlString)
        try? fileManager.removeItem(at: url)
    }
    
    func tryDelete(urlStrings: [String?]) {
        for urlString in urlStrings {
            if let urlString = urlString {
                self.tryDelete(urlString: urlString)
            }
        }
    }
}
