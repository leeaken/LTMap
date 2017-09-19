//
//  LTPopMenuView.swift
//  LTMap
//
//  可滑动的菜单view
//  Created by aken on 2017/5/25.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit


let defaultPopMenuViewHeight:CGFloat = 100

class LTPopMenuView: UIView {

    private var marginTop:CGFloat?
    private var beginpoint: CGPoint?
    private var isCanSlide:Bool = false
    
    
    var canSlide: Bool = false {
        
        didSet {
            
            isCanSlide = canSlide
        }
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        if !isCanSlide {
            
            return
        }

        self.marginTop = (self.superview?.frame.size.height)!/2 + 20
        
        for touch: AnyObject in touches {
            
            let t:UITouch = touch as! UITouch
            
            beginpoint = t.location(in: self)
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        
        if !isCanSlide {
            
            return
        }
        
        for tmpTouch: AnyObject in touches {
            
            let touch:UITouch = tmpTouch as! UITouch
            let currentPosition:CGPoint = touch.location(in: self)
            let offsetY = currentPosition.y - (beginpoint?.y)!
            
            
            self.center = CGPoint(x: self.center.x , y: self.center.y + offsetY)
        
            
            print("\(self.center .y)---> \(self.frame.size.height/2)")
        
            
            // y轴最上面
            let minBottomY = (self.superview?.frame.size.height)!/2 + 20
            
             if self.center.y <= minBottomY {

                self.center = CGPoint(x: self.center.x , y: minBottomY)
                self.marginTop = minBottomY
            }
    
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        if !isCanSlide {
            
            return
        }

        let maxBottomY = (self.superview?.frame.size.height)! + defaultPopMenuViewHeight
        
        
        let midBottomY = self.superview?.frame.size.height
        
        if self.center.y > maxBottomY {
            
            UIView.beginAnimations("move", context: nil)
            UIView.setAnimationDuration(1)
            
            self.center = CGPoint(x: self.center.x , y: maxBottomY)
            
            
            
            UIView.commitAnimations()
            
            print("\(self.frame.origin.y)")
        
        }else if self.center.y > (midBottomY! + 20) { // 下滑屏幕中间就自动滚动到默认位置
            
            UIView.beginAnimations("move", context: nil)
            UIView.setAnimationDuration(0.5)
            
            self.center = CGPoint(x: self.center.x , y: maxBottomY)
            
            UIView.commitAnimations()
        
        }else if self.center.y <= midBottomY! { // 超出屏幕中间就自动滚动到顶部
            
            UIView.beginAnimations("move", context: nil)
            UIView.setAnimationDuration(0.5)
            
            self.center = CGPoint(x: self.center.x , y: self.marginTop!)
            
            UIView.commitAnimations()
        }
    }

    
   // MARK: - 创建UI
    func setupUI() {
        
        
    }
}
