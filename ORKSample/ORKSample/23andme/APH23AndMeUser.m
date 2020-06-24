//
//  APH23AndMeUser.m
//  CardioHealth
//
//  Created by Dariusz Lesniak on 04/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

#import "APH23AndMeUser.h"

@implementation APH23AndMeUser

- (instancetype)initWithData: (NSDictionary*) data token: (NSString*) token refreshToken:(NSString*) refreshToken
{
    self = [super init];
    if (self) {
        self.userId = [data objectForKey:@"id"];
        self.token = token;
        self.refreshToken = refreshToken;
        [self initProfiles:[data objectForKey:@"profiles"]];
    }
    return self;
}

-(void) initProfiles:(NSArray*) dictProfiles {
    NSMutableArray *profiles = [[NSMutableArray alloc] init];
    for (NSDictionary *dictProfile in dictProfiles) {
        APH23AndMeProfile * profile = [[APH23AndMeProfile alloc] initWithData:dictProfile];
        [profiles addObject:profile];
    }
    self.profiles = profiles;
}

-(NSString *)profileId {
    return [self.profiles objectAtIndex:0].profileId;
}


@end

@implementation APH23AndMeProfile
- (instancetype)initWithData: (NSDictionary*) data
{
    self = [super init];
    if (self) {
        self.genotyped = [data objectForKey:@"genotyped"];
        self.profileId = [data objectForKey:@"id"];
    }
    return self;
}
@end
