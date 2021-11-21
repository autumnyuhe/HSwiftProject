//
//  HLiveRoomNoteVC.m
//  QFProj
//
//  Created by Jovial on 2021/9/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

//#import "HLiveRoomNoteVC.h"
//#import "HTupleView.h"
//#import "UIViewController+HTransition.h"
//
//@interface HLiveRoomNoteVC () <HTupleViewDelegate>
//@property (nonatomic) UIVisualEffectView *visualView;
//@property (nonatomic) HTupleView *tupleView;
//@property (nonatomic) NSString *note;
//@property (nonatomic) CGSize noteSize;
//@end
//
//@implementation HLiveRoomNoteVC
//
//- (CGSize)containerSize {
//    self.note = @"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"测试通告"@"end";
//    self.noteSize = [self.note sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToWidth:240];
//    return CGSizeMake(270, 86+self.noteSize.height);
//}
//
//- (UIVisualEffectView *)visualView {
//    if (!_visualView) {
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//        _visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
//        CGRect frame = CGRectZero;
//        frame.size = self.containerSize;
//        _visualView.frame = frame;
//    }
//    return _visualView;
//}
//
//- (HTupleView *)tupleView {
//    if (!_tupleView) {
//        CGRect frame = CGRectZero;
//        frame.size = self.containerSize;
//        _tupleView = [[HTupleView alloc] initWithFrame:frame];
//        _tupleView.backgroundColor = UIColor.clearColor;
//        _tupleView.layer.cornerRadius = 10.f;//默认系统弹框圆角为10.f
//        [_tupleView bounceDisenable];
//    }
//    return _tupleView;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.backgroundColor = UIColor.clearColor;
//    [self.topBar setHidden:YES];
//    if (self.hideVisualView) {
//        self.tupleView.backgroundColor = UIColor.whiteColor;
//        [self.view addSubview:self.tupleView];
//    }else {
//        [self.visualView.contentView addSubview:self.tupleView];
//        [self.view addSubview:self.visualView];
//    }
//    [self.tupleView setTupleDelegate:self];
//}
//
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    if (!self.hideVisualView) {
//        for (UIView *subview in self.visualView.subviews) {
//            subview.layer.cornerRadius = self.tupleView.layer.cornerRadius;
//        }
//    }
//}
//
//- (void)vcWillDisappear:(HVCDisappearType)type {
//    if (type == HVCDisappearTypePop || type == HVCDisappearTypeDismiss) {
//        [self.tupleView releaseTupleBlock];
//        self.visualView = nil;
//    }
//}
//
//- (NSInteger)numberOfSectionsInTupleView {
//    return 1;
//}
//- (NSInteger)numberOfItemsInSection:(NSInteger)section {
//    return 4;
//}
//- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row) {
//        case HCell0:
//            return CGSizeMake(self.tupleView.width, 42.5);
//            break;
//        case HCell1:
//            return CGSizeMake(self.tupleView.width, self.noteSize.height);
//            break;
//        case HCell2:
//            return CGSizeMake(self.tupleView.width, 1);
//            break;
//        case HCell3:
//            return CGSizeMake(self.tupleView.width, 42.5);
//            break;
//
//        default:
//            break;
//    }
//    return CGSizeZero;
//}
//- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row) {
//        case HCell0:
//            return UIEdgeInsetsMake(0, 15, 2.5, 15);
//        case HCell1:
//            return UIEdgeInsetsMake(2.5, 15, 0, 15);
//        case HCell2:
//            return UIEdgeInsetsZero;
//        case HCell3:
//            return UIEdgeInsetsZero;
//
//        default:
//            break;
//    }
//    return UIEdgeInsetsZero;
//}
//- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row) {
//        case HCell0: {
//            HTupleNoteCell *cell = itemBlock(nil, HTupleNoteCell.class, nil, YES);
//            cell.label.font = [UIFont boldSystemFontOfSize:17.f];
//            cell.label.textAlignment = NSTextAlignmentCenter;
//            cell.label.textVerticalAlignment = HTextVerticalAlignmentBottom;
//            cell.label.textColor = HColorHex(#0B0A0C);
//            cell.label.text = @"公告通知";
//        }
//            break;
//        case HCell1: {
//            HTupleNoteCell *cell = itemBlock(nil, HTupleNoteCell.class, nil, YES);
//            cell.label.font = [UIFont systemFontOfSize:12.f];
//            cell.label.textAlignment = NSTextAlignmentLeft;
//            cell.label.textVerticalAlignment = HTextVerticalAlignmentTop;
//            cell.label.numberOfLines = 0;
//            cell.label.textColor = HColorHex(#070507);
//            cell.label.text = self.note;
//        }
//            break;
//        case HCell2: {
//            HTupleBlankCell *cell = itemBlock(nil, HTupleBlankCell.class, nil, YES);
//            cell.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
//        }
//            break;
//        case HCell3: {
//            HTupleLabelCell *cell = itemBlock(nil, HTupleLabelCell.class, nil, YES);
//            cell.label.font = [UIFont boldSystemFontOfSize:17.f];
//            cell.label.textAlignment = NSTextAlignmentCenter;
//            cell.label.textColor = HColorHex(#3184DD);
//            cell.label.text = @"知道了";
//        }
//            break;
//
//        default:
//            break;
//    }
//
//}
//- (void)didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == HCell3) {
//        [self back];
//    }
//}
//
//@end
