//
//  ViewController.m
//  apnTest
//
//  Created by  on 12. 7. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>
#import "ViewController.h"

@interface ViewController ()

@property (retain, nonatomic) NSMutableData * receivedData;

@end

@implementation ViewController

@synthesize myToken;
@synthesize receivedData;

- (BOOL)requestUrl:(NSString *)url {
    // URL 접속 초기화
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:30.0]; 
    [request setHTTPMethod:@"POST"]; 
    NSString * bodyString = [@"deviceType=ios&regId=" stringByAppendingFormat:@"%@", myToken];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) { 
        self.receivedData = [NSMutableData data];
        return YES;
    }
    
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data]; 
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError : %@", [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading: %@", [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
