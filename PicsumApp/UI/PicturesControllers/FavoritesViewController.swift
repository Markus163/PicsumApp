//
//  FavoritesViewController.swift
//  PicsumApp
//
//  Created by Марк Михайлов on 25.03.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    //MARK: - Properties
    private var cellId = "itemCell"
    private var items: [Int] = []
    private let picsumService: NetworkingService = .init()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    //MARK: - Private Functions
    private func update() {
        items = picsumService.getAllFavorites()
        tableView.reloadData()
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritePictureCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if let faveCell = cell as? FavoritePictureCell {
            faveCell.getStoredPicture(picId: items[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.width
    }
    
}

