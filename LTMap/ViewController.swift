//
//  ViewController.swift
//  LTMap
//
//  Created by aken on 2017/5/24.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


public let annotationViewDefaultHeight:CGFloat = 200

class ViewController: UIViewController {

    var mapView:MKMapView!
    
    public var completeLocate:Bool = false
    public var isLongPress:Bool = false
    public var annotationView = LTAnnotationView()
    

    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        }
        
        self.setupUI()
        
        longpress()
    }
    
    func setupUI()  {
        
    
        self.mapView = MKMapView(frame: self.view.bounds)
        self.mapView.showsUserLocation = true;
        self.mapView.showsCompass = true;
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        
        self.mapView.addSubview(self.annotationView)
        
        self.mapView.userTrackingMode = .followWithHeading
        self.mapView.mapType = MKMapType.standard
        
        // 设置level
        let latDelta = 0.02
        let longDelta = 0.02
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let center = CLLocationCoordinate2D(latitude: 22.631468, longitude: 113.995469)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: center, span: currentLocationSpan)
        self.mapView.setRegion(region, animated: true)
        
        self.annotationView.frame = CGRect(x: 10, y: self.view.frame.size.height, width: self.view.frame.size.width - 20, height: annotationViewDefaultHeight)
        self.annotationView.backgroundColor = UIColor.white
        self.annotationView.layer.cornerRadius = 8.0
//        self.annotationView.canSlide = true;
        self.annotationView.delegate = self
        
        
        
    }
    
    func longpress() {
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(handleLongpressGesture(sender:)))
        //长按时间为1秒
        longpressGesutre.minimumPressDuration = 0.5
        //允许15秒运动
        longpressGesutre.allowableMovement = 10
        //所需触摸1次
        longpressGesutre.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(longpressGesutre)
    }
    
    func handleLongpressGesture(sender : UILongPressGestureRecognizer) {
        
        
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
//            objectAnnotation.title = "当前位置"
//            objectAnnotation.subtitle = "自定义大头针"
            
        
            
            let location = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    
                    //取得最后一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
                    let placemark:CLPlacemark = (placemarks?.last)!
//                    let location = placemark.location;//位置
//                    let region = placemark.region;//区域
                    let addressDic = placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
                    let name=placemark.name;//地名
//                    let thoroughfare=placemark.thoroughfare;//街道
//                    let subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
                    //                    let locality=placemark.locality; // 城市
                    //                    let subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
                    //                    let administrativeArea=placemark.administrativeArea; // 州
                    //                    let subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
                    //                    let postalCode=placemark.postalCode; //邮编
                    //                    let ISOcountryCode=placemark.ISOcountryCode; //国家编码
                    //                    let country=placemark.country; //国家
                    //                    let inlandWater=placemark.inlandWater; //水源、湖泊
                    //                    let ocean=placemark.ocean; // 海洋
                    //                    let areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
//                    print(name)
//                    print("------")
//                    print(addressDic)
//                    print("------")
//                    print(subThoroughfare)
//                    print("------")
//                    print(addressDic ?? "")
                    

                    let deatail = (placemark.addressDictionary?["FormattedAddressLines"] as? [String])?.first!
                
                    objectAnnotation.title = name
                    objectAnnotation.subtitle = deatail
                    
                    self.mapView.addAnnotation(objectAnnotation)
                    self.mapView.selectAnnotation(objectAnnotation, animated: true)
                    
//                    print(deatail)
                }
                
            })
            
        }
        
    }
    
    
}



