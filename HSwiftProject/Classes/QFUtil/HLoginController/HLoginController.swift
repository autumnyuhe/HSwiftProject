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

    func numberOfSectionsInTupleView() -> Any {
        return 1
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 6
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
            case 0:return CGSizeMake(self.tupleView.width, 60)
            case 1:return CGSizeMake(self.tupleView.width, 60)
            case 2:return CGSizeMake(self.tupleView.width, 60)
            case 3:return CGSizeMake(self.tupleView.width, 40)
            case 4:return CGSizeMake(self.tupleView.width, 45)
            case 5:return CGSizeMake(self.tupleView.width, 20)
            default:return CGSizeZero
        }
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
            case 0:return UIEdgeInsetsMake(15, 0, 0, 0)
            case 1:return UIEdgeInsetsMake(15, 0, 0, 0)
            case 2:return UIEdgeInsetsMake(15, 0, 0, 0)
            case 3:return UIEdgeInsetsMake(0, 15, 0, 15)
            case 4:return UIEdgeInsetsMake(0, 15, 0, 15)
            case 5:return UIEdgeInsetsMake(5, 15, 0, 0)
            default:return UIEdgeInsetsZero
        }
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        
        switch (indexPath.row) {
            case 0:
                let cell = itemBlock(nil, HTupleTextFieldCell.self, nil, true) as! HTupleTextFieldCell
                cell.textField.backgroundColor = UIColor(hex:"#F2F2F2")

                cell.textField.leftWidth = 80
                cell.textField.leftLabel.textAlignment = .center
                cell.textField.leftLabel.text = "+86"

                cell.textField.placeholder = "请输入手机号"
                cell.textField.textColor = UIColor(hex:"#BABABF")
                cell.textField.font = UIFont.systemFont(ofSize: 14)
                //cell.textField.inputValidator = HPhoneValidator.new

                cell.signalBlock = { (target, signal) in
                    let cell = target as! HTupleTextFieldCell
                    NSLog("选中%d",cell)
                }
            case 1:
                let cell = itemBlock(nil, HTupleTextFieldCell.self, nil, true) as! HTupleTextFieldCell
                cell.textField.backgroundColor = UIColor(hex:"#F2F2F2")

                cell.textField.leftWidth = 80
                cell.textField.leftLabel.textAlignment = .center
                cell.textField.leftLabel.text = "昵称"

                cell.textField.placeholder = "请输入昵称"
                cell.textField.textColor = UIColor(hex:"#BABABF")
                cell.textField.font = UIFont.systemFont(ofSize: 14)

                cell.signalBlock = { (target, signal) in
                    let cell = target as! HTupleTextFieldCell
                    NSLog("选中%d",cell)
                }
            case 2:
                let cell = itemBlock(nil, HTupleTextFieldCell.self, nil, true) as! HTupleTextFieldCell
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
                cell.textField.rightButton.pressed = { (sender, data) in

                }

                cell.signalBlock = { (target, signal) in
                    let cell = target as! HTupleTextFieldCell
                    NSLog("选中%d",cell)
                }
            case 3:
                _ = itemBlock(nil, HTupleBaseCell.self, nil, true)
            case 4:
                let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
                cell.buttonView.backgroundColor = UIColor(hex:"#CCCCCC")
                cell.buttonView.text = "登录"
                cell.buttonView.pressed = { (sender, data) in

                }

                cell.signalBlock = { (target, signal) in
                    let cell = target as! HTupleButtonCell
                    NSLog("选中%d",cell)
                }
            case 5:

                let cell = itemBlock(nil, HServiceAuthorizationCell.self, nil, true) as! HServiceAuthorizationCell

                cell.serviceAgreementBlock = {

                }
                cell.signalBlock = { (target, signal) in
                    let cell = target as! HServiceAuthorizationCell
                    if (cell.isAuthorized) {

                    }
                }

            default:
                _ = itemBlock(nil, HTupleBaseCell.self, nil, true)
        }
    }

}
