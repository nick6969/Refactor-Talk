//
//  UITableViewExtension.swift
//  talk
//
//  Created by Nick on 9/29/20.
//

import UIKit

// swiftlint:disable force_cast
extension UITableView {
    func registerCell<T: UITableViewCell>(type: T.Type) {
        register(type, forCellReuseIdentifier: String(describing: type))
    }
    
    func registerCells<T: UITableViewCell>(types: [T.Type]) {
        types.forEach { registerCell(type: $0) }
    }
    
    func registerNibCell<T: UITableViewCell>(type: T.Type) {
        let className = String(describing: type)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func registerNibCells<T: UITableViewCell>(types: [T.Type]) {
        types.forEach { registerNibCell(type: $0) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: type)) as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: String(describing: type))
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(with type: T.Type) -> T {
        if let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as? T {
            return view
        }
        return type.init(reuseIdentifier: String(describing: type))
    }
}
// swiftlint:enable force_cast
