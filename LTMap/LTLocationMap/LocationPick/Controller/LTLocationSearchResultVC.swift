//
//  LTLocationSearchResultVC.swift
//  LTMap
//
//  Created by aken on 2017/6/3.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit
import MJRefresh

class LTLocationSearchResultVC: UIViewController {
    
    
    // MARK: -- 公共成员
    
    var dataSource = [LTPoiModel]()
    
    var hastNext:Bool = false
    
    var isKeyboardSearch:Bool = false {
        
        didSet {
            
            resettRequestParameter()
        }
    }
    
    weak var searchBar:UISearchBar?
    
    var coordinate:CLLocationCoordinate2D? {
        
        didSet {
            
            searchParam.location = coordinate
        }
    }
    
    weak open var delegate: LTLocationSearchResultVCDelegate?
    
    var searchParam = LTPOISearchAroundArg()
    
    fileprivate var poiManager = LTGeocodeManager()
    
    fileprivate lazy var tableView:UITableView = {
        
        let myTableView = UITableView(frame: CGRect.zero, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        return myTableView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor =  UIColor.white
        
        self.edgesForExtendedLayout = [] //.all
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = false
        
        setupUI()
        addViewContrains()
        
       
        searchParam.offset = LTLocationCommon.POISearchPageSize;
        searchParam.page = 1;
        searchParam.radius = LTLocationCommon.POISearchRadius;
        
    }

    func setupUI() {
    
        view.addSubview(tableView)
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            [weak self] in
            
            if self?.hastNext == true {
                
                self?.searchParam.page = (self?.searchParam.page!)! + 1;
     
                if (self?.isKeyboardSearch)! {
                    
                    self?.searchPlaceWithKeyWord(keyword: self?.searchParam.keyword, adCode: self?.searchParam.city)
                    
                }else {
                    
                    self?.searchInputTipsAutoCompletionWithKeyword(keyword: self?.searchParam.keyword, cityName: self?.searchParam.city)
                }
                
            }else {
                
                self?.tableView.mj_footer.isHidden = true;
            }
        })
    }
    
    private func addViewContrains() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
    }

    // MARK: -- 公共方法
    func reloadData() {
        
        tableView.reloadData()
    }
    
    func resettRequestParameter() {
        
        dataSource.removeAll()
        
        searchParam.offset = LTLocationCommon.POISearchPageSize;
        searchParam.page = 1;
        searchParam.radius = LTLocationCommon.POISearchRadius;
        searchParam.city = ""
        searchParam.keyword = ""
        tableView.mj_footer.isHidden = false;
        hastNext = false
        
    }
    

    func searchInputTipsAutoCompletionWithKeyword(keyword:String?,cityName:String?) {
        
        searchParam.city = cityName
        searchParam.keyword = keyword
        
        poiManager.searchInputTipsAutoCompletionWithKeyword(param:searchParam) { [weak self](array, hasNext) in
            
            self?.tableView.mj_footer.endRefreshing()
            
//            self?.hastNext = hastNext as! Bool
            
            if array.count > 0 {
                
                self?.dataSource.append(contentsOf: array)
                self?.reloadData()
            
            }
            
        }
        
    }
    
    func searchPlaceWithKeyWord(keyword:String?,adCode:String?) {
    
        searchParam.city = adCode
        searchParam.keyword = keyword
        
        poiManager.searchPlaceWithKeyWord(param:searchParam) {  [weak self](array, hastNext) in
            
            self?.tableView.mj_footer.endRefreshing()
            
            self?.hastNext = hastNext as! Bool
            
            if array.count > 0 {
                
                self?.dataSource.append(contentsOf: array)
                self?.tableView.reloadData()
                
                self?.tableView.mj_footer.isHidden = false;
            }
            
            if self?.hastNext == false {
                
                self?.tableView.mj_footer.isHidden = true;
            }
            
        }
    }

}

protocol LTLocationSearchResultVCDelegate : NSObjectProtocol {
    
    func tableViewDidSelectAt(selectedIndex:Int,model:LTPoiModel)
}
