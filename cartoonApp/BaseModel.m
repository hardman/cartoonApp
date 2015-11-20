//
//  BaseModel.m
//  cartoonApp
//
//  Created by kaso on 20/11/15.
//  Copyright © 2015年 kaso. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(void) initWithData:(id)data{
    [self setValuesForKeysWithDictionary:data];
}

@end
