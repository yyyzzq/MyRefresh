//
//  MyRefreshHeader.swift
//  MyRefresh
//
//  Created by yyyzzq on 2019/1/28.
//  Copyright © 2019 yyyzzq. All rights reserved.
//

import UIKit

open class MyRefreshHeader: MyRefreshControl {
    
//    public static func headerWithRefreshing(action: @escaping (()->Void)) -> MyRefreshHeader {
//        let header = self.init()
//        header.refreshCallBack = action
//        return header
//    }
    
    override open var refreshState: MyRefreshState {
        didSet {
            switch refreshState {
            case .refreshing:
                if oldValue != .refreshing && window != nil {
                    let offsetY = originContentInset.top > 0 ? bounds.size.height + originContentInset.top : bounds.size.height;
                    
                    UIView.animate(withDuration: 0.25,
                                   animations: {
                                    self.scrollView?.contentInset.top = offsetY
                                    self.scrollView?.contentOffset.y = -offsetY
                    },
                                   completion: { _ in
                                    self.performRefreshingCallBack()
                    })
                }
            case .normal:
                if oldValue == .refreshing {
                    UIView.animate(withDuration: 0.5,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 0.8,
                                   options: [.curveLinear],
                                   animations: {
                                    self.scrollView?.contentInset.top = self.originContentInset.top
                    },
                                   completion: { _ in
                                    self.refreshState = .normal
                    })
                }
            default: break
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        var h = layoutRefresh()
        if h == 0 {
            h = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        }
        self.frame.origin.y = -h
        self.frame.size.height = h
    }
    
    override open func contentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.contentOffsetDidChange(change: change)
        
        guard let newOffsetY = (change?[.newKey] as? CGPoint)?.y, newOffsetY <= 0 else {
            return
        }
//        guard newOffsetY <= 0 else {
//            return
//        }
        if !scrollView!.isDragging && refreshState == .ready {
            startRefreshing()
            return
        }
        
        let insetTop = -originContentInset.top
        var refreshValue = -bounds.size.height;
        if insetTop < 0 {
            refreshValue -= originContentInset.top
        }
        
        if refreshState == .refreshing {
            // https://stackoverflow.com/questions/5466097/section-headers-in-uitableview-when-inset-of-tableview-is-changed
            // section headerView 在界面上的显示位置由UITableView.contentInset.top决定，直到被下一个section headerView替代
            var insetT = max(-scrollView!.contentOffset.y, originContentInset.top)
            insetT = min(insetT, -refreshValue)
            scrollView?.contentInset.top = insetT
            return
        }
        
        if newOffsetY >= insetTop {
            if refreshState != .normal {
                refreshState = .dragging(progress: 0.0)
                refreshState = .normal
            }
        } else if newOffsetY <= refreshValue {
            if scrollView!.isDragging && refreshState != .ready {
                refreshState = .dragging(progress: 1.0)
                refreshState = .ready
            }
        } else if newOffsetY <= 0 {
            var off = newOffsetY + ignoreHeight
            var h = refreshValue + ignoreHeight
            
            if originContentInset.top > 0 {
                off += originContentInset.top
                h += originContentInset.top
            }
            if off <= 0 {
                refreshState = .dragging(progress: Float(max(min(abs(off / h), 1), 0)))
            }
        }
    }
}
