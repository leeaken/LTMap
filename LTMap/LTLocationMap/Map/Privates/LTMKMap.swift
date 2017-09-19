//
//  LTMKMap.swift
//  LTMap
//
//  苹果自带地图类
//  Created by aken on 2017/5/30.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit
import MapKit


class LTMKMap: LTMap {
   
    
    override var canShowCallout:Bool  {
        
        didSet {
            
            isCanShowCallout = canShowCallout;
        }
    }

    // MARK: -- 私有成员
    
    fileprivate var isLongPress: Bool = false
    
    fileprivate var isCanShowCallout = true
    
    private lazy var mapView:MKMapView = { [weak self] in
        
        let mView = MKMapView(frame: (self?.bounds)!)
        mView.showsUserLocation = true;
        mView.showsCompass = true;
        mView.delegate = self
        
        mView.userTrackingMode = .followWithHeading
        mView.mapType = MKMapType.standard
        
        mView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        return mView
        
    }()
    
    
    // MARK: -- 私人方法
    override func setupUI() {
        
        self.addSubview(mapView)
    }
    
    override func handleLongpressGesture(sender : UILongPressGestureRecognizer) {
        
        
        if sender.state == UIGestureRecognizerState.ended {
            
            isLongPress = false
            return
        }
        
        if sender.state == UIGestureRecognizerState.began {
        
            isLongPress = true
            
            let point = sender.location(in: self.mapView) as CGPoint
            let coor = mapView.convert(point, toCoordinateFrom: mapView)
            
            let objectAnnotation = MKPointAnnotation()
            
            objectAnnotation.coordinate = coor

            let location = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    
                    //取最后一个地标（一个地名可能搜索出多个地址）
                    let placemark:CLPlacemark = (placemarks?.last)!
                    
                    let deatail = (placemark.addressDictionary?["FormattedAddressLines"] as? [String])?.first!
                    let name=placemark.name;//地名
                    
                    objectAnnotation.title = name
                    objectAnnotation.subtitle = deatail
                    
                    self.mapView.addAnnotation(objectAnnotation)
                    self.mapView.selectAnnotation(objectAnnotation, animated: true)
                }
                
            })
        }
        
    }
    
    // MARK: -- 公共方法

    override func reSetFrame(frame:CGRect) {
        
        self.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        mapView.frame = self.bounds
    }
    
    override func setRegion(coordinate: CLLocationCoordinate2D) {
        
        if  CLLocationCoordinate2DIsValid(coordinate) {
            
            let latDelta = 0.02
            let longDelta = 0.02
            let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            
            let region:MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: currentLocationSpan)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    

    override func addAnnotation(annotation: LTAnnotation) {
        
        guard let coordinate = annotation.coordinate,CLLocationCoordinate2DIsValid(coordinate) else {
            
            return
        }
        
        //创建一个大头针对象
        let objectAnnotation = MKPointAnnotation()
        
        //设置大头针的显示位置
        objectAnnotation.coordinate = annotation.coordinate!
        //设置点击大头针之后显示的标题
        objectAnnotation.title = annotation.title
        //设置点击大头针之后显示的描述
        objectAnnotation.subtitle = annotation.subtitle
        //添加大头针
        mapView.addAnnotation(objectAnnotation)
    }
    
    override func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
}


// MARK: -- MKMapViewDelegate

extension LTMKMap:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {

            annotationView.canShowCallout = isCanShowCallout
            annotationView.image = UIImage(named: "map_small_pin")
            
            if isLongPress {
                
                annotationView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
                    annotationView.transform = .identity
                }, completion: nil)
            }
            
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation
        
        
        if let coordinate = location?.coordinate {
            
            
            let center:CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let placemark = MKPlacemark(coordinate: center.coordinate, addressDictionary: ["street":location?.title as Any])
            let mapItem = MKMapItem(placemark: placemark)
            // 打开自带高德地图导航
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
            
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if (delegate != nil) {

            let pointAnnotation = view.annotation
            
            let annotation = LTAnnotation()
            
            if let title = pointAnnotation?.title {
                
                annotation.title = title
            }
            
            if let subTitle = pointAnnotation?.subtitle {
                
                annotation.subtitle = subTitle
                
            }
            
            if let coordinate = pointAnnotation?.coordinate {
                
                annotation.coordinate = coordinate
            }

            
            delegate?.mapView(mapView: self, didSelect: annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        if (delegate != nil)  {

            let pointAnnotation = view.annotation
            
            let annotation = LTAnnotation()
            
            if let title = pointAnnotation?.title {
                
                annotation.title = title
            }
            
            if let subTitle = pointAnnotation?.subtitle {
                
                annotation.subtitle = subTitle
                
            }
            
            if let coordinate = pointAnnotation?.coordinate {
                
                annotation.coordinate = coordinate
            }
            
            delegate?.mapView(mapView: self, didDeselect: annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        isMapPanned = mapViewRegionDidChangeFromUserInteraction()

        if delegate != nil  {

            delegate?.mapView(mapView: self, regionWillChangeAnimated: animated)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        let centerCoor = mapView.centerCoordinate;
        centerCoordinate = centerCoor

        if delegate != nil {
            
            delegate?.mapView(mapView: self, regionDidChangeAnimated: animated)
        }
    }
    
}
