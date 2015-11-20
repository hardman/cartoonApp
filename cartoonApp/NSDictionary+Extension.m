//
//  NSDictionary+Extension.m
//  YOYO
//
//  Created by kaso on 20/11/15.
//  Copyright © 2015年 meibo. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary(CheckContains)

-(BOOL)containsKey:(NSString *)key{
    
    id value = [self objectForKey:key];
    if(!value){
        return NO;
    }
    return ![value isEqual:[NSNull null]];
}

-(NSMutableDictionary *)removeNSNull{
    
    NSMutableDictionary *ret = [[NSMutableDictionary alloc]initWithDictionary:self];
    NSMutableArray * markDeleteKey = [[NSMutableArray alloc] init];
    NSMutableDictionary * markModifyDict = [[NSMutableDictionary alloc] init];
    for (NSString * key in ret) {
        id value = [ret objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
            [markModifyDict setObject:[value removeNSNull] forKey:key];
        }else{
            if (value == nil || [value isEqual: [NSNull null]]) {
                [markDeleteKey addObject:key];
            }
        }
    }
    
    for (NSString *key in markModifyDict) {
        id value = [markModifyDict objectForKey:key];
        [ret setObject:value forKey:key];
    }
    
    for (NSString *key in markDeleteKey) {
        [ret removeObjectForKey:key];
    }
    
    return ret;
}

@end

@implementation NSArray (CheckContains)

-(NSMutableArray *)removeNSNull{
    NSMutableArray * ret = [[NSMutableArray alloc]initWithArray:self];
    NSMutableArray * markDeleteIndex = [[NSMutableArray alloc]init];
    NSMutableDictionary * markModifyDict = [[NSMutableDictionary alloc]init];
    for (id value in ret) {
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            [markModifyDict setObject:[value removeNSNull] forKey:@([ret indexOfObject:value])];
        }else{
            if (value == nil || [value isEqual: [NSNull null]]) {
                [markDeleteIndex addObject:@([ret indexOfObject:value])];
            }
        }
    }
    for (NSNumber *key in markModifyDict) {
        id value = [markModifyDict objectForKey:key];
        [ret setObject:value atIndexedSubscript:[key integerValue]];
    }
    for (NSNumber *key in markDeleteIndex) {
        [ret removeObjectAtIndex:[key integerValue]];
    }
    return ret;
}

@end
