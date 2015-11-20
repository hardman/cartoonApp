//
//  UIDevice+PhoneModel.h
//  YOYO
//
//  Created by kaso on 23/9/15.
//  Copyright (c) 2015年 meibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Iphone4,
    Iphone5,
    Iphone6,
    Iphone6plus,
    unknown,
} EnumIphoneModel;

@interface UIDevice (IPhoneModel)

+ (NSString *)iPhonesModelString;
+ (EnumIphoneModel)iPhonesModelInt;

@end
