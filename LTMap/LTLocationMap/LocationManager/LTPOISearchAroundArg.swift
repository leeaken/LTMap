//
//  LTPOISearchAroundArg.swift
//  LTMap
//
//  地理位置搜索参数对象
//  Created by aken on 2017/6/2.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit

class LTPOISearchAroundArg:NSObject {

    // 搜索范围
    var radius: Int?
    
    // 每页记录数, 范围1-50, [default = 20]
    var offset: Int?
    
    // 当前页数, 范围1-100, [default = 1]
    var page: Int?
    
    // 当前经纬度
    var location: CLLocationCoordinate2D?
    
    // 搜索关键字
    var keyword: String?
    
    // 城市
    var city: String?
    
}
