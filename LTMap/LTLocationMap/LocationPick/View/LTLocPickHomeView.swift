//
//  LTLocPickHomeView.swift
//  LTMap
//
//  Created by aken on 2017/6/16.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation

class LTLocPickHomeView: UIView {
    
    var selectedPoiModel = LTPoiModel()
    
    var listPickView:LTLocPickListView?
    
    var mapPickView:LTLocPickMapView?
    
    
    var location:CLLocationCoordinate2D? {
        
        didSet  {

            listPickView?.location = location
            mapPickView?.location = location;
        }
        
    }
    
    override var frame:CGRect {
        
        didSet {
            
            super.frame = frame
            addViewContrains()

        }
    }
    
    fileprivate var pickType:MXPickLocationType = .LTPickMix
    
    // 搜索框
    let searchResultVC = LTLocationSearchResultVC()
    
    lazy var searchController:UISearchController = { [weak self] in
        
        let controller = UISearchController(searchResultsController: self?.searchResultVC)
        controller.searchBar.delegate = self
        controller.dimsBackgroundDuringPresentation = true
        controller.searchBar.searchBarStyle = .prominent
        controller.searchBar.sizeToFit()
        controller.hidesNavigationBarDuringPresentation = true
        controller.definesPresentationContext = true
        controller.searchBar.placeholder = "搜索地点"
        controller.delegate = self
        
        return controller
        
    }()
    
    
    init(frame: CGRect,type:MXPickLocationType) {
        
        super.init(frame: frame)
        
        pickType = type
        
        setupUI()
        
        addViewContrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        searchController.view.removeFromSuperview()
    }
    
    private func setupUI() {

        listPickView = LTLocPickListView(frame: CGRect.zero)
        mapPickView = LTLocPickMapView(frame: CGRect.zero)
        
        self.addSubview(searchController.searchBar)
        searchResultVC.searchBar = searchController.searchBar
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
    
        switch pickType {
            
        case .LTPickMix:
            
            self.addSubview(mapPickView!)
            self.addSubview(listPickView!)
            
            listPickView?.delegate = self
            mapPickView?.delegate = self
            searchResultVC.delegate = self
            searchResultVC.coordinate = location;
            
            break
            
        case .LTPickList :
            
            self.addSubview(listPickView!)
            listPickView?.delegate = self
            searchResultVC.delegate = self
            searchResultVC.coordinate = location;
            
            break
            
        default:
            
            self.addSubview(mapPickView!)
            mapPickView?.delegate = self
            searchResultVC.delegate = self
            searchResultVC.coordinate = location;
            
            break
       
        }
    
       
    }
    
    private func addViewContrains() {
        
        switch pickType {
            
        case .LTPickMix:
            
            mapPickView?.frame = CGRect(x: 0, y: searchController.searchBar.frame.maxY,width: UIScreen.main.bounds.size.width, height: LTLocationCommon.MapDefaultHeight)
            
            listPickView?.frame = CGRect(x: 0, y: (mapPickView?.frame.maxY)!,width: UIScreen.main.bounds.size.width, height: LTLocationCommon.TableViewDefaultHeight)
            
            break
            
        case .LTPickList :
            
            listPickView?.frame = CGRect(x: 0, y: searchController.searchBar.frame.maxY,width: UIScreen.main.bounds.size.width, height: self.frame.size.height - 44 - 44 - 20)
            
            break
            
        default:
            
            mapPickView?.frame = CGRect(x: 0, y: searchController.searchBar.frame.maxY,width: UIScreen.main.bounds.size.width, height: self.frame.size.height - 44 - 44 - 20)
            
            break
            
        }


        
    }
    
    func viewController(_ view: UIView) -> UIViewController {
        
        var responder: UIResponder? = view
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        return (responder as? UIViewController)!
    }
    

}


extension LTLocPickHomeView:UISearchControllerDelegate,LTLocPickListViewDelegate,LTMapViewDelegate {
    
    /// MARK -- UISearchController delegate
    func willPresentSearchController(_ searchController: UISearchController) {
        
        
        viewController(self).navigationController?.navigationBar.isTranslucent = true;
    }
    
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
        viewController(self).navigationController?.navigationBar.isTranslucent = false;
        
    }
    
    /// MARK -- LTLocPickListView Delegate
    func tableViewForPickListViewDidSelectAt(selectedIndex: Int, model: LTPoiModel) {
        
        selectedPoiModel = model
        
        if let location = model.coordinate {
            
            mapPickView?.setRegion(coordinate: location)
        }

    }
    
    func scrollViewOnPickListViewDidScroll(_ scrollView: UIScrollView) {
        
        if (pickType != .LTPickMix) {
            
            return
        }
        
        if scrollView.contentOffset.y > 9.0 {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                
                [weak self] in
                
                self?.mapPickView?.frame = CGRect(x: 0, y: (self?.searchController.searchBar.frame.maxY)!,width: UIScreen.main.bounds.size.width, height: LTLocationCommon.MapAfterAnimationsDefaultHeight)
                
                self?.listPickView?.frame = CGRect(x: 0, y: (self?.mapPickView?.frame.maxY)!,width: UIScreen.main.bounds.size.width, height: LTLocationCommon.TableViewAfterAnimationsDefaultHeight)
                
                }, completion: { (bol) in
                    
                    
            })
            
        }else if scrollView.contentOffset.y <= 0 {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                
                [weak self] in
                
                self?.mapPickView?.frame = CGRect(x: 0, y: (self?.searchController.searchBar.frame.maxY)!,width: UIScreen.main.bounds.size.width, height: LTLocationCommon.MapDefaultHeight)
                
                self?.listPickView?.frame = CGRect(x: 0, y: (self?.mapPickView?.frame.maxY)!,width: UIScreen.main.bounds.size.width, height: LTLocationCommon.TableViewDefaultHeight)
                
                }, completion: { (bol) in
                    
                    
            })
        }
    }
    
    /// MARK -- Map delegate
    func mapView(mapView: LTMapView, regionDidChangeAnimated animated: Bool) {
        
        if CLLocationCoordinate2DIsValid(mapView.centerCoordinate!) {
            
            location = mapView.centerCoordinate
        }
    }
    
}

/// MARK: -- UISearchBarDelegate
extension LTLocPickHomeView:UISearchBarDelegate {
    
    //点击搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        listPickView.resettRequestParameter()
        let word = searchBar.text

        searchResultVC.coordinate = location
        searchResultVC.isKeyboardSearch = true
        searchResultVC.searchPlaceWithKeyWord(keyword: word, adCode: "深圳")
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchResultVC.coordinate = location
        searchResultVC.isKeyboardSearch = true
        searchResultVC.searchPlaceWithKeyWord(keyword: searchText, adCode: "深圳")
    }
}

/// MARK -- LTLocationSearchResultVCDelegate
extension LTLocPickHomeView:LTLocationSearchResultVCDelegate {
    
    func tableViewDidSelectAt(selectedIndex:Int,model:LTPoiModel) {
        
        searchController.isActive = false

        let searchParam = LTPOISearchAroundArg()
        searchParam.city = model.city
        searchParam.keyword = model.title
        searchParam.location = model.coordinate
        
        listPickView?.searchParam = searchParam
        

        print(selectedIndex)
    }
}
