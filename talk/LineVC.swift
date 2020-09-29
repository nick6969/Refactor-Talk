//
//  LineVC.swift
//  talk
//
//  Created by Nick on 9/29/20.
//

import UIKit

final class LineVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.registerCell(type: LineInfoCell.self)
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let area: String
    private var models: [LineInfoModel] = []
    
    init(area: String) {
        self.area = area
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = area + " 路線清單"
        
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.mLay(pin: .zero)
        loadData()
    }

    private
    func loadData() {
        
        var request: URLRequest = URLRequest(url: URL(string: "https://e12d2071b3fe.ngrok.io/newTaipei/garbageTruck/lines")!)
        request.httpMethod = "POST"
        request.httpBody = """
            {
                "area": "\(area)"
            }
            """.data(using: .utf8)!
        
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            if err != nil {
                return
            }
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode(LineContentModel.self, from: data)
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

extension LineVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: LineInfoCell.self)
        cell.setup(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

struct LineContentModel: Codable {
    let data: [LineInfoModel]
}

struct LineInfoModel: Codable {
    let id: String
    let name: String
}

