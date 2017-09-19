//
//  LTGeocodeProtocol.swift
//  LTMap
//
//  编译地理信息

//  Created by aken on 2017/6/14.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation


typealias SearchCompletion=(_ array:[LTPoiModel],_ hasNext:Any)->Void

/// 反地理编码类型
enum LTGeocodeType: String {
    
    case LTCN,LTAbroad  // 国内和国外
}

protocol LTGeocodeProtocol {
    
    
    /// 逆地理编码类型(高德或谷歌)
    var type:LTGeocodeType { get }
    
    /// 逆地理编码
    ///
    ///   - coordinate: 经纬度
    ///   - completion: 回调
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D,completion:@escaping(SearchCompletion))
    
    /// 根据经纬度搜索附近信息
    ///
    ///   - param: 搜索对象参数
    ///   - completion: 回调
    func searchNearbyWithCoordinate(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion))
    
    /// 根据关键字自动联想补全搜索 searchTipsWithKeyword
    ///
    ///   - param: 搜索对象参数
    ///   - completion: 回调
    func searchInputTipsAutoCompletionWithKeyword(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion))
    
    /// 根据关键字和code POI搜索
    ///
    ///   - param: 搜索对象参数
    ///   - completion: 回调
    func searchPlaceWithKeyWord(param:LTPOISearchAroundArg,completion:@escaping(SearchCompletion))
    
}
