//
//  LTGaodeGeocode.swift
//  LTMap
//
//  高德poi搜索
//  Created by aken on 2017/6/14.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation

class LTGaodeGeocode: NSObject,LTGeocodeProtocol {
    
    let type: LTGeocodeType = .LTCN
    
    fileprivate var dataCompletion:SearchCompletion?
    
    private lazy var searchPoi:AMapSearchAPI = {
        
        let search = AMapSearchAPI()
        search?.delegate = self
        
        return search!
        
    }()
    
    private lazy var searchRequest:AMapPOIAroundSearchRequest = {
        
        let searchReq = AMapPOIAroundSearchRequest()
        
        return searchReq
        
    }()
    
    private lazy var searchInputTips:AMapInputTipsSearchRequest = {
        
        let searchInput = AMapInputTipsSearchRequest()
        
        return searchInput
        
    }()
    
    private lazy var searchPoiKeywordRequest:AMapPOIKeywordsSearchRequest = {
        
        let searchPoiKey = AMapPOIKeywordsSearchRequest()
        
        return searchPoiKey
        
    }()
    
    private lazy var reGeocode:AMapReGeocodeSearchRequest = {
        
        let reGeocodeRequest = AMapReGeocodeSearchRequest()
        
        return reGeocodeRequest
        
    }()
    
    override init(){
        
        super.init()
        
        AMapServices.shared().apiKey = LTLocationMapCommon.AMapServicesApiKey
    }
    
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D,completion:@escaping(SearchCompletion)) {
        
        if !CLLocationCoordinate2DIsValid(coordinate) {
            
            print("输入的经纬度不合法")
            return
        }
        
        reGeocode.location = AMapGeoPoint.location(withLatitude:CGFloat((coordinate.latitude)), longitude: CGFloat((coordinate.longitude)))
        searchPoi.aMapReGoecodeSearch(reGeocode)
        
        dataCompletion = completion
        
    }
    
    func searchNearbyWithCoordinate(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {
        
        guard let coordinate = param.location,CLLocationCoordinate2DIsValid(coordinate) else {
            
            print("输入的经纬度不合法")
            return
        }
        
        // 配置搜索参数
        
        searchRequest.location = AMapGeoPoint.location(withLatitude:CGFloat((param.location?.latitude)!), longitude: CGFloat((param.location?.longitude)!))
        
        searchRequest.requireExtension = true
        searchRequest.offset = param.offset!
        searchRequest.page = param.page!
        searchRequest.radius = param.radius!
        searchPoi.aMapPOIAroundSearch(searchRequest)
        
        dataCompletion = completion
        
    }
    
    func searchInputTipsAutoCompletionWithKeyword(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {
        
        dataCompletion = completion
        
        if let keyword = param.keyword,
            let city = param.city {
            
            searchInputTips.keywords = keyword
            searchInputTips.city = city
            //AMapInputTipsSearch
            searchPoi.aMapInputTipsSearch(searchInputTips)
            
        }
        
    }
    
    func searchPlaceWithKeyWord(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {
        
        dataCompletion = completion
        
        if let keyword = param.keyword,
            let city = param.city  {
            
            searchPoiKeywordRequest.page = param.page!
            searchPoiKeywordRequest.offset = param.offset!
            
            //
            searchPoiKeywordRequest.keywords = keyword
            searchPoiKeywordRequest.city = city
            searchPoiKeywordRequest.requireExtension = true
            //AMapPOIKeywordsSearch
            searchPoi.aMapPOIKeywordsSearch(searchPoiKeywordRequest)
        }
    }
}

// MARK: -- AMapSearchDelegate
extension LTGaodeGeocode : AMapSearchDelegate {
    
    // AMapReGeocodeSearchRequest
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
        //        print("response :\(response.formattedDescription())")
        
        var poiArray = [LTPoiModel]()
        
        if (response.regeocode != nil) {
            
            
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            
            let model = LTPoiModel()
            model.coordinate = coordinate
            model.title = response.regeocode.addressComponent.township
            model.subtitle = response.regeocode.formattedAddress
            model.city = response.regeocode.addressComponent.city
            
            poiArray.append(model)
            
        }
        
        if let closure = dataCompletion {
            
            closure(poiArray,poiArray.count)
        }
        
        
    }
    
    // AMapSearchAPI--Delegate
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        var poiArray = [LTPoiModel]()
        
        let array = response.pois.enumerated()
        
        for (_, value) in array {
            
            let model = value as AMapPOI
            
            let poi = LTPoiModel()
            poi.uid = model.uid!
            poi.title = model.name!
            poi.subtitle = model.address!
            poi.city = model.city!
            poi.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(model.location.latitude), CLLocationDegrees(model.location.longitude))
            
            poiArray.append(poi)
            
            
        }
        
        
        
        let totalPageNum:Int = (response.count  +  request.offset  - 1) / request.offset;
//        
        var hasNext:Bool = true
        
        if totalPageNum == request.page {
            
            hasNext = false
            
        }else if (response.count == 0) {
            hasNext = false
        }

        print("totalPage:\(String(describing: totalPageNum))---currentPage:\(String(describing: request.page))")

        
        if let closure = dataCompletion {
            
            closure(poiArray,hasNext)
        }
    }
    
    // AMapInputTipsSearchRequest -- delegate
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        
        
        var poiArray = [LTPoiModel]()
        
        let array = response.tips.enumerated()
        
        for (_, value) in array {
            
            let model = value as AMapTip
            
            let poi = LTPoiModel()
            poi.uid = model.uid!
            poi.title = model.name!
            poi.subtitle = model.address!
            poi.city = model.adcode!
            
            
            if let coor = model.location {
                
                poi.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(coor.latitude), CLLocationDegrees(coor.longitude))
            }
            
            
            poiArray.append(poi)
            
            
        }
        
        if let closure = dataCompletion {
            
            closure(poiArray,response.count)
        }
        
    }
}
