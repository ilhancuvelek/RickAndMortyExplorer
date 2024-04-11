//
//  CharacterViewModel.swift
//  RickAndMortyApp
//
//  Created by İlhan Cüvelek on 10.04.2024.
//

import Foundation
import RxSwift
import RxCocoa

class CharacterViewModel{
    
    let characters:PublishSubject<[Character]>=PublishSubject()
    let errors:PublishSubject<String>=PublishSubject()
    let loading:PublishSubject<Bool>=PublishSubject()
    let filterCharacters:PublishSubject<[Character]>=PublishSubject()
    
    func requestData(){
        
        self.loading.onNext(true)
        
        let url=URL(string: "https://rickandmortyapi.com/api/character")
        
        WebService().getCharacterInfo(url: url!) { [self] result in
            
            self.loading.onNext(false)
            
            switch result{
            case .success(let apiResponse):
                characters.onNext(apiResponse.results)
            case .failure(let error):
                switch error{
                case .parsingError:
                    print("parsing error")
                case.serverError:
                    print("service error")
                }
            }
        }
    }
    
    func filterCharacter(name: String? = nil, status: String? = nil, species: String? = nil, type: String? = nil, gender: String? = nil) {
        self.loading.onNext(true)
        
        var filterURLString = "https://rickandmortyapi.com/api/character?"
        
        var filterQueries = [String]()
        if let name = name {
            filterQueries.append("name=\(name)")
        }
        if let status = status {
            filterQueries.append("status=\(status)")
        }
        if let species = species {
            filterQueries.append("species=\(species)")
        }
        if let type = type {
            filterQueries.append("type=\(type)")
        }
        if let gender = gender {
            filterQueries.append("gender=\(gender)")
        }
        
        filterURLString += filterQueries.joined(separator: "&")
        
        guard let filterURL = URL(string: filterURLString) else {
            self.loading.onNext(false)
            self.errors.onNext("Invalid filter URL")
            return
        }
        
        WebService().getCharacterInfo(url: filterURL) { [weak self] result in
            self?.loading.onNext(false)
            
            switch result {
            case .success(let apiResponse):
                self?.filterCharacters.onNext(apiResponse.results)
            case .failure(let error):
                switch error {
                case .parsingError:
                    self?.errors.onNext("Parsing error")
                case .serverError:
                    self?.errors.onNext("Service error")
                }
            }
        }
    }


}
