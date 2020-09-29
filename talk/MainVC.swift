//
//  MainVC.swift
//  talk
//
//  Created by Nick on 9/29/20.
//

import UIKit

final class MainVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.registerCell(type: AreaCell.self)
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var models: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.mLay(pin: .zero)
        loadData()
    }

    private
    func loadData() {
        
        var request: URLRequest = URLRequest(url: URL(string: "https://e12d2071b3fe.ngrok.io/newTaipei/garbageTruck/area")!)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            if err != nil {
                return
            }
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode(AreaContentModel.self, from: data)
                DispatchQueue.main.async {
                    self.models = model.data
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
                return
            }
            
        }.resume()
    }
    
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: AreaCell.self)
        cell.setup(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

struct AreaContentModel: Codable {
    let data: [String]
}

final class AreaCell: UITableViewCell {
    
    private var label: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        label.mLay(pin: .init(top: 20, leading: 20, bottom: 20, trailing: 20))
    }
    
    func setup(with model: String) {
        label.text = model
    }
}
