//
//  LineVC.swift
//  talk
//
//  Created by Nick on 9/29/20.
//

import UIKit
/**
 curl -X POST "https://4ece5861a7d6.ngrok.io/newTaipei/garbageTruck/detail"
 -H  "accept: application/json"
 -H  "Content-Type: application/json"
 -d "{  \"lineID\": \"251001\"}"
 */
final class LineDetailVC: BaseTableVC<LineDetailCell, LineDetailModel> {
    
    private let lineID: String

    init(lineID: String) {
        self.lineID = lineID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = lineID + " 路線清單"
    }
    /// curl -X POST "https://4ece5861a7d6.ngrok.io/newTaipei/garbageTruck/detail"
    /// -H  "accept: application/json"
    /// -H  "Content-Type: application/json"
    /// -d "{  \"lineID\": \"251001\"}"
    override func loadData(success: (([LineDetailModel]) -> Void)?, failure: ((LoaderError) -> Void)?) {
        let url = URL(string: Settings.apiDomain + "newTaipei/garbageTruck/detail")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = """
            {
                "line_id": "\(lineID)"
            }
            """
        request.httpBody = body.data(using: .utf8)!

        let loadDataObject = SessionLoader<LineDetailContentModel>(request: request)
        let successHandle: (LineDetailContentModel) -> Void = { success?($0.data) }
        loadDataObject.loadData (success: successHandle, failure: failure)
    }
    
    override func configCell(model: LineDetailModel, cell: LineDetailCell) {
        cell.setup(with: model)
    }
    
}

/**
 GarbageTruck{
 FoodScrapsFriday    boolean
 FoodScrapsMonday    boolean
 FoodScrapsSaturday    boolean
 FoodScrapsSunday    boolean
 FoodScrapsThursday    boolean
 FoodScrapsTuesday    boolean
 FoodScrapsWednesday    boolean
 LineID    string
 city    string
 */
struct LineDetailContentModel: Codable {
    let data: [LineDetailModel]
}
struct LineDetailModel: Codable {
    let FoodScrapsFriday:       Bool
    let FoodScrapsMonday:       Bool
    let FoodScrapsSaturday:     Bool
    let FoodScrapsSunday:       Bool
    let FoodScrapsThursday:     Bool
    let FoodScrapsTuesday:      Bool
    let FoodScrapsWednesday:    Bool
    let LineID:    String
    let city:      String
    let name:      String
    let time:      String
}


class LineDetailCell: UITableViewCell {
    
    func setup(with model: LineDetailModel) {
        textLabel?.numberOfLines = 0
        textLabel?.text =
            """
            city: \(model.city)
            name: \(model.name)
            """
    }
}
