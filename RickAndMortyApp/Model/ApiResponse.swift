//
//  ApiResponse.swift
//  RickAndMortyApp
//
//  Created by İlhan Cüvelek on 10.04.2024.
//

import Foundation

struct ApiResponse: Decodable {
    let info: Info
    let results: [Character]
}
