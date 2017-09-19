//
//  LTGoogleGeocode.swift
//  LTMap
//
//  使用google webservice地理编译
//  Created by aken on 2017/6/14.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation

class LTGoogleGeocode: NSObject,LTGeocodeProtocol {
    
    let type: LTGeocodeType = .LTAbroad
    
    fileprivate var dataCompletion:SearchCompletion?
    
    fileprivate var pagetoken:String?

    override init() {
        
    }
    

    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D,completion:@escaping(SearchCompletion)) {
        
        
    }
    

    func searchNearbyWithCoordinate(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {
        
        dataCompletion = completion
        
        var keywork:String = ""
        
        if (param.keyword == nil) {
            
            keywork = ""
            
        }else {
            
            keywork = param.keyword!
        }
        
        var location:String = ""
        if let lat = param.location?.latitude , let log = param.location?.longitude {
            
            location = "\(String(describing: lat)),\(String(describing: log))"
        }

        var parameter: [String: Any]
        
        if pagetoken==nil {
            
            parameter = ["input":keywork,
                         "location":location]
        }else {
            
            parameter = ["input":keywork,
                         "location":location,
                         "pagetoken":pagetoken!]
        }

        let request = MXGooglNearbysearchRequest(requestParameter: parameter)
        
        LTGoogleManager().request(request) { [weak self] (model) in
            
            if let model = model {
                
                var poiArray = [LTPoiModel]()
                
                if (model.models != nil && (model.models?.count)! > 0) {
                    
                    for infos in model.models! {
                        
                        let poi = LTPoiModel()
                        poi.uid = infos.uid
                        poi.title = infos.title
                        poi.subtitle = infos.subtitle
                        poi.coordinate = infos.coordinate
                        
                        self?.pagetoken = infos.pagetoken
                        
                        poiArray.append(poi)
                    }
                }
                
                
                if let closure = self?.dataCompletion {
                    
                    if self?.pagetoken == nil {
                        
                         closure(poiArray,false)
                        
                    }else {
                        
                        closure(poiArray,true)
                    }

                }
  
            }
        }

    }
    

    func searchInputTipsAutoCompletionWithKeyword(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {
        
        searchPlaceWithKeyWord(param: param, completion: completion)
    }

    
    func searchPlaceWithKeyWord(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {
        
        searchNearbyWithCoordinate(param: param, completion: completion)
        
    }
    
    // 此函数搜索返回的数据量少
    private func autoCompleteWithKeyWord(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {
    
        dataCompletion = completion
        
        let keywork:String = param.keyword!
        
        var location:String = ""
        if let lat = param.location?.latitude , let log = param.location?.longitude {
            
            location = "\(String(describing: lat)),\(String(describing: log))"
        }
        
        
        var parameter: [String: Any]
        
        if pagetoken==nil {
            
            parameter = ["input":keywork,
                         "location":location]
        }else {
            
            parameter = ["input":keywork,
                         "location":location,
                         "pagetoken":pagetoken!]
        }
        
        let request = MXGooglAutoCompleteRequest(requestParameter: parameter)
        
        LTGoogleManager().request(request) { [weak self] (model) in
            
            if let model = model {
                
                var poiArray = [LTPoiModel]()
                
                for infos in model.models! {
                    
                    let poi = LTPoiModel()
                    poi.uid = infos.uid
                    poi.title = infos.title
                    poi.subtitle = infos.subtitle
                    self?.pagetoken = infos.pagetoken
                    
                    poiArray.append(poi)
                }
                
                if let closure = self?.dataCompletion {
                    
                    if self?.pagetoken == nil {
                        
                        closure(poiArray,false)
                        
                    }else {
                        
                        closure(poiArray,true)
                    }
                    
                }
                
                
            }
        }

        
    }
}
