//
//  LTMapProtocol.swift
//  LTMap
//
//  地图类的常用方法声明,其它地图所用到的常用方法

//  Created by aken on 2017/6/8.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation

protocol LTMapProtocol {
    
    /// 是否显示地图默认的Callout
    var canShowCallout:Bool { get set }
    
    /// 地图拖动
    var isMapPanned:Bool { get set }
   
    /// 地图中心点经纬度
    var centerCoordinate: CLLocationCoordinate2D? { get set }
    
    /// 长按添加大头针
    var allowLongPressAddPointAnnotation:Bool { get set }
    
    /// 设置frame
    func reSetFrame(frame:CGRect)
    
    /// 添加地理位置
    ///
    /// - Parameter coordinate: 经纬度
    func setRegion(coordinate: CLLocationCoordinate2D)
    
    /// 添加大头针
    ///
    /// - Parameter annotation: 经纬度
    func addAnnotation(annotation: LTAnnotation)
    
    
}

extension LTMapProtocol {
    
    // 默认实现，即setFrame为optional
    public func reSetFrame(frame:CGRect) {
        
        
    }
    
}
