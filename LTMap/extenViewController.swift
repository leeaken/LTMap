//
//  extenViewController.swift
//  LTMap
//
//  Created by aken on 2017/5/26.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension  ViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        let array = locations;

//        print(array)
    }

}

extension ViewController:LTAnnotationViewDelegate {
    
    func hideAnnotationView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.annotationView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: annotationViewDefaultHeight)
            
        }) { (finish:Bool) in
            
        }
    }
    
    func touchAnnotationViewScanButton(annotation: LTAnnotation) {
        
        print("touchAnnotationViewScanButton")
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        //        print(mapView.centerCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        //获取用户当前的中心位置
        let center = userLocation.location?.coordinate
        
        if center==nil {
            
            return;
        }
        
        
        if (!completeLocate) {

            completeLocate = true;
            
            mapView.setCenter(center!, animated: true)
            
            //改变显示区域
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegionMake(center!, span)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
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
            // Configure your annotation view here
            annotationView.canShowCallout = false
            annotationView.image = UIImage(named: "map_pin")
            
            if isLongPress {
                
                annotationView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
                    annotationView.transform = .identity
                }, completion: nil)
            }
            
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
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
        
        self.annotationView.annotation = annotation;
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.annotationView.frame = CGRect(x:0, y: self.view.frame.size.height - annotationViewDefaultHeight, width: self.view.frame.size.width, height: annotationViewDefaultHeight)
            
        }) { (finish:Bool) in
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.annotationView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: annotationViewDefaultHeight)
            
        }) { (finish:Bool) in
            
        }
    }
}
