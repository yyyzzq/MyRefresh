//
//  MyRefreshStatus.swift
//  MyWallpaper
//
//  Created by yyyzzq on 2019/2/9.
//  Copyright © 2019 yyyzzq. All rights reserved.
//

import UIKit

//class MyRefreshPlaceHolder: UIView {
//
//    var verticalOffset : CGFloat = 0.0
//    var verticalSpacing: CGFloat = 10.0
//
//    lazy var imageView: UIImageView = {
//        addSubview($0)
//        return $0
//    }(UIImageView())
//
//    lazy var titleLabel: UILabel = {
//        addSubview($0)
//        return $0
//    }(UILabel())
//
//    override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//
//        if superview == nil && newSuperview != nil {
//            self.frame = newSuperview!.bounds
//        }
//    }
//}

open class MyRefreshPlaceHolder: UIView {
    
    /// 图片
    lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        addSubview($0)
        return $0
    }(UIImageView())
    /// 标题
    lazy var titleLabel: UILabel = {
        $0.textAlignment = .center
        $0.font = cconfig.titleFont
        $0.textColor = cconfig.blackColor
        addSubview($0)
        return $0
    }(UILabel())
    /// 详情
    lazy var detailLabel: UILabel = {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = cconfig.detailFont
        $0.textColor = cconfig.grayColor
        addSubview($0)
        return $0
    }(UILabel())
    /// 按钮
    lazy var actionButton: UIButton = {
        $0.backgroundColor = cconfig.actionColor
        $0.titleLabel?.font = cconfig.actionFont
        $0.setTitleColor(cconfig.blackColor, for: .normal)
        $0.layer.cornerRadius = 3.0
        $0.addTarget(self, action: #selector(tap), for: .touchUpInside)
        addSubview($0)
        return $0
    }(UIButton())
    
    var tapHandle: (()->Void)? {
        didSet {
            if let _ = tapHandle, actionTitle == nil {
                self.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    var verticalOffset : CGFloat = cconfig.offsetY {
        didSet {
            layout()
        }
    }
    var verticalSpacing: CGFloat = cconfig.margin {
        didSet {
            layout()
        }
    }
    var actionSize: CGSize? {
        didSet {
            layout()
        }
    }
    var detailWidth: CGFloat = cconfig.widthMax {
        didSet {
            layout()
        }
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(tap))
    }()
    
    private var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    private var title: String? {
        didSet {
           self.titleLabel.text = title
        }
    }
    private var detailTitle: String? {
        didSet {
           self.detailLabel.text = detailTitle
        }
    }
    private var actionTitle: String? {
        didSet {
            self.actionButton.setTitle(actionTitle, for: .normal)
        }
    }
    
    public convenience init(imageName: String?, title: String?, action: (()->Void)? = nil) {
        self.init(imageName, title, nil, nil, action)
    }
    
    public convenience init(imageName: String?, title: String?, detailTitle: String?, action: (()->Void)? = nil) {
        self.init(imageName, title, detailTitle, nil, action)
    }
    
    public convenience init(imageName: String?, title: String?, actionTitle: String?, action: (()->Void)? = nil) {
        self.init(imageName, title, nil, nil, action)
    }
    
    public init(_ imageName: String?, _ title: String?, _ detailTitle: String?, _ actionTitle: String?, _ action: (()->Void)? = nil) {
        super.init(frame: CGRect.zero)
        
        if let img = imageName {
            self.image = UIImage(named: img)
            self.imageView.image = self.image
        }
        if let txt = title {
            self.title = txt
            self.titleLabel.text = txt
        }
        if let det = detailTitle {
            self.detailTitle = det
            self.detailLabel.text = det
        }
        if let act = actionTitle {
            self.actionTitle = act
            self.actionButton.setTitle(act, for: .normal)
        }
        if let han = action {
            self.tapHandle = han
        }
        if action != nil && actionTitle == nil {
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if superview == nil && newSuperview != nil && self.frame == CGRect.zero {
            self.frame = newSuperview!.bounds
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        
        var imgH: CGFloat = 0.0
        var txtH: CGFloat = 0.0
        var detH: CGFloat = 0.0
        var btnH: CGFloat = 0.0
        
        if let _ = image {
            imageView.sizeToFit()
            imageView.center.x = self.center.x
            imgH = imageView.bounds.size.height + verticalSpacing
        }
        if let _ = title {
            titleLabel.sizeToFit()
            titleLabel.center.x = self.center.x
            txtH = titleLabel.bounds.size.height + verticalSpacing
        }
        if let txt = detailTitle {
            detH = txt.boundingRect(with: CGSize(width: detailWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [.font : detailLabel.font], context: nil).size.height
            detailLabel.frame.size = CGSize(width: detailWidth, height: detH)
            detailLabel.center.x = self.center.x
            detH += verticalSpacing
        }
        if let _ = actionTitle {
            var buttonSize = CGSize.zero
            if let size = self.actionSize {
                buttonSize = size
            } else {
                actionButton.sizeToFit()
                let w = max(min(actionButton.bounds.width + cconfig.actionPadding * 2, cconfig.widthMax), cconfig.actionWidthMin)
                let h = actionButton.bounds.height + cconfig.actionPadding
                buttonSize = CGSize(width: w, height: h)
            }
            actionButton.frame.size = buttonSize
            actionButton.center.x = self.center.x
            btnH = buttonSize.height
        }
        
        let y = (self.bounds.size.height - imgH - txtH - detH - btnH) * 0.5 + verticalOffset
        
        if let _ = image {
            imageView.frame.origin.y = y
        }
        if let _ = title {
            titleLabel.frame.origin.y = y + imgH
        }
        if let _ = detailTitle {
            detailLabel.frame.origin.y = y + imgH + txtH
        }
        if let _ = actionTitle {
            actionButton.frame.origin.y = y + imgH + txtH + detH
        }
    }
    
    @objc func tap() {
        if let action = tapHandle {
            action()
        }
    }
}

private struct cconfig {
    // 每个子控件之间的间距
    static let margin: CGFloat = 20.0
    // 距离中心点y的偏移量
    static let offsetY: CGFloat = 0.0
    // 按钮边缘距离文字的间距
    static let actionPadding: CGFloat = 10.0
    // 按钮最小宽度
    static let actionWidthMin: CGFloat = 150.0
    // 最大宽度
    static let widthMax: CGFloat = UIScreen.main.bounds.size.width - 12.0 * 2
    // 描述字体
    static let titleFont = UIFont.systemFont(ofSize: 16)
    // 详细描述字体
    static let detailFont = UIFont.systemFont(ofSize: 15)
    // 按钮字体大小
    static let actionFont = UIFont.systemFont(ofSize: 14)
    // 黑色
    static let blackColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
    // 灰色
    static let grayColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    // 按钮颜色
    static let actionColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
}
