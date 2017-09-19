//
//  LTGaodeMap.swift
//  LTMap
//
//  第三方高德地图
//  Created by aken on 2017/6/13.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation
import MapKit

class LTGaodeMap: LTMap {
    
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
    
    fileprivate lazy var mapView:MAMapView = { [weak self] in
        
        let mView = MAMapView(frame: (self?.bounds)!)
        mView.showsUserLocation = true;
        mView.showsCompass = true;
        mView.delegate = self
        
        mView.userTrackingMode = .followWithHeading
        
        mView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        return mView
        
        }()

    fileprivate var poiManager = LTGeocodeManager()
    
    override func setupUI() {
        
        self.addSubview(mapView)
    }
//    
    
    override func mapViewRegionDidChangeFromUserInteraction() -> Bool {

        if let gestureRecognizers = self.mapView.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    override func reSetFrame(frame:CGRect) {
        
        self.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        mapView.frame = self.bounds
    }
    
    override func setRegion(coordinate: CLLocationCoordinate2D) {
        
        if  CLLocationCoordinate2DIsValid(coordinate) {
            
            let latDelta = 0.02
            let longDelta = 0.02
            let currentLocationSpan:MACoordinateSpan = MACoordinateSpanMake(latDelta, longDelta)
            let region = MACoordinateRegion(center: coordinate, span: currentLocationSpan)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func addAnnotation(annotation: LTAnnotation) {
        
        guard let coordinate = annotation.coordinate,CLLocationCoordinate2DIsValid(coordinate) else {
            
            return
        }
        

        let objectAnnotation = MAPointAnnotation()
        objectAnnotation.coordinate = annotation.coordinate!

        objectAnnotation.title = annotation.title
        objectAnnotation.subtitle = annotation.subtitle
        mapView.addAnnotation(objectAnnotation)
    }
    
}

// MARK:--
extension LTGaodeMap:MAMapViewDelegate {
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        
        let location = userLocation.location?.coordinate
        
        if location==nil {
            
            return;
        }
        
        if (!completeLocate) {
            
            completeLocate = true;
        
            mapView.centerCoordinate = location!
            mapView.setZoomLevel(zoomLevel, animated: false)
        }
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        guard !(annotation is MAUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MAAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
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
    
    func mapView(_ mapView: MAMapView, annotationView view: MAAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
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
    
    func mapView(_ mapView: MAMapView!, regionWillChangeAnimated animated: Bool) {
        
        isMapPanned = mapViewRegionDidChangeFromUserInteraction()
        
        if delegate != nil  {
            
            delegate?.mapView(mapView: self, regionWillChangeAnimated: animated)
        }
    }
    
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        
        
        let centerCoor = mapView.centerCoordinate;
        centerCoordinate = centerCoor
        
        if delegate != nil {
            
            delegate?.mapView(mapView: self, regionDidChangeAnimated: animated)
        }
    }
    
    func mapView(_ mapView: MAMapView, didSelect view: MAAnnotationView) {
        
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
    
    func mapView(_ mapView: MAMapView, didDeselect view: MAAnnotationView) {
        
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
       
    func mapView(_ mapView: MAMapView!, didLongPressedAt coordinate: CLLocationCoordinate2D) {
        

        if allowLongPressAddPointAnnotation {
            
            if let gestureRecognizers = mapView.gestureRecognizers {
                for recognizer in gestureRecognizers {
                    if( recognizer.state == UIGestureRecognizerState.began) {
                        isLongPress = true
                    }else if (recognizer.state == UIGestureRecognizerState.ended ) {
                        isLongPress = false
                    }
                }
            }
            
            print("handleLongpressGesture \(coordinate) -->long press:\(isLongPress)")
            
            
            let objectAnnotation = MAPointAnnotation()
            
            objectAnnotation.coordinate = coordinate
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
//            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
//                
//                if error != nil {
//                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
//                    return
//                }
//                
//                if (placemarks?.count)! > 0 {
//                    
//                    //取最后一个地标（一个地名可能搜索出多个地址）
//                    let placemark:CLPlacemark = (placemarks?.last)!
//                    
//                    let deatail = (placemark.addressDictionary?["FormattedAddressLines"] as? [String])?.first!
//                    let name=placemark.name;//地名
//                    
//                    objectAnnotation.title = name
//                    objectAnnotation.subtitle = deatail
//                    
//                    self.mapView.addAnnotation(objectAnnotation)
//                    self.mapView.selectAnnotation(objectAnnotation, animated: true)
//                }
//                
//            })
            
            poiManager.searchReGeocodeWithCoordinate(coordinate: location.coordinate, completion: { (array, total) in
                
                if array.count > 0 {
                    
                    let model = array.first!
                    
                    objectAnnotation.title = model.title
                    objectAnnotation.subtitle = model.subtitle
                    
                    self.mapView.addAnnotation(objectAnnotation)
                    self.mapView.selectAnnotation(objectAnnotation, animated: true)
                }
                
            })

        }
        
    }

}
