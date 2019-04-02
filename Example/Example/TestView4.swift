import Foundation
import UIKit
import LayoutKit

class TestView4: TestView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black

        let redView = self.addColorSubView(UIColor.red)
        let blueView = self.addColorSubView(UIColor.blue)
        let greenView = self.addColorSubView(UIColor.green)

        self.onLayoutSubviews = { make in

            make.size(redView, blueView, greenView) == (80, 80)

            let F = make.flexible
            make.xPlace(F, redView, F, blueView, F, greenView, F)
            make.yCenter(redView, blueView, greenView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
