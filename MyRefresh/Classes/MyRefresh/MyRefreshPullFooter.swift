//
//  MyRefreshPullFooter.swift
//  MyWallpaper
//
//  Created by yyyzzq on 2019/1/31.
//  Copyright © 2019 yyyzzq. All rights reserved.
//

import UIKit

open class MyRefreshPullFooter: MyRefreshFooter {
    
    override open var refreshState: MyRefreshState {
        didSet {
            let h = self.bounds.size.height
            let distance = ceil(self.scrollView!.contentSize.height - self.scrollView!.bounds.size.height)
            
            switch refreshState {
            case .refreshing:
                if oldValue != .refreshing {
                    UIView.animate(withDuration: 0.25,
                                   animations: {
                                    
                                    var bottom = h
                                    var offsetY = distance + bottom
                                    
                                    if distance < 0 {
                                        bottom = h - distance
                                        offsetY = h
                                    } else if self.originContentInset.bottom > 0 {
                                        offsetY += self.originContentInset.bottom
                                        bottom += self.originContentInset.bottom
                                    }
                                    print("~~~~~~~~~~~~~~~bottom:\(bottom),offsetY:\(offsetY)")
                                    self.scrollView?.contentInset.bottom = bottom
                                    self.scrollView?.contentOffset.y = offsetY
                    },
                                   completion: { (_) in
                                    self.performRefreshingCallBack()
                    })
                }
            case .normal:
                if oldValue == .refreshing {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.scrollView?.contentInset.bottom = self.originContentInset.bottom
                        let offsetY = self.scrollView!.contentOffset.y
                        print("footer==finish==^^==offset:\(offsetY),distance:\(distance)")
                        if distance > 0 && offsetY <= distance {
                            let v = h - min(self.originContentInset.bottom, 0.0)
                            self.scrollView?.contentOffset.y += v
                        }
                    }) { (_) in
                        if self.refreshState != .normal {
                            self.refreshState = .normal
                        }
                    }
                }
            default: break
            }
        }
    }
    
    override open func contentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.contentSizeDidChange(change: change)
        
        guard let y = (change?[.newKey] as? CGSize)?.height else {
            return
        }
        frame.origin.y = max(y, self.scrollView!.bounds.size.height)
    }
    
    override open func contentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.contentOffsetDidChange(change: change)
        
        guard refreshState != .refreshing else {
            return
        }
        guard let offsetY = (change?[.newKey] as? CGPoint)?.y, offsetY >= 0 else {
            return
        }
//        guard offsetY >= 0 else {
//            return
//        }
        let scrollH = scrollView!.bounds.size.height
        let contentH = scrollView!.contentSize.height
        let bottom = scrollView!.contentInset.bottom
        var distance = max(ceil(contentH - scrollH), 0.0)
        if bottom > 0 {
            distance += bottom
        }
        print("foot--- offsetY = \(offsetY), distance = \(distance)")
        guard offsetY > distance else {
            if refreshState != .normal {
                print("foot--- normal===  off:\(offsetY), dis:\(distance)")
                refreshState = .normal
            }
            return
        }
        
        let isDragging = scrollView!.isDragging
        if refreshState == .ready && !isDragging {
            startRefreshing()
            print("foot--- 开始刷新~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
            return
        }
        
        let maxValue = ceil(distance + bounds.size.height)
        
        if offsetY <= maxValue {
            /*
             var off = newOffsetY + ignoreHeight
             var h = refreshValue + ignoreHeight
             
             if originContentInset.top > 0 {
             off += originContentInset.top
             h += originContentInset.top
             }
             if off <= 0 {
             refreshState = .dragging(progress: Float(max(min(abs(off / h), 1), 0)))
             }
             */
            if offsetY >= distance + ignoreHeight {
                print("foot--- dragging===  off:\(offsetY), dis:\(distance), max:\(maxValue), progress:\(abs(offsetY / maxValue))") //((offsetY - distance) / (maxValue - distance))
                let progress = abs((offsetY + ignoreHeight) / maxValue)
                refreshState = .dragging(progress: Float(max(min(progress, 1), 0)))
            }
        } else if offsetY > maxValue {
            print("foot--- ready===  off:\(offsetY), dis:\(distance), max:\(maxValue)")
            if refreshState != .ready && isDragging {
                print("foot--- 准备刷新~~~isDragging:\(isDragging)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                refreshState = .ready
            }
        }
    }
}
