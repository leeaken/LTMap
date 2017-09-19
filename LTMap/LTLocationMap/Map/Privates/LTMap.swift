//
//  LTMap.swift
//  LTMap
//
//  地图基类
//  Created by aken on 2017/6/13.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation

class LTMap: UIView,LTMapProtocol {
 
    
    var isMapPanned: Bool = false
    
    weak var delegate: LTMapDelegate?
        
    var canShowCallout:Bool = true
    
    var allowLongPressAddPointAnnotation:Bool = false {
        
        didSet {
            
            if (allowLongPressAddPointAnnotation) {
                addLongpressGesutre()
            }
        }
    }
    
    var centerCoordinate: CLLocationCoordinate2D? = kCLLocationCoordinate2DInvalid
    
    // MARK: -- lifeCircle
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLongpressGesutre() {
        
        // 长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(handleLongpressGesture(sender:)))
        // 长按时间为1秒
        longpressGesutre.minimumPressDuration = 0.5
        // 允许15秒运动
        longpressGesutre.allowableMovement = 10
        // 所需触摸1次
        longpressGesutre.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(longpressGesutre)
    }
    
    func handleLongpressGesture(sender : UILongPressGestureRecognizer) {

    
    }

    func setupUI() {
        
    }
    
    func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        
        return false
    }

    /// 设置frame
    func reSetFrame(frame:CGRect) {
        
    }
    
    /// 添加地理位置
    func setRegion(coordinate: CLLocationCoordinate2D) {
        
    }
    
    /// 添加大头针
    func addAnnotation(annotation: LTAnnotation) {
        
    }
    
}
