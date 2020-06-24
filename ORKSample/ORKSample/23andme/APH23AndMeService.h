//
//  APH23andmeService.h
//  CardioHealth
//
//  Created by Dariusz Lesniak on 11/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class APH23AndMeClient;
@class APHStanfordClient;
@class APHStanfordDownloadGenomeResponse;
@class APH23AndMeUserIdUploader;

extern NSString * const STANFORD_STATUS_KEY;
extern NSString * const URL_23ANDME_KEY;

@interface APH23andmeProcessStatus : NSObject

@property (atomic, readonly) NSError* bridgeError;
@property (atomic, readonly) NSError* stanfordError;
@property (atomic, readonly) APHStanfordDownloadGenomeResponse* stanfordDownloadResponse;

- (instancetype)initWithBridgeError: (NSError*) bridgeError
                      stanfordError: (NSError*) stanfordError
                     stanfordStatus: (APHStanfordDownloadGenomeResponse*) stanfordDownloadResponse;

-(BOOL) hasFailed;
-(BOOL) alreadyDownloaded;
@end

@interface APH23AndMeService : NSObject

+(APH23AndMeService*) createWith23andmeToken:(NSString*) token refreshToken:(NSString*) refreshToken;
-(instancetype) initWith23AndMeClient:(APH23AndMeClient*) client23andme
                       stanfordClient:(APHStanfordClient*) stanfordClient
                       bridgeUploader:(APH23AndMeUserIdUploader*) bridgeUploader;

-(void)processData: (void (^) (APH23andmeProcessStatus* result, NSError* fetch23andmeUserError)) resultHandler;
-(void)checkStatus;
+(void) startPeriodicStatusChecks;
+(void) tryReschedule23andmeTask;
+(void)notifyUserWithMessage:(NSString*) message withAction:(void (^)(UIAlertAction *action))action;

@end

