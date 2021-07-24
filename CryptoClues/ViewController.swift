//
//  ViewController.swift
//  CryptoClues
//
//  Created by Dala  on 7/23/21.
//

import UIKit

//API Caller
// UI To display crypto
// MVVM

class ViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModels = [CryptoTableViewCellViewModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Crypto Tracker"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        APICaller.shared.getAllCryptoData { [weak self] result in
            
            switch result {
            case .success(let models):
                self?.viewModels = models.compactMap({ CryptoTableViewCellViewModel(
                    //Number Formatter
                    
                    name: $0.name ?? "",
                    symbol: $0.asset_id,
                    price:"$1")
                    
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as! CryptoTableViewCell
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}
