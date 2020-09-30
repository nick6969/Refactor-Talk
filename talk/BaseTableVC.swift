//
//  BaseTableVC.swift
//  talk
//
//  Created by Nick on 9/29/20.
//

import UIKit

class BaseTableVC<Cell: UITableViewCell, Model: Codable>: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - NEED OVERRIDE
    func loadData(success: (([Model]) -> Void)?) {
        fatalError()
    }
    
    func configCell(model: Model, cell: Cell) {
        fatalError()
    }
    
    // MARK: - YOU CAN CHOICE OVERRIDE OR NOT
    func didSelectCell(indexPath: IndexPath, model: Model) { }
    
    // MARK: - IMPLEMENT
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.registerCell(type: Cell.self)
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    var models: [Model] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.mLay(pin: .zero)
        loadData { models in
            DispatchQueue.main.async {
                self.models = models
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: Cell.self)
        configCell(model: models[indexPath.row], cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        didSelectCell(indexPath: indexPath, model: models[indexPath.row])
    }
    
}

