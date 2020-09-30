//
//  MainVC.swift
//  talk
//
//  Created by Nick on 9/29/20.
//

import UIKit

final class MainVC: BaseTableVC<AreaCell, String> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "區域表"
    }
    override func loadData(success: (([String]) -> Void)?) {
        guard
            let url = URL(string: Settings.apiDomain + "newTaipei/garbageTruck/area") else {
            // precondition < assert < fatalError
           preconditionFailure("URL == nil")
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let loadDataObject = SessionLoader<AreaContentModel>(request: request)
        loadDataObject.loadData{
            model in
            success?(model.data)
        }
    }
    
    override func configCell(model: String, cell: AreaCell) {
        cell.setup(with: model)
    }
    
    override func didSelectCell(indexPath: IndexPath, model: String) {
        let vc = LineVC(area: model)
        self.navigationController?.pushViewController(vc, animated: true)
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

final class LineInfoCell: UITableViewCell {
    
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
    
    func setup(with model: LineInfoModel) {
        label.text = model.id + " \(model.name)"
    }
}
