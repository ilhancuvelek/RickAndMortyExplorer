//
//  Info.swift
//  RickAndMortyApp
//
//  Created by İlhan Cüvelek on 10.04.2024.
//

import Foundation

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
