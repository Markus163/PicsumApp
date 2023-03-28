//
//  RandomViewController.swift
//  PicsumApp
//
//  Created by Марк Михайлов on 25.03.2023.
//

import UIKit

class RandomViewController: UIViewController {
    
    //MARK: - Properties
    private var items: [Int] = []
    private var cellId = "itemCell"
    private var isLoading = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Random"
        setupData()
        setupTable()
        NotificationCenter.default.addObserver(self, selector: #selector(onAddedToFavorite(_:)), name: .addedToFavorite, object: nil)
    }
    
    //MARK: - Private Functions
    private func setupData() {
        // Skeleton
        for _ in 1...1000 {
            items.append(Int.random(in: 1...1000))
        }
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RandomPictureCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 420
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    private func showSuccessPopup() {
        let alert = UIAlertController(title: "Success", message: "Added to Favorites", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Objc Function
    @objc func onAddedToFavorite(_ notification: Notification) {
        showSuccessPopup()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension RandomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if let randomPictureCell = cell as? RandomPictureCell {
            randomPictureCell.loadRandomImage(id: items[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
}
