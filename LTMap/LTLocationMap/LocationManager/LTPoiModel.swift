//
//  LTPoiModel.swift
//  LTMap
//
//  Created by aken on 2017/6/2.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit

class LTPoiModel: NSObject {

    // ID
    var uid: String?
    
    // 标题
    var title: String?
    
    // 详细描述
    var subtitle: String?
    
    // 城市
    var city: String?
    
    // 地理位置
    var coordinate: CLLocationCoordinate2D?
}
