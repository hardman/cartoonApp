//
//  EventDispatcher.m
//  YOYO
//
//  Created by kaso on 27/6/15.
//  Copyright (c) 2015年 meibo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EventDispatcher.h"

@implementation EventQueue

-(EventQueue *)init{
    self = [super init];
    mQueue = [[NSMutableArray alloc] init];
    return self;
}

-(void) push:(id) item{
    [mQueue addObject:item];
}

-(id)pop{
    id item = [mQueue objectAtIndex:0];
    [mQueue removeObjectAtIndex:0];
    return item;
}

-(id)top{
    return [mQueue objectAtIndex:0];
}

-(NSUInteger)lenth{
    return [mQueue count];
}

-(void)clear{
    [mQueue removeAllObjects];
}

-(BOOL)isEmpty{
    return [self lenth] == 0;
}

-(id) at:(int)index{
    return [mQueue objectAtIndex:index];
}

-(id) remove:(int)index{
    id ret = [mQueue objectAtIndex:index];
    [mQueue removeObjectAtIndex:index];
    return ret;
}

-(id)getQueue{
    return mQueue;
}

@end

static EventDispatcher *sEventDispatcher = NULL;
static NSInteger sPendingDataIndex = 0;
@interface EventDispatcher (PrivateMethod)
-(EventDispatcher*)initDispatcher;
-(int) isMaped:(NSString *)event target:(id) target;
-(void) removeMapedAt:(int)index;
-(void) markRemoveEventIndex:(int)index;
-(void) onUpdate;
@end

@implementation EventDispatcher

+(NSInteger) getPendingDataIndex{
    return sPendingDataIndex;
}

+(NSInteger) raisePendingDataIndex{
    return ++sPendingDataIndex;
}

+(EventDispatcher *)getInstance{
    if (sEventDispatcher == NULL) {
        sEventDispatcher = [[EventDispatcher alloc]initDispatcher];
    }
    return sEventDispatcher;
}

-(void) startTimer{
    [mTimer fire];
}

-(void) stopTimer{
    [mTimer invalidate];
}

-(EventDispatcher *)initDispatcher{
    self = [super init];
    
    mMappedEvent = [[EventQueue alloc] init];
    mMappedTarget = [[EventQueue alloc] init];
    mMappedCallback = [[EventQueue alloc] init];
    mPendingEvent = [[EventQueue alloc] init];
    mPendingEventDatas = [[NSMutableDictionary alloc]init];
    
    mMarkedRemoveEventIndexes = [[NSMutableArray alloc]init];
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1/30.0 target:self selector:@selector(onUpdate) userInfo:nil repeats:YES];
    [self startTimer];
    
    return self;
}

-(void)onUpdate{
    if (mPendingEvent.lenth > 0) {
        for (int i = (int)mPendingEvent.lenth - 1; i >= 0 ; i--) {
            NSString *pEvent = [mPendingEvent at:i];
            NSInteger pendingEventDataIndex = -1;
            if ([pEvent containsString:@"##"]) {
                NSInteger len = pEvent.length;
                NSRange range = [pEvent rangeOfString:@"##"];
                NSString *subEvent = [pEvent substringWithRange:NSMakeRange(range.location + range.length, len - range.location - 2)];
                pendingEventDataIndex = [subEvent integerValue];
                pEvent = [pEvent substringToIndex:range.location];
            }
            for (int j = (int)mMappedEvent.lenth - 1; j >= 0 ; j--) {
                if ([pEvent isEqualToString:[mMappedEvent at: j]]) {
                    //find one map
                    EventDispatcherCallback cb = [mMappedCallback at: j];
                    if (cb) {
                        id data = nil;
                        if (pendingEventDataIndex >= 0) {
                            data = [mPendingEventDatas objectForKey:@(pendingEventDataIndex)];
                        }
                        if (data == nil || [data isEqual:[NSNull null]]) {
                            data = nil;
                        }
                        if(!cb(data)){
                            [self markRemoveEventIndex:j];
                        }
                    }
                }
            }
            [self realRemoveEvents];
            if (pendingEventDataIndex >= 0) {
                [mPendingEventDatas removeObjectForKey:@(pendingEventDataIndex)];
            }
            [mPendingEvent remove:i];
        }
        //[mPendingEventDatas removeAllObjects];
        [mPendingEvent clear];
    }else{
        [self realRemoveEvents];
    }
}

-(int) isMaped:(NSString *)event target:(id) target{
    for (int i = 0; i < mMappedEvent.lenth; i++) {
        if ([event isEqualToString:[mMappedEvent at:i]]) {
            if (target == [mMappedTarget at:i]) {
                return i;
            }
        }
    }
    return -1;
}

-(void) markRemoveEventIndex:(int)index{
    if (![mMarkedRemoveEventIndexes containsObject:@(index)]) {
        [mMarkedRemoveEventIndexes addObject:@(index)];
        [mMarkedRemoveEventIndexes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj2 compare:obj1];
        }];
    }
}

-(void) realRemoveEvents{
    for (id idx in mMarkedRemoveEventIndexes){
        [self removeMapedAt:[idx intValue]];
    }
    [mMarkedRemoveEventIndexes removeAllObjects];
}

-(void) removeMapedAt:(int)index{
    [mMappedEvent remove: index];
    [mMappedTarget remove: index];
    [mMappedCallback remove: index];
}

-(void)mapEvent:(NSString *)event target:(id) target callback:(EventDispatcherCallback)cb{
    if ([self isMaped:event target:target] >= 0) {
        Log(@"error event %@, target %@ has mapped already", event, target);
        return;
    }
    [mMappedEvent push:event];
    [mMappedTarget push:target];
    [mMappedCallback push:cb];
}

-(void)unmapEvent:(NSString *)event target:(id)target{
    int i = [self isMaped:event target:target];
    if (i >= 0) {
        [self markRemoveEventIndex:i];
    }
}

-(void)dispatch:(NSString *)event data:(id)data{
    if (!event || [event isEqual:[NSNull null]]) {
        Log(@"dispatch event is nil");
        return;
    }
    NSInteger currPendingDataIndex = [EventDispatcher raisePendingDataIndex];
    //Log(@"EventDispatcher currPendingDataIndex = %ld", (long)currPendingDataIndex);
    [mPendingEvent push:[NSString stringWithFormat:@"%@##%@", event, @(currPendingDataIndex)]];
    if (data != nil && ![data isEqual:[NSNull null]]) {
        [mPendingEventDatas setObject:data forKey:@(currPendingDataIndex)];
    }
}

-(void) dispatch: (NSString *)event{
    [self dispatch:event data:nil];
}

@end