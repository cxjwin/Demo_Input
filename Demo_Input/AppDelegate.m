//
//  AppDelegate.m
//  Demo_Input
//
//  Created by cxjwin on 14-4-23.
//  Copyright (c) 2014年 cxjwin. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDAsyncUdpSocket.h"
#import "DemoViewController.h" 

@interface AppDelegate ()

@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:queue];
	
	NSError *error = nil;
	if (![self.udpSocket bindToPort:8080 error:&error]) {
		NSLog(@"Error binding: %@", error);
		return NO;
	}
	
	if (![self.udpSocket beginReceiving:&error]) {
		NSLog(@"Error receiving: %@", error);
		return NO;
	}
	
    DemoViewController *viewController = [[DemoViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (msg) {
		NSLog(@"%@", msg);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KUDPMessage" object:msg];
	} else {
		NSString *host = nil;
		uint16_t port = 0;
		[GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
		NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
	}
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
