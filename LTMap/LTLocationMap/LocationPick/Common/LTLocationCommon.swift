//
//  LTLocationCommon.swift
//  LTMap
//
//  Created by aken on 2017/6/16.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation

let cellIdentifier = "cellIdentifier"

struct LTLocationCommon {
    
    static let MapDefaultWidth = UIScreen.main.bounds.size.width
    static let MapDefaultHeight = (UIScreen.main.bounds.size.height - 64)/2 - 44
    static let MapAfterAnimationsDefaultHeight = (UIScreen.main.bounds.size.height - 64)/2 - 132 - 44
    static let TableViewDefaultHeight = (UIScreen.main.bounds.size.height - 64)/2
    static let TableViewAfterAnimationsDefaultHeight = (UIScreen.main.bounds.size.height - 64)/2 + 132
    static let POISearchPageSize = 20
    static let POISearchRadius = 1000
}

enum MXPickLocationType: String {
    
    case LTPickMix  // 地图和列表混合
    case LTPickMap  // 地图
    case LTPickList // 列表
}
