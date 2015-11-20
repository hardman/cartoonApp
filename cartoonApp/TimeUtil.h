//
//  TimeUtil.h
//  YOYO
//
//  Created by kaso on 27/6/15.
//  Copyright (c) 2015年 meibo. All rights reserved.
//

#ifndef YOYO_TimeUtil_h
#define YOYO_TimeUtil_h

#import <Foundation/Foundation.h>
@interface TimeUtil : NSObject

+(double)getCurrentTimeWithSec;
+(double)getCurrentTimeWithMSec;
+(void)setTimeOffsetWithServer:(double) serverTime;

@end

#endif
