//
//  WebSocketNetwork.m
//  SRWebSocketDemo
//
//  Created by jiahao on 2016/11/29.
//  Copyright © 2016年 SILICN. All rights reserved.
//

#import "WebSocketNetwork.h"


static SRWebSocket * webScoket = nil;


@interface WebSocketNetwork ()

@property (nonatomic, strong) SRWebSocket *webSocket;

@property (nonatomic, strong) NSOperationQueue *delegateQueue;

@end


@implementation WebSocketNetwork


+ (instancetype)shareInstance
{
    static WebSocketNetwork *mySocket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySocket = [[WebSocketNetwork alloc]init];
    });
    return mySocket;
    
}

- (instancetype)shareInstance
{
    return [[self class] shareInstance];
}


- (id)init
{
    self= [super init];
    if (self) {
        self.delegateQueue = [[NSOperationQueue alloc]init];
        self.delegateQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)startConnect
{
    if (_webSocket == nil) {
        self.webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:@""]];
    }
    self.webSocket.delegate = self;
    [self.webSocket open];
    self.webSocket.delegateOperationQueue = self.delegateQueue;
    self.status = WebSocketStatusConnecting;
    
}

- (void)sendMessage:(NSDictionary *)message
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil];
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self.webSocket sendString:msg error:nil];
    
}


#pragma mark Receive Messages

/**
 Called when any message was received from a web socket.
 This method is suboptimal and might be deprecated in a future release.
 
 @param webSocket An instance of `SRWebSocket` that received a message.
 @param message   Received message. Either a `String` or `NSData`.
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
   // NSLog(@"%s",__FUNCTION__);
    
}

/**
 Called when a frame was received from a web socket.
 
 @param webSocket An instance of `SRWebSocket` that received a message.
 @param string    Received text in a form of UTF-8 `String`.
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string
{
     NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@   %@",string,[[NSThread currentThread] isMainThread] ? @"Main":@"NoMain");

    if (self.delegate && [self.delegate respondsToSelector:@selector(webSocketDidReceivedMessage:)]) {
        [self.delegate webSocketDidReceivedMessage:string];
    }
    
}

/**
 Called when a frame was received from a web socket.
 
 @param webSocket An instance of `SRWebSocket` that received a message.
 @param data      Received data in a form of `NSData`.
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithData:(NSData *)data
{
     NSLog(@"%s",__FUNCTION__);
}

#pragma mark Status & Connection

/**
 Called when a given web socket was open and authenticated.
 
 @param webSocket An instance of `SRWebSocket` that was open.
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
     NSLog(@"%s",__FUNCTION__);
    self.status = WebSocketStatusConnected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLogin:)]) {
        [self.delegate onLogin:WebSocketStatusConnected];
    }
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"hello":@"word"} options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [webSocket sendString:str error:&error];
    
    
}

/**
 Called when a given web socket encountered an error.
 
 @param webSocket An instance of `SRWebSocket` that failed with an error.
 @param error     An instance of `NSError`.
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    self.status = WebSocketStatusConnectFail;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLogin:)]) {
        [self.delegate onLogin:WebSocketStatusConnectFail];
    }
    
     NSLog(@"%s   %@",__FUNCTION__,error);
}

/**
 Called when a given web socket was closed.
 
 @param webSocket An instance of `SRWebSocket` that was closed.
 @param code      Code reported by the server.
 @param reason    Reason in a form of a String that was reported by the server or `nil`.
 @param wasClean  Boolean value indicating whether a socket was closed in a clean state.
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(nullable NSString *)reason wasClean:(BOOL)wasClean
{
    self.status = WebSocketStatusLoseConnect;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLogin:)]) {
        [self.delegate onLogin:WebSocketStatusLoseConnect];
    }
     NSLog(@"%s",__FUNCTION__);
}

/**
 Called on receive of a ping message from the server.
 
 @param webSocket An instance of `SRWebSocket` that received a ping frame.
 @param data      Payload that was received or `nil` if there was no payload.
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceivePingWithData:(nullable NSData *)data
{
    
    NSString *ping = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (ping != nil) {
          NSLog(@"ping =  %@",ping);
    }
  
    
}

/**
 Called when a pong data was received in response to ping.
 
 @param webSocket An instance of `SRWebSocket` that received a pong frame.
 @param pongData  Payload that was received or `nil` if there was no payload.
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(nullable NSData *)pongData
{
     NSLog(@"%s",__FUNCTION__);
}


@end
