//
//  CharacterListVC.swift
//  RickAndMortyApp
//
//  Created by İlhan Cüvelek on 10.04.2024.
//

import RxCocoa
import RxSwift
import UIKit

class CharacterListVC: UIViewController, UITableViewDelegate, UISearchBarDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    

    let rmCharacterVM = CharacterViewModel()
    let disposeBag = DisposeBag()

    var characters = [Character]()
    var filteredCharacters = [Character]()
    
    var selectedCharId = Int()
    var selectedChar:Character?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .green
        navigationController?.navigationBar.tintColor = .green

        //tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        rmCharacterVM.requestData()
        
        fetchData()
        setupBindings()
        filteredCharacters=characters
        
        tableView.delegate=self
        tableView.dataSource=self
        searchBar.delegate = self
        
        indicatorView.isHidden = false 
    }

    func fetchData() {
        rmCharacterVM.characters.observe(on: MainScheduler.asyncInstance).subscribe { characterList in
            self.characters = characterList
            self.filteredCharacters = characterList // Filtrelenmiş karakterlerin başlangıçta tüm karakterlere eşit olmasını sağlar
            self.tableView.reloadData() // TableView'ı güncelle
        }.disposed(by: disposeBag)
    }

    func setupBindings() {
        rmCharacterVM.errors.observe(on: MainScheduler.asyncInstance).subscribe { errorString in
            print(errorString)
        }.disposed(by: disposeBag)
        
        rmCharacterVM.loading.bind(to: indicatorView.rx.isAnimating).disposed(by: disposeBag)

//        rmCharacterVM
//            .characters
//            .observe(on: MainScheduler.asyncInstance)
//            .bind(to: tableView.rx.items(cellIdentifier: "CharacterCell", cellType: CharacterListTableViewCell.self)) { _, item, cell in
//                cell.character = item
//            }.disposed(by: disposeBag)
        
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

       filteredCharacters=[]
        
        if searchText == ""{
            filteredCharacters=characters
        }else{
            for data in characters{
                if data.name.lowercased().contains(searchText.lowercased()){
                    filteredCharacters.append(data)
                }
            }
        }
        
  

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterListTableViewCell
  
        cell.character=filteredCharacters[indexPath.row]

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCharId = filteredCharacters[indexPath.row].id
        self.selectedChar = filteredCharacters[indexPath.row]
        
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"{
            let destinationVC=segue.destination as! DetailVC
            destinationVC.chosenChar=self.selectedChar
        }
    }




}
