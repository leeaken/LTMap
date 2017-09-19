//
//  LTAnnotation.swift
//  LTMap
//
//  地理位置对象消息
//  Created by aken on 2017/5/26.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit
import MapKit

public class LTAnnotation: NSObject {

    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
    override init() {
        
        super.init()
    }
}
