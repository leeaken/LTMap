//
//  LTAnnotationView.swift
//  LTMap
//
//  自定义点击大头针弹出视图
//  Created by aken on 2017/5/25.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc protocol LTAnnotationViewDelegate:NSObjectProtocol {
    
    @objc optional func hideAnnotationView()
    @objc optional func touchAnnotationViewScanButton(annotation:LTAnnotation)
}

class LTAnnotationView: LTPopMenuView {

    private var scanBtn:UIButton = UIButton()    // 扫一扫
    private var line:UIView = UIView()           // 分割线
    private var navBtn:UIButton = UIButton()     // 导航
    private var closeBtn:UIButton = UIButton()   // 关闭
    private var titleLbl:UILabel = UILabel()     // 标题
    private var desLbl:UILabel = UILabel()       // 描述
    private var locationImV:UIImageView = UIImageView()       // 位置图标
    private var distanceLbl:UILabel = UILabel()       // 距离
    
    weak var delegate:LTAnnotationViewDelegate?
    
    var annotation:LTAnnotation? {
    
        didSet {
            
            titleLbl.text =  annotation?.title
            desLbl.text =  annotation?.subtitle
            distanceLbl.text = "30m"
        }
    
    }
    
    //
    override func setupUI() {
        
        
        self.addSubview(line)
        self.addSubview(scanBtn)
        self.addSubview(navBtn)
        self.addSubview(closeBtn)
        self.addSubview(locationImV)
        self.addSubview(distanceLbl)
        self.addSubview(titleLbl)
        self.addSubview(desLbl)
        
        line.backgroundColor = UIColor.lightGray
        
        scanBtn.setTitle("扫码兑换", for: .normal)
        scanBtn.backgroundColor = UIColor.lightGray
        scanBtn.layer.cornerRadius = 4.0
        scanBtn.addTarget(self, action: #selector(scanButtonClick), for: .touchUpInside)
        
        navBtn.setImage(UIImage(named: "navigation"), for: .normal)
        navBtn.addTarget(self, action: #selector(navButtonClick), for: .touchUpInside)
        closeBtn.setImage(UIImage(named: "nav_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(clickButtonClick), for: .touchUpInside)
        
        locationImV.image = UIImage(named: "location")
        
        
    
        desLbl.numberOfLines = 2
        
        self.addFrameContrains()
        //
    }
    
    func addFrameContrains() {
        
        distanceLbl.sizeToFit()
        
        line.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(44)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(0.5)
        }
        
        scanBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(40)
        }
        
        navBtn.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(0)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.width.equalTo(30)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(0)
            make.left.equalTo(self.snp.left).offset(10)
            make.height.width.equalTo(40)
        }
        
        distanceLbl.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(3)
            make.right.equalTo(self.snp.right).offset(-10)
            make.width.equalTo(50)
        }
        
        locationImV.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(5)
            make.right.equalTo(distanceLbl.snp.left).offset(-5)
            make.height.equalTo(16)
            make.width.equalTo(13)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(5)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(locationImV.snp.left).offset(-5)
        }
        
        desLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(10)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
        }
        
    }

    // MARK: - 按钮事件
    func scanButtonClick() {
        
        if delegate != nil &&
            delegate!.responds(to: #selector(LTAnnotationViewDelegate.touchAnnotationViewScanButton(annotation:))) {
            
            delegate?.touchAnnotationViewScanButton!(annotation: annotation!)
        }
    }
    
    func clickButtonClick() {
        
        if delegate != nil &&
            delegate!.responds(to: #selector(LTAnnotationViewDelegate.hideAnnotationView)) {
            
            delegate?.hideAnnotationView!()
        }
    }
    
    func navButtonClick() {
        
        let center:CLLocation = CLLocation(latitude: 22.53311473, longitude: 114.06379665)
        let placemark = MKPlacemark(coordinate: center.coordinate, addressDictionary: ["street":annotation?.title ?? ""])
        let mapItem = MKMapItem(placemark: placemark)
        // 打开自带高德地图导航
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
}
