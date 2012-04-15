//
//  AppDelegate.m
//  Frisbee
//
//  Created by Abimanyu Raja on 4/14/12.
//  Copyright (c) 2012 The Greatest Company. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self createStatusItem];
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
