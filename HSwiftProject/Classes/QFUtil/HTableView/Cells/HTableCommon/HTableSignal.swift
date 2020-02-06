//
//  HTableSignal.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

let KTableSkinNotify = "tableSkinNotify"

typealias HTableCellInitBlock = (_ target: AnyObject) -> Void
typealias HTableCellSignalBlock = (_ target: AnyObject, _ signal: HTableSignal?) -> Void

class HTableSignal: NSObject {
    var signal: AnyObject?
    var tag: Int = 0
    var name: String?
}
