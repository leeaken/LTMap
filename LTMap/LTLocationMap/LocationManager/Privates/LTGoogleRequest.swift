//
//  LTGoogleRequest.swift
//  LTMap
//
//  谷歌service poi搜索
//  Created by aken on 2017/6/14.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation

enum MXGoogleHTTPMethod: String {
    
    case GET,POST
}

struct LTGoogleRequestCommon {
    
    static let GoogleRequestAutocompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    static let GoogleRequestNearbysearchUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    static let GoogleRequestPlaceDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json"
    static let GoogleRequestGeocodingUrl = "https://maps.googleapis.com/maps/api/geocode/json"
    //
    static let GoogleRequestRadius = "1000"
}

protocol LTGoogleRequest {
    
    var path:String { get }
    var method:MXGoogleHTTPMethod { get }
    var parameter: [String:Any] { get }
    var parseType: LTGoogleParseModelType { get }
    associatedtype Response:LTGoogleModelDecodable
    
}

protocol MXGoogleSession {
    
    func request<T: LTGoogleRequest>(_ r: T, handler: @escaping (T.Response?) -> Void)

}

protocol LTGoogleModelDecodable {
    
    static func parse(data:Data,type:LTGoogleParseModelType) -> Self?
}


class MXGooglAutoCompleteRequest: LTGoogleRequest {
    
    var requestParameter:[String: Any]?
    
    init(requestParameter:[String: Any]) {
        
        self.requestParameter = requestParameter
    }
    
    let method: MXGoogleHTTPMethod = .GET
    
    let parseType: LTGoogleParseModelType = .LTGoogleParseAutocomplete
    
    var parameter: [String : Any] {
        
        return self.requestParameter!
    }

    typealias Response = LTGoogleModel
    
    var path: String {
        
        let input:String = self.requestParameter!["input"] as! String
        let radius = LTGoogleRequestCommon.GoogleRequestRadius
        let key = LTLocationMapCommon.GoogleServicesApiKey
        let loc:String = self.requestParameter!["location"] as! String
        
        if let pagetoken:String = self.requestParameter!["pagetoken"] as? String {
            
            let url = LTGoogleRequestCommon.GoogleRequestAutocompleteUrl+"?sensor=true&input=\(input)&radius=\(radius)&key=\(key)&location=\"\(loc)\"&pagetoken=\(pagetoken)"
            
            return url;
        }
        

        return LTGoogleRequestCommon.GoogleRequestAutocompleteUrl+"?sensor=true&input=\(input)&radius=\(radius)&key=\(key)&location=\"\(loc)\""
    }
}

class MXGooglNearbysearchRequest: LTGoogleRequest {
    
    var requestParameter:[String: Any]?
    
    init(requestParameter:[String: Any]) {
        
        self.requestParameter = requestParameter
    }
    
    let method: MXGoogleHTTPMethod = .GET
    
    let parseType: LTGoogleParseModelType = .LTGoogleParseNearby
    
    var parameter: [String : Any] {
        
        return self.requestParameter!
    }
    
    typealias Response = LTGoogleModel
    
    var path: String {
        
        let input:String = self.requestParameter!["input"] as! String
        let radius = LTGoogleRequestCommon.GoogleRequestRadius
        let key = LTLocationMapCommon.GoogleServicesApiKey
        let loc:String = self.requestParameter!["location"] as! String
        
        if let pagetoken:String = self.requestParameter!["pagetoken"] as? String {
            
            let url = LTGoogleRequestCommon.GoogleRequestNearbysearchUrl+"?sensor=true&keyword=\(input)&radius=\(radius)&key=\(key)&location=\(loc)&pagetoken=\(pagetoken)"
            
            return url
        }
        
        let url = LTGoogleRequestCommon.GoogleRequestNearbysearchUrl+"?sensor=true&keyword=\(input)&radius=\(radius)&key=\(key)&location=\(loc)"
        
        
        return url
        
    }
}
