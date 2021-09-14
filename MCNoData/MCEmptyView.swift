//
//  MCEmptyView.swift
//  MCNoData
//
//  Created by zc_mc on 2021/9/13.
//

import UIKit
import SnapKit

class MCEmptyView: UIView {
    
    private var btnClickBlock: (() -> ())?
    
    /// 缺省页初始化器
    /// - Parameters:
    ///   - image: 缺省图
    ///   - title: 缺省标题
    ///   - btnTitle: 按钮标题
    ///   - topY: 居上高度（该值大于0，就会居上布局）
    ///   - offset: 相对竖向居中的偏移（默认竖向居中，如果topY>0,就会居上布局）
    ///   - btnClickAction: 按钮回调
    init(image: UIImage?,
         title: String?,
         btnTitle: String?,
         topY: CGFloat = 0,
         offset: CGFloat = 100,
         btnClickAction: (() -> ())?) {
        super.init(frame: .zero)
        
        self.image = image
        self.title = title
        self.btnTitle = btnTitle
        self.topY = topY
        self.offset = offset
        
        self.btnClickBlock = btnClickAction
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var topY: CGFloat?
    private let stackSpacing: CGFloat = 20
    private var offset: CGFloat = 100
    
    private var image: UIImage? {
        didSet {
            addImageView()
        }
    }
    
    private var title: String? {
        didSet {
            addTitle()
        }
    }
    
    private var btnTitle: String? {
        didSet {
            addBtn()
        }
    }
    
    private lazy var imgView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var btn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor("#ffffff"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.backgroundColor = UIColor.orange
        return btn
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = stackSpacing
        return view
    }()
    
    private func setupUI() {
        
        self.backgroundColor = .white
        self.addSubview(contentStackView)
        
        if let top = topY, top > 0 {
            contentStackView.snp.makeConstraints { make in
                make.top.equalTo(top)
                make.centerX.equalToSuperview()
            }
        } else {
            contentStackView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-self.offset)
            }
        }

        
        addImageView()
        addTitle()
        addBtn()
    }
    
    private func addImageView() {
        if let img = image {
            imgView.image = img
            if contentStackView.contains(imgView) { return }
            contentStackView.addArrangedSubview(imgView)
        }
    }
    
    private func addTitle() {
        if let tit = title, tit.count > 0 {
            titleLabel.text = tit
            if contentStackView.contains(titleLabel) { return }
            contentStackView.addArrangedSubview(titleLabel)
            
        }
    }
    
    private func addBtn() {
        if let btnTit = btnTitle, btnTit.count > 0 {
            btn.setTitle(btnTit, for: .normal)
            if contentStackView.contains(btn) { return }
            contentStackView.addArrangedSubview(btn)
            btn.snp.makeConstraints { make in
                make.width.equalTo(150)
                make.height.equalTo(40)
            }
            btn.layer.cornerRadius = 20
        }
    }
    
}


