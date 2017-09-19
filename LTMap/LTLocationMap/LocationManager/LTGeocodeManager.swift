//
//  LTGeocodeManager.swift
//  LTMap
//
//  POI地理位置搜索
//  国内调用高德poi,国外使用谷歌webservice

//  Created by aken on 2017/6/2.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit

class LTGeocodeManager {
    
    fileprivate var dataCompletion:SearchCompletion?
    
    fileprivate var searchManager:LTGeocodeProtocol?
    
    private var location:CLLocationCoordinate2D?
    
    
    /// 默认构造是用国内高德poi
    init(){
        
        searchManager = createSearchCountry(type: .LTCN)
        
    }
    
    
    /// 通过构造参数经纬度来初始化poi搜索，国内使用高德，国外使用谷歌
    ///
    /// - Parameter coordinate: 经纬度
    init(coordinate:CLLocationCoordinate2D) {
        
        location = coordinate
        
        if isInChina() {
            
            searchManager = createSearchCountry(type: .LTCN)
            
        } else {
            
            searchManager = createSearchCountry(type: .LTAbroad)
        }
    }
    
    /// MARK: -- 私有方法
    private func isInChina() ->Bool {
        
        // 默认为中国
        if !CLLocationCoordinate2DIsValid(location!) {
            
            return true
        }
        
        return AMapLocationDataAvailableForCoordinate(location!)
    }
    
    private func createSearchCountry(type:LTGeocodeType) -> LTGeocodeProtocol? {
        
        switch type {
            
        case .LTCN:
            
            return LTGaodeGeocode()
            
        case.LTAbroad:
            
            return LTGoogleGeocode()
            
        }
        
    }

    func switchSearchCountry(type:LTGeocodeType) {
    
        // 如果当前type已经创建了，则直接返回
        if searchManager?.type != type {
            
            searchManager = createSearchCountry(type:type)
        }
        
    }
    
    /// MARK: -- 公共方法
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D,completion:@escaping(SearchCompletion)) {
        
        if !CLLocationCoordinate2DIsValid(coordinate) {

            print("输入的经纬度不合法")
            return
        }
        
        searchManager?.searchReGeocodeWithCoordinate(coordinate: coordinate, completion: completion)
        
    }

    func searchNearbyWithCoordinate(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {
        
        guard let coordinate = param.location,CLLocationCoordinate2DIsValid(coordinate) else {
            
            print("输入的经纬度不合法")
            return
        }
        
        searchManager?.searchNearbyWithCoordinate(param: param, completion: completion)
    }
    
    func searchInputTipsAutoCompletionWithKeyword(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {
        
        
        searchManager?.searchInputTipsAutoCompletionWithKeyword(param: param, completion: completion)

        
    }

    func searchPlaceWithKeyWord(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion)) {

        
        searchManager?.searchPlaceWithKeyWord(param: param, completion: completion)
    }
}

