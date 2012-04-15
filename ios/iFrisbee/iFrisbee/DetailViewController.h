//
//  DetailViewController.h
//  iFrisbee
//
//  Created by Abimanyu Raja on 4/14/12.
//  Copyright (c) 2012 The Greatest Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
