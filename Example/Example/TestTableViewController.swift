import Foundation
import UIKit

class TestViewController: UIViewController {
    let _viewType: UIView.Type

    init(viewType: UIView.Type) {
        _viewType = viewType
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let aView = _viewType.init(frame: UIScreen.main.bounds)
        self.view = aView
    }
}

private let kCellId = "CellId"

class TestTableViewController: UITableViewController {
    fileprivate var _testInfos: [(String, UIView.Type)] = [
        ("Left Right Top Bottom, Center", TestView0.self),
        ("Edges", TestView1.self),
        ("Place", TestView2.self),
        ("Flexible Height", TestView3.self),
        ("Equal Distance", TestView4.self),
        ("Ref view", TestView5.self),
        ("Fixed", TestView6.self),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        self.title = "LayoutKit Test"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _testInfos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath)
        let title = _testInfos[indexPath.row].0

        cell.textLabel?.text = title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (_, viewType) = _testInfos[indexPath.row]
        let aViewController = TestViewController(viewType: viewType)
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
}

