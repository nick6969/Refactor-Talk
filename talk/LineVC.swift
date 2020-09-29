//
//  LineVC.swift
//  talk
//
//  Created by Nick on 9/29/20.
//

import UIKit

final class LineVC: BaseTableVC<LineInfoCell, LineInfoModel> {
    
    private let area: String

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
    }
    
    override func loadData(success: (([LineInfoModel]) -> Void)?) {
        var request: URLRequest = URLRequest(url: URL(string: "https://4ece5861a7d6.ngrok.io/newTaipei/garbageTruck/lines")!)
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
                success?(model.data)
            } catch {
                print(error)
                return
            }

        }.resume()
    }
    
    override func configCell(model: LineInfoModel, cell: LineInfoCell) {
        cell.setup(with: model)
    }
    
}

struct LineContentModel: Codable {
    let data: [LineInfoModel]
}

struct LineInfoModel: Codable {
    let id: String
    let name: String
}

