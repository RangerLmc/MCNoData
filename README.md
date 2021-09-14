# MCNoData
一个好用的缺省页
tableView设置代理
tableView.noDataDelegate = self

```
extension ViewController: UITableViewNoDataDelegate {
    func tableView(noDataViewFor tableView: UITableView) -> UIView? {
        return MCEmptyView(image: UIImage(named: "shoppingCart"), title: "暂无数据", btnTitle: "去购买") {
            print("点击了去购买" )
        }
    }
}

```
