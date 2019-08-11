//
//  MyRefreshControl.swift
//  MyRefresh
//
//  Created by yyyzzq on 2019/1/28.
//  Copyright © 2019 yyyzzq. All rights reserved.
//

import UIKit

public enum MyRefreshState: Equatable {
    case normal
    case dragging(progress: Float)
    case ready
    case refreshing
    case finish
}

open class MyRefreshControl: UIView {
    
    weak var scrollView:    UIScrollView?
    var originContentInset: UIEdgeInsets = UIEdgeInsets.zero
    open var refreshState:  MyRefreshState = .normal
    
    public var ignoreHeight: CGFloat = 0.0
    var refreshCallBack:    (() -> Void)?
    
    private var observering = false
    private var refreshWhenDraw = false
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if self.superview != nil && newSuperview == nil {
            if observering { // 移除监听
                removeObserver(self, forKeyPath: KVO.KeyPath.contentOffset)
            }
        } else if superview == nil && newSuperview != nil {
            if !observering {
                guard newSuperview!.isKind(of: UIScrollView.self) else {
                    return
                }
                scrollView = (newSuperview as! UIScrollView)
                originContentInset = scrollView!.contentInset
                
                frame = CGRect(x: 0, y: frame.origin.y, width: newSuperview!.bounds.size.width, height: frame.size.height)
                scrollView?.alwaysBounceVertical = true
                
                addRefreshObserver()
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if refreshWhenDraw {
            refreshWhenDraw = false
            startRefreshing()
        }
    }
    
//    init() {
//        super.init(frame: CGRect.zero)
//        initRefresh()
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initRefresh()
    }
    
    open func initRefresh() {
        backgroundColor = UIColor.white
    }
    open func layoutRefresh() -> CGFloat {
        return 0.0
    }
    
    open func startRefreshing() {
//        print("开始刷新-startRefreshing")
        if window == nil {
            refreshWhenDraw = true
            self.setNeedsDisplay()
        } else {
            self.refreshState = .refreshing
        }
    }
    
    open func endRefreshing(state: MyRefreshState = .normal) {
        //        print("结束刷新-endRefreshing")
        self.refreshState = state
    }
    
    public func performRefreshingCallBack() {
        if let blcok = refreshCallBack {
            blcok()
        }
    }
    
    open func contentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
    }
    open func contentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        scrollView?.removeRefreshHeader()
        removeRefreshObserver()
    }
}

extension MyRefreshControl {
    
    private struct KVO {
        enum KeyPath {
            static let contentOffset = #keyPath(UIScrollView.contentOffset)
            static let contentSize   = #keyPath(UIScrollView.contentSize)
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard window != nil else {
            return
        }
        guard object as? UIScrollView == scrollView else {
            return
        }
        guard self.isUserInteractionEnabled else {
            return
        }
        guard !self.isHidden else {
            return
        }
        
        if keyPath == KVO.KeyPath.contentOffset {
            contentOffsetDidChange(change: change)
        }
        if keyPath == KVO.KeyPath.contentSize {
            contentSizeDidChange(change: change)
        }
    }
    
    private func addRefreshObserver() {
        self.scrollView?.addObserver(self, forKeyPath: KVO.KeyPath.contentOffset, options: [.old, .new], context: nil)
        self.scrollView?.addObserver(self, forKeyPath: KVO.KeyPath.contentSize, options: [.old, .new], context: nil)
        
        observering = true
    }
    
    private func removeRefreshObserver() {
        self.scrollView?.removeObserver(self, forKeyPath: KVO.KeyPath.contentOffset)
        self.scrollView?.removeObserver(self, forKeyPath: KVO.KeyPath.contentSize)
        
        observering = false
    }
}
