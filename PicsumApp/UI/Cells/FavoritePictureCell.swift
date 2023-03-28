//
//  FavoritedPictureCell.swift
//  PicsumApp
///Users/markmihaylov/Desktop/PicsumApp/PicsumApp/UI/Cells/FavoritedPictureCell.swift
//  Created by Марк Михайлов on 25.03.2023.
//

import UIKit

final class FavoritePictureCell: UITableViewCell {
    
    //MARK: - Properties
    private  let networkingService: NetworkingService = .init()
    private  let cellImageView: UIImageView = .init(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: UIScreen.main.bounds.width,
                                                         height: UIScreen.main.bounds.width))
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(cellImageView)
    }
    
    func getStoredPicture(picId: Int) {
        if let image = networkingService.getFavoritedImage(picId: picId) {
            cellImageView.image = image
        }
    }
    
    override func prepareForReuse() {
        cellImageView.image = nil
    }
    
}

