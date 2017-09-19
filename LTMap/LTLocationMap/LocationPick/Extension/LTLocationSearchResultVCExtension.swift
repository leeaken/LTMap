//
//  LTLocationSearchResultVCExtension.swift
//  LTMap
//
//  导航界面-搜索结果拓展
//  Created by aken on 2017/6/4.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit


private let cellForSearchIdentifier = "cellForSearchIdentifier"

extension LTLocationSearchResultVC : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
        
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellForSearchIdentifier) as? LTLocationCell
        
        if cell == nil {
            
            cell =  LTLocationCell(style:.subtitle,reuseIdentifier: cellForSearchIdentifier)
        }
        
        let model = dataSource[indexPath.row]
        
        cell?.searchKeyword = searchParam.keyword
        cell?.enabledFoundCharacter = true
        cell?.model = model
        
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataSource[indexPath.row]
        
        if let del = self.delegate {
            
            del.tableViewDidSelectAt(selectedIndex: indexPath.row, model: model)
        }
        
        print(model.subtitle as Any)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if let  tmpSearchBar = searchBar {
            
            if dataSource.count > 0 {
             
                tmpSearchBar.resignFirstResponder()
            }
        }
        
        
    }
}
