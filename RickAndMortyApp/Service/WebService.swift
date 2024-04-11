//
//  WebService.swift
//  RickAndMortyApp
//
//  Created by İlhan Cüvelek on 10.04.2024.
//

import Foundation

enum ApiError:Error{
    case serverError
    case parsingError
}

class WebService{
    
    func getCharacterInfo(url:URL,completion: @escaping (Result<ApiResponse,ApiError>)->()){
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(.failure(.serverError))
            }else if let data=data{
                let apiResponse = try? JSONDecoder().decode(ApiResponse.self, from: data)
                if let apiResponse=apiResponse{
                    completion(.success(apiResponse))
                }else{
                    completion(.failure(.parsingError))
                }
            }
        }.resume()
    }
}
