//
//  PEBKeyboardViewController.h
//  PonyEmotionBoard
//
//  Created by 崔 明辉 on 15-2-23.
//  Copyright (c) 2015年 崔 明辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PEBKeyboardPresenter;

@interface PEBKeyboardViewController : UIViewController

@property (nonatomic, strong) PEBKeyboardPresenter *eventHandler;

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, assign) BOOL isPresenting;

- (void)configureViewLayouts;

- (void)updateView;

@end
