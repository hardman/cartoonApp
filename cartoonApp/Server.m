//
//  Server.m
//  YOYO
//
//  Created by kaso on 27/6/15.
//  Copyright (c) 2015年 meibo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

#import "Server.h"
#import "Constants.h"
#import "TimeUtil.h"
#import "NSDictionary+Extension.h"
#import "EventDispatcher.h"
#import "ModelBinder.h"

static Server * sSever = nil;

@implementation Server{
    BOOL isEventMaped;
}

+(Server *) getInstance{
    if (!sSever) {
        sSever = [[Server alloc]init];
    }
    return sSever;
}

-(void) mapEvents{
    if (isEventMaped) {
        return;
    }
    id __weak weakSelf = self;
    [[EventDispatcher getInstance]mapEvent:EVT_HTTP_SERVER_INCOMMING_CALL target:self callback:^BOOL(id data) {
        if (weakSelf) {
            NSString *type = [data objectForKey:@"type"];
            NSString *method = [data objectForKey:@"method"];
            id params = [data objectForKey:@"params"];
            ModelBinder *binder = [data objectForKey:@"binder"];
            if ([type isEqualToString:@"post"]) {
                [weakSelf POST:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [binder.model initWithData:responseObject];
                    [[EventDispatcher getInstance] dispatch: binder.event data: @{@"status": @YES, @"model": binder.model}];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [[EventDispatcher getInstance] dispatch: binder.event data: @{@"status": @NO}];
                    Log(@"[ERROR] when call method=%@,type=%@,params=%@", method, type, params);
                }];
            }else if([type isEqualToString:@"get"]){
                [weakSelf GET:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [binder.model initWithData:responseObject];
                    [[EventDispatcher getInstance] dispatch: binder.event data: @{@"status": @YES, @"model": binder.model}];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [[EventDispatcher getInstance] dispatch: binder.event data: @{@"status": @NO}];
                    Log(@"[ERROR] when call method=%@,type=%@,params=%@", method, type, params);
                }];
            }
        }
        return YES;
    }];
    isEventMaped = YES;
}

-(void) adjustTimeOff:(id) response{
    if([response containsKey:@"timestamp"]){
        [TimeUtil setTimeOffsetWithServer:[[response objectForKey:@"timestamp"] integerValue]];
    }
}

-(void) HttpGet: (NSString *)method params: (id) params callback:(ServerCallback)callback{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    
    NSMutableString * url = MAKE_URL(HTTP_SERVER_HOST, HTTP_SERVER_GATE, method);
    
    NSMutableDictionary *ParamsDic=[[NSMutableDictionary alloc]initWithDictionary:params];
    [manager GET: url parameters: ParamsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self adjustTimeOff: responseObject];
        if (![@1  isEqual: [responseObject objectForKey: @"status"]]) {
            Log(@"HttpGet error when method=%@, error=%@", method, responseObject);
        }else{
//            Log(@"HttpGet OK when method=%@, response=%@", method, responseObject);
        }
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"HttpGet error when method=%@, error=%@", method, error);
        callback(@{@"status":@(-1), @"msg":@"error", @"error": error});
    }];
}

-(void) HttpPost: (NSString *)method params: (id) params callback:(ServerCallback)callback{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    
    NSMutableString * url = MAKE_URL(HTTP_SERVER_HOST, HTTP_SERVER_GATE, method);
    
    NSMutableDictionary *ParamsDic=[[NSMutableDictionary alloc]initWithDictionary:params];
    [manager POST:url parameters:ParamsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self adjustTimeOff: responseObject];
        if (![@1  isEqual: [responseObject objectForKey: @"status"]]) {
            Log(@"httpPost error when method=%@, error=%@", method, responseObject);
        }else{
//            Log(@"httpPost OK when method=%@, response=%@", method, responseObject);
        }
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"httpPost error when method=%@, error=%@", method, error);
        callback(@{@"status":@(-1), @"msg":@"error", @"error": error});
    }];
}

-(void) HttpUploadImage:(NSString *) method params: (id)params callback:(ServerCallback)callback{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    
    NSMutableString * url = MAKE_URL(HTTP_SERVER_HOST, HTTP_SERVER_GATE, method);
    
    NSMutableDictionary *ParamsDic=[[NSMutableDictionary alloc]initWithDictionary:params];
    
    [manager POST:url parameters:ParamsDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [params objectForKey:@"usefile"];
        [formData appendPartWithFileData: UIImagePNGRepresentation(image) name:@"usefile" fileName:@"usefile.png" mimeType:@"image/png"];
//        [formData appendPartWithFileURL:fileUrl name:@"usefile" fileName:@"usefile.png" mimeType:@"image/png" error:nil];
//        NSData *tokenData = [[UserInfoModel shareUserInfoModel].token dataUsingEncoding:NSUTF8StringEncoding];
//        [formData appendPartWithFormData:tokenData name:@"token"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self adjustTimeOff: responseObject];
        if (![@1  isEqual: [responseObject objectForKey: @"status"]]) {
            Log(@"httpPost error when method=%@, error=%@", method, responseObject);
        }else{
            //Log(@"httpPost OK when method=%@, response=%@", method, responseObject);
        }
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"httpPost error when method=%@, error=%@", method, error);
        callback(@{@"status":@(-1), @"msg":@"error", @"error": error});
    }];
}

@end