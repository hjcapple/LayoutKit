import Foundation
import UIKit
import LayoutKit

class TestView6: TestView {

    private func addLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        self.addSubview(label)
        return label
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let middle = self.addColorSubView(UIColor.red)
        let leftLabel = self.addLabel(text: "Left")
        let rightLabel = self.addLabel(text: "Right")
        let topLabel = self.addLabel(text: "Top")
        let bottomLabel = self.addLabel(text: "Bottom")

        self.onLayoutSubviews = { make in

            make.size(middle) == (44, 44)
            make.sizeToFit(leftLabel, rightLabel, topLabel, bottomLabel)

            make.center(middle)

            make.ref(middle).yCenter(leftLabel, rightLabel)
            make.xPlace(fixed: middle, 40, rightLabel)
            make.xPlace(make.flexible, leftLabel, 40, fixed: middle)

            make.ref(middle).xCenter(topLabel, bottomLabel)
            make.yPlace(fixed: middle, 40, bottomLabel)
            make.yPlace(make.flexible, topLabel, 40, fixed: middle)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
