//
//  APHStanfordClient.h
//  CardioHealth
//
//  Created by Dariusz Lesniak on 08/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class APH23AndMeUser;

@interface APHStanfordBasicResponse : NSObject
@property (atomic, readonly) NSString* status;
@property (atomic, readonly) NSString* message;
@property (atomic, readonly) NSNumber* errorCode;

-(instancetype)initWithData: (NSDictionary*) data;
-(BOOL)isComplete;
-(BOOL)isPending;
-(BOOL)hasFailed;
@end

@interface APHStanfordDownloadGenomeResponse : APHStanfordBasicResponse
@property (atomic, readonly) NSString* statusKey;

-(instancetype)initWithData: (NSDictionary*) data;
@end


@interface APHStanfordClient : NSObject <NSURLSessionDelegate>
+ (APHStanfordClient *)sharedInstance;
-(instancetype) initWithBaseUrl:(NSString *) baseUrl;
-(void) downloadGenome:(APH23AndMeUser *)user withCompletion:(void (^) (APHStanfordDownloadGenomeResponse *user, NSError *error)) handler;
-(void) checkStatus:(NSString *) user withCompletion: (void (^) (APHStanfordBasicResponse *statusDetails, NSError *error)) handler;
-(void) signup:(NSString *) user withCompletion: (void (^) (APHStanfordBasicResponse *statusDetails, NSError *error)) handler;
@end

