//
//  MyRefreshStateView.swift
//  MyWallpaper
//
//  Created by yyyzzq on 2019/2/3.
//  Copyright © 2019 yyyzzq. All rights reserved.
//

import UIKit

protocol RefreshAnimation {
    func startAnimation()
    func stopAnimation()
}

open class MyRefreshAnimation: UIView, RefreshAnimation {
    
    open func startAnimation() {
    }
    
    open func stopAnimation() {
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if superview == nil && newSuperview != nil {
            self.frame = newSuperview!.bounds
        }
    }
}
