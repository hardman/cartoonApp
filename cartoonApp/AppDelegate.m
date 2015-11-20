//
//  AppDelegate.m
//  cartoonApp
//
//  Created by kaso on 19/11/15.
//  Copyright © 2015年 kaso. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Server.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


-(void) createWindow{
    //创建window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

-(void) createViewControllers{
    NSArray *viewCtlData = @[
  @{
      @"className": @"MainController",
      @"image": @"maintabbarmain",
      @"selecetdImage": @"maintabbarmainselect",
      @"title": LANG_MAIN_TABBAR_TITLE1
      },
  @{
      @"className": @"RankController",
      @"image": @"maintabbarrank",
      @"selecetdImage": @"maintabbarrankelect",
      @"title": LANG_MAIN_TABBAR_TITLE2
      },
  @{
      @"className": @"CartoonGroupController",
      @"image": @"maintabbarcartoongroup",
      @"selecetdImage": @"maintabbarcartoongroupelect",
      @"title": LANG_MAIN_TABBAR_TITLE3
      },
  @{
      @"className": @"DownloadController",
      @"image": @"maintabbardownload",
      @"selecetdImage": @"maintabbardownloadelect",
      @"title": LANG_MAIN_TABBAR_TITLE4
      }
  ];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    [viewCtlData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class clazz = NSClassFromString([obj objectForKey:@"className"]);
        UIViewController *instance = [[clazz alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:instance];
        //标题和图片
        nav.tabBarItem.title = [obj objectForKey:@"title"];
        nav.tabBarItem.image = [UIImage imageNamed: [obj objectForKey:@"image"]];
        nav.tabBarItem.selectedImage = [UIImage imageNamed: [obj objectForKey:@"selectedImage"]];
        [viewControllers addObject:nav];
    }];
    
    UITabBarController *tabbarController = [[UITabBarController alloc]init];
    tabbarController.viewControllers = viewControllers;
    self.window.rootViewController = tabbarController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self createWindow];
    [self createViewControllers];
    [self initSomeStates];
    return YES;
}

-(void) initSomeStates{
    [[Server getInstance] mapEvents];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
