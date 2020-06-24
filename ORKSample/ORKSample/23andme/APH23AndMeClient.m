//
//  APH23AndMeClient.m
//  CardioHealth
//
//  Created by Dariusz Lesniak on 04/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//


#import "APH23AndMeClient.h"
#import "APH23AndMeUser.h"

@interface APH23AndMeClient ()

@property (nonatomic, strong) NSString* baseUrl;
@property (nonatomic, strong) NSString* authToken;
@property (nonatomic, strong) NSString* refreshToken;
@property (nonatomic, strong) NSURL* userEndpoint;

@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic, strong) NSURLResponse* response;
@property (nonatomic, strong) NSOperationQueue* callbackQueue;
@property (nonatomic, strong) void (^fetchUserCallback) (APH23AndMeUser *user, NSError *error) ;

@end

@implementation APH23AndMeClient

-(instancetype) initWithBaseUrl:(NSString *) baseUrl andToken:(NSString *) authToken refreshToken:(NSString *)refreshToken {
    
    self = [super init];
    if (self) {
        self.baseUrl = baseUrl;
        _callbackQueue = [[NSOperationQueue alloc] init];
        _baseUrl = baseUrl;
        _authToken = authToken;
        _refreshToken = refreshToken;
        self.userEndpoint = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@", self.baseUrl, @"/1/user/"]];
    }
    return self;
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)__unused connection {
    
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) self.response;
    if (httpResp.statusCode == 200) {
        NSError *jsonError;
        
        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&jsonError];
        
        self.fetchUserCallback([[APH23AndMeUser alloc] initWithData:userData token:self.authToken refreshToken:self.refreshToken], jsonError);
    } else {
        self.fetchUserCallback(nil, [self handleError:httpResp.statusCode data:self.responseData]);
    }
}

- (void)connection:(NSURLConnection *)__unused connection didReceiveResponse:(NSURLResponse *) response {
    self.response = response;
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)__unused connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)__unused connection didFailWithError:(NSError *)error {
    self.fetchUserCallback(nil,error);
}

-(void) fetchUser:(void (^) (APH23AndMeUser *user, NSError *error)) handler {
    self.fetchUserCallback = handler;
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:self.userEndpoint];
    [urlRequest setTimeoutInterval:20];
    [urlRequest setValue:[[NSString alloc] initWithFormat:@"Bearer %@", self.authToken] forHTTPHeaderField:@"Authorization"];
    
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                  delegate:self
                                                          startImmediately:NO];
    [conn setDelegateQueue:self.callbackQueue];
    [conn start];
    
}

-(void)connection:(NSURLConnection *)__unused connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL* baseURL = [NSURL URLWithString:@"https://api.researchkit.23andme.io/"];
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
            NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
        NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(NSError*) handleError:(NSInteger) statusCode data: (NSData*) data {
    
    NSDictionary *errorInfo = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
    
    return [NSError errorWithDomain:@"com.23andme" code:statusCode userInfo:errorInfo];
}

@end
