//
//  WebSocketNetwork.h
//  SRWebSocketDemo
//
//  Created by jiahao on 2016/11/29.
//  Copyright © 2016年 SILICN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

typedef NS_ENUM(NSInteger,WebSocketStatus)
{
    WebSocketStatusConnecting = 0,
    WebSocketStatusConnected,
    WebSocketStatusConnectFail,
    WebSocketStatusLoseConnect
};


@protocol SLWebSocketDelegate <NSObject>

@optional

- (void)onLogin:(WebSocketStatus)state;

- (void)webSocketDidReceivedMessage:(id)message;


@end


@interface WebSocketNetwork : NSObject <SRWebSocketDelegate>




+ (instancetype)shareInstance;

- (instancetype)shareInstance;

- (void)startConnect;


@property (nonatomic, assign) WebSocketStatus status;

@property (nonatomic, assign) id <SLWebSocketDelegate>delegate;

- (void)sendMessage:(NSDictionary *)message;



@end
