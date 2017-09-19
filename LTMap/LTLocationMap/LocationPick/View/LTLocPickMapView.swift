//
//  LTLocPickMapView.swift
//  LTMap
//
//  Created by aken on 2017/6/16.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation

class LTLocPickMapView: UIView {
    
    weak var delegate:LTMapViewDelegate?
    
    lazy var mapView:LTMapView = {
        
        let myMapView = LTMapView(frame: CGRect.zero)
        myMapView.delegate = self
        myMapView.allowLongPressAddPointAnnotation = false
        
        return myMapView
        
    }()
    
    private lazy var mapPin:UIImageView = {
        
        let myMapPin = UIImageView(frame: CGRect.zero)
        myMapPin.image = UIImage(named: "map_small_pin")
        
        return myMapPin
        
    }()
    
    var location:CLLocationCoordinate2D? {
        
        didSet  {
            
            if let coor = location {
                
                if  CLLocationCoordinate2DIsValid(coor) {
                    
                    mapView .setRegion(coordinate: coor);
                }
                
            }
            
        }
        
    }
    
    override var frame:CGRect {
        
        didSet {
            
            super.frame = frame
            
            if !frame.equalTo(CGRect.zero) {
                
                addViewContrains()
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        
        addViewContrains()
    }
    
    init(frame: CGRect,location:CLLocationCoordinate2D) {
        
        super.init(frame: frame)
        
        setupUI()
        
        setRegion(coordinate: location)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        self.addSubview(mapView)
        mapView.addSubview(mapPin)
    }
    
    private func addViewContrains() {
        
        mapView.frame = self.bounds
        
        mapPin.snp.makeConstraints { make in
            make.center.equalTo(mapView.snp.center)
            make.height.width.equalTo(42)
        }

    }
    
    func annimatePin() {
        
        let point1 = CGPoint(x: mapPin.layer.position.x, y: mapPin.layer.position.y)
        let point2 = CGPoint(x: mapPin.layer.position.x, y: mapPin.layer.position.y - 20)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.values = [NSValue.init(cgPoint: point1), NSValue.init(cgPoint: point2)]
        animation.duration = 0.2;
        animation.autoreverses = true;
        
        mapPin.layer.add(animation, forKey: "")
        
    }
    
    func setRegion(coordinate: CLLocationCoordinate2D) {
        
        mapView.setRegion(coordinate: coordinate)
    }
    
}

extension LTLocPickMapView : LTMapViewDelegate {
    
    
    func mapView(mapView: LTMapView, didSelect annotation: LTAnnotation) {
        
        print("didSelect")
    }
    
    func mapView(mapView: LTMapView, didDeselect annotation: LTAnnotation) {
        
        print("didDeselect")
    }
    
    func mapView(mapView: LTMapView, regionWillChangeAnimated animated: Bool) {
        
        
    }
    
    func mapView(mapView: LTMapView, regionDidChangeAnimated animated: Bool) {
        
        if mapView.isMapPanned {
            
            annimatePin()
            
            if (delegate != nil) {
                
                delegate?.mapView!(mapView: mapView, regionDidChangeAnimated: animated)
            }
            
        }
        
    }
}
