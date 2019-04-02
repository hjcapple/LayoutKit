import Foundation
import UIKit
import LayoutKit

class TestView3: TestView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let redView = self.addColorSubView(UIColor.red)
        let blueView = self.addColorSubView(UIColor.blue)
        let yellowView = self.addColorSubView(UIColor.yellow)

        self.onLayoutSubviews = { make in

            make.height(redView, blueView, yellowView) == [44, make.flexible, 44]

            make.xEqual(redView, blueView, yellowView)
            make.yPlace(redView, blueView, yellowView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
