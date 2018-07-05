//
//  HUBTextView.h
//  Halva
//
//  Created by Александр Макшов on 02.04.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

@interface HUBTextView : UITextView

@property (copy, nonatomic) void(^didChangeTextBlock)(HUBTextView *textView);
@property (copy, nonatomic) BOOL(^shouldReturnBlock)(HUBTextView *textView);

@property (assign, nonatomic) BOOL isSimultaneousGestureEnabled;

- (void)removeAllInsets;

@end
