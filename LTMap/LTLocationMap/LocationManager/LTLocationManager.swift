//
//  LTLocationManager.swift
//  LTMap
//
//  定位管理类
//  Created by aken on 2017/6/2.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit

struct LTLocationManagerDefaultConfig {
    
    static let defaultLocationTimeout: NSInteger = 6
    static let defaultReGeocodeTimeout: NSInteger = 3
}

final class LTLocationManager : NSObject {

    
    lazy var locationManager = AMapLocationManager()
    
    var completionBlock: AMapLocatingCompletionBlock!
    
    // MARK -- 公共属性
    // 经纬度
    var location:CLLocationCoordinate2D?
    
    // 当前地址
    var address:String?
    
    // 省/直辖市
    var province:String?
    
    // 当前城市
    var city:String?
    
    // 区
    var district:String?
    
    // 国家
    var country:String?
  
    // 单例实例化
    static let shared = LTLocationManager()
    
    
    private override init(){
        
        super.init()
        
        createCompleteBlock()
        configLocationManager()
    }
    
    // MARK -- 公共方法
    func startUpdatingLocation() {
        
        locationManager.requestLocation(withReGeocode: true, completionBlock: completionBlock)
    }
    
    // MARK -- 私有方法
    fileprivate func configLocationManager() {
        
        AMapServices.shared().apiKey = LTLocationMapCommon.AMapServicesApiKey
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
//        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.locationTimeout = LTLocationManagerDefaultConfig.defaultLocationTimeout
        
        locationManager.reGeocodeTimeout = LTLocationManagerDefaultConfig.defaultReGeocodeTimeout
        
    }
    
    fileprivate func createCompleteBlock() {
    
        completionBlock = { [weak self] (location: CLLocation?, regeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    print("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    print("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                
            }
            
            if let location = location {
                
                self?.location = location.coordinate

                if let regeocode = regeocode {
                    
                    self?.address = regeocode.formattedAddress
                    self?.city = regeocode.city
                    self?.district = regeocode.district
                    self?.province = regeocode.province
                    self?.country = regeocode.country
                    
                }
            }
            
        }
        
    }
}

extension LTLocationManager : AMapLocationManagerDelegate {
    
    
}
