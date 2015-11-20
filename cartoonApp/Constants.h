//
//  Constants.h
//  cartoonApp
//
//  Created by kaso on 20/11/15.
//  Copyright © 2015年 kaso. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#import "Translate.h"

//log
#if defined(DEBUG) && DEBUG == 1
    #define Log(...) NSLog(__VA_ARGS__)
#else
    #define Log(...)
#endif

//颜色
#define COLOR(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1]
#define COLORA(r, g, b, a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)/255.f]

//尺寸 设计分辨率为 iphone6plus 414x736的屏幕
#define SCREENSIZE [[UIScreen mainScreen] bounds]
#define DESIGNWIDTH 414
#define DESIGNHEIGHT 736

#define x(v) ((v) * SCREENSIZE.size.width / DESIGNWIDTH)
#define y(v) ((v) * SCREENSIZE.size.height / DESIGNHEIGHT)

//weak
#define WEAKSELF __typeof(self) __weak weakSelf = self;

//server
#define HTTP_SERVER_HOST @"http://localhost"
#define HTTP_SERVER_GATE @8080
#define MAKE_URL(host, port, method) [NSMutableString stringWithFormat:@"%@:%@/%@", host, port, method]

#define EVT_HTTP_SERVER_INCOMMING_CALL @"evt_http_server_incoming_call"

//调用接口
#define modelBinder(evt, model) [[ModelBinder alloc] initWithEvent: evt andModel: model]
#define call(method, type, params, binder) [[EventDispatcher getInstance] dispatch: EVT_HTTP_SERVER_INCOMMING_CALL data:@{@"type": type, @"method": method, @"params": params, @"binder":binder}]
#define post(method, params, binder) call(method, @"post", params, binder)
#define get(method, params, binder) call(method, @"get", params, binder)

#endif /* Constants_h */
