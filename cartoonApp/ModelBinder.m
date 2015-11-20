//
//  ModelBinder.m
//  cartoonApp
//
//  Created by kaso on 20/11/15.
//  Copyright © 2015年 kaso. All rights reserved.
//

#import "ModelBinder.h"

@implementation ModelBinder

-(instancetype)initWithEvent: (NSString *)evt andModel: (BaseModel *)model{
    if (self = [super init]) {
        self.event = evt;
        self.model = model;
    }
    return self;
}

@end
