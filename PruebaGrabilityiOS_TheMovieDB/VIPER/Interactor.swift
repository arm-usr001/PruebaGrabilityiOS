//
//  Interactor.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 7/9/21.
//  Copyright © 2021 Arm. All rights reserved.
//

//ref to presenter

//URL

import Foundation
import SwiftlyCache

protocol AnyInteractor{
    var presenter: AnyPresenter? {get set}
    
    func callMediaAPI<T: Codable>(_ url: URL, genericType: T.Type, completition: ((T) -> Void)?) // completition = For Testing Network Request...
}

 // In the rest of the code, no need completition...
extension AnyInteractor{
    func callMediaAPI<T: Codable>(_ url: URL, genericType: T.Type){
        callMediaAPI(url, genericType: genericType, completition: nil)
    }
}


class Interactor: AnyInteractor{
    
    var presenter: AnyPresenter?
    
    var urlSession : URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30
        if #available(iOS 11, *) {
          configuration.waitsForConnectivity = true
        }
        return URLSession(configuration: configuration)
    }()

    
    //Generic function for JSON Api requests...
    func callMediaAPI<T: Codable>(_ url: URL, genericType: T.Type, completition: ((T) -> Void)? = nil )  {
        //Getting from the cache if no internet...
        guard NetworkMonitor.shared?.isConnected ?? false else {
            if let entities = getFromCache(for: url, genericType: genericType){
                self.presenter?.interactorDidFetchMediaData(with: .success(entities), gen: genericType)
            }
            else{
                self.presenter?.interactorDidFetchMediaData(with: .failure( NSError(domain: "", code: 001, userInfo: [ NSLocalizedDescriptionKey: "Cache not existing"])), gen: genericType)
            }
            return
        }
        
        let task = urlSession.dataTask(with: url) { [weak self](data, response, error) in
            guard let data = data, error == nil else{
                self?.presenter?.interactorDidFetchMediaData(with: .failure(error!), gen: genericType)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy =  .formatted(DateFormatter.yyyyMMdd)
                let entities = try jsonDecoder.decode(genericType.self, from: data)
                
                
                completition?(entities)//For Testing Network Request...
                
                self?.saveToCache(for: url, entities: entities)
                self?.presenter?.interactorDidFetchMediaData(with: .success(entities), gen: genericType)
            }
            catch let error{
                self?.presenter?.interactorDidFetchMediaData(with: .failure(error), gen: genericType)
            }
        }
        task.resume()
    }
    
    //Saving to cache, using url as a key without last parameter in  upcoming, top_rated and popular movie urls
    fileprivate func saveToCache<T:Codable>(for url: URL, entities: T) {
        let cache = MultiCache<T>()
        
        switch url.absoluteString {
            case _ where url.absoluteString.contains("upcoming?api"),
                 _ where url.absoluteString.contains("top_rated?api"),
                 _ where url.absoluteString.contains("popular?api"):
                    cache.set(forKey: String(url.absoluteString[..<url.absoluteString.index(url.absoluteString.startIndex, offsetBy: url.absoluteString.count-5)]), value: entities)
            default:
                cache.set(forKey: url.absoluteString, value: entities)
        }
    }
    
    //Getting from cache, using url as a key without last parameter in  upcoming, top_rated and popular movie urls
    fileprivate func getFromCache<T:Codable>(for url: URL,  genericType: T.Type) -> T? {
        let cache = MultiCache<T>()
        
        switch url.absoluteString {
            case _ where url.absoluteString.contains("upcoming?api"),
                 _ where url.absoluteString.contains("top_rated?api"),
                 _ where url.absoluteString.contains("popular?api"):
                    if let entities = cache.object(forKey: String(url.absoluteString[..<url.absoluteString.index(url.absoluteString.startIndex, offsetBy: url.absoluteString.count-5)])){
                        return entities
                    }
            default:
                if let entities = cache.object(forKey: url.absoluteString){
                    return entities
                }
        }
        return nil
    }
}


