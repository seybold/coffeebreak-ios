//
//  BreakRoomViewController.m
//  CoffeeBreak
//
//  Created by Robin Seybold on 23/10/14.
//  Copyright (c) 2014 Robin Seybold. All rights reserved.
//

#import "BreakRoomViewController.h"

@interface BreakRoomViewController ()

@end

@implementation BreakRoomViewController {
    SRWebSocket* webSocket;
    NSString *checkUsers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self connectWebSocket];
    self.navigationItem.title = [NSString stringWithFormat:@"#%@", _roomName];
    checkUsers = [NSString stringWithFormat:@"{\"tag\":\"%@\",\"action\":\"/\"}", _roomName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)connectWebSocket {
    webSocket.delegate = nil;
    webSocket = nil;
    
    NSString *urlString = @"ws://coffeebreak.ws:1880";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    webSocket = newWebSocket;
    NSString *login = [NSString stringWithFormat:@"{\"tag\":\"%@\",\"action\":\"#\"}", _roomName];
    [webSocket send:login];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    NSString *action = [dict valueForKey:@"action"];
    
    if (action.length == 0) {
        [webSocket send:checkUsers];
    } else if ([action isEqualToString:@"/"]) {
        [self listUsers:[dict valueForKey:@"users"]];
    } else if ([action isEqualToString:@"+"]) {
        [webSocket send:checkUsers];
    }
}

- (void)listUsers:(NSArray *)users {
    //NSMutableString *userList = [[NSMutableString alloc]init];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < users.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    _usersTable.dataSource = users;
    [_usersTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
   /* for (NSMutableString *user in users) {
        [userList appendString:[NSString stringWithFormat:@"%@\n", user]];
    }
    _userListView.text = userList;*/
}

- (IBAction)sendMessage:(id)sender {
    NSString *breakMsg = [NSString stringWithFormat:@"{\"user\":\"%@\",\"action\":\"+\"}", _usernameField.text];
    [webSocket send:breakMsg];
}

@end