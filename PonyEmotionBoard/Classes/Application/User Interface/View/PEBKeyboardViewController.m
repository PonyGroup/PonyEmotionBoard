//
//  PEBKeyboardViewController.m
//  PonyEmotionBoard
//
//  Created by 崔 明辉 on 15-2-23.
//  Copyright (c) 2015年 崔 明辉. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PEBKeyboardViewController.h"
#import "PEBKeyboardPresenter.h"
#import "PEBKeyboardInteractor.h"
#import "PEBKeyboardDelegateObject.h"
#import "UITextField+PEBCursor.h"
#import "UITextView+PEBCursor.h"

@interface PEBKeyboardViewController ()

@property (nonatomic, weak) NSLayoutConstraint *viewBottomSpaceConstraint;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) IBOutlet PEBKeyboardDelegateObject *keyboardDelegates;

@end

@implementation PEBKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSendButtonReactiveCocoa];
    [self.eventHandler updateView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layouts

- (void)configureViewLayouts {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"view": self.view};
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[view]-0-|"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:views];
        [self.view.superview addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(216)]-(-216)-|"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:views];
        self.viewBottomSpaceConstraint = [constraints lastObject];
        [self.view.superview addConstraints:constraints];
    }
    [self.view layoutIfNeeded];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.keyboardDelegates updateView];
}

#pragma mark - cursorPosition

- (void)updateCursorPosition {
    UITextPosition *beginning = self.textField.beginningOfDocument;
    UITextRange *selectedRange = self.textField.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    const NSInteger location = [self.textField offsetFromPosition:beginning
                                                       toPosition:selectionStart];
    [self.textField peb_setCursorPosition:location];
}

#pragma mark - isPresented

- (void)setIsPresenting:(BOOL)isPresented {
    _isPresenting = isPresented;
    if (isPresented) {
        [self updateCursorPosition];
    }
    isPresented ? [self present] : [self dismiss];
}

- (void)present {
    self.viewBottomSpaceConstraint.constant = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.viewBottomSpaceConstraint.constant = 0.0;
        [self.view layoutIfNeeded];
    }];
}

- (void)dismiss {
    self.viewBottomSpaceConstraint.constant = -216.0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.viewBottomSpaceConstraint.constant = -216.0;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Update View

- (void)updateView {
    [self.keyboardDelegates updateView];
}

#pragma mark - Setter 

- (void)setEventHandler:(PEBKeyboardPresenter *)eventHandler {
    _eventHandler = eventHandler;
    self.keyboardDelegates.eventHandler = _eventHandler;
}

- (void)setTextField:(UITextField *)textField {
    _textField = textField;
    self.keyboardDelegates.textField = textField;
}

#pragma mark - Send Button

- (void)configureSendButtonReactiveCocoa {
    [RACObserve(self, textField.text) subscribeNext:^(NSString *x) {
        [self setSendButtonEnabled:x.length];
    }];
}

- (IBAction)handleSendButtonTapped:(id)sender {
    if ([self.textField isKindOfClass:[UITextField class]]) {
        [[self.textField delegate] textFieldShouldReturn:self.textField];
    }
    else if ([self.textField isKindOfClass:[UITextView class]]) {
        [[(UITextView *)self.textField delegate] textView:(UITextView *)self.textField
                                  shouldChangeTextInRange:NSMakeRange(0, 0)
                                          replacementText:@"\n"];
    }
}

- (void)setSendButtonEnabled:(BOOL)enabled {
    if (enabled) {
        self.sendButton.enabled = YES;
        self.sendButton.backgroundColor = [UIColor colorWithRed:0.0
                                                          green:122.0/255.0
                                                           blue:255.0/255.0
                                                          alpha:1.0];
    }
    else {
        self.sendButton.enabled = NO;
        self.sendButton.backgroundColor = [UIColor clearColor];
    }
}


@end
