//
//  AppDelegate.m
//  iFrisbee
//
//  Created by Abimanyu Raja on 4/14/12.
//  Copyright (c) 2012 The Greatest Company. All rights reserved.
//

#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <sys/socket.h>
#include <netinet/in.h>

#define SERVER_IP "10.30.35.27" 
//CHANGE HERE

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    MPMediaItem * song = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
    NSString * title   = [song valueForProperty:MPMediaItemPropertyTitle];
    NSString * album   = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString * artist  = [song valueForProperty:MPMediaItemPropertyArtist];
    NSLog(title);
    
    struct sockaddr_in addr;
    int sockfd;
    
    // Create a socket
    sockfd = socket( AF_INET, SOCK_STREAM, 0 );
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr(SERVER_IP);
    addr.sin_port = htons( 5003 );
    
    int conn = connect(sockfd, &addr, sizeof(addr)); 
    
    if (!conn) {
        //NSString *msg = @"poll";
        NSData* data = [title dataUsingEncoding:NSUTF8StringEncoding];
        ssize_t datasend = send(sockfd, [data bytes], [data length], 0);
        close(sockfd);
    }else{
        NSLog(@"Did not connect");
    }
    
    return YES;
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
