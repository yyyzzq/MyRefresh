//
//  MyRefreshAutoFooter.swift
//  MyWallpaper
//
//  Created by yyyzzq on 2019/1/31.
//  Copyright © 2019 yyyzzq. All rights reserved.
//

import UIKit

open class MyRefreshAutoFooter: MyRefreshFooter {
    
    // 上拉刷新控件出现时是否自动刷新
    var isAutomatically = true
    // 上拉刷新控件出现百分之多少时自动刷新
    var appearPercent: Float = 1.0
    
    override open var refreshState: MyRefreshState {
        didSet {
            switch refreshState {
            case .refreshing:
                if oldValue != .refreshing {
                    performRefreshingCallBack()
                }
            default: break
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView?.contentInset.bottom = originContentInset.bottom + frame.size.height;
    }
    
    override open func contentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.contentSizeDidChange(change: change)
        
        guard let y = (change?[.newKey] as? CGSize)?.height else {
            return
        }
        frame.origin.y = y
    }
    
    override open func contentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.contentOffsetDidChange(change: change)
        
        guard refreshState != .refreshing && refreshState != .finish else {
            return
        }
        guard let old = (change?[.oldKey] as? CGPoint)?.y else {
            return
        }
        guard let new = (change?[.newKey] as? CGPoint)?.y else {
            return
        }
        guard new > old else {
            return
        }
        
        let scrollH = scrollView!.bounds.size.height
        let contentH = scrollView!.contentSize.height
        let top = scrollView!.contentInset.top
        
        // 判断内容是否小于屏幕
//        if (top + contentH) < scrollH {
//            let distance = -top
//            guard new > distance else {
//                return
//            }
//            print("开始刷新~~~^^^^^~~~~~~~~~~~~~~~~new:\(new),distance:\(distance)")
//            startRefreshing()
//            let isDragging = scrollView!.isDragging
//            if isDragging && refreshState != .ready {
//                refreshState = .ready
//            }
//            guard !isDragging && refreshState == .ready else {
//                return
//            }
//            startRefreshing()
//        } else {
            let height = bounds.size.height
            let distance = contentH - scrollH + height * CGFloat(appearPercent)
            guard new >= distance else {
                return
            }
            if isAutomatically && (top + contentH) >= scrollH {
                startRefreshing()
                print("footer~~auto~~new:\(new), distance:\(distance), contentH:\(contentH), scrollH:\(scrollH), height:\(height)")
            } else {
                let isDragging = scrollView!.isDragging
                if isDragging && refreshState != .ready {
                    refreshState = .ready
                }
                if !isDragging && refreshState == .ready {
                    startRefreshing()
                    print("footer~~drag~~new:\(new), distance:\(distance), contentH:\(contentH), scrollH:\(scrollH), height:\(height)")
                }
            }
//        }
    }
}
