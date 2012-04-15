//
//  AppDelegate.h
//  Frisbee
//
//  Created by Abimanyu Raja on 4/14/12.
//  Copyright (c) 2012 The Greatest Company. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem	*statusItem;
}

@property (assign) IBOutlet NSWindow *window;

@end
