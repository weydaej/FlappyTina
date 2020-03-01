//
//  randomFunc.swift
//  FlappyTina
//
//  Created by Emily Weyda on 7/30/16.
//  Copyright © 2016 Emily Weyda. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {

    public static func random() -> CGFloat {
    
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
        
    }
    
    public static func random(min min : CGFloat, max : CGFloat) -> CGFloat{
    
        return CGFloat.random() * (max - min) + min
    
    }
}