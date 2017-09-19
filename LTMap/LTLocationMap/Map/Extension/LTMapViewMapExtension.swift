//
//  LTMapViewMapExtension.swift
//  LTMap
//
//  地图代理拓展
//  Created by aken on 2017/5/31.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit

extension LTMapView:LTMapDelegate {
    
    func mapView(mapView: LTMapProtocol, didSelect annotation: LTAnnotation) {
        
        if delegate != nil &&
            delegate!.responds(to: #selector(LTMapViewDelegate.mapView(mapView:didSelect:))) {
            
            delegate?.mapView!(mapView: self, didSelect: annotation)
        }
    }
    
    func mapView(mapView: LTMapProtocol, didDeselect annotation: LTAnnotation) {
        
        if delegate != nil &&
            delegate!.responds(to: #selector(LTMapViewDelegate.mapView(mapView:didDeselect:))) {
            
            delegate?.mapView!(mapView: self, didDeselect: annotation)
        }
    }
    
    func mapView(mapView: LTMapProtocol, regionWillChangeAnimated animated: Bool) {
        
        centerCoordinate = mapView.centerCoordinate
        isMapPanned = mapView.isMapPanned
        
        if delegate != nil &&
            delegate!.responds(to: #selector(LTMapViewDelegate.mapView(mapView:regionWillChangeAnimated:))) {
            
            delegate?.mapView!(mapView: self, regionWillChangeAnimated: animated)
        }
    }
    
    func mapView(mapView: LTMapProtocol, regionDidChangeAnimated animated: Bool) {
        
        centerCoordinate = mapView.centerCoordinate
        
        if delegate != nil &&
            delegate!.responds(to: #selector(LTMapViewDelegate.mapView(mapView:regionDidChangeAnimated:))) {
            
            delegate?.mapView!(mapView: self, regionDidChangeAnimated: animated)
        }
    }
}

