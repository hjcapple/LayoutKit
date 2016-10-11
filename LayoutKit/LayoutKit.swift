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
    func tk_layoutSubviews(_ callback: ((LayoutKitMaker) -> Void))
    {
        let make = LayoutKitMaker(bounds: self.bounds)
        callback(make)
    }
}

///////////////////////////////////////////////////////////
public final class LayoutKitMaker
{
    fileprivate var _bounds : CGRect
    
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
    public func resetBounds(_ bounds: CGRect)
    {
        _bounds = bounds
    }
    
    @discardableResult
    public func insetEdges(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect
    {
        let oldBounds = _bounds
        _bounds.origin.x += left
        _bounds.origin.y += top
        _bounds.size.width -= (left + right)
        _bounds.size.height -= (top + bottom)
        return oldBounds
    }
    
    @discardableResult
    public func insetEdges(edge: CGFloat) -> CGRect
    {
        return insetEdges(top: edge, left: edge, bottom: edge, right: edge)
    }
}


// MARK: -
// MARK: size
extension LayoutKitMaker
{
    public struct SizeGroup
    {
        private let _views : [LayoutKitView]
        fileprivate init(views: [LayoutKitView])
        {
            _views = views
        }
        
        fileprivate func setValue(_ size: CGSize)
        {
            for view in _views
            {
                var rt = view.frame
                rt.size = size
                view.frame = rt
            }
        }
    }
    
    public func size(_ views: [LayoutKitView]) -> SizeGroup
    {
        return SizeGroup(views: views)
    }
    
    public func size(_ views: LayoutKitView...) -> SizeGroup
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
    group == CGSize(width: size.0, height: size.1)
}

// MARK: -
// MARK: width
extension LayoutKitMaker
{
    public struct WidthGroup
    {
        private let _items : [LayoutKitSetWidthItem]
        private let _totalWidth : CGFloat
        fileprivate init(items: [LayoutKitSetWidthItem], totalWidth: CGFloat)
        {
            _items = items
            _totalWidth = totalWidth
        }
        
        fileprivate func setValue(_ value: CGFloat)
        {
            for item in _items
            {
                item.layoutKit_setFrameWidth(value)
            }
        }
        
        fileprivate func setValues(_ values: [LayoutKitxPlaceItem])
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
    
    public func width(_ items: [LayoutKitSetWidthItem]) -> WidthGroup
    {
        return WidthGroup(items: items, totalWidth: _bounds.size.width)
    }
    
    public func width(_ items: LayoutKitSetWidthItem...) -> WidthGroup
    {
        return width(items)
    }
}

public func == (group: LayoutKitMaker.WidthGroup, value: CGFloat)
{
    group.setValue(value)
}

public func == (group: LayoutKitMaker.WidthGroup, values: [LayoutKitxPlaceItem])
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
        fileprivate init(items: [LayoutKitSetHeightItem], totalHeight: CGFloat)
        {
            _items = items
            _totalHeight = totalHeight
        }
        
        fileprivate func setValue(_ value: CGFloat)
        {
            for item in _items
            {
                item.layoutKit_setFrameHeight(value)
            }
        }
        
        fileprivate func setValues(_ values: [LayoutKityPlaceItem])
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
    
    public func height(_ items: [LayoutKitSetHeightItem]) -> HeightGroup
    {
        return HeightGroup(items: items, totalHeight: _bounds.height)
    }
    
    public func height(_ items: LayoutKitSetHeightItem...) -> HeightGroup
    {
        return height(items)
    }
}

public func == (group: LayoutKitMaker.HeightGroup, value: CGFloat)
{
    group.setValue(value)
}

public func == (group: LayoutKitMaker.HeightGroup, value: [LayoutKityPlaceItem])
{
    group.setValues(value)
}

// MARK: -
// MARK: xPlace
extension LayoutKitMaker
{
    public func xPlace(_ items: [LayoutKitxPlaceItem])
    {
        let flexibleValue = computeXFlexibleValue(_bounds.width, items)
        var xpos = _bounds.minX
        for item in items
        {
            item.layoutKit_setFrameOriginX(xpos)
            xpos += computeTotalWidth(item, flexibleValue: flexibleValue)
        }
    }
    
    public func xPlace(_ items: LayoutKitxPlaceItem...)
    {
        return xPlace(items)
    }
}

// MARK: -
// MARK: yPlace
extension LayoutKitMaker
{
    public func yPlace(_ items: [LayoutKityPlaceItem])
    {
        let flexibleValue = computeYFlexibleValue(_bounds.height, items)
        var ypos = _bounds.minY
        for item in items
        {
            item.layoutKit_setFrameOriginY(ypos)
            ypos += computeTotalHeight(item, flexibleValue: flexibleValue)
        }
    }
    
    public func yPlace(_ items: LayoutKityPlaceItem...)
    {
        return yPlace(items)
    }
}

// MARK: -
// MARK: xPlace fixed
extension LayoutKitMaker
{
    public func xPlace(fixed first: LayoutKitView, _ items : LayoutKitxPlaceItem ...)
    {
        let oldBounds = _bounds
        defer {
            _bounds = oldBounds
        }
        
        let maxX = _bounds.maxX
        _bounds.origin.x = first.frame.maxX
        _bounds.size.width = maxX - _bounds.origin.x
        xPlace(items)
    }
    
    public func xPlace(_ items: LayoutKitxPlaceItem ..., fixed last: LayoutKitView)
    {
        let oldBounds = _bounds
        defer {
            _bounds = oldBounds
        }
        
        let maxX = last.frame.minX
        _bounds.size.width = maxX - _bounds.origin.x
        xPlace(items)
    }
}

// MARK: -
// MARK: yPlace fixed
extension LayoutKitMaker
{
    public func yPlace(fixed first: LayoutKitView, _ items : LayoutKityPlaceItem ...)
    {
        let oldBounds = _bounds
        defer {
            _bounds = oldBounds
        }
        
        let maxY = _bounds.maxY
        _bounds.origin.y = first.frame.maxY
        _bounds.size.height = maxY - _bounds.origin.y
        yPlace(items)
    }
    
    public func yPlace(_ items: LayoutKityPlaceItem ..., fixed last: LayoutKitView)
    {
        let oldBounds = _bounds
        defer {
            _bounds = oldBounds
        }
        
        let minY = last.frame.minY
        _bounds.size.height = minY - _bounds.origin.y
        yPlace(items)
    }
}

// MARK: -
// MARK: xCenter
extension LayoutKitMaker
{
    public func xCenter(_ views : [LayoutKitView])
    {
        let midX = _bounds.midX
        for view in views
        {
            var frame = view.frame
            frame.origin.x = midX - frame.size.width * 0.5
            view.frame = frame
        }
    }
    
    public func xCenter(_ views : LayoutKitView...)
    {
        xCenter(views)
    }
}

// MARK: -
// MARK: yCenter
extension LayoutKitMaker
{
    public func yCenter(_ views: [LayoutKitView])
    {
        let midY = _bounds.midY
        for view in views
        {
            var frame = view.frame
            frame.origin.y = midY - frame.size.height * 0.5
            view.frame = frame
        }
    }
    
    public func yCenter(_ views: LayoutKitView...)
    {
        yCenter(views)
    }
}


// MARK: -
// MARK: center
extension LayoutKitMaker
{
    public func center(_ views: [LayoutKitView])
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
    
    public func center(_ views: LayoutKitView...)
    {
        center(views)
    }
}

// MARK: -
// MARK: xLeft
extension LayoutKitMaker
{
    public func xLeft(_ views : [LayoutKitView])
    {
        let minX = _bounds.minX
        for view in views
        {
            var frame = view.frame
            frame.origin.x = minX
            view.frame = frame
        }
    }
    
    public func xLeft(_ views : LayoutKitView...)
    {
        xLeft(views)
    }
}

// MARK: -
// MARK: xRight
extension LayoutKitMaker
{
    public func xRight(_ views : [LayoutKitView])
    {
        let maxX = _bounds.maxX
        for view in views
        {
            var frame = view.frame
            frame.origin.x = maxX - frame.size.width
            view.frame = frame
        }
    }
    
    public func xRight(_ views : LayoutKitView...)
    {
        xRight(views)
    }
}

// MARK: -
// MARK: yTop
extension LayoutKitMaker
{
    public func yTop(_ views : [LayoutKitView])
    {
        let minY = _bounds.minY
        for view in views
        {
            var frame = view.frame
            frame.origin.y = minY
            view.frame = frame
        }
    }
    
    public func yTop(_ views : LayoutKitView...)
    {
        yTop(views)
    }
}

// MARK: -
// MARK: yBottom
extension LayoutKitMaker
{
    public func yBottom(_ views : [LayoutKitView])
    {
        let maxY = _bounds.maxY
        for view in views
        {
            var frame = view.frame
            frame.origin.y = maxY - frame.size.height
            view.frame = frame
        }
    }
    
    public func yBottom(_ views : LayoutKitView...)
    {
        yBottom(views)
    }
}

// MARK: -
// MARK: xEqual
extension LayoutKitMaker
{
    public func xEqual(_ views: [LayoutKitView])
    {
        for view in views
        {
            var frame = view.frame
            frame.origin.x = _bounds.origin.x
            frame.size.width = _bounds.size.width
            view.frame = frame
        }
    }
    
    public func xEqual(_ views: LayoutKitView...)
    {
        xEqual(views)
    }
}

// MARK: -
// MARK: yEqual
extension LayoutKitMaker
{
    public func yEqual(_ views: [LayoutKitView])
    {
        for view in views
        {
            var frame = view.frame
            frame.origin.y = _bounds.origin.y
            frame.size.height = _bounds.size.height
            view.frame = frame
        }
    }
    
    public func yEqual(_ views: LayoutKitView...)
    {
        yEqual(views)
    }
}


// MARK: -
// MARK: equal
extension LayoutKitMaker
{
    public func equal(_ views: [LayoutKitView])
    {
        for view in views
        {
            view.frame = _bounds
        }
    }
    
    public func equal(_ views: LayoutKitView...)
    {
        equal(views)
    }
}


#if os(iOS)
    // MARK: -
    // MARK: sizeToFit
    extension LayoutKitMaker
    {
        public func sizeToFit(_ views: [UIView])
        {
            for view in views
            {
                view.sizeToFit()
            }
        }
        
        public func sizeToFit(_ views: UIView...)
        {
            sizeToFit(views)
        }
    }
#endif

// MARK: -
// MARK: ref
extension LayoutKitMaker
{
    public func ref(_ view: LayoutKitView) -> LayoutKitMaker
    {
        return LayoutKitMaker(bounds: view.frame)
    }
}

// MARK: -
// MARK: Flexible Value
extension LayoutKitMaker
{
    public func xFlexibleValue(_ items: [LayoutKitxPlaceItem]) -> CGFloat
    {
        return computeXFlexibleValue(_bounds.size.width, items)
    }
    
    public func xFlexibleValue(_ items: LayoutKitxPlaceItem...) -> CGFloat
    {
        return computeXFlexibleValue(_bounds.size.width, items)
    }
    
    fileprivate func yFlexibleValue(_ items: [LayoutKityPlaceItem]) -> CGFloat
    {
        return computeYFlexibleValue(_bounds.size.height, items)
    }
    
    public func yFlexibleValue(_ items: LayoutKityPlaceItem...) -> CGFloat
    {
        return computeYFlexibleValue(_bounds.size.height, items)
    }
}

////////////////////////////////////////////////////
// MARK: -
// MARK: protocol
public protocol LayoutKitxPlaceItem
{
    var layoutKit_frameWidth    : CGFloat  { get  }
    var layoutKit_numOfFlexible : CGFloat  { get  }
    
    func layoutKit_setFrameOriginX(_ x : CGFloat)
}

public protocol LayoutKityPlaceItem
{
    var layoutKit_frameHeight   : CGFloat  { get  }
    var layoutKit_numOfFlexible : CGFloat  { get  }
    func layoutKit_setFrameOriginY(_ y : CGFloat)
}

public protocol LayoutKitSetWidthItem
{
    func layoutKit_setFrameWidth(_ width: CGFloat)
}

public protocol LayoutKitSetHeightItem
{
    func layoutKit_setFrameHeight(_ height: CGFloat)
}

//////////////////////////////////////
// MARK: -
// MARK: View
extension LayoutKitView : LayoutKitxPlaceItem, LayoutKityPlaceItem,
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
    
    public func layoutKit_setFrameOriginX(_ x : CGFloat)
    {
        var rt = self.frame
        rt.origin.x = x
        self.frame = rt
    }
    
    public func layoutKit_setFrameOriginY(_ y : CGFloat)
    {
        var rt = self.frame
        rt.origin.y = y
        self.frame = rt
    }
    
    public func layoutKit_setFrameWidth(_ width: CGFloat)
    {
        var rt = self.frame
        rt.size.width = width
        self.frame = rt
    }
    
    public func layoutKit_setFrameHeight(_ height: CGFloat)
    {
        var rt = self.frame
        rt.size.height = height
        self.frame = rt
    }
}

// MARK: -
// MARK: CGFloat
extension CGFloat : LayoutKitxPlaceItem, LayoutKityPlaceItem
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
    
    public func layoutKit_setFrameOriginX(_ x : CGFloat) {
    }
    
    public func layoutKit_setFrameOriginY(_ y : CGFloat) {
    }
}

// MARK: -
// MARK: Int
extension Int : LayoutKitxPlaceItem, LayoutKityPlaceItem
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
    
    public func layoutKit_setFrameOriginX(_ x : CGFloat) {
    }
    
    public func layoutKit_setFrameOriginY(_ y : CGFloat) {
    }
}

// MARK: -
// MARK: LayoutKitFlexible
public struct LayoutKitFlexible : LayoutKitxPlaceItem, LayoutKityPlaceItem
{
    fileprivate let _num : CGFloat
    fileprivate init(num: CGFloat)
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
    
    public func layoutKit_setFrameOriginX(_ x : CGFloat) {
    }
    
    public func layoutKit_setFrameOriginY(_ y : CGFloat) {
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
    public func layoutKit_setFrameWidth(_ width: CGFloat)
    {
    }
    
    public func layoutKit_setFrameHeight(_ height: CGFloat)
    {
    }
}

/////////////////////////////////////////////////
// MARK: -
// MARK: private functions
private func computeTotalWidth(_ item: LayoutKitxPlaceItem, flexibleValue: CGFloat) -> CGFloat
{
    return item.layoutKit_frameWidth + item.layoutKit_numOfFlexible * flexibleValue
}

private func computeTotalHeight(_ item: LayoutKityPlaceItem, flexibleValue: CGFloat) -> CGFloat
{
    return item.layoutKit_frameHeight + item.layoutKit_numOfFlexible * flexibleValue
}

private func computeXFlexibleValue(_ totalWidth: CGFloat, _ items: [LayoutKitxPlaceItem]) -> CGFloat
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

private func computeYFlexibleValue(_ totalHeight: CGFloat, _ items: [LayoutKityPlaceItem]) -> CGFloat
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

