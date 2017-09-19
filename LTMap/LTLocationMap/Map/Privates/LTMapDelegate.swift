//
//  LTMapDelegate.swift
//  LTMap
//
//  Created by aken on 2017/6/12.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation


protocol  LTMapDelegate: NSObjectProtocol {
    
    func mapView(mapView: LTMapProtocol, didSelect annotation: LTAnnotation)
    func mapView(mapView: LTMapProtocol, didDeselect annotation: LTAnnotation)
    func mapView(mapView: LTMapProtocol, regionWillChangeAnimated animated: Bool)
    func mapView(mapView: LTMapProtocol, regionDidChangeAnimated animated: Bool)
}
