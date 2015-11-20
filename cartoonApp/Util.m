//
//  Util.m
//  cartoonApp
//
//  Created by kaso on 20/11/15.
//  Copyright © 2015年 kaso. All rights reserved.
//

#import "Util.h"
#import "UIDevice+PhoneModel.h"
#import "Constants.h"
#import <ADSupport/ASIdentifierManager.h>
#import "UIImageView+AFNetworking.h"

@implementation Util

+(NSString *)getClientInfo{
    NSMutableString *ret = [[NSMutableString alloc]init];
    [ret appendString:@"os:iphone"];
    [ret appendFormat:@",osVersion:%f", [[[UIDevice currentDevice] systemVersion] floatValue]];
    [ret appendString:@",phoneBrand:iphone"];
    [ret appendFormat:@",phoneModel:%@", [UIDevice iPhonesModelString]];
    [ret appendFormat:@",appVersionName:%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [ret appendFormat:@",appVersionCode:%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    NSString * adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString * deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [ret appendFormat:@",adId:%@", adId];
    [ret appendFormat:@",deviceId:%@", deviceId];
    NSString *identifier = nil;
    if(!adId){
        identifier = deviceId;
    }else{
        identifier = adId;
    }
    [ret appendFormat:@",uuid:%@", identifier];
    //    [ret appendFormat:@",channel:%@", CHANNEL_NAME ];
    //    [ret appendFormat:@",subChannel:%@", SUB_CHANNEL_NAME ];
    return ret;
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

+ (NSString *)clearCache
{
    //清除缓存目录
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *searchPath = [searchPaths lastObject];
    
    NSString *str = [NSString stringWithFormat:@"缓存已清除%.1fM", [self folderSizeAtPath:searchPath]];
    NSLog(@"%@",str);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:searchPath];
    for (NSString *p in files) {
        NSError *error;
        NSString *currPath = [searchPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:currPath]) {
            BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:currPath error:&error];
            Log(@"移除文件 %@ ret= %d", currPath, ret);
        }else{
            Log(@"文件不存在 %@", currPath);
        }
    }
    return str;
}

@end
