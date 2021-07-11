//
//  APIConstants.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 10/07/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import Foundation

struct APIConstants {
    
    static let ApiKey_themoviedb = "a95fb66a5a1139997ea6e345413baff8"
    
    // MARK: server path
    static let ApiScheme = "https"
    static let ApiHost = "api.themoviedb.org"
    static let ApiPath = "/3"
    
    static let Language = "en-US"
    
    // MARK: Image poster info
    static let secureBaseImageURLString = "https://image.tmdb.org/t/p/"
    static let posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
    
    struct APIParameters {
        static let ApiKey = "api_key"
        static let Language = "language"
        static let Page = "page"
        static let Query = "query"
    }
    
    struct APIMethods {
        static let SearchPopularMovie = "/movie/popular"
        static let SearchTopRatedMovies = "/movie/top_rated"
        static let SearchUpcomingMovies = "/movie/upcoming"
        static let SearchMovie = "/movie/"
        static let SearchVideo = "/videos"
        static let SearchTextMovie = "/search/movie"
    }
}
