//
//  LTMapViewDelegate.swift
//  LTMap
//
//  Created by aken on 2017/5/31.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation
import UIKit

@objc protocol  LTMapViewDelegate: NSObjectProtocol {

    @objc optional func mapView(mapView: LTMapView, didSelect annotation: LTAnnotation)
    @objc optional func mapView(mapView: LTMapView, didDeselect annotation: LTAnnotation)
    @objc optional func mapView(mapView: LTMapView, regionWillChangeAnimated animated: Bool)
    @objc optional func mapView(mapView: LTMapView, regionDidChangeAnimated animated: Bool)
}
