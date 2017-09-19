//
//  LTGoogleManager.swift
//  LTMap
//
//  Created by aken on 2017/6/14.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation

struct LTGoogleManager:MXGoogleSession {
    
    
    func request<T: LTGoogleRequest>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        
        let url = URL(string: r.path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        var request = URLRequest(url: url!)

        request.httpMethod = r.method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) {
            data, res, error  in
   
            if let data = data, let res = T.Response.parse(data: data, type: r.parseType) {
                
                DispatchQueue.main.async {
                    handler(res)
                }
                
            } else {
                
                DispatchQueue.main.async {
                    handler(nil)
                }
            }
            
        }
        
        task.resume()
        
    }
}
