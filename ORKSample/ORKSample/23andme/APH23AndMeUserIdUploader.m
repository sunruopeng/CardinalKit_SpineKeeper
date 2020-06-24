//
//  APH23AndMeUserIdUploader.m
//  CardioHealth
//
//  Created by Dariusz Lesniak on 05/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

#import "APH23AndMeUserIdUploader.h"
#import "APH23AndMeUser.h"

NSString * const k23andMeFileName = @"23andMeUserId";

@interface APH23AndMeUserIdUploader ()

@property(nonatomic, strong) APCDataArchive *dataArchiver;
@property(nonatomic, strong) APCDataArchiveUploader *dataUploader;

@end

@implementation APH23AndMeUserIdUploader

-(instancetype)initWithArchiver:(APCDataArchive *)archive
                       uploader:(APCDataArchiveUploader *)dataUploader {
    
    self = [super init];
    if (self) {
        self.dataArchiver = archive;
        self.dataUploader = dataUploader;
    }
    return self;
}

-(void)uploadUserData: (APH23AndMeUser*) user withCompletion:(void (^)(NSError * error)) completion {
    
    [self.dataArchiver insertIntoArchive:[self buildData:user] filename: k23andMeFileName];
    [self.dataUploader encryptAndUploadArchive:self.dataArchiver withCompletion:completion];
}

-(NSDictionary*) buildData: (APH23AndMeUser*) user {
    
    NSMutableDictionary  *userIdData = [NSMutableDictionary dictionary];
    userIdData[@"item"] = k23andMeFileName;
    userIdData[@"userId"] = user.userId;
    userIdData[@"profileId"] = user.profileId;
    
    return userIdData;
}

@end
