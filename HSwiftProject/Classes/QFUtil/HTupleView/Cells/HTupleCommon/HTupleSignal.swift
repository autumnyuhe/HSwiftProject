//
//  HTupleSignal.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

let KTupleSkinNotify = "tupleSkinNotify"

typealias HTupleCellInitBlock = (_ target: AnyObject) -> Void
typealias HTupleCellSignalBlock = (_ target: AnyObject, _ signal: HTupleSignal?) -> Void

class HTupleSignal: NSObject {
    var signal: AnyObject?
    var tag: Int = 0
    var name: String?
}
