//
//  Game.swift
//  Game.do
//
//  Created by user186880 on 5/15/21.
//

import Foundation

struct Game: Codable{
    let id: Int
    let alternative_names: [Int]?
    let cover: Int?
    let genres: [Int]?
    let game_modes: [Int]?
    let name: String
    let platforms: [Int]?
    let summary: String?
    let url: String
}

struct GameMode: Codable {
    let id: Int
    let name: String
}

struct Platform: Codable {
    let id: Int
    let abbreviation: String
    let alternative_name: String?
    let category: Int
    let generation: Int?
    let name: String
    let platform_logo: Int?
    let url: String
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct AlternativeName: Codable {
    let comment: String
    let game: Int
    let name: String
}

struct Artwork: Codable {
    let id: Int
    let url: String?
}
