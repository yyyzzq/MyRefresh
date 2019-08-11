//
//  MyRefreshFooter.swift
//  MyWallpaper
//
//  Created by yyyzzq on 2019/1/29.
//  Copyright © 2019 yyyzzq. All rights reserved.
//

import UIKit

open class MyRefreshFooter: MyRefreshControl {
    
    public static func footerWithRefreshing(action: @escaping (()->Void)) -> MyRefreshFooter {
        let footer = self.init()
        footer.refreshCallBack = action
        return footer
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        var h = layoutRefresh()
        if h == 0 {
            h = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        }
        frame.size.height = h
    }
    
//    override func contentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
//        super.contentSizeDidChange(change: change)
//        
//        guard let y = (change?[.newKey] as? CGSize)?.height else {
//            return
//        }
//        frame.origin.y = max(y, scrollView!.bounds.size.height)
//    }
}
