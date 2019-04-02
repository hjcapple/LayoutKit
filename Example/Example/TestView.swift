import Foundation
import UIKit
import LayoutKit

class TestView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var onLayoutSubviews: ((inout LayoutKitMaker) -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()

        if let onLayoutSubviews = onLayoutSubviews {
            self.tk_layout(onLayoutSubviews)
        }
    }
}

public extension UIView {

    func addColorSubView(_ color: UIColor) -> UIView {
        let aView = UIView()
        aView.backgroundColor = color
        self.addSubview(aView)
        return aView
    }
}
