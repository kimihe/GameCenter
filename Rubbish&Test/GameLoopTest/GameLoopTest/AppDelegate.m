//
//  AppDelegate.m
//  GameLoopTest
//
//  Created by 周祺华 on 2016/11/11.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "AppDelegate.h"
#import "MainView.h"
#import "ViewController.h"

@interface AppDelegate ()
{
    MainView *mainView;
    id timer;
    UIViewController *rootVC;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    rootVC = [ViewController new];
    self.window.rootViewController = rootVC;

    mainView = [[MainView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    mainView.backgroundColor = [UIColor grayColor];
    [self.window addSubview:mainView];
//    [rootVC.view addSubview:mainView];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self stopGameLoop];
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
    [self startGameLoop];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void) startGameLoop {
    NSString *deviceOS = [[UIDevice currentDevice] systemVersion];
    bool forceTimerVariant = TRUE;
    
    if (forceTimerVariant || [deviceOS compare: @"3.1" options: NSNumericSearch] == NSOrderedAscending) {
        //33 frames per second -> timestep between the frames = 1/33
        NSTimeInterval fpsDelta = 0.0303;
        timer = [NSTimer scheduledTimerWithTimeInterval: fpsDelta
                                                 target: self
                                               selector: @selector( loop )
                                               userInfo: nil
                                                repeats: YES];
        
    } else {
        int frameLink = 2;
        timer = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget: self selector: @selector( loop )];
        [timer setFrameInterval: frameLink];
        [timer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
    }
    
    NSLog(@"Game Loop timer instance: %@", timer);
}

- (void) stopGameLoop {
    [timer invalidate];
    timer = nil;
}

- (void) loop {
    [mainView setNeedsDisplay]; //triggers MainView's drawRect:-method
}


@end
