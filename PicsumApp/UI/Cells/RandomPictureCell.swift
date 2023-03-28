//
//  RandomPictureCell.swift
//  PicsumApp
//
//  Created by Марк Михайлов on 25.03.2023.
//

import UIKit

final class RandomPictureCell: UITableViewCell {
    
    //MARK: - Properties
    private let picsumService: NetworkingService = .init()
    private var currentId: Int = 0
    
    private lazy var labelView: UILabel = .init(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: UIScreen.main.bounds.width,
                                                              height: UIScreen.main.bounds.width))
    private lazy var loadingView: UIActivityIndicatorView = .init(style: .large)
    private lazy var cellImageView: UIImageView = .init(frame: CGRect(x: 0,
                                                                      y: 0,
                                                                      width: UIScreen.main.bounds.width,
                                                                      height: UIScreen.main.bounds.width))
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(cellImageView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView)
        centerConstraints(loadingView)
    }
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        // invalidate
        labelView.removeFromSuperview()
        cellImageView.image = nil
        currentId = 0
    }
    
    // MARK: - Load random image
    func loadRandomImage(id: Int) {
        showLoading()
        currentId = id
        picsumService.getImage(id: id) { picId, image, errorString in
            DispatchQueue.main.async {
                if let errorString = errorString {
                    self.showError(error: errorString)
                    return
                }
                self.cellImageView.image = image
                self.hideLoading()
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped))
                tap.numberOfTapsRequired = 2
                self.addGestureRecognizer(tap)
            }
        }
    }
    
    //MARK: - Private Functions
    private func hideLoading() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
    private func showLoading() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    private func showError(error: String) {
        self.hideLoading()
        self.backgroundColor = .gray
        self.labelView.text = error
        self.labelView.textAlignment = .center
        self.addSubview(self.labelView)
        self.centerConstraints(self.labelView)
        print(error)
    }
    
    private func centerConstraints(_ uiView: UIView) {
        uiView.centerXAnchor.constraint(greaterThanOrEqualTo: self.centerXAnchor).isActive = true
        uiView.centerYAnchor.constraint(greaterThanOrEqualTo: self.centerYAnchor).isActive = true
    }
    
    //MARK: - Objc Functions
    @objc func doubleTapped() {
        if let image = cellImageView.image {
            self.picsumService.storeFavorited(picId: currentId, image: image)
            NotificationCenter.default.post(name: .addedToFavorite, object: nil)
        }
    }
    
}

