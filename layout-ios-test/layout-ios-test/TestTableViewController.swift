/*
The MIT License (MIT)

Copyright (c) 2016 HJC hjcapple@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation
import UIKit

class TestViewController : UIViewController
{
    let _viewType : UIView.Type
    
    init(viewType: UIView.Type)
    {
        _viewType = viewType
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView()
    {
        let aView = _viewType.init(frame: UIScreen.mainScreen().bounds)
        self.view = aView
    }
}


private let kCellId = "CellId"
class TestTableViewController : UITableViewController
{
    private var _testInfos : [(String, UIView.Type)] = [
        ("Left Right Top Bottom, Center", TestView0.self),
        ("Edges", TestView1.self),
        ("Place", TestView2.self),
        ("Flexible Height", TestView3.self),
        ("Equal Distance", TestView4.self),
        ("Ref view", TestView5.self)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        self.title = "LayoutKit Test"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCellId)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _testInfos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellId, forIndexPath: indexPath)
        let (title, _) = _testInfos[indexPath.row]
        
        cell.textLabel?.text = title
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let (_, viewType) = _testInfos[indexPath.row]
        let aViewController = TestViewController(viewType: viewType)
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
}



