//
//  LobbyViewController.h
//  CoffeeBreak
//
//  Created by Robin Seybold on 23/10/14.
//  Copyright (c) 2014 Robin Seybold. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LobbyViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *roomTextField;

-(IBAction)unwindToLobby:(UIStoryboardSegue*)segue;
@end
