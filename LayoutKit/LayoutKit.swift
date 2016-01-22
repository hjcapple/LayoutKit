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
    
    public var flexible : LayoutFlexible {
        return LayoutFlexible(num: 1)
    }
    
    public var placeHolder : LayoutPlaceHolder {
        return LayoutPlaceHolder()
    }
    
    public var width : CGFloat {
        return _bounds.size.width
    }
    
    public var height : CGFloat {
        return _bounds.size.height
    }
    
    private init(bounds: CGRect)
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
// MARK: - xAlign
extension LayoutKitMaker
{
    public func xAlign(items: [LayoutKitPositionItem])
    {
        let flexibleValue = xFlexibleValue(_bounds.width, items)
        var xpos : CGFloat = _bounds.minX
        for item in items
        {
            item.layoutKit_setFrameOriginX(xpos)
            xpos += flexibleValue * CGFloat(item.layoutKit_numOfFlexible)
            xpos += item.layoutKit_frameWidth
        }
    }
    
    public func xAlign(items: LayoutKitPositionItem...)
    {
        return xAlign(items)
    }
}

// MARK: -
// MARK: - yAlign
extension LayoutKitMaker
{
    public func yAlign(items: [LayoutKitPositionItem])
    {
        let flexibleValue = yFlexibleValue(_bounds.height, items)
        var ypos : CGFloat = _bounds.minY
        for item in items
        {
            item.layoutKit_setFrameOriginY(ypos)
            ypos += flexibleValue * CGFloat(item.layoutKit_numOfFlexible)
            ypos += item.layoutKit_frameHeight
        }
    }
    
    public func yAlign(items: LayoutKitPositionItem...)
    {
        return yAlign(items)
    }
}

// MARK: -
// MARK: - xAlign Fixed
extension LayoutKitMaker
{
    public func xAlignFirstFixed(first first: LayoutKitView, _ items : LayoutKitPositionItem ...)
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
    
    public func xAlignLastFixed(items: LayoutKitPositionItem ..., last: LayoutKitView)
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
// MARK: - yAlign Fixed
extension LayoutKitMaker
{
    public func yAlignFirstFixed(first first: LayoutKitView, _ items : LayoutKitPositionItem ...)
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
    
    public func yAlignLastFixed(items: LayoutKitPositionItem ..., last: LayoutKitView)
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
// MARK: - xCenter
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
// MARK: - yCenter
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
// MARK: - center
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
// MARK: - xLeft
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
// MARK: - xRight
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
// MARK: - yTop
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
// MARK: - yBottom
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
// MARK: - xEqual
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
// MARK: - yEqual
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
// MARK: - equal
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
    // MARK: - sizeToFit
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
// MARK: - allSize
extension LayoutKitMaker
{
    public struct AllSize
    {
        let views : [LayoutKitView]
        private init(views: [LayoutKitView])
        {
            self.views = views
        }
    }
    
    public func allSize(views: [LayoutKitView]) -> AllSize
    {
        return AllSize(views: views)
    }
    
    public func allSize(views: LayoutKitView...) -> AllSize
    {
        return allSize(views)
    }
}

public func == (lhs: LayoutKitMaker.AllSize, rhs: CGSize)
{
    for view in lhs.views
    {
        var rt = view.frame
        rt.size = rhs
        view.frame = rt
    }
}

// MARK: -
// MARK: - allWidth
extension LayoutKitMaker
{
    public struct AllWidth
    {
        private let views : [LayoutKitView]
        private init(views: [LayoutKitView])
        {
            self.views = views
        }
    }
    
    public func allWidth(views: [LayoutKitView]) -> AllWidth
    {
        return AllWidth(views: views)
    }
    
    public func allWidth(views: LayoutKitView...) -> AllWidth
    {
        return allWidth(views)
    }
}

public func == (lhs: LayoutKitMaker.AllWidth, rhs: CGFloat)
{
    for view in lhs.views
    {
        var rt = view.frame
        rt.size.width = rhs
        view.frame = rt
    }
}

// MARK: -
// MARK: - allHeight
extension LayoutKitMaker
{
    public struct AllHeight
    {
        private let views : [LayoutKitView]
        private init(views: [LayoutKitView])
        {
            self.views = views
        }
    }
    
    public func allHeight(views: [LayoutKitView]) -> AllHeight
    {
        return AllHeight(views: views)
    }
    
    public func allHeight(views: LayoutKitView...) -> AllHeight
    {
        return allHeight(views)
    }
}

public func == (lhs: LayoutKitMaker.AllHeight, rhs: CGFloat)
{
    for view in lhs.views
    {
        var rt = view.frame
        rt.size.height = rhs
        view.frame = rt
    }
}

// MARK: -
// MARK: - eachWidth
extension LayoutKitMaker
{
    public struct EachWidth
    {
        private let _items : [LayoutKitSizeItem]
        private let _bounds : CGRect
        private init(items: [LayoutKitSizeItem], bounds: CGRect)
        {
            _items = items
            _bounds = bounds
        }
        
        private func values(values: [LayoutKitPositionItem])
        {
            let flexibleValue = xFlexibleValue(_bounds.width, values)
            let count = min(_items.count, values.count)
            for i in 0 ..< count
            {
                let val = values[i]
                let frameWidth = val.layoutKit_frameWidth + flexibleValue * CGFloat(val.layoutKit_numOfFlexible)
                _items[i].layoutKit_setFrameWidth(frameWidth)
            }
        }
    }
    
    public func eachWidth(items: [LayoutKitSizeItem]) -> EachWidth
    {
        return EachWidth(items: items, bounds: _bounds)
    }
    
    public func eachWidth(items: LayoutKitSizeItem...) -> EachWidth
    {
        return eachWidth(items)
    }
}

public func == (lhs: LayoutKitMaker.EachWidth, rhs: [LayoutKitPositionItem])
{
    lhs.values(rhs)
}

// MARK: -
// MARK: - eachHeight
extension LayoutKitMaker
{
    public struct EachHeight
    {
        private let _items : [LayoutKitSizeItem]
        private let _bounds : CGRect
        private init(items: [LayoutKitSizeItem], bounds: CGRect)
        {
            _items = items
            _bounds = bounds
        }
        
        public func values(values: [LayoutKitPositionItem])
        {
            let flexibleValue = yFlexibleValue(_bounds.height, values)
            let count = min(_items.count, values.count)
            for i in 0 ..< count
            {
                let val = values[i]
                let frameWidth = val.layoutKit_frameHeight + flexibleValue * CGFloat(val.layoutKit_numOfFlexible)
                _items[i].layoutKit_setFrameHeight(frameWidth)
            }
        }
    }
    
    public func eachHeight(items: [LayoutKitSizeItem]) -> EachHeight
    {
        return EachHeight(items: items, bounds: _bounds)
    }
    
    public func eachHeight(items: LayoutKitSizeItem...) -> EachHeight
    {
        return eachHeight(items)
    }
}

public func == (lhs: LayoutKitMaker.EachHeight, rhs: [LayoutKitPositionItem])
{
    lhs.values(rhs)
}

// MARK: -
// MARK: - ref
extension LayoutKitMaker
{
    public func ref(view: LayoutKitView) -> LayoutKitMaker
    {
        return LayoutKitMaker(bounds: view.frame)
    }
}

////////////////////////////////////////////////////
// MARK: -
// MARK: -protocol
public protocol LayoutKitPositionItem
{
    var layoutKit_frameWidth    : CGFloat  { get  }
    var layoutKit_frameHeight   : CGFloat  { get  }
    var layoutKit_numOfFlexible : CGFloat  { get  }
    
    func layoutKit_setFrameOriginX(x : CGFloat)
    func layoutKit_setFrameOriginY(y : CGFloat)
}

public protocol LayoutKitSizeItem
{
    func layoutKit_setFrameWidth(width: CGFloat)
    func layoutKit_setFrameHeight(height: CGFloat)
}

//////////////////////////////////////
extension LayoutKitView : LayoutKitPositionItem, LayoutKitSizeItem
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

extension CGFloat : LayoutKitPositionItem
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

extension Int : LayoutKitPositionItem
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

public struct LayoutFlexible : LayoutKitPositionItem
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

public struct LayoutPlaceHolder: LayoutKitSizeItem
{
    public func layoutKit_setFrameWidth(width: CGFloat)
    {
    }
    
    public func layoutKit_setFrameHeight(height: CGFloat)
    {
    }
}

public func * (flexible: LayoutFlexible, num: CGFloat) -> LayoutFlexible
{
    return LayoutFlexible(num: flexible._num * num)
}

public func * (num: CGFloat, flexible: LayoutFlexible) -> LayoutFlexible
{
    return LayoutFlexible(num: flexible._num * num)
}

/////////////////////////////////////////////////
private func xFlexibleValue(totalWidth: CGFloat, _ items: [LayoutKitPositionItem]) -> CGFloat
{
    var total = totalWidth
    var num : CGFloat = 0
    for item in items
    {
        num += item.layoutKit_numOfFlexible
        total -= item.layoutKit_frameWidth
    }
    return (num < CGFloat(FLT_EPSILON)) ? 0 : (total / CGFloat(num))
}

private func yFlexibleValue(totalHeight: CGFloat, _ items: [LayoutKitPositionItem]) -> CGFloat
{
    var total = totalHeight
    var num : CGFloat = 0
    for item in items
    {
        num += item.layoutKit_numOfFlexible
        total -= item.layoutKit_frameHeight
    }
    return (num < CGFloat(FLT_EPSILON)) ? 0 : (total / CGFloat(num))
}

//////////////////////////////////////////////////

