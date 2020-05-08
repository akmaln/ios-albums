//
//  Album.swift
//  Albums
//
//  Created by Akmal Nurmatov on 5/7/20.
//  Copyright © 2020 Akmal Nurmatov. All rights reserved.
//

import Foundation

struct Album: Codable {
    let name: String
    let id: String
    let genres: [String]
    let artist: String
    let coverArt: [URL]
    let songs: [Song]
    
    
    enum AlbumKeys: String, CodingKey {
        case artist
        case name
        case genres
        case id
        case songs
        case coverArt
        
        enum CoverArtKeys: String, CodingKey {
            case url
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumKeys.self)
        artist = try container.decode(String.self, forKey: .artist)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(String.self, forKey: .id)
        genres = try container.decode([String].self, forKey: .genres)
        songs = try container.decode([Song].self, forKey: .songs)
        var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        var coverArtUrls: [URL] = []
        while coverArtContainer.isAtEnd == false {
            let coverArtString = try coverArtContainer.decode(String.self)
            if let coverArtURL = URL(string: coverArtString) {
                coverArtUrls.append(coverArtURL)
            }
        }
        coverArt = coverArtUrls 
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AlbumKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(artist, forKey: .artist)
        try container.encode(genres, forKey: .genres)
        try container.encode(songs, forKey: .songs)
        
        let coverArtStrings = coverArt.map { $0.absoluteString }
        try container.encode(coverArtStrings, forKey: .coverArt)
    }
    
}

struct Song: Codable {
    let duration: String
    let name: String
    let id: String
    
    enum SongCodingKeys: String, CodingKey {
        case duration
        case id
        case name
        
        enum DurationCodingKeys: String, CodingKey {
            case duration
        }
        
        enum NameCodingKeys: String, CodingKey {
            case title
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongCodingKeys.self)
        let durationKeyedContainer = try container.nestedContainer(keyedBy: SongCodingKeys.DurationCodingKeys.self, forKey: .duration)
        let namedKeyedContainer = try container.nestedContainer(keyedBy: SongCodingKeys.NameCodingKeys.self, forKey: .name)
        
        duration = try durationKeyedContainer.decode(String.self, forKey: .duration)
        name = try namedKeyedContainer.decode(String.self, forKey: .title)
        id = try container.decode(String.self, forKey: .id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SongCodingKeys.self)
        var durationKeyedContainer = container.nestedContainer(keyedBy: SongCodingKeys.DurationCodingKeys.self, forKey: .duration)
        var namedKeyedContainer = container.nestedContainer(keyedBy: SongCodingKeys.NameCodingKeys.self, forKey: .name)
        
        try container.encode(id, forKey: .id)
        try durationKeyedContainer.encode(duration, forKey: .duration)
        try namedKeyedContainer.encode(name, forKey: .title) 
    }
}
