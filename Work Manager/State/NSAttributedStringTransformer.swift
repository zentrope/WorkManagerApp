//
//  NSAttributedStringTransformer.swift
//  CDAtString
//
//  Created by Keith Irwin on 1/17/22.
//

import CoreData

@objc(NSAttributedStringTransformer)
class NSAttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {

    override public class func transformedValueClass() -> AnyClass {
        return NSAttributedString.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
}
