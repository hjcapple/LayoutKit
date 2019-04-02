import Foundation
import UIKit

class TestView1: TestView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let colors = [
            UIColor.red,
            UIColor.blue,
            UIColor.yellow,
            UIColor.green,
            UIColor.purple,
            UIColor.orange,
        ]

        let views = colors.map { self.addColorSubView($0) }

        self.onLayoutSubviews = { make in

            let edge: CGFloat = 20

            for view in views {
                make.equal(view)
                make.insetEdges(edge: edge)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
