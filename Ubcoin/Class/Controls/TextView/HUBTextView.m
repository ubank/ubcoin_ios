//
//  HUBTextView.m
//  Halva
//
//  Created by Александр Макшов on 02.04.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBTextView.h"

@interface HUBTextView () <UITextViewDelegate>

@end

@implementation HUBTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setupTextView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    
    if (self)
    {
        [self setupTextView];
    }
    
    return self;
}

- (void)setupTextView
{
    self.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.didChangeTextBlock)
    {
        self.didChangeTextBlock(self);
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.shouldReturnBlock)
    {
        return self.shouldReturnBlock(self);
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer
{
    return self.isSimultaneousGestureEnabled;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    return [[UIApplication sharedApplication] canOpenURL:URL];
}

- (void)removeAllInsets
{
    self.contentInset = UIEdgeInsetsZero;
    self.textContainerInset = UIEdgeInsetsZero;
    self.textContainer.lineFragmentPadding = 0;
}

@end
