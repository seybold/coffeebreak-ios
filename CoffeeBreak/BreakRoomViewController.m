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
    SRWebSocket* wSocket;
    NSString *checkUsers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self connectWebSocket];
    self.navigationItem.title = [NSString stringWithFormat:@"#%@ as %@", _roomName, _name];
    checkUsers = [NSString stringWithFormat:@"{\"tag\":\"%@\",\"action\":\"/\"}", _roomName];
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        }
    
    [_userListView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];

    _userListView.editable = YES;
    _userListView.textAlignment = NSTextAlignmentCenter;
    _userListView.editable = NO;

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    //Center vertical alignment
    //CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    //topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    //tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    //Bottom vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
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
    wSocket.delegate = nil;
    wSocket = nil;
    
    NSString *urlString = @"ws://coffeebreak.ws:1880";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    wSocket = newWebSocket;
    NSString *login = [NSString stringWithFormat:@"{\"tag\":\"%@\",\"action\":\"#\"}", _roomName];
    [wSocket send:login];
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
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
    NSString *action = [dict valueForKey:@"action"];
    if([dict objectForKey:@"activeUsers"] != nil) {
        NSInteger activeUsers = [[dict objectForKey:@"activeUsers"] integerValue];
        _usersLabel.text = [NSString stringWithFormat:@"%ld", activeUsers];
    }
    
    
    if (action.length == 0) {
        [webSocket send:checkUsers];
    } else if ([action isEqualToString:@"/"]) {
        [self listUsers:[dict valueForKey:@"users"]];
    } else if ([action isEqualToString:@"+"]) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif) {
            localNotif.alertBody = [NSString stringWithFormat:
                                    NSLocalizedString(@"%@ wants to take a break.", nil), [dict valueForKey:@"user"]];
            localNotif.alertAction = NSLocalizedString(@"Read Message", nil);
            localNotif.soundName = @"alarmsound.caf";
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
        }
        [webSocket send:checkUsers];
    }
    
}

- (void)listUsers:(NSArray *)users {
    
    if(users.count >= 5) {
        _smokeLabel.hidden = TRUE;
        [_userListView setBackgroundColor:[UIColor blackColor]];
        [_userListView setTextColor:[UIColor whiteColor]];
    } else {
        _smokeLabel.hidden = FALSE;
        [_userListView setBackgroundColor:[UIColor whiteColor]];
        [_userListView setTextColor:[UIColor blackColor]];
    }
    NSMutableString *userList = [[NSMutableString alloc]init];
    for (NSMutableString *user in users) {
        [userList appendString:[NSString stringWithFormat:@"%@\n", user]];
    }
    _userListView.text = userList;
}

- (IBAction)sendMessage:(id)sender {
    NSString *breakMsg = [NSString stringWithFormat:@"{\"user\":\"%@\",\"action\":\"+\"}", _name];
    [wSocket send:breakMsg];
}

- (void)dealloc {
    [_userListView removeObserver:self forKeyPath:@"contentSize"];
    [wSocket close];
    wSocket.delegate = nil;
    wSocket = nil;
}

@end
