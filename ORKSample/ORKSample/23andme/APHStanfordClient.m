//
//  APHStanfordClient.m
//  CardioHealth
//
//  Created by Dariusz Lesniak on 08/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

#import "APHStanfordClient.h"
#import "APH23AndMeUser.h"

@interface APHStanfordClient ()
@property (nonatomic, strong) NSString* baseUrl;
@property (nonatomic, strong) NSString* downloadGenomePath;
@property (nonatomic, strong) NSString* checkStatusPath;
@property (nonatomic, strong) NSString* signup;
@end


@implementation APHStanfordClient

+ (APHStanfordClient *)sharedInstance {
    static APHStanfordClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initWithBaseUrl:@"https://device-qa.stanford.edu/mhc-KnRJe654r9xkA5tX/api"];
    });
    return sharedClient;
}

-(instancetype) initWithBaseUrl:(NSString *) baseUrl {
    self = [super init];
    if (self) {
        self.baseUrl = baseUrl;
        self.downloadGenomePath =  [[NSString alloc] initWithFormat:@"%@%@", self.baseUrl, @"/v1/23andme"];
        self.checkStatusPath =  [[NSString alloc] initWithFormat:@"%@%@", self.baseUrl, @"/v1/23andme/%@/status"];
        self.signup = [[NSString alloc] initWithFormat:@"%@%@", self.baseUrl, @"/v1/auth/signUp"];
    }
    return self;
}

-(void) signup:(NSString *)user withCompletion:(void (^)(APHStanfordBasicResponse *, NSError *))handler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.signup]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{@"password": @"abcd",
                                                                   @"email": @"a@a.com",
                                                                   @"study": @"genepool"}
                                                         options:0 error:nil]];
    
    NSURLSessionDataTask *dataTask = [[self createSession] dataTaskWithRequest:request
                                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable __unused response, NSError * _Nullable error) {
                                                                 if (!error) {
                                                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                                     if (httpResp.statusCode == 200) {
                                                                         NSError *jsonError;
                                                                         
                                                                         NSDictionary *statusDetailsData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                           options:NSJSONReadingAllowFragments
                                                                                                                                             error:&jsonError];
                                                                         
                                                                         handler([[APHStanfordDownloadGenomeResponse alloc] initWithData:statusDetailsData], jsonError);
                                                                     } else {
                                                                         handler(nil, [self handleError:httpResp.statusCode data:data]);
                                                                     }
                                                                 } else {
                                                                     handler(nil, error);
                                                                 }
                                                             }];
    [dataTask resume];
}

-(void) downloadGenome:(APH23AndMeUser *)user withCompletion:(void (^)(APHStanfordDownloadGenomeResponse *, NSError *))handler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downloadGenomePath]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{@"user": user.userId,
                                                                   @"token": user.token,
                                                                   @"profile": user.profileId,
                                                                   @"refreshToken": user.refreshToken}
                                                         options:0 error:nil]];
    
    NSURLSessionDataTask *dataTask = [[self createSession] dataTaskWithRequest:request
                                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable __unused response, NSError * _Nullable error) {
                                                                 if (!error) {
                                                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                                     if (httpResp.statusCode == 200) {
                                                                         NSError *jsonError;
                                                                         
                                                                         NSDictionary *statusDetailsData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                           options:NSJSONReadingAllowFragments
                                                                                                                                             error:&jsonError];
                                                                         
                                                                         handler([[APHStanfordDownloadGenomeResponse alloc] initWithData:statusDetailsData], jsonError);
                                                                     } else {
                                                                         handler(nil, [self handleError:httpResp.statusCode data:data]);
                                                                     }
                                                                 } else {
                                                                     handler(nil, error);
                                                                 }
                                                             }];
    [dataTask resume];
}

-(void)checkStatus:(NSString *)statusKey withCompletion:(void (^)(APHStanfordBasicResponse *, NSError *))handler {
    NSURLSessionDataTask *dataTask = [[self createSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:self.checkStatusPath, statusKey]]
                                                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable __unused response, NSError * _Nullable error) {
                                                             if (!error) {
                                                                 NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                                 if (httpResp.statusCode == 200) {
                                                                     NSError *jsonError;
                                                                     
                                                                     NSDictionary *statusDetailsData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                       options:NSJSONReadingAllowFragments
                                                                                                                                         error:&jsonError];
                                                                     
                                                                     handler([[APHStanfordBasicResponse alloc] initWithData:statusDetailsData], jsonError);
                                                                 } else {
                                                                     handler(nil, [self handleError:httpResp.statusCode data:data]);
                                                                 }
                                                                 
                                                             } else {
                                                                 handler(nil, error);
                                                             }
                                                         }];
    [dataTask resume];
}

-(NSURLSession*) createSession {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:@{@"Accept" : @"application/json", @"Content-Type": @"application/json"}];
    
    return [NSURLSession sessionWithConfiguration:sessionConfig
                                         delegate:self
                                    delegateQueue:nil];
}

-(NSError*) handleError:(NSInteger) statusCode data: (NSData*) data {
    
    NSDictionary *errorInfo = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
    
    return [NSError errorWithDomain:@"edu.stanford" code:statusCode userInfo:errorInfo];
}


@end

static const NSString *STANFORD_STATUS_FAILED = @"failed" ;
static const NSString *STANFORD_STATUS_COMPLETE = @"complete" ;
static const NSString *STANFORD_STATUS_PENDING = @"pending" ;
static const NSInteger HTTP_STATUS_OK = 200;

@implementation APHStanfordDownloadGenomeResponse
- (instancetype)initWithData: (NSDictionary*) data {
    self = [super initWithData:data];
    if (self) {
        _statusKey = [data objectForKey:@"statusKey"];
    }
    return self;
}
@end

@implementation APHStanfordBasicResponse
-(instancetype)initWithData: (NSDictionary*) data{
    self = [super init];
    if (self) {
        _status = [data objectForKey:@"status"];
        _message = [data objectForKey:@"message"];
        _errorCode = [data objectForKey:@"errorCode"];
    }
    return self;
}

-(BOOL)isComplete {
    return [STANFORD_STATUS_COMPLETE isEqualToString:self.status];
}

-(BOOL)isPending {
    return [STANFORD_STATUS_PENDING isEqualToString:self.status];
}

-(BOOL)hasFailed {
    return [STANFORD_STATUS_FAILED isEqualToString:self.status];
}
@end
