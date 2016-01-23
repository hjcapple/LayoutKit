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

#if os(iOS)
    import UIKit
    public typealias LayoutKitView = UIView
#else
    import AppKit
    public typealias LayoutKitView = NSView
#endif

public extension LayoutKitView
{
    func tk_layoutSubviews(@noescape callback:(LayoutKitMaker -> Void))
    {
        let make = LayoutKitMaker(bounds: self.bounds)
        callback(make)
    }
}

///////////////////////////////////////////////////////////
public class LayoutKitMaker
{
    private var _bounds : CGRect
    
    public var flexible : LayoutKitFlexible {
        return LayoutKitFlexible(num: 1)
    }
    
    public var placeHolder : LayoutKitPlaceHolder {
        return LayoutKitPlaceHolder()
    }
    
    public var w : CGFloat {
        return _bounds.size.width
    }
    
    public var h : CGFloat {
        return _bounds.size.height
    }
    
    public init(bounds: CGRect)
    {
        _bounds = bounds
    }
}

// MARK: -
// MARK: bounds
extension LayoutKitMaker
{
    public func resetBounds(bounds: CGRect)
    {
        _bounds = bounds
    }
    
    public func insetBounds(top top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect
    {
        let oldBounds = _bounds
        _bounds.origin.x += left
        _bounds.origin.y += top
        _bounds.size.width -= (left + right)
        _bounds.size.height -= (top + bottom)
        return oldBounds
    }
    
    public func insetBounds(edge edge: CGFloat) -> CGRect
    {
        return insetBounds(top: edge, left: edge, bottom: edge, right: edge)
    }
}


// MARK: -
// MARK: size
extension LayoutKitMaker
{
    public struct SizeGroup
    {
        private let _views : [LayoutKitView]
        private init(views: [LayoutKitView])
        {
            _views = views
        }
        
        private func setValue(size: CGSize)
        {
            for view in _views
            {
                var rt = view.frame
                rt.size = size
                view.frame = rt
            }
        }
    }
    
    public func size(views: [LayoutKitView]) -> SizeGroup
    {
        return SizeGroup(views: views)
    }
    
    public func size(views: LayoutKitView...) -> SizeGroup
    {
        return size(views)
    }
}

public func == (group: LayoutKitMaker.SizeGroup, size: CGSize)
{
    group.setValue(size)
}

public func == (group: LayoutKitMaker.SizeGroup, size: (CGFloat, CGFloat))
{
    group == CGSizeMake(size.0, size.1)
}

// MARK: -
// MARK: width
extension LayoutKitMaker
{
    public struct WidthGroup
    {
        private let _items : [LayoutKitSetWidthItem]
        private let _totalWidth : CGFloat
        private init(items: [LayoutKitSetWidthItem], totalWidth: CGFloat)
        {
            _items = items
            _totalWidth = totalWidth
        }
        
        private func setValue(value: CGFloat)
        {
            for item in _items
            {
                item.layoutKit_setFrameWidth(value)
            }
        }
        
        private func setValues(values: [LayoutKitxAlignItem])
        {
            let flexibleValue = computeXFlexibleValue(_totalWidth, values)
            let count = min(_items.count, values.count)
            for i in 0 ..< count
            {
                let frameWidth = computeTotalWidth(values[i], flexibleValue: flexibleValue)
                _items[i].layoutKit_setFrameWidth(frameWidth)
            }
        }
    }
    
    public func width(items: [LayoutKitSetWidthItem]) -> WidthGroup
    {
        return WidthGroup(items: items, totalWidth: _bounds.size.width)
    }
    
    public func width(items: LayoutKitSetWidthItem...) -> WidthGroup
    {
        return width(items)
    }
}

public func == (group: LayoutKitMaker.WidthGroup, value: CGFloat)
{
    group.setValue(value)
}

public func == (group: LayoutKitMaker.WidthGroup, values: [LayoutKitxAlignItem])
{
    group.setValues(values)
}

// MARK: -
// MARK: height
extension LayoutKitMaker
{
    public struct HeightGroup
    {
        private let _items : [LayoutKitSetHeightItem]
        private let _totalHeight : CGFloat
        private init(items: [LayoutKitSetHeightItem], totalHeight: CGFloat)
        {
            _items = items
            _totalHeight = totalHeight
        }
        
        private func setValue(value: CGFloat)
        {
            for item in _items
            {
                item.layoutKit_setFrameHeight(value)
            }
        }
        
        private func setValues(values: [LayoutKityAlignItem])
        {
            let flexibleValue = computeYFlexibleValue(_totalHeight, values)
            let count = min(_items.count, values.count)
            for i in 0 ..< count
            {
                let frameHeight = computeTotalHeight(values[i], flexibleValue: flexibleValue)
                _items[i].layoutKit_setFrameHeight(frameHeight)
            }
        }
    }
    
    public func height(items: [LayoutKitSetHeightItem]) -> HeightGroup
    {
        return HeightGroup(items: items, totalHeight: _bounds.height)
    }
    
    public func height(items: LayoutKitSetHeightItem...) -> HeightGroup
    {
        return height(items)
    }
}

public func == (group: LayoutKitMaker.HeightGroup, value: CGFloat)
{
    group.setValue(value)
}

public func == (group: LayoutKitMaker.HeightGroup, value: [LayoutKityAlignItem])
{
    group.setValues(value)
}

// MARK: -
// MARK: xAlign
extension LayoutKitMaker
{
    public func xAlign(items: [LayoutKitxAlignItem])
    {
        let flexibleValue = computeXFlexibleValue(_bounds.width, items)
        var xpos = _bounds.minX
        for item in items
        {
            item.layoutKit_setFrameOriginX(xpos)
            xpos += computeTotalWidth(item, flexibleValue: flexibleValue)
        }
    }
    
    public func xAlign(items: LayoutKitxAlignItem...)
    {
        return xAlign(items)
    }
}

// MARK: -
// MARK: yAlign
extension LayoutKitMaker
{
    public func yAlign(items: [LayoutKityAlignItem])
    {
        let flexibleValue = computeYFlexibleValue(_bounds.height, items)
        var ypos = _bounds.minY
        for item in items
        {
            item.layoutKit_setFrameOriginY(ypos)
            ypos += computeTotalHeight(item, flexibleValue: flexibleValue)
        }
    }
    
    public func yAlign(items: LayoutKityAlignItem...)
    {
        return yAlign(items)
    }
}

// MARK: -
// MARK: xAlign Fixed
extension LayoutKitMaker
{
    public func xAlignFirstFixed(first first: LayoutKitView, _ items : LayoutKitxAlignItem ...)
    {
        let oldBounds = _bounds
        defer {
            _bounds = oldBounds
        }
        
        let maxX = _bounds.maxX
        _bounds.origin.x = first.frame.maxX
        _bounds.size.width = maxX - _bounds.origin.x
        xAlign(items)
    }
    
    public func xAlignLastFixed(items: LayoutKitxAlignItem ..., last: LayoutKitView)
    {
        let oldBounds = _bounds
        defer {
            _bounds = oldBounds
        }
        
        let maxX = last.frame.minX
        _bounds.size.width = maxX - _bounds.origin.x
        xAlign(items)
    }
}

// MARK: -
// MARK: yAlign Fixed
extension LayoutKitMaker
{
    public func yAlignFirstFixed(first first: LayoutKitView, _ items : LayoutKityAlignItem ...)
    {
        let oldBounds = _bounds
        defer {
            _bounds = oldBounds
        }
        
        let maxY = _bounds.maxY
        _bounds.origin.y = first.frame.maxY
        _bounds.size.height = maxY - _bounds.origin.y
        yAlign(items)
    }
    
    public func yAlignLastFixed(items: LayoutKityAlignItem ..., last: LayoutKitView)
    {
        let oldBounds = _bounds
        defer {
            _bounds = oldBounds
        }
        
        let minY = last.frame.minY
        _bounds.size.height = minY - _bounds.origin.y
        yAlign(items)
    }
}

// MARK: -
// MARK: xCenter
extension LayoutKitMaker
{
    public func xCenter(views : [LayoutKitView])
    {
        let midX = _bounds.midX
        for view in views
        {
            var frame = view.frame
            frame.origin.x = midX - frame.size.width * 0.5
            view.frame = frame
        }
    }
    
    public func xCenter(views : LayoutKitView...)
    {
        xCenter(views)
    }
}

// MARK: -
// MARK: yCenter
extension LayoutKitMaker
{
    public func yCenter(views: [LayoutKitView])
    {
        let midY = _bounds.midY
        for view in views
        {
            var frame = view.frame
            frame.origin.y = midY - frame.size.height * 0.5
            view.frame = frame
        }
    }
    
    public func yCenter(views: LayoutKitView...)
    {
        yCenter(views)
    }
}


// MARK: -
// MARK: center
extension LayoutKitMaker
{
    public func center(views: [LayoutKitView])
    {
        let midY = _bounds.midY
        let midX = _bounds.midX
        
        for view in views
        {
            var frame = view.frame
            frame.origin.x = midX - frame.size.width * 0.5
            frame.origin.y = midY - frame.size.height * 0.5
            view.frame = frame
        }
    }
    
    public func center(views: LayoutKitView...)
    {
        center(views)
    }
}

// MARK: -
// MARK: xLeft
extension LayoutKitMaker
{
    public func xLeft(views : [LayoutKitView])
    {
        let minX = _bounds.minX
        for view in views
        {
            var frame = view.frame
            frame.origin.x = minX
            view.frame = frame
        }
    }
    
    public func xLeft(views : LayoutKitView...)
    {
        xLeft(views)
    }
}

// MARK: -
// MARK: xRight
extension LayoutKitMaker
{
    public func xRight(views : [LayoutKitView])
    {
        let maxX = _bounds.maxX
        for view in views
        {
            var frame = view.frame
            frame.origin.x = maxX - frame.size.width
            view.frame = frame
        }
    }
    
    public func xRight(views : LayoutKitView...)
    {
        xRight(views)
    }
}

// MARK: -
// MARK: yTop
extension LayoutKitMaker
{
    public func yTop(views : [LayoutKitView])
    {
        let minY = _bounds.minY
        for view in views
        {
            var frame = view.frame
            frame.origin.y = minY
            view.frame = frame
        }
    }
    
    public func yTop(views : LayoutKitView...)
    {
        yTop(views)
    }
}

// MARK: -
// MARK: yBottom
extension LayoutKitMaker
{
    public func yBottom(views : [LayoutKitView])
    {
        let maxY = _bounds.maxY
        for view in views
        {
            var frame = view.frame
            frame.origin.y = maxY - frame.size.height
            view.frame = frame
        }
    }
    
    public func yBottom(views : LayoutKitView...)
    {
        yBottom(views)
    }
}

// MARK: -
// MARK: xEqual
extension LayoutKitMaker
{
    public func xEqual(views: [LayoutKitView])
    {
        for view in views
        {
            var frame = view.frame
            frame.origin.x = _bounds.origin.x
            frame.size.width = _bounds.size.width
            view.frame = frame
        }
    }
    
    public func xEqual(views: LayoutKitView...)
    {
        xEqual(views)
    }
}

// MARK: -
// MARK: yEqual
extension LayoutKitMaker
{
    public func yEqual(views: [LayoutKitView])
    {
        for view in views
        {
            var frame = view.frame
            frame.origin.y = _bounds.origin.y
            frame.size.height = _bounds.size.height
            view.frame = frame
        }
    }
    
    public func yEqual(views: LayoutKitView...)
    {
        yEqual(views)
    }
}


// MARK: -
// MARK: equal
extension LayoutKitMaker
{
    public func equal(views: [LayoutKitView])
    {
        for view in views
        {
            view.frame = _bounds
        }
    }
    
    public func equal(views: LayoutKitView...)
    {
        equal(views)
    }
}


#if os(iOS)
    // MARK: -
    // MARK: sizeToFit
    extension LayoutKitMaker
    {
        public func sizeToFit(views: [UIView])
        {
            for view in views
            {
                view.sizeToFit()
            }
        }
        
        public func sizeToFit(views: UIView...)
        {
            sizeToFit(views)
        }
    }
#endif

// MARK: -
// MARK: ref
extension LayoutKitMaker
{
    public func ref(view: LayoutKitView) -> LayoutKitMaker
    {
        return LayoutKitMaker(bounds: view.frame)
    }
}

// MARK: -
// MARK: Flexible Value
extension LayoutKitMaker
{
    public func xFlexibleValue(items: [LayoutKitxAlignItem]) -> CGFloat
    {
        return computeXFlexibleValue(_bounds.size.width, items)
    }
    
    public func xFlexibleValue(items: LayoutKitxAlignItem...) -> CGFloat
    {
        return computeXFlexibleValue(_bounds.size.width, items)
    }
    
    private func yFlexibleValue(items: [LayoutKityAlignItem]) -> CGFloat
    {
        return computeYFlexibleValue(_bounds.size.height, items)
    }
    
    public func yFlexibleValue(items: LayoutKityAlignItem...) -> CGFloat
    {
        return computeYFlexibleValue(_bounds.size.height, items)
    }
}

////////////////////////////////////////////////////
// MARK: -
// MARK: protocol
public protocol LayoutKitxAlignItem
{
    var layoutKit_frameWidth    : CGFloat  { get  }
    var layoutKit_numOfFlexible : CGFloat  { get  }
    
    func layoutKit_setFrameOriginX(x : CGFloat)
}

public protocol LayoutKityAlignItem
{
    var layoutKit_frameHeight   : CGFloat  { get  }
    var layoutKit_numOfFlexible : CGFloat  { get  }
    func layoutKit_setFrameOriginY(y : CGFloat)
}

public protocol LayoutKitSetWidthItem
{
    func layoutKit_setFrameWidth(width: CGFloat)
}

public protocol LayoutKitSetHeightItem
{
    func layoutKit_setFrameHeight(height: CGFloat)
}

//////////////////////////////////////
// MARK: -
// MARK: View
extension LayoutKitView : LayoutKitxAlignItem, LayoutKityAlignItem,
                          LayoutKitSetWidthItem, LayoutKitSetHeightItem
{
    public var layoutKit_numOfFlexible : CGFloat {
        return 0
    }
    
    public var layoutKit_frameWidth : CGFloat {
        return self.frame.width
    }
    
    public var layoutKit_frameHeight : CGFloat {
        return self.frame.height
    }
    
    public func layoutKit_setFrameOriginX(x : CGFloat)
    {
        var rt = self.frame
        rt.origin.x = x
        self.frame = rt
    }
    
    public func layoutKit_setFrameOriginY(y : CGFloat)
    {
        var rt = self.frame
        rt.origin.y = y
        self.frame = rt
    }
    
    public func layoutKit_setFrameWidth(width: CGFloat)
    {
        var rt = self.frame
        rt.size.width = width
        self.frame = rt
    }
    
    public func layoutKit_setFrameHeight(height: CGFloat)
    {
        var rt = self.frame
        rt.size.height = height
        self.frame = rt
    }
}

// MARK: -
// MARK: CGFloat
extension CGFloat : LayoutKitxAlignItem, LayoutKityAlignItem
{
    public var layoutKit_numOfFlexible : CGFloat {
        return 0
    }
    
    public var layoutKit_frameWidth : CGFloat {
        return self
    }
    
    public var layoutKit_frameHeight : CGFloat {
        return self
    }
    
    public func layoutKit_setFrameOriginX(x : CGFloat) {
    }
    
    public func layoutKit_setFrameOriginY(y : CGFloat) {
    }
}

// MARK: -
// MARK: Int
extension Int : LayoutKitxAlignItem, LayoutKityAlignItem
{
    public var layoutKit_numOfFlexible : CGFloat {
        return 0
    }
    
    public var layoutKit_frameWidth : CGFloat {
        return CGFloat(self)
    }
    
    public var layoutKit_frameHeight : CGFloat {
        return CGFloat(self)
    }
    
    public func layoutKit_setFrameOriginX(x : CGFloat) {
    }
    
    public func layoutKit_setFrameOriginY(y : CGFloat) {
    }
}

// MARK: -
// MARK: LayoutKitFlexible
public struct LayoutKitFlexible : LayoutKitxAlignItem, LayoutKityAlignItem
{
    private let _num : CGFloat
    private init(num: CGFloat)
    {
        _num = num
    }
    
    public var layoutKit_numOfFlexible : CGFloat {
        return _num
    }
    
    public var layoutKit_frameWidth : CGFloat {
        return CGFloat(0.0)
    }
    
    public var layoutKit_frameHeight : CGFloat {
        return CGFloat(0.0)
    }
    
    public func layoutKit_setFrameOriginX(x : CGFloat) {
    }
    
    public func layoutKit_setFrameOriginY(y : CGFloat) {
    }
}

public func * (flexible: LayoutKitFlexible, num: CGFloat) -> LayoutKitFlexible
{
    return LayoutKitFlexible(num: flexible._num * num)
}

public func * (num: CGFloat, flexible: LayoutKitFlexible) -> LayoutKitFlexible
{
    return LayoutKitFlexible(num: flexible._num * num)
}

// MARK: -
// MARK: LayoutKitPlaceHolder
public struct LayoutKitPlaceHolder: LayoutKitSetWidthItem, LayoutKitSetHeightItem
{
    public func layoutKit_setFrameWidth(width: CGFloat)
    {
    }
    
    public func layoutKit_setFrameHeight(height: CGFloat)
    {
    }
}

/////////////////////////////////////////////////
// MARK: -
// MARK: private functions
private func computeTotalWidth(item: LayoutKitxAlignItem, flexibleValue: CGFloat) -> CGFloat
{
    return item.layoutKit_frameWidth + item.layoutKit_numOfFlexible * flexibleValue
}

private func computeTotalHeight(item: LayoutKityAlignItem, flexibleValue: CGFloat) -> CGFloat
{
    return item.layoutKit_frameHeight + item.layoutKit_numOfFlexible * flexibleValue
}

private func computeXFlexibleValue(totalWidth: CGFloat, _ items: [LayoutKitxAlignItem]) -> CGFloat
{
    var total = totalWidth
    var num : CGFloat = 0
    for item in items
    {
        num += item.layoutKit_numOfFlexible
        total -= item.layoutKit_frameWidth
    }
    return (num < CGFloat(FLT_EPSILON)) ? 0 : (total / num)
}

private func computeYFlexibleValue(totalHeight: CGFloat, _ items: [LayoutKityAlignItem]) -> CGFloat
{
    var total = totalHeight
    var num : CGFloat = 0
    for item in items
    {
        num += item.layoutKit_numOfFlexible
        total -= item.layoutKit_frameHeight
    }
    return (num < CGFloat(FLT_EPSILON)) ? 0 : (total / num)
}

//////////////////////////////////////////////////////

