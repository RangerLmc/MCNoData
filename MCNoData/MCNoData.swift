//
//  MCNoData.swift
//  MCNoData
//
//  Created by zc_mc on 2021/9/13.
// 利用runtime的方法交换reloadData来处理缺省页

import UIKit

/// 我们可以通过给DispatchQueue实现一个扩展方法来实现DispatchOnce(已经被废弃)的功能
extension DispatchQueue {
    private static var onceTracker = [String]()
    class func once(_ token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}

extension NSObject {
    
    static func swizzleMethod(_ cls: AnyClass, originSelector: Selector, swizzleSelector: Selector) {
        // 获取原方法
        let originMethod = class_getInstanceMethod(cls, originSelector)!
        // 获取魔法方法
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSelector)!
        
        // 添加魔法方法
        let didAssMethod = class_addMethod(cls, originSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod))
        
        if didAssMethod {
            // 使用魔法方法替换原方法
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod))
        } else {
            method_exchangeImplementations(originMethod, swizzleMethod)
        }
    }
    
}

/// 程序运行后就要调用方法交换
extension UIApplication {
    static let classSwizzedMethod: Void = {
        UITableView.mc_initialize
        
    }()
    
    open override var next: UIResponder? {
        UITableView.mc_initialize
        return super.next
    }
}

/// UITableView无数据协议
protocol UITableViewNoDataDelegate: NSObjectProtocol {
    
    func tableView(noDataViewFor tableView: UITableView) -> UIView?
}

fileprivate var NoDataDeletateKey = "NoDataDeletateKey"
fileprivate var IsInitFinish = "IsInitFinish"
fileprivate let kPlaceViewTag = 56789

extension UITableView {
    
    // 添加存储属性
    var noDataDelegate: UITableViewNoDataDelegate? {
        get {
            objc_getAssociatedObject(self, &NoDataDeletateKey) as? UITableViewNoDataDelegate
        }
        set {
            objc_setAssociatedObject(self, &NoDataDeletateKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    static let mc_initialize: Void = {
        DispatchQueue.once(UUID().uuidString) {
            swizzleMethod(UITableView.self, originSelector: #selector(UITableView.reloadData), swizzleSelector: #selector(UITableView.mc_reloadData))
        }
    }()
    
    ///
    @objc func mc_reloadData() {
        
        mc_reloadData()
        
        guard let _ = noDataDelegate else { return }
        
        // 忽略第一次刷新
//        if !isInitFinish() {
//            mc_havingData(true)
//            mc_setIsInitFinish(true)
//            return
//        }
        
        // 刷新完成后检测数据
        DispatchQueue.main.async {
            var havingData = false
            for i in 0 ..< self.numberOfSections {
                let row = self.numberOfRows(inSection: i)
                if row > 0 {
                    havingData = true
                    break
                }
            }
            self.mc_havingData(havingData)
        }
        
    }
    
    /// 设置占位图
    fileprivate func mc_havingData(_ isHave: Bool) {
        
        if isHave {
            // 不需要占位图
            if let view = viewWithTag(kPlaceViewTag) {
                view.removeFromSuperview()
            }
            return
        }
        
        // 移除之前的占位图
        if let pView = viewWithTag(kPlaceViewTag) {
            pView.removeFromSuperview()
        }
        
        // 添加占位图
        if let pView = noDataDelegate?.tableView(noDataViewFor: self) {
            pView.frame = self.bounds
            pView.tag = kPlaceViewTag
            addSubview(pView)
        }
        
    }
    
    /// 设置加载完数据
    fileprivate func mc_setIsInitFinish(_ finish: Bool) {
        objc_setAssociatedObject(self, &IsInitFinish, finish, .OBJC_ASSOCIATION_ASSIGN)
    }
    
    /// 是否已经加载完成数据
    fileprivate func isInitFinish() -> Bool {
        let obj = objc_getAssociatedObject(self, &IsInitFinish)
        let isFinish = obj as? Bool
        return isFinish ?? false
    }
    
}


