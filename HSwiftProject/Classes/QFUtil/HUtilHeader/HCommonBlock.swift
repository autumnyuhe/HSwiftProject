//
//  HCommonBlock.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/18.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// universal block define

typealias min_callback = () -> Void

typealias callback = (_ sender: AnyObject, _ data: AnyObject?) -> Void

typealias callback2 = (_ sender: AnyObject, _ data: AnyObject, _ data2: AnyObject) -> Void

typealias simple_callback = (_ sender: AnyObject) -> Void

typealias fail_callback = (_ sender: AnyObject, _ error: Error) -> Void

typealias returnback = (_ sender: AnyObject, _ data: AnyObject) -> AnyObject

typealias finish_callback = (_ sender: AnyObject, _ data: AnyObject, _ error: Error) -> Void
