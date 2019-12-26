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

typealias callback = (_ sender: Any?, _ data: Any?) -> Void

typealias callback2 = (_ sender: Any?, _ data: Any?, _ data2: Any?) -> Void

typealias simple_callback = (_ sender: Any?) -> Void

typealias fail_callback = (_ sender: Any?, _ error: Error) -> Void

typealias returnback = (_ sender: Any?, _ data: Any?) -> Any?

typealias finish_callback = (_ sender: Any?, _ data: Any?, _ error: Error) -> Void
