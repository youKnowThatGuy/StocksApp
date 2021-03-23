//
//  CacheManager.swift
//  StocksApp
//
//  Created by Клим on 21.03.2021.
//

import Foundation

class CacheManager{
    private init(){}
    static let shared = CacheManager()
    private let fileManager = FileManager.default
    
    //-MARK: SEARCH CACHING
    func cacheSearches(_ dataForjson: String?, completion: ((Bool)-> Void)? = nil){
        DispatchQueue.global(qos: .utility).async { [self] in
        
        guard let data = dataForjson else{
            completion?(false)
            return
        }
      let jsonUrl = getServicesDirectory().appendingPathComponent("searchHistory.json")
            /*
            let mass: [String] = []
            let newData = try JSONEncoder().encode(mass)
       */
        
        do{
            try data.write(to: jsonUrl, atomically: true, encoding: .utf8)
            completion?(true)
        }
        catch {
            print(error)
            completion?(false)
        }
        }
    }
    
    func getSearches(completion: @escaping (String) -> Void){
        let jsonUrl = getServicesDirectory().appendingPathComponent("searchHistory.json")
        DispatchQueue.global(qos: .userInteractive).async {
            
            if let data = self.fileManager.contents(atPath: jsonUrl.path),
               let string = String(data: data, encoding: .utf8){
            
            DispatchQueue.main.async {
        completion(string)
            }
            }
        }
    }
    
    
    
    func cacheFavourites(_ dataForjson: String?, completion: ((Bool)-> Void)? = nil){
        DispatchQueue.global(qos: .utility).async { [self] in
        
        guard let data = dataForjson else{
            completion?(false)
            return
        }
      let jsonUrl = getServicesDirectory().appendingPathComponent("favouritesList.json")
        
        do{
            try data.write(to: jsonUrl, atomically: true, encoding: .utf8)
            completion?(true)
        }
        catch {
            print(error)
            completion?(false)
        }
        }
    }
    
    func getFavourites(completion: @escaping (String) -> Void){
        let jsonUrl = getServicesDirectory().appendingPathComponent("favouritesList.json")
        DispatchQueue.global(qos: .userInteractive).async {
            
            if let data = self.fileManager.contents(atPath: jsonUrl.path),
               let string = String(data: data, encoding: .utf8){
            
            DispatchQueue.main.async {
        completion(string)
            }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    private func getServicesDirectory()-> URL{
        let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CachedServices")
        
        if !fileManager.fileExists(atPath: url.path){
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    
    
    
}
