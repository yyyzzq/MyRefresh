//
//  UIScrollView+MyRefresh.swift
//  MyWallpaper
//
//  Created by yyyzzq on 2019/2/3.
//  Copyright © 2019 yyyzzq. All rights reserved.
//

import UIKit

private struct refreshKey {
    static var header  = "header"
    static var footer  = "footer"
    static var empty   = "empty"
    static var error   = "error"
    static var loading = "loading"
    static var state   = "state"
}

public enum MyLoadingState {
    case success
    case failure
    case loading
    case empty
}

extension UIScrollView {
    
    public var refreshHeader: MyRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &refreshKey.header) as? MyRefreshHeader
        }
        set {
            if let newHeader = newValue {
                guard refreshHeader != newHeader else {
                    return
                }
                refreshHeader?.removeFromSuperview()
                insertSubview(newHeader, at: 0)
            } else {
                refreshHeader?.removeFromSuperview()
            }
            objc_setAssociatedObject(self,
                                     &refreshKey.header,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var refreshFooter: MyRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &refreshKey.footer) as? MyRefreshFooter
        }
        set {
            if let newFooter = newValue {
                guard refreshFooter != newFooter else {
                    return
                }
                refreshFooter?.removeFromSuperview()
                insertSubview(newFooter, at: 0)
            } else {
                refreshHeader?.removeFromSuperview()
            }
            objc_setAssociatedObject(self,
                                     &refreshKey.footer,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func register(refreshHeader: MyRefreshHeader, _ action: @escaping (()->Void)) {
        self.refreshHeader = refreshHeader
        self.refreshHeader?.refreshCallBack = action
    }
    
    public func register(refreshFooter: MyRefreshFooter, _ action: @escaping (()->Void)) {
        self.refreshFooter = refreshFooter
        self.refreshHeader?.refreshCallBack = action
    }
    
    func removeRefreshHeader() {
        refreshHeader = nil
    }
    
    func removeRefreshFooter() {
        refreshFooter = nil
    }
}

extension UIScrollView {
    
    public var refreshEmpty: UIView? {
        get {
            return objc_getAssociatedObject(self, &refreshKey.empty) as? UIView
        }
        set {
            if let view = objc_getAssociatedObject(self, &refreshKey.empty) as? UIView {
                view.isHidden = true
            }
            if let newEmpty = newValue {
                guard refreshEmpty != newEmpty else {
                    return
                }
                refreshEmpty?.removeFromSuperview()
                insertSubview(newEmpty, at: 0)
            } else {
                refreshEmpty?.removeFromSuperview()
            }
            objc_setAssociatedObject(self,
                                     &refreshKey.empty,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var refreshError: UIView? {
        get {
            return objc_getAssociatedObject(self, &refreshKey.error) as? UIView
        }
        set {
            if let view = objc_getAssociatedObject(self, &refreshKey.error) as? UIView {
                view.isHidden = true
            }
            if let newError = newValue {
                guard refreshError != newError else {
                    return
                }
                refreshError?.removeFromSuperview()
                insertSubview(newError, at: 0)
            } else {
                refreshError?.removeFromSuperview()
            }
            objc_setAssociatedObject(self,
                                     &refreshKey.error,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var refreshLoading: MyRefreshAnimation? {
        get {
            return objc_getAssociatedObject(self, &refreshKey.loading) as? MyRefreshAnimation
        }
        set {
            if let view = objc_getAssociatedObject(self, &refreshKey.loading) as? MyRefreshAnimation {
                view.isHidden = true
            }
            if let newLoading = newValue {
                guard refreshLoading != newLoading else {
                    return
                }
                refreshLoading?.removeFromSuperview()
                insertSubview(newLoading, at: 0)
            } else {
                refreshLoading?.removeFromSuperview()
            }
            objc_setAssociatedObject(self,
                                     &refreshKey.loading,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var loadingState: MyLoadingState {
        get {
            guard let state = objc_getAssociatedObject(self, &refreshKey.state) as? MyLoadingState else {
                return .success
            }
            return state
        }
        set {
            if let error = refreshError {
                error.isHidden = newValue != .failure
            }
            if let empty = refreshEmpty {
                empty.isHidden = newValue != .empty
            }
            if let loading = refreshLoading {
                loading.isHidden = newValue != .loading
                if newValue == .loading {
                    loading.startAnimation()
                } else {
                    loading.stopAnimation()
                }
            }
            if let header = refreshHeader {
                header.isHidden = newValue == .loading || newValue == .failure
            }
            if let footer = refreshFooter {
                footer.isHidden = newValue != .success
            }
            objc_setAssociatedObject(self,
                                     &refreshKey.state,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
