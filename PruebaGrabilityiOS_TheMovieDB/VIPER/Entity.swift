//
//  Entity.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 7/9/21.
//  Copyright © 2021 Arm. All rights reserved.
//

//Model

import Foundation

struct ResultMovieCall : Codable{
    let page: Int
    let results : [ResultMovieItemCall]?
    let total_pages : Int
    let total_results : Int
}

struct ResultMovieItemCall : Codable {
    let id: Int
    let backdrop_path: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: Date?
    let title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        backdrop_path = try? container.decode(String.self, forKey: .backdrop_path)
        original_language = try? container.decode(String.self, forKey: .original_language)
        original_title = try? container.decode(String.self, forKey: .original_title)
        overview = try? container.decode(String.self, forKey: .overview)
        popularity = try? container.decode(Double.self, forKey: .popularity)
        poster_path = try? container.decode(String.self, forKey: .poster_path)
        release_date = try? container.decode(Date.self, forKey: .release_date)
        title = try? container.decode(String.self, forKey: .title)
        video = try? container.decode(Bool.self, forKey: .video)
        vote_average = try? container.decode(Double.self, forKey: .vote_average)
        vote_count = try? container.decode(Int.self, forKey: .vote_count)
    }
}


struct ResultVideoCall: Codable {
    let id: Int
    let results: [ResultVideoItemCall]
}

struct ResultVideoItemCall: Codable {
    let id, iso639_1, iso3166_1, key: String?
    let name, site: String?
    let size: Int?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case key, name, site, size, type
    }
}
