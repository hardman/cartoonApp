//
//  TimeUtil.m
//  YOYO
//
//  Created by kaso on 27/6/15.
//  Copyright (c) 2015年 meibo. All rights reserved.
//

#import "TimeUtil.h"

static double sTimeOffWithServer = 0;

@implementation TimeUtil

+(double)getLocalTimeWithSec{
    return [[NSDate date]timeIntervalSince1970];
}

+(double)getLocalTimeWithMSec{
    return [self getCurrentTimeWithSec] * 1000;
}

+(void)setTimeOffsetWithServer:(double) serverTime{
    sTimeOffWithServer = serverTime - [self getLocalTimeWithSec];
}

+(double)getCurrentTimeWithSec{
    return [self getLocalTimeWithSec] + sTimeOffWithServer;
}

+(double)getCurrentTimeWithMSec{
    return [self getLocalTimeWithMSec] + sTimeOffWithServer;
}

@end