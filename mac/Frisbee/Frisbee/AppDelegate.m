//
//  AppDelegate.m
//  Frisbee
//
//  Created by Abimanyu Raja on 4/14/12.
//  Copyright (c) 2012 The Greatest Company. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreFoundation/CoreFoundation.h>
#import <sys/socket.h>
#include <netinet/in.h>

#define SERVER_IP "50.116.7.184"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self createStatusItem];
    
    // Poll the server constantly (this should be on a seperate thread, but the UI thread
    struct sockaddr_in addr;
    int sockfd;
    
    while(true){
        // Create a socket
        sockfd = socket( AF_INET, SOCK_STREAM, 0 );
        addr.sin_family = AF_INET;
        addr.sin_addr.s_addr = inet_addr(SERVER_IP);
        addr.sin_port = htons( 5002 );
        
        int conn = connect(sockfd, &addr, sizeof(addr)); 
        
        if (!conn) {
            NSString *msg = @"poll";
            NSData* data = [msg dataUsingEncoding:NSUTF8StringEncoding];
            ssize_t datasend = send(sockfd, [data bytes], [data length], 0);
            
            char buf[100];
            memset(buf, 0, sizeof(buf));
            
            int numbytes = recv(sockfd, buf, sizeof(buf)-1, 0); 
            buf[numbytes] = '\0';
           
            NSString *cmd = [NSString stringWithUTF8String: buf];
            
            NSLog(cmd);
            
            if(![cmd isEqualToString:@"empty"]){
                NSString *prefix = @"http://50.116.7.184/?";
                NSString *URL = [prefix stringByAppendingString:cmd];
                NSLog(URL);
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:URL]];
            }
            
            close(sockfd);
        }else{
            NSLog(@"Did not connect");
        }
        // Sleep for 0.1 seconds
        usleep(100000);
    }

    
}


- (void) createStatusItem {
	NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
	statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
	if (statusItem) {
		[statusItem setMenu:[self statusItemMenu]];
		[statusItem setHighlightMode:YES];
		[statusItem setImage:[NSImage imageNamed:@"growlTunes.png"]];
		[statusItem setAlternateImage:[NSImage imageNamed:@"growlTunes-selected.png"]];
		[statusItem setToolTip:NSLocalizedString(@"2:06 PM", /*comment*/ nil)];
	}
}

- (NSMenu *) statusItemMenu {
	//NSLog(@"In statusItemMenu");
	NSMenu *menu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"TwoOSixPM"];
	if (menu) {
		NSMenuItem * item;
		NSString *empty = @""; //used for the key equivalent of all the menu items.
		
		item = [menu addItemWithTitle:NSLocalizedString(@"Open Music Log", @"") action:@selector(openTextFile:) keyEquivalent:empty];
		[item setTarget:self];
		
		item = [menu addItemWithTitle:NSLocalizedString(@"About 2:06PM", @"") action:@selector(openAboutPage:) keyEquivalent:empty];
		[item setTarget:self];
		
		item = [menu addItemWithTitle:NSLocalizedString(@"Quit 2:06PM", @"") action:@selector(quit206AM:) keyEquivalent:empty];
		[item setTarget:self];
		
	}
    return menu;
}

@end
