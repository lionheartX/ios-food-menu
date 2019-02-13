//
//  FilePathManager.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-12.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit
class FilePathManager {
    static let shared = FilePathManager()
    
    let fileManager = FileManager.default
    
    func save(image: UIImage, name: String, type: String) -> String? {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let filePath = documentsURL.appendingPathComponent(type + "-" + name + ".png")
        
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
    
    func delete(name: String) {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let documentsPath = documentsURL.path
        let fileToDelete = documentsURL.appendingPathComponent(name + ".png")
        if let files = try? FileManager.default.contentsOfDirectory(atPath: "\(documentsPath)") {
            for file in files {
                if "\(documentsPath)/\(file)" == fileToDelete.path {
                    try? fileManager.removeItem(at: fileToDelete)
                }
            }
        }
    }
}
