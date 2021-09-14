//
//  ViewController.swift
//  MCNoData
//
//  Created by zc_mc on 2021/9/13.
//

import UIKit

class ViewController: UIViewController {
    
    private let cellID = "UITableViewCell"
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        view.dataSource = self
        view.delegate = self
        view.noDataDelegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellID)
        tableView.reloadData()
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = "这是第\(indexPath.row + 1)个cell"
        return cell
        
    }
    
}

extension ViewController: UITableViewNoDataDelegate {
    func tableView(noDataViewFor tableView: UITableView) -> UIView? {
        return MCEmptyView(image: UIImage(named: "shoppingCart"), title: "暂无数据", btnTitle: "去购买") {
            print("点击了去购买" )
        }
    }
}

