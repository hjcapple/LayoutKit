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
import LayoutKit

class TestView6 : TestView
{
    private func addLabel(text: String) -> UILabel
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        self.addSubview(label)
        return label
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let middle    = self.addColorSubView(UIColor.red)
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
