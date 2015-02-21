//
//  TextLogView.swift
//  minventure
//
//  Created by Andy Sherwood on 1/31/15.
//  Copyright (c) 2015 Andy Sherwood. All rights reserved.
//

import Foundation
import UIKit

public class TextLogView:UIView {
    
    private var _spans:[String]
    private var _maxSpans:Int
    private var _maxWidth:Int
    private var _font:UIFont
    private var _attributes:[NSObject:AnyObject]
    
    public required init(coder aDecoder: NSCoder) {

        _spans = []
        _maxSpans = 0
        _maxWidth = 0
        
        _font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        _attributes = [
            NSFontAttributeName: _font,
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
        
        super.init(coder: aDecoder)
    }
    
    public func addLine(line:String) {

        let words = splitLineIntoWords(line)
        var newSpan:String = ""
        var newSpanWidth = 0
        
        for var i = 0; i < words.count; i++ {
            
            let word = (i < (words.count-1))
                ? "\(words[i]) "
                : "\(words[i])"
            
            let wordWidth = widthOfWord(word)
            
            if newSpanWidth + wordWidth > _maxWidth {
                
                addSpan(newSpan)
                
                newSpan = ""
                newSpanWidth = 0
            }
            
            newSpan += word
            newSpanWidth += wordWidth
        }
        
        if newSpanWidth > 0 {
            addSpan(newSpan)
        }
        
        setNeedsDisplay()
    }
    
    public override func drawRect(rect: CGRect) {

        var context = UIGraphicsGetCurrentContext()
        
        _maxSpans = getMaxSpans(rect)
        _maxWidth = getMaxWidth(rect)
        
        var y:Int = 0
        
        for span:NSString in _spans {
            
            span.drawAtPoint(CGPoint(x: 0, y: y), withAttributes: _attributes)
            
            y += Int(_font.lineHeight)
        }
    }
    
    private func getMaxWidth(rect: CGRect) -> Int {
        
        return Int(rect.width)
    }
    
    private func getMaxSpans(rect: CGRect) -> Int {
        
        return Int(rect.height / _font.lineHeight)
    }
    
    private func splitLineIntoWords(line:String) -> [String] {
    
        return split(line, {$0 == " "}, maxSplit: Int.max, allowEmptySlices: false)
    }
    
    private func widthOfWord(word:NSString) -> Int {
        
        let size = word.sizeWithAttributes(_attributes)
        return Int(size.width)
    }

    private func addSpan(newSpan:String) {
        
        _spans.append(newSpan)
        
        if _spans.count > _maxSpans {
            _spans.removeAtIndex(0)
        }
    }
}