//
//  PicsumService.swift
//  PicsumApp
//
//  Created by Марк Михайлов on 26.03.2023.
//

import Foundation
import UIKit

final class NetworkingService {
    
    //MARK: - Properties
    private let imageStorage: ImageStorageService = .init()
    private let urlSession: URLSession
        
    init() {
        urlSession = .init(configuration: .default)
    }
    
    typealias ImageCompletion = (_ picId: String, _ image: UIImage?, _ errorString: String?) -> Void
    
    // MARK: - Fetch Images
    func getImage(id: Int, completion: @escaping ImageCompletion) {
        let dataTask: URLSessionDataTask?
        let urlStirng = "https://picsum.photos/id/\(id)/info"
        guard let url = URL(string: urlStirng) else {return}
        let request = URLRequest(url: url)
        dataTask =
            urlSession.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    print(error)
                }
                if let jsonData = data {
                    do {
                        let pic: ImageModel = try JSONDecoder().decode(ImageModel.self, from: jsonData)
                        let mqPic = "https://picsum.photos/id/\(pic.id)/400/400"
                        self.downloadImage(link: mqPic, completion: completion)
                    } catch {
                        print(error.localizedDescription)
                        var error = ""
                        if let dataString = data {
                            error = String(decoding: dataString, as: UTF8.self)
                        }
                        completion("\(id)", nil, "Id \(id) Error \(error)")
                    }
                }
            })
        dataTask?.resume()
    }
    
    private func downloadImage(link: String, completion: @escaping ImageCompletion) {
        guard let url = URL(string: link) else {
            print("error")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                print("error")
                completion(link, nil, "Error \(String(describing: response)) \(String(describing: error))")
                return
            }
            completion(link, image, nil)
        }.resume()
    }
    
    func storeFavorited(picId: Int, image: UIImage) {
        imageStorage.store(image: image, forKey: String(picId))
        let defaults = UserDefaults.standard
        var allFavorites = defaults.object(forKey: "StoredPictures") as? [Int] ?? [Int]()
        allFavorites.append(picId)
        defaults.set(allFavorites, forKey: "StoredPictures")
    }
    
    func getAllFavorites() -> [Int] {
        UserDefaults.standard.object(forKey: "StoredPictures") as? [Int] ?? [Int]()
    }
    
    func getFavoritedImage(picId: Int) -> UIImage? {
        if let image = imageStorage.readImage(forKey: String(picId)) {
            return image
        }
        return nil
    }
    
}


