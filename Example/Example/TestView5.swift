import Foundation
import UIKit
import LayoutKit

class TestView5Cell: TestView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let iconView = self.addColorSubView(UIColor.blue)

        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = "Title"
        self.addSubview(titleLabel)

        let detailLabel = UILabel()
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.text = "Detail text"
        self.addSubview(detailLabel)

        let longDetalLabel = UILabel()
        longDetalLabel.font = UIFont.systemFont(ofSize: 10)
        longDetalLabel.text = "Long Long detail text"
        self.addSubview(longDetalLabel)

        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.text = "2 days ago"
        self.addSubview(timeLabel)

        self.onLayoutSubviews = { make in

            let height = make.yFlexibleValue(10, make.flexible, 10)
            make.size(iconView) == (height, height)
            make.sizeToFit(titleLabel, detailLabel, longDetalLabel, timeLabel)

            make.xPlace(10, iconView, 10, titleLabel, make.flexible, timeLabel, 10)
            make.ref(titleLabel).xLeft(detailLabel, longDetalLabel)

            make.yCenter(iconView, timeLabel)
            make.yPlace(make.flexible, titleLabel, 6, detailLabel, longDetalLabel, make.flexible)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TestView5: TestView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.black

        let cell = TestView5Cell()
        self.addSubview(cell)

        self.onLayoutSubviews = { make in

            make.height(cell) == 100
            make.xEqual(cell)
            make.yCenter(cell)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
