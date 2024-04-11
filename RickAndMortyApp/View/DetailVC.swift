//
//  DetailVC.swift
//  RickAndMortyApp
//
//  Created by İlhan Cüvelek on 11.04.2024.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    
    var chosenChar:Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text=chosenChar?.name
        statusLabel.text=chosenChar?.status
        speciesLabel.text=chosenChar?.species
        if chosenChar?.type == ""{
            typeLabel.text=" - "
        }else{
            typeLabel.text=chosenChar?.type
        }
        genderLabel.text=chosenChar?.gender
        originLabel.text=chosenChar?.origin.name
        locationLabel.text=chosenChar?.location.name
        
        let imageURLString = chosenChar?.image

        if let imageURL = URL(string: imageURLString!) {
            // UIImage'ı URL'den yükle
            loadImage(from: imageURL) { [self] image in
                if let image = image {
                    imageView.image=image
                } else {
                    // UIImage yüklenemedi
                    print("Hata: Resim yüklenemedi.")
                }
            }
        } else {
            print("Hata: Geçersiz URL.")
        }

    }
    
    // Bir URL'den UIImage oluştur
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }.resume()
    }
    


}
