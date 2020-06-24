//
//  APH23AndMeUserIdUploader.h
//  CardioHealth
//
//  Created by Dariusz Lesniak on 05/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

@import APCAppCore;
#import <Foundation/Foundation.h>
@class APH23AndMeUser;

@interface APH23AndMeUserIdUploader : NSObject



-(instancetype)initWithArchiver:(APCDataArchive*) archive
                       uploader:(APCDataArchiveUploader*) dataUploader;

-(void)uploadUserData: (APH23AndMeUser*) user withCompletion:(void (^)(NSError * error)) completion;


@end
