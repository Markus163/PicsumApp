//
//  PicsumImage.swift
//  PicsumApp
//
//  Created by Марк Михайлов on 26.03.2023.
//

import Foundation

struct ImageModel : Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
