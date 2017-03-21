//
//  UIFont+customFont.m
//  DealGali
//
//  Created by Virinchi Software on 24/07/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "UIFont+customFont.h"

@implementation UIFont (customFont)
+ (UIFont *)DGHyperLineButtonFont {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    });
    
    
    return textFont;
}
+ (UIFont *)DGHeadingNotifiFont {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    });
    
    
    return textFont;
}

+ (UIFont *)DGTextFieldFont {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    });
    
    
    return textFont;
}
+ (UIFont *)DGTextHomeFont {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f];
    });
    
    
    return textFont;
}
+ (UIFont *)DGTextHome10Font {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
    });
    
    
    return textFont;
}

+ (UIFont *)DGTextHome11Font {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
    });
    
    
    return textFont;
}
+ (UIFont *)DGTextHome12Font {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    });
    
    
    return textFont;
}

+ (UIFont *)DGTextViewFont {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    });
    
    
    return textFont;
}
+ (UIFont *)DGLocalNotiFont {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    });
    
    
    return textFont;
}


+ (UIFont *)DGTextMediumFont {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    });
    
    
    return textFont;
}


+ (UIFont *)DGActionButtonFont {
    
    static UIFont *textFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFont = [UIFont fontWithName:@"HelveticaNeue" size:20.0f];
    });
    
    
    return textFont;
}

@end
