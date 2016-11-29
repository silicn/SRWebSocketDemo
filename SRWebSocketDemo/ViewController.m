//
//  ViewController.m
//  SRWebSocketDemo
//
//  Created by jiahao on 2016/11/29.
//  Copyright © 2016年 SILICN. All rights reserved.
//

#import "ViewController.h"
#import "WebSocketNetwork.h"


@interface ViewController ()<SLWebSocketDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WebSocketNetwork *networking = [WebSocketNetwork shareInstance];
    networking.delegate = self;
    
    [networking startConnect];
    
   
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)btnclick:(id)sender {
    
    WebSocketNetwork *networking = [WebSocketNetwork shareInstance];
    
    
    for (int i = 0; i < 10; i ++) {
        NSString *str = [NSString stringWithFormat:@"hello%d",i];
        NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:str,@"where", nil];
        [networking sendMessage:message];
    }

}


- (void)onLogin:(WebSocketStatus)state
{
    if (state == WebSocketStatusConnected) {
           }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
