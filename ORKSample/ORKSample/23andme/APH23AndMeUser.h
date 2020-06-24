//
//  APH23AndMeUser.h
//  CardioHealth
//
//  Created by Dariusz Lesniak on 04/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APH23AndMeProfile : NSObject

@property (nonatomic) BOOL genotyped;
@property (nonatomic, strong) NSString* profileId;

- (instancetype)initWithData: (NSDictionary*) data;

@end

@interface APH23AndMeUser : NSObject

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* refreshToken;
@property (nonatomic, strong) NSArray<APH23AndMeProfile *>* profiles;
- (instancetype)initWithData: (NSDictionary*) data token:(NSString*) token refreshToken:(NSString*) refreshToken;
- (NSString*) profileId;

@end

