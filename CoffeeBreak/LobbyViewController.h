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
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *goButton;

-(IBAction)unwindToLobby:(UIStoryboardSegue*)segue;
@end
