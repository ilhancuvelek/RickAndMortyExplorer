//
//  CharacterListTableViewCell.swift
//  RickAndMortyApp
//
//  Created by İlhan Cüvelek on 10.04.2024.
//

import UIKit

class CharacterListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isAliveLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    public var character:Character!{
        didSet{
            let imageURLString = character.image

            if let imageURL = URL(string: imageURLString) {
                // UIImage'ı URL'den yükle
                loadImage(from: imageURL) { image in
                    if let image = image {
                        self.characterImage.image=image
                    } else {
                        // UIImage yüklenemedi
                        print("Hata: Resim yüklenemedi.")
                    }
                }
            } else {
                print("Hata: Geçersiz URL.")
            }
            self.nameLabel.text="Name : \(character.name)"
            self.isAliveLabel.text="Status : \(character.status)"
        }
    }

}
