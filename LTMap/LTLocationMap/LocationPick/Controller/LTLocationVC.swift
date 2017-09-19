//
//  LTLocationVC.swift
//  LTMap
//
//  地理位置搜索和选择
//  Created by aken on 2017/5/27.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit


class LTLocationVC: UIViewController {

    
    // MARK: -- 公共成员
    var pickHomeView:LTLocPickHomeView?
    
    // 默认坐标
    let defCoordinate = CLLocationCoordinate2D(latitude: 22.631468, longitude: 113.995469)
    // MARK: -- LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = [] //.all
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = false
        
        setupUI()
 
        let coordinate = LTLocationManager.shared.location
        
        if let coor = coordinate {
            
            if  CLLocationCoordinate2DIsValid(coor) {
                
                pickHomeView?.location = coor
            }
            
        }else { // 给默认值
            
            pickHomeView?.location = defCoordinate
        }
        
    }
    
    deinit {
        
    }

    // MARK: - 创建UI

    private func setupUI() {
        
        self.title = "位置"
        pickHomeView = LTLocPickHomeView(frame: CGRect.zero, type:.LTPickMix)
        view.backgroundColor = UIColor.white
        view.addSubview(pickHomeView!)

        
        let rightItem = UIBarButtonItem(title: "发送", style: .done, target: self, action: #selector(sendLocationInfos))
        self.navigationItem.rightBarButtonItem = rightItem
//
        addViewContrains()
        
    }
    
    private func addViewContrains() {
    
        pickHomeView?.frame = self.view.bounds
    }

    
    @objc fileprivate func sendLocationInfos() {
        
        
        print("send \(pickHomeView?.selectedPoiModel.title)-->\(pickHomeView?.selectedPoiModel.subtitle)")
    }
    
    
}
