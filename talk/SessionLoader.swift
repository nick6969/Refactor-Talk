//
//  LoadDataType.swift
//  talk
//
//  Created by 游宗諭 on 2020/9/29.
//

import Foundation

///
///  the same
/// 1. URLSession
/// 2. (Data, Res, Error) -> Void
/// 3. JSON decode
///   not the same
/// 1. URL
/// 2. Request
/// 3. Decodable 的型別
///

enum LoaderError {
    case urlSessionError(Error)
    case noData
    case decodeError(Error)
    
    var message: String {
        switch self {
        case let .urlSessionError(err):
            return err.localizedDescription
        case .noData:
            return "Server return empty data"
        case let .decodeError(err):
            return err.localizedDescription
        }
    }
}

class SessionLoader<DecodeType : Decodable> {
    
   init(request: URLRequest) {
        self.request = request
    }
    
    let request: URLRequest
    
    @discardableResult
    func loadData(
        success: ((DecodeType) -> Void)?,
        failure: ((LoaderError) -> Void)?
    ) -> URLSessionTask {
    
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            if err != nil {
                failure?(.urlSessionError(err!))
                return
            }
            guard let data = data else {
                failure?(.noData)
                return
            }
            do {
                let model = try JSONDecoder().decode(DecodeType.self, from: data)
                success?(model)
            } catch {
                failure?(.decodeError(error))
                return
            }
            
        }
        task.resume()
        return task
    }
}
