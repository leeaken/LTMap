//
//  LTLocationCell.swift
//  LTMap
//
//  Created by aken on 2017/6/6.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit
import SnapKit

class LTLocationCell: UITableViewCell {

    private var selectedImageView:UIImageView?
    
    // 包含有图片
    var enabledFoundCharacter:Bool?
    
    var searchKeyword:String?
    
    var isSelectViewHidden:Bool = false {
        
        didSet {
            
            if isSelectViewHidden {
                
                selectedImageView?.isHidden = true
                
            }else {
                
                selectedImageView?.isHidden = false
            }
        }
    }
    
    var model:LTPoiModel? {
    
        didSet {
            
            
            if enabledFoundCharacter! {
                
                let rangStr:String = searchKeyword!
                
                let string = model?.title
                
                if let range = string?.range(of: rangStr) {
                    
                    let nsRange = string?.nsRange(from: range)
                    
                    //富文本设置
                    let attributeString = NSMutableAttributedString(string:(model?.title)!)
                    
                    //设置字体颜色
                    let color = UIColor(red: 0.12, green: 0.74, blue: 0.13, alpha: 1.00)
                    attributeString.addAttribute(NSForegroundColorAttributeName, value: color,
                                                 range: nsRange!)
                    
                    self.textLabel?.attributedText = attributeString
                    
                    self.detailTextLabel?.text = model?.subtitle
                    
                }

            }
            
        }
    
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        
        selectedImageView = UIImageView(image: UIImage(named: "location_select"))
        selectedImageView?.isHidden = true
        contentView.addSubview(selectedImageView!)
        
        selectedImageView?.snp.makeConstraints({ (make) in
            make.right.equalTo(contentView.snp.right).offset(-25)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(15)
            make.height.equalTo(11)
        })
    }
}


extension String {
    func nsRange(from range: Range<Index>) -> NSRange {
        let lower = UTF16View.Index(range.lowerBound, within: utf16)
        let upper = UTF16View.Index(range.upperBound, within: utf16)
        return NSRange(location: utf16.startIndex.distance(to: lower), length: lower.distance(to: upper))
    }
}
