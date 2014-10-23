//
//  LobbyViewController.m
//  CoffeeBreak
//
//  Created by Robin Seybold on 23/10/14.
//  Copyright (c) 2014 Robin Seybold. All rights reserved.
//

#import "LobbyViewController.h"
#import "BreakRoomViewController.h"

@interface LobbyViewController ()

@end

@implementation LobbyViewController

-(IBAction)unwindToLobby:(UIStoryboardSegue*)segue {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
*/
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navController = [segue destinationViewController];
    BreakRoomViewController *breakRoom = navController.visibleViewController;
    breakRoom.roomName = _roomTextField.text;
    
}


@end
