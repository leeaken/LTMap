//
//  LTLocPickListView.swift
//  LTMap
//
//  列表信息
//  Created by aken on 2017/6/16.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import Foundation
import MJRefresh

protocol LTLocPickListViewDelegate:NSObjectProtocol {
    
    func tableViewForPickListViewDidSelectAt(selectedIndex:Int,model:LTPoiModel)
    
    func scrollViewOnPickListViewDidScroll(_ scrollView: UIScrollView)
}

class LTLocPickListView:UIView {
    
    
    weak var delegate:LTLocPickListViewDelegate?
    
    public private(set)  var dataSource = [LTPoiModel]()
    
    var searchParam = LTPOISearchAroundArg() {
        
        didSet {
            
            isSearchKeyword = true
            resettRequestParameter()
            
            searchKeyword(param: searchParam)
        }
    }
    
    fileprivate var hastNext:Bool = false
    
    fileprivate var selectedItem:String?
    
    fileprivate var currentSelected:Int = 0
    
    fileprivate var poiManager = LTGeocodeManager()
    
    private var isSearchKeyword = false
    
    var location:CLLocationCoordinate2D?  {
        
        didSet  {
            
            resettRequestParameter()
            
            if(!AMapDataAvailableForCoordinate(location!)) {
                
//                let alert = UIAlertController(title: "", message: "当前位置不在中国区域内，是否切谷歌服务", preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//                let okAction = UIAlertAction(title: "确定", style: .default, handler:{
//                    (UIAlertAction) -> Void in
//                    print("点击确定事件")
//                })
//                
//                alert.addAction(cancelAction)
//                alert.addAction(okAction)
//                
//                self.viewController(self).present(alert, animated: true, completion: nil)
                
                poiManager.switchSearchCountry(type: .LTAbroad)
                
                
                
            }else {
                
                poiManager.switchSearchCountry(type: .LTCN)
            }
            
             searchPlayWithCoordinate(coord: location!)
        }
    
    }
    
    lazy var tableView:UITableView = {
        
        let myTableView = UITableView(frame: CGRect.zero, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        return myTableView
        
    }()
    
    override var frame:CGRect {
        
        didSet {
            
            super.frame = frame
            
            addViewContrains()
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        
        addViewContrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.addSubview(tableView)
        
        searchParam.offset = LTLocationCommon.POISearchPageSize;
        searchParam.radius = LTLocationCommon.POISearchRadius;
        searchParam.page = 1;

        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            [weak self] in
            
            if self?.hastNext == true {
                
                self?.searchParam.page = (self?.searchParam.page!)! + 1;
                
                if (self?.isSearchKeyword)! {
                
                    self?.searchKeyword(param: (self?.searchParam)!)
                    
                }else {
                    
                    self?.searchPlayWithCoordinate(coord: (self?.searchParam.location)!)
                }
                
            }
        })

    }
    
    private func addViewContrains() {
        
        tableView.frame = self.bounds
    }
    
    // MARK:-- public
    
    /// 根据经纬度搜索附近-(当进入此界面时，会自动调用)
    private func searchPlayWithCoordinate(coord:CLLocationCoordinate2D) {
        
        if CLLocationCoordinate2DIsValid(coord) {
            searchParam.location = coord
        }
        
        poiManager.searchNearbyWithCoordinate(param: searchParam) { [weak self](array, hastNext) in
            
            self?.tableView.mj_footer.endRefreshing()
            
            self?.hastNext  = hastNext as! Bool
            
            if array.count > 0 {
                
                self?.dataSource.append(contentsOf: array)
                self?.tableView.reloadData()
                self?.findSelectedItem()
                
                self?.tableView.mj_footer.isHidden = false;
            }
            
            if self?.hastNext == false {
                
                self?.tableView.mj_footer.isHidden = true;
            }
        }
        
        
    }
    
    /// 根据关键字搜索附近(当进入用户搜索关键字时，出现的数据列表，点击列表时会调用)
    private func searchKeyword(param: LTPOISearchAroundArg) {
        
        poiManager.searchPlaceWithKeyWord(param: param) {  [weak self](array, hastNext) in
            
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
    
    private func viewController(_ view: UIView) -> UIViewController {
        
        var responder: UIResponder? = view
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        return (responder as? UIViewController)!
    }
    
    private func findSelectedItem() {
        
        if selectedItem == nil {
            return
        }
        
        var i:Int = 0
        
        for item in dataSource {
            
            if ((item.uid?.compare(selectedItem!)) != nil) {
                
                currentSelected = i
                break
            }
            
            i += 1
        }
        
    }
    
    func resettRequestParameter() {
        
        dataSource.removeAll()
        searchParam.offset = LTLocationCommon.POISearchPageSize;
        searchParam.page = 1;
        searchParam.radius = LTLocationCommon.POISearchRadius;
        hastNext = false
        
        tableView.reloadData()
        
    }
}

// MARK: -- UITableView delegate
extension LTLocPickListView:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LTLocationCell
        
        if cell == nil {
            
            cell =  LTLocationCell(style:.subtitle,reuseIdentifier: cellIdentifier)
        }
        
        let model = dataSource[indexPath.row]
        
        cell?.textLabel?.text =  model.title
        cell?.detailTextLabel?.text = model.subtitle
        
        if (indexPath.row == self.currentSelected) {
            cell?.isSelectViewHidden = false;
        } else {
            cell?.isSelectViewHidden = true;
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.row]
        
        self.currentSelected = indexPath.row
            
        tableView.reloadData()
        
        
        if (delegate != nil)  {
        
            delegate?.tableViewForPickListViewDidSelectAt(selectedIndex: indexPath.row, model: model)
        }
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if (delegate != nil)  {
            
            delegate?.scrollViewOnPickListViewDidScroll(scrollView)
        }
        
    }

}

// MARK: -- UIAlertViewDelegate
extension LTLocPickListView:UIAlertViewDelegate {
    
    
}


