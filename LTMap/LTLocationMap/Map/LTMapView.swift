//
//  LTMapView.swift
//  LTMap
//
//  Created by aken on 2017/6/12.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation


class LTMapView: UIView,LTMapProtocol {
    
    
    /// 地图对象
    var mapView:LTMapProtocol?
    
    var isMapPanned: Bool = false
    
    var centerCoordinate: CLLocationCoordinate2D? = kCLLocationCoordinate2DInvalid
    
    weak var delegate: LTMapViewDelegate?
    
    var allowLongPressAddPointAnnotation:Bool = false {
        
        didSet {
            
            mapView?.allowLongPressAddPointAnnotation = allowLongPressAddPointAnnotation
        }
    }
    
    var canShowCallout:Bool = true {
        
        didSet {
            
            mapView?.canShowCallout = canShowCallout
        }
    }
    
    
    override var frame:CGRect {
        
        didSet {
            
            super.frame = frame
            
            reSetFrame(frame: frame)
        }
    }
    
    // MARK: -- lifeCircle
    
    
    /// 默认构造是使用自带苹果地图
    ///
    /// - frame: 位置大小
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        switchMapWithLocation(location: kCLLocationCoordinate2DInvalid)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 通过构造参数经纬度来初始化地图，国内使用苹果地图，国外使用谷歌
    ///
    ///   - frame: 位置大小
    ///   - location: 经纬度
    init(frame: CGRect,location:CLLocationCoordinate2D) {
        
        super.init(frame: frame)
        
        switchMapWithLocation(location: location)
        setupUI()
        
        setRegion(coordinate: location)
    }
    
    
    /// 通过构造参数类型来初始化地图
    ///
    ///   - frame: 位置大小
    ///   - type: 地图类型
    init(frame: CGRect,type:LTMapType) {
        
        super.init(frame: frame)
        
        mapView = createMapViewWith(type:type)
        setupUI()

    }
    
    // MARK: -- 私有方法
    
    private func setupUI() {
        
        if let mapView = mapView {
            
            self.addSubview(mapView as! LTMap)
            
            (mapView as! LTMap).delegate = self

        }
        
    }
    
    private func switchMapWithLocation(location: CLLocationCoordinate2D) {
        
        if isInChina(location: location) {
            
            mapView = createMapViewWith(type:.MKMap)
            
        }else {
            
            mapView = createMapViewWith(type:.Google)
        }
    }
    
    private func createMapViewWith(type:LTMapType)-> LTMapProtocol? {
        
        switch type {
            
        case .MKMap:
            
            return LTMKMap(frame: self.bounds)
            
        case.Gaode:

            return LTGaodeMap(frame: self.bounds)
            
        case.Google:
            
            return LTGoogleMap(frame: self.bounds)
            
    
        default:
            return LTMKMap(frame: self.bounds)
        }
        
    }
    
    private func isInChina(location: CLLocationCoordinate2D) ->Bool {
        
        // 默认为中国
        if !CLLocationCoordinate2DIsValid(location) {
            
            return true
        }
        
        return AMapLocationDataAvailableForCoordinate(location)
    }
    
    // MARK: -- 公共方法
 
    func reSetFrame(frame: CGRect) {
        
        mapView?.reSetFrame(frame: frame)
    }
    
    func setRegion(coordinate: CLLocationCoordinate2D) {
        
        mapView?.setRegion(coordinate: coordinate)
    }
    
    func addAnnotation(annotation: LTAnnotation) {
        
        mapView?.addAnnotation(annotation: annotation)
    }
    
    
}

