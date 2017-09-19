//
//  LTGoogleModel.swift
//  LTMap
//
//  Google 模型对象信息
//  Created by aken on 2017/6/15.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation
import SwiftyJSON

enum LTGoogleParseModelType: String {
    
    case LTGoogleParseAutocomplete,LTGoogleParseNearby,LTGoogleParsePlaceDetails
}

struct LTGoogleModel {
    
    // ID
    var uid: String?
    
    // 标题
    var title: String?
    
    // 详细描述
    var subtitle: String?
    
    // 城市
    var city: String?
    
    // 地理位置
    var coordinate: CLLocationCoordinate2D?
    
    var models:[LTGoogleModel]?
    
    var pagetoken:String?
    
    init?(data:Data,type:LTGoogleParseModelType) {
        
        if type == .LTGoogleParseAutocomplete {
            
            parseAutocompleteData(data: data)
            
        }else if type == .LTGoogleParseNearby {
            
            parseNearbyData(data: data)
        }
    }
    
    private mutating func parseAutocompleteData(data:Data) {
        
        let json = try? JSON(data: data, options: [.allowFragments])
        
        let status = json!["status"].string
        
        if status == "OK" {
            
            if let array = json!["predictions"].array {
                
                var tempArray = [LTGoogleModel]()
                
                for value in array {
                    
                    self.uid = value["reference"].string
                    self.subtitle = value["description"].string
                    
                    if let sub = value["structured_formatting"].dictionary {
                        
                        self.title = sub["main_text"]?.string
                    }
                    
                    tempArray.append(self)
                }
                
                self.models = tempArray
            }
            
        }
       
    }
    
    private mutating func parseNearbyData(data:Data) {
        
        let json = try? JSON(data: data, options: [.allowFragments])
        
        let status = json!["status"].string
        
        if status == "OK" {
            
            if let array = json!["results"].array {
                
                var tempArray = [LTGoogleModel]()
                
                for value in array {
                    
                    self.uid = value["id"].string
                    self.title = value["name"].string
                    self.subtitle = value["vicinity"].string
                    self.pagetoken = json?["next_page_token"].string
                    
                    if let sub = value["geometry"].dictionary {
                        
                        if let subLoc = sub["location"]?.dictionary {
                            
                            if let lat = subLoc["lat"]?.double, let log = subLoc["lng"]?.double {
                                
                                self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: log)
                            }
                        }
                    }
                    
                    tempArray.append(self)
                }
                
                self.models = tempArray
            }
            
        }
        
    }

}

extension LTGoogleModel:LTGoogleModelDecodable {
    
    static func parse(data:Data,type:LTGoogleParseModelType) -> LTGoogleModel? {
        
        return LTGoogleModel(data: data, type: type)
    }
}

