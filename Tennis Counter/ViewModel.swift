//
//  GraphModel.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 7/23/24.
//

import Foundation

enum Surface {
    case Clay
    case Grass
    case Hard
}

struct PercentPoint: Identifiable, Codable {
    var id = UUID().uuidString
    var point: Int
    var percent: Float
    
}

struct sortedPoint: Identifiable, Codable {
    var id = UUID().uuidString
    var point: Point
    var owner: Int
}

struct Point: Identifiable, Codable {
    var id = UUID().uuidString
    var point: Int
    var server: Int
    var game: Int
    var gameN: Int
    var firstServeIn: Bool
    
    var keyShotType: String
    var shotType: String
    var stroke: String
    var location: String
    
    var cause: String
    var comment: String
    var rallyLength: String
    var additionalTrackers: [String]
    var set: Int
    var breakp: Bool
    var breakpcon: Bool
}

struct FileData: Codable {
    let match: Int
    let results1: [Point]
    let results2: [Point]
    
    let name1: String
    let name2: String
    let tiebreakThird: Bool
    let surface: String
    let matchLength: Int
    let setLen: Int
    let time: String
    let date: Date
    let ads: Bool
    let games11: Int
    let games21: Int
    let games12: Int
    let games22: Int
    let games13: Int
    let games23: Int
    let delete: Bool
    let additionalTrackers: [String]
    let superPoints1: Int
    let superPoints2: Int
}
