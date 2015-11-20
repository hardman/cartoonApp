//
//  Server.h
//  YOYO
//
//  Created by kaso on 27/6/15.
//  Copyright (c) 2015年 meibo. All rights reserved.
//

#ifndef YOYO_Server_h
#define YOYO_Server_h

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef void (^ServerCallback)(id responseObj);

@interface Server : NSObject
//
//+(void) HttpGet: (NSString *)method params: (id) params callback:(ServerCallback)callback;
//
//+(void) HttpPost: (NSString *)method params: (id) params callback:(ServerCallback)callback;
//
//+(void) HttpUploadImage:(NSString *) method params: (id)params callback:(ServerCallback)callback;

-(void) mapEvents;

+(Server *) getInstance;

@end

#endif
