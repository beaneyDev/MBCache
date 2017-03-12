//
//  MBCacheController.swift
//  Pods
//
//  Created by Matt Beaney on 12/03/2017.
//
//

import Foundation
import CryptoSwift

open class MBCacheController: NSCache<AnyObject, AnyObject> {
    public static let shared = MBCacheController()
    static let kPSCACHEPersistentCachePath = "MBPersistentCache"
    
    func ephemeralCachePath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    }
    
    func persistentCachePath() -> String {
        var persistentCachePath = ephemeralCachePath() as NSString
        
        persistentCachePath = persistentCachePath.appendingPathComponent(MBCacheController.kPSCACHEPersistentCachePath) as NSString
        
        do {
            try FileManager.default.createDirectory(atPath: persistentCachePath as String, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
        
        return persistentCachePath as String
    }
    
    func cachedResourceForRequest(_ request: URLRequest) -> Data? {
        switch request.cachePolicy {
        case NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData:
            return nil
        default:
            break
        }
        
        if let cache = self.object(forKey: resourceCacheKeyForRequest(request) as AnyObject) as? Data {
            return cache
        }
        
        if let cache = checkPersistentCacheForRequest(request) {
            return cache
        }
        
        if let cache = checkEphemeralCacheForRequest(request) {
            return cache
        }
        
        return nil
    }
    
    func resourceCacheKeyForRequest(_ request: URLRequest) -> String {
        return request.url!.absoluteString.sha1()
    }
    
    func checkEphemeralCacheForRequest(_ request: URLRequest) -> Data? {
        let urlHash = resourceCacheKeyForRequest(request)
        
        let cachePath = ephemeralCachePath() as NSString
        
        let filePath = cachePath.appendingPathComponent(urlHash)
        
        if MBFileSystemController.shared.fileExistsAtPath(filePath) {
            return (try? Data(contentsOf: URL(fileURLWithPath: filePath)))
        }
        
        return nil
    }
    
    func checkPersistentCacheForRequest(_ request: URLRequest) -> Data? {
        let urlHash = resourceCacheKeyForRequest(request)
        
        let cachePath = persistentCachePath() as NSString
        
        let filePath = cachePath.appendingPathComponent(urlHash)
        
        if MBFileSystemController.shared.fileExistsAtPath(filePath) {
            return (try? Data(contentsOf: URL(fileURLWithPath: filePath)))
        }
        
        return nil
    }
    
    func writeCacheResourceToPersistentCache(_ data: Data, request: URLRequest) {
        let urlHash = resourceCacheKeyForRequest(request)
        
        let cachePath = persistentCachePath() as NSString
        
        let filePath = cachePath.appendingPathComponent(urlHash)
        
        MBFileSystemController.shared.writeDataToPath(filePath, data: data)
    }
}
