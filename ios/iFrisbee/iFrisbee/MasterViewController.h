//
//  MasterViewController.h
//  iFrisbee
//
//  Created by Abimanyu Raja on 4/14/12.
//  Copyright (c) 2012 The Greatest Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
