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
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITableView *usersTable;
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) IBOutlet UITextView *userListView;
- (IBAction)sendMessage:(id)sender;

@end
