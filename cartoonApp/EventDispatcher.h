//
//  EventDispatcher.h
//  YOYO
//
//  Created by kaso on 27/6/15.
//  Copyright (c) 2015年 meibo. All rights reserved.
//

#ifndef YOYO_EventDispatcher_h
#define YOYO_EventDispatcher_h

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface EventQueue: NSObject{
    NSMutableArray *mQueue;
}

-(void) push:(id) item;
-(id)pop;
-(id)top;
-(NSUInteger)lenth;
-(void)clear;
-(BOOL)isEmpty;
-(id)at:(int)index;
-(id)remove:(int)index;
-(id)getQueue;
@end

typedef BOOL (^EventDispatcherCallback)(id); //返回值表示是否从map列表中移除掉监听的事件。返回NO表示移除，返回YES表示继续监听。

@interface EventDispatcher: NSObject{
    @private EventQueue *mMappedEvent;
    @private EventQueue *mMappedTarget;
    @private EventQueue *mMappedCallback;
    
    @private EventQueue *mPendingEvent;

    @private NSMutableDictionary *mPendingEventDatas;

    @private NSMutableArray *mMarkedRemoveEventIndexes;
    
    @private NSTimer *mTimer;
}
-(void) startTimer;
-(void) stopTimer;
-(void) mapEvent: (NSString *)event target:(id) target callback:(EventDispatcherCallback) cb;
-(void) unmapEvent: (NSString *)event target:(id) target;
-(void) dispatch: (NSString *)event data:(id)data;
-(void) dispatch: (NSString *)event;
+(EventDispatcher *)getInstance;

@end
#endif
