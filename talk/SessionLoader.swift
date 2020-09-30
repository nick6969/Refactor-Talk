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

class SessionLoader<DecodeType : Decodable> {
   init(request: URLRequest) {
        self.request = request
    }
    
    
    let request: URLRequest
    
    func loadData(success: ((DecodeType) -> Void)?) {
    
        URLSession.shared.dataTask(with: self.request) { data, res, err in
            if err != nil {
                return
            }
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode(DecodeType.self, from: data)
                success?(model)
            } catch {
                print(error)
                return
            }
            
        }.resume()
    }
}
