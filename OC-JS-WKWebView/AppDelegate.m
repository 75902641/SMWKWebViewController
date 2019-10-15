//
//  AppDelegate.m
//  OC-JS-WKWebView
//
//  Created by KT-yzx on 2019/10/14.
//  Copyright © 2019 OC-JS-WKWebView. All rights reserved.
//

#import "AppDelegate.h"
#import "SMWKWebViewController.h"
#import "SMNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.


    [self registerForRemoteNotifications];

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

+(UIWindow*)getWindow {

    UIWindow* win = nil; //[UIApplication sharedApplication].keyWindow;

    for (id item in [UIApplication sharedApplication].windows) {

        if([item class] == [UIWindow class]) {

            if(!((UIWindow*)item).hidden) {

                win = item;

                break;

            }

        }

    }

    return win;

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(void)registerForRemoteNotifications{
    
    
    if(@available(iOS 10.0, *)){
        //iOS 10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!!!!!!!!!!!!!!!!!!");
            }
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"xxxxxxx = %@",settings);
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
    }
    else  {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
        
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
    
    NSString *deviceTokenStr = @"";
    
    if (@available(iOS 13.0, *)) {
        if (![deviceToken isKindOfClass:[NSData class]]) return;
        const unsigned *tokenBytes = [deviceToken bytes];
        deviceTokenStr = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        NSLog(@"deviceToken:%@",deviceTokenStr);
        
    }else{
        deviceTokenStr = [NSString stringWithFormat:@"%@", deviceToken];
        if ([deviceTokenStr hasPrefix:@"<"])
        {
            deviceTokenStr = [deviceTokenStr substringFromIndex:1];
        }
        if ([deviceTokenStr hasSuffix:@">"])
        {
            deviceTokenStr = [deviceTokenStr substringToIndex:([deviceTokenStr length] - 1)];
        }
        
    }
    
    NSString *oldDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if (oldDeviceToken != nil && deviceTokenStr.length > 0 && [oldDeviceToken isEqualToString:deviceTokenStr]) {
        return;
    }
    
  
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"deviceTokenStr = %@", deviceTokenStr);
    
   
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"获取失败%@",error);
    
}

@end
