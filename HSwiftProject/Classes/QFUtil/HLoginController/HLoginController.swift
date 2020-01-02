//
//  HLoginController.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HLoginController: HTupleController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.leftNaviButton.isHidden = true
        self.title = "登录"
        self.tupleView.delegate = self
    }

    func numberOfSectionsInTupleView() -> NSInt {
        return NSInt(value: 1)
    }
    func numberOfItemsInSection(_ section: NSInt) -> NSInt {
        return NSInt(value: 6)
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> NSSize {
        switch (indexPath.row) {
            case 0:return CGSizeMake(self.tupleView.width, 60).sizeValue
            case 1:return CGSizeMake(self.tupleView.width, 60).sizeValue
            case 2:return CGSizeMake(self.tupleView.width, 60).sizeValue
            case 3:return CGSizeMake(self.tupleView.width, 40).sizeValue
            case 4:return CGSizeMake(self.tupleView.width, 45).sizeValue
            case 5:return CGSizeMake(self.tupleView.width, 20).sizeValue
            default:return CGSizeZero.sizeValue
        }
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> NSEdgeInsets {
        switch (indexPath.row) {
            case 0:return UIEdgeInsetsMake(15, 0, 0, 0).edgeInsetsValue
            case 1:return UIEdgeInsetsMake(15, 0, 0, 0).edgeInsetsValue
            case 2:return UIEdgeInsetsMake(15, 0, 0, 0).edgeInsetsValue
            case 3:return UIEdgeInsetsMake(0, 15, 0, 15).edgeInsetsValue
            case 4:return UIEdgeInsetsMake(0, 15, 0, 15).edgeInsetsValue
            case 5:return UIEdgeInsetsMake(5, 15, 0, 0).edgeInsetsValue
            default:return UIEdgeInsetsZero.edgeInsetsValue
        }
    }
    func tupleItem(_ itemObject: NSTupleItem, atIndexPath indexPath: IndexPath) {
        switch (indexPath.row) {
            case 0:
                let cell = itemObject.itemBlock(nil, HTupleTextFieldCell.self, nil, true) as! HTupleTextFieldCell
                cell.textField.backgroundColor = UIColor(hex:"#F2F2F2")

                cell.textField.leftWidth = 80
                cell.textField.leftLabel.textAlignment = .center
                cell.textField.leftLabel.text = "+86"

                cell.textField.placeholder = "请输入手机号"
                cell.textField.textColor = UIColor(hex:"#BABABF")
                cell.textField.font = UIFont.systemFont(ofSize: 14)
                //cell.textField.inputValidator = HPhoneValidator.new

                cell.signalBlock = { ( cell: HTupleTextFieldCell, signal: HTupleSignal) in

                } as? HTupleCellSignalBlock
            case 1:
                let cell = itemObject.itemBlock(nil, HTupleTextFieldCell.self, nil, true) as! HTupleTextFieldCell
                cell.textField.backgroundColor = UIColor(hex:"#F2F2F2")

                cell.textField.leftWidth = 80
                cell.textField.leftLabel.textAlignment = .center
                cell.textField.leftLabel.text = "昵称"

                cell.textField.placeholder = "请输入昵称"
                cell.textField.textColor = UIColor(hex:"#BABABF")
                cell.textField.font = UIFont.systemFont(ofSize: 14)

                cell.signalBlock = { ( cell: HTupleTextFieldCell, signal: HTupleSignal) in

                } as? HTupleCellSignalBlock
            case 2:
                let cell = itemObject.itemBlock(nil, HTupleTextFieldCell.self, nil, true) as! HTupleTextFieldCell
                cell.textField.backgroundColor = UIColor(hex:"#F2F2F2")

                cell.textField.leftWidth = 80
                cell.textField.leftLabel.textAlignment = .center
                cell.textField.leftLabel.text = "验证码"

                cell.textField.placeholder = "请输入验证码"
                cell.textField.textColor = UIColor(hex:"#BABABF")
                cell.textField.font = UIFont.systemFont(ofSize: 14)
                //cell.textField.inputValidator = HNumericValidator.new

                cell.textField.rightWidth = 120
                cell.textField.rightButton.text = "获取验证码"
                cell.textField.rightButton.textFont = UIFont.systemFont(ofSize: 14)
                cell.textField.rightButton.pressed = { (_ send: AnyObject, _ data: AnyObject) in

                } as? callback

                cell.signalBlock = { ( cell: HTupleTextFieldCell, signal: HTupleSignal) in

                } as? HTupleCellSignalBlock
            case 3:
                _ = itemObject.itemBlock(nil, HTupleBaseCell.self, nil, true)
            case 4:
                let cell = itemObject.itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
                cell.buttonView.backgroundColor = UIColor(hex:"#CCCCCC")
                cell.buttonView.text = "登录"
                cell.buttonView.pressed = { (_ send: AnyObject, _ data: AnyObject) in

                } as? callback

                cell.signalBlock = { ( cell: HTupleButtonCell, signal: HTupleSignal) in

                } as? HTupleCellSignalBlock
            case 5:

                let cell = itemObject.itemBlock(nil, HServiceAuthorizationCell.self, nil, true) as! HServiceAuthorizationCell

                cell.serviceAgreementBlock = {

                }
                cell.signalBlock = { ( cell: HServiceAuthorizationCell, signal: HTupleSignal) in
                    if (cell.isAuthorized) {

                    }
                } as? HTupleCellSignalBlock

            default:
                _ = itemObject.itemBlock(nil, HTupleBaseCell.self, nil, true)
        }
    }

}
