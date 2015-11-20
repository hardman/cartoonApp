//
//  NSDictionary+Extension.h
//  YOYO
//
//  Created by kaso on 20/11/15.
//  Copyright © 2015年 meibo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(CheckContains)

-(BOOL)containsKey:(NSString *)key;

-(NSMutableDictionary *)removeNSNull;

@end

@interface NSArray(CheckContains)

-(NSMutableArray *)removeNSNull;

@end

