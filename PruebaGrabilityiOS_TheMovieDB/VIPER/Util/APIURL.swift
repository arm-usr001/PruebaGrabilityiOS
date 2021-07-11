//
//  APIURL.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 10/07/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import Foundation

class APIURL {

    static func fullURLGeneral(_ method: String, page: String? = nil, searchString: String? = nil) -> URL {

        var components = URLComponents()
        components.scheme = APIConstants.ApiScheme
        components.host = APIConstants.ApiHost
        components.path = APIConstants.ApiPath + method
        components.queryItems = [URLQueryItem]()
        components.queryItems?.append(URLQueryItem(name: APIConstants.APIParameters.ApiKey, value: APIConstants.ApiKey_themoviedb))
        components.queryItems?.append(URLQueryItem(name: APIConstants.APIParameters.Page, value: page)) // page
        return components.url!
    }
    
    static func fullURLForSearch(_ methodRequest: String, searchString: String?) -> URL {
        var components = URLComponents()
        components.scheme = APIConstants.ApiScheme
        components.host = APIConstants.ApiHost
        components.path = APIConstants.ApiPath + methodRequest
        components.queryItems = [URLQueryItem]()
        components.queryItems?.append(URLQueryItem(name: APIConstants.APIParameters.ApiKey, value: APIConstants.ApiKey_themoviedb))
        components.queryItems?.append(URLQueryItem(name: APIConstants.APIParameters.Query, value: searchString)) // query
        return components.url!
    }
}
