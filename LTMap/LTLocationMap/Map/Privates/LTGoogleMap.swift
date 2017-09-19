//
//  LTGoogleMap.swift
//  LTMap
//
//  谷歌地图
//  Created by aken on 2017/6/19.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation
import GoogleMaps

class LTGoogleMap: LTMap {


    override var canShowCallout:Bool  {
        
        didSet {
            
            isCanShowCallout = canShowCallout;
        }
    }

    // MARK: -- 私有成员
    
    fileprivate var isLongPress: Bool = false
    
    fileprivate var isCanShowCallout = true
    
    fileprivate var completeLocate:Bool = false
    
    fileprivate let zoomLevel:CGFloat = 15.1
    
    fileprivate var firstLocationUpdate:Bool = false

    fileprivate lazy var mapView:GMSMapView = { [weak self] in
    
        let mView = GMSMapView(frame:(self?.bounds)!)
        mView.settings.compassButton = true;
        mView.settings.myLocationButton = true;
        mView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        mView.delegate = self
        return mView
        
    }()

    
    deinit {
        
        mapView.removeObserver(self, forKeyPath: "myLocation")
    }
    
    fileprivate var isMapPan: Bool = false
  
    private func addPanGesutre () {
        
        let mapPan = UIPanGestureRecognizer(target: self, action: #selector(dragMapAction(sender:)))
        mapPan.minimumNumberOfTouches = 1
        mapPan.maximumNumberOfTouches = 1
        mapPan.delegate = self
        mapView.gestureRecognizers = [mapPan];
    }
    
    @objc fileprivate func dragMapAction(sender:UIPanGestureRecognizer) {
        
        
        if sender.state == .began {
   
            isMapPan = true
            
        }else if sender.state == .ended  {
        
            isMapPan = true
        }
    }
    
    override func setupUI() {
        
        GMSServices.provideAPIKey(LTLocationMapCommon.GoogleMapApiKey)
        
        self.addSubview(mapView)
        
        DispatchQueue.main.async { [weak self] in
            
            self?.mapView.isMyLocationEnabled = true
        }

        mapView.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        
        addPanGesutre()
    }

    override func reSetFrame(frame:CGRect) {
        
        self.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        mapView.frame = self.bounds
    }
    
    override func setRegion(coordinate: CLLocationCoordinate2D) {
        
        if  CLLocationCoordinate2DIsValid(coordinate) {
            

            mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: Float(zoomLevel))

        }
    }
    
    override func addAnnotation(annotation: LTAnnotation) {
        
        guard let coordinate = annotation.coordinate,CLLocationCoordinate2DIsValid(coordinate) else {
            
            return
        }
        
        let marker = GMSMarker()
        marker.position = annotation.coordinate!
        marker.title = annotation.title
        marker.snippet = annotation.subtitle
        marker.icon = UIImage(named: "map_small_pin")
        marker.map = mapView
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
       
        
        // self?.mapView.isMyLocationEnabled = true 只有打开才会调用这代理
        if !firstLocationUpdate {
            
            firstLocationUpdate = true
            
            if let loc:CLLocation = change?[NSKeyValueChangeKey.newKey] as? CLLocation {
                
                let trancLoc = LTLocationConverter.wgs84(toGcj02: loc.coordinate)
                
                 mapView.camera = GMSCameraPosition.camera(withLatitude: trancLoc.latitude, longitude: trancLoc.longitude, zoom: Float(zoomLevel))
            }

        }
        
    }
    
    override func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        
        let view = self.mapView.subviews[0]
        
        if let gestureRecognizers = view.gestureRecognizers {
            
            for recognizer in gestureRecognizers {
                
                print(recognizer.state)
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
}

/// MARK -- 
extension LTGoogleMap:GMSMapViewDelegate {
    
    // 类似mkmapview中的  regionWillChangeAnimated
    public func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        isMapPanned = isMapPan
        
//         mapView.clear()
        
        if delegate != nil  {
            
            delegate?.mapView(mapView: self, regionWillChangeAnimated: gesture)
        }
    }

    
    // 类似mkmapview中的 regionDidChangeAnimated
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        

        let centerCoor = position.target;
        centerCoordinate = centerCoor
        
        print("idleAt:",isMapPanned)
        
        if delegate != nil {
            
            delegate?.mapView(mapView: self, regionDidChangeAnimated: true)
        }
        
        isMapPan = false
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        
        if (delegate != nil) {
            
            let annotation = LTAnnotation()
            
            if let title = marker.title {
                
                annotation.title = title
            }
            
            if let subTitle = marker.snippet {
                
                annotation.subtitle = subTitle
                
            }
            
            if CLLocationCoordinate2DIsValid(marker.position) {
                
                annotation.coordinate = marker.position
            }
            delegate?.mapView(mapView: self, didDeselect: annotation)
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        if !isCanShowCallout {
            
            // 如果不设置一个空的页面，则不会调用didCloseInfoWindowOf
            let blankView = UIView(frame:CGRect(x: 0, y: 0, width: 100, height: 10))
            blankView.isHidden = true
            
            return blankView
        }
        
        return nil
        
    }
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        
        
        if (delegate != nil) {
            
            let annotation = LTAnnotation()
            
            if let title = marker.title {
                
                annotation.title = title
            }
            
            if let subTitle = marker.snippet {
                
                annotation.subtitle = subTitle
                
            }
            
            if CLLocationCoordinate2DIsValid(marker.position) {
                
                annotation.coordinate = marker.position
            }
            delegate?.mapView(mapView: self, didSelect: annotation)
        }

        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        if allowLongPressAddPointAnnotation {
            
            GMSGeocoder().reverseGeocodeCoordinate(coordinate, completionHandler: { (response, error) in
                
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if let result = response?.firstResult() {
                    
                    let marker = GMSMarker()
                    marker.position = coordinate
                    marker.title = result.lines?[0]
                    marker.snippet = result.lines?[1]
                    marker.map = mapView
                }
                
            })
            
            print(coordinate)
        }
    }
    
    
}

extension LTGoogleMap:UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return true
    }
}
