//
//  HLiveRoomShareVC.m
//  QFProj
//
//  Created by Jovial on 2021/9/29.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

//#import "HLiveRoomShareVC.h"
//#import "HTupleView.h"
//
//#define KItemHeight     80
//#define KFooterHeight   50
//
//@interface HLiveRoomShareVC () <HTupleViewDelegate>
//@property (nonatomic) UIVisualEffectView *visualView;
//@property (nonatomic) HTupleView *tupleView;
//@property (nonatomic) NSInteger rowItems;
//@end
//
//@implementation HLiveRoomShareVC
//
//- (CGSize)containerSize {
//    return CGSizeMake(UIScreen.width, KItemHeight*2+KFooterHeight+UIScreen.bottomBarHeight);
//}
//
//- (HTransitionStyle)presetType {
//    return HTransitionStyleSheet;
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
//        _tupleView.layer.cornerRadius = 3.f;//默认为3.f
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
//    _rowItems = 5;
//}
//
//- (void)vcWillDisappear:(HVCDisappearType)type {
//    if (type == HVCDisappearTypePop || type == HVCDisappearTypeDismiss) {
//        [self.tupleView releaseTupleBlock];
//        self.visualView = nil;
//    }
//}
//
//- (BOOL)hideVisualView {
//    return YES;
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
//- (NSInteger)numberOfItemsInSection:(NSInteger)section {
//    return _rowItems;
//}
//- (CGSize)sizeForFooterInSection:(NSInteger)section {
//    NSInteger height = KFooterHeight;
//    if (UIScreen.isIPhoneX) height += UIScreen.bottomBarHeight;
//    return CGSizeMake(self.tupleView.width, height);
//}
//- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(self.tupleView.width/4, KItemHeight);
//}
//
//- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return UIEdgeInsetsMake(10, 0, 0, 0);
//}
//- (UIEdgeInsets)edgeInsetsForFooterInSection:(NSInteger)section {
//    NSInteger height = 0;
//    if (UIScreen.isIPhoneX) height += UIScreen.bottomBarHeight;
//    return UIEdgeInsetsMake(10, 0, height, 0);
//}
//- (void)tupleFooter:(HTupleFooter)footerBlock inSection:(NSInteger)section {
//    HTupleButtonApex *cell = footerBlock(nil, HTupleButtonApex.class, nil, YES);
//    [cell addTopLineWithSize:1.f color:[UIColor colorWithWhite:0.1 alpha:0.2] paddingLeft:0 paddingRight:0];
//    [cell.buttonView setBackgroundColor:[UIColor whiteColor]];
//    [cell.buttonView setTitleColor:[UIColor blackColor]];
//    [cell.buttonView setTitle:@"取消"];
//    [cell.buttonView setPressed:^(id sender, id data) {
//        [self back];
//    }];
//}
//- (void)tupleItem:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath {
//    HTupleViewCellVertValue1 *cell = itemBlock(nil, HTupleViewCellVertValue1.class, nil, YES);
//    cell.imageView.backgroundColor = UIColor.redColor;
//    [cell.imageView setImageWithName:@"icon_no_server"];
//    [cell.imageView setFillet:YES];
//    cell.labelHeight = 25;
//    cell.label.text = @"Item";
//    cell.label.textColor = UIColor.blackColor;
//    [cell.label setTextAlignment:NSTextAlignmentCenter];
//}
//- (void)didSelectCell:(HTupleBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    [self back];
//}
//
//@end
