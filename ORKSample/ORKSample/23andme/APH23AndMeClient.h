//
//  APH23AndMeClient.h
//  CardioHealth
//
//  Created by Dariusz Lesniak on 04/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class APH23AndMeUser;

@interface APH23AndMeClient : NSObject <NSURLConnectionDelegate>

-(instancetype) initWithBaseUrl:(NSString *) baseUrl andToken:(NSString *) authToken refreshToken:(NSString*) refreshToken;
-(void) fetchUser:(void (^) (APH23AndMeUser *user, NSError *error)) handler;

@end
