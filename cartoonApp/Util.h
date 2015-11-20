//
//  Util.h
//  cartoonApp
//
//  Created by kaso on 20/11/15.
//  Copyright © 2015年 kaso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util: NSObject
+(NSString *)getClientInfo;
+(float) folderSizeAtPath:(NSString*) folderPath;
+(long long) fileSizeAtPath:(NSString*) filePath;
+(NSString *)clearCache;
@end
