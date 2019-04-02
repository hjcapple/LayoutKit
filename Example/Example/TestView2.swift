import Foundation
import UIKit
import LayoutKit

class TestView2: TestView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let redView = self.addColorSubView(UIColor.red)
        let blueView = self.addColorSubView(UIColor.blue)
        let yellowView = self.addColorSubView(UIColor.yellow)

        self.onLayoutSubviews = { make in

            make.width(redView, blueView, yellowView) == [50, 100, 200]
            make.height(redView, blueView, yellowView) == 100

            make.xCenter(redView, blueView, yellowView)
            make.yPlace(
                make.flexible,
                redView,
                10,
                blueView,
                10,
                yellowView,
                make.flexible
            )
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
