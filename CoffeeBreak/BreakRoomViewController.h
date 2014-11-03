//
//  BreakRoomViewController.h
//  CoffeeBreak
//
//  Created by Robin Seybold on 23/10/14.
//  Copyright (c) 2014 Robin Seybold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface BreakRoomViewController : UIViewController <SRWebSocketDelegate>
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) IBOutlet UITextView *userListView;
@property (strong, nonatomic) IBOutlet UILabel *usersLabel;
- (IBAction)sendMessage:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *smokeLabel;
@property (strong, nonatomic) IBOutlet UILabel *coffeeLabel;

@end
