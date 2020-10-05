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
    
    override func loadData(success: (([LineInfoModel]) -> Void)?, failure: ((LoaderError) -> Void)?) {
        let url = URL(string: Settings.apiDomain + "newTaipei/garbageTruck/lines")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = """
            {
                "area": "\(area)"
            }
            """.data(using: .utf8)!


        let loadDataObject = SessionLoader<LineContentModel>(request: request)
        let successHandle: (LineContentModel) -> Void = { success?($0.data) }
        loadDataObject.loadData (success: successHandle, failure: failure)
    }
    
    override func configCell(model: LineInfoModel, cell: LineInfoCell) {
        cell.setup(with: model)
    }
    override func didSelectCell(indexPath: IndexPath, model: LineInfoModel) {
        let id = model.id
        let vc = LineDetailVC(lineID: id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

struct LineContentModel: Codable {
    let data: [LineInfoModel]
}

struct LineInfoModel: Codable {
    let id: String
    let name: String
}

