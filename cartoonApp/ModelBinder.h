//
//  ModelBinder.h
//  cartoonApp
//
//  Created by kaso on 20/11/15.
//  Copyright © 2015年 kaso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ModelBinder : NSObject

@property (nonatomic, strong) BaseModel *model;

@property (nonatomic, copy) NSString *event;

-(instancetype)initWithEvent: (NSString *)evt andModel: (BaseModel *)model;

@end
