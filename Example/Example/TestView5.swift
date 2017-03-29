/*
 The MIT License (MIT)

 Copyright (c) 2017 HJC hjcapple@gmail.com

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
