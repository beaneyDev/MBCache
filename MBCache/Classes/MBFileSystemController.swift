//
//  PSFileSystemController.swift
//  PSReader
//
//  Created by Mark Godden on 02/05/2016.
//  Copyright © 2016 PageSuite. All rights reserved.
//

import UIKit

class MBFileSystemController {
    static let shared = MBFileSystemController()
    
    func returnDocsPath() -> String? {
        let docPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)
        
        var url: String = ""
        
        if let documentDirectory = docPaths.first {
            url = documentDirectory
            return url
        }
        
        return nil
    }
    
    func fileExistsAtDocPath(_ path: String) -> Bool {
        let docPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)
        
        var url: String = ""
        
        if let documentDirectory = docPaths.first {
            url = documentDirectory + "/\(path)"
        }
        
        return FileManager.default.fileExists(atPath: url)
    }
    
    func fileExistsAtPath(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    func writeDataToPath(_ path: String, data: Data) {
        try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
    }
    
    func returnDataForFileInDocs(_ filePath: String) -> Data? {
        let docPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)
        
        var url: String = ""
        
        if let documentDirectory = docPaths.first {
            url = documentDirectory + "/\(filePath)"
        }
        
        if let data: Data = try? Data(contentsOf: URL(fileURLWithPath: url)) {
            return data
        }
        
        return nil
    }
}
