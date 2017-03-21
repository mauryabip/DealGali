//
//  UIColor+customColor.m
//  DealGali
//
//  Created by Abhishek Kumar on 8/24/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "UIColor+customColor.h"

@implementation UIColor (customColor)
+ (UIColor *)DGPinkColor {
    
    static UIColor *pinkColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pinkColor = [UIColor colorWithRed:230.0 / 255.0
                                     green:9.0 / 255.0
                                      blue:127.0 / 255.0
                                     alpha:1.0];
    });
    
    
    return pinkColor;
}

+ (UIColor *)DGPurpleColor{
    
    static UIColor *PurpleColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PurpleColor = [UIColor colorWithRed:137.0 / 255.0
                                     green:7.0 / 255.0
                                      blue:178.0 / 255.0
                                     alpha:1.0];
    });
    return PurpleColor;
}

+ (UIColor *)DGLightGrayColor{
    
    static UIColor *TextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TextColor = [UIColor colorWithRed:170.0 / 255.0
                                        green:170.0 / 255.0
                                         blue:170.0 / 255.0
                                        alpha:1.0];
    });
    
    return TextColor;
}


+ (UIColor *)DGDarkGrayColor{
    
    static UIColor *TextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TextColor = [UIColor colorWithRed:85.0 / 255.0
                                    green:85.0 / 255.0
                                     blue:85.0 / 255.0
                                    alpha:1.0];
    });
    return TextColor;
}


+ (UIColor *)DGBlackColor{
    
    static UIColor *SecBGColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SecBGColor = [UIColor colorWithRed:0.0 / 255.0
                                    green:0.0 / 255.0
                                     blue:0.0 / 255.0
                                    alpha:1.0];
        
        
    });
    
    return SecBGColor;
}
+ (UIColor *)DGWhiteColor{
    
    static UIColor *SecBGColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SecBGColor = [UIColor colorWithRed:255.0 / 255.0
                                     green:255.0 / 255.0
                                      blue:255.0 / 255.0
                                     alpha:1.0];
        
        
    });
    
    return SecBGColor;
}

+ (UIColor *)DGImgBorderColor{
    
    static UIColor *ImgBGBorderColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ImgBGBorderColor = [UIColor colorWithRed:228.0 / 255.0
                                     green:229.0 / 255.0
                                      blue:230.0 / 255.0
                                     alpha:1.0];
        
        
    });
    
    return ImgBGBorderColor;
}
@end
