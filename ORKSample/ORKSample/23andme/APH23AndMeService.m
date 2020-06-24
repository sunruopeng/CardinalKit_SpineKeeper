//
//  APH23andmeService.m
//  CardioHealth
//
//  Created by Dariusz Lesniak on 11/01/2016.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

#import "APH23AndMeService.h"
#import "APH23AndMeClient.h"
#import "APHStanfordClient.h"
#import "APH23AndMeUserIdUploader.h"
#import "APH23AndMeUser.h"
#import "APH23andmeTask.h"
#import "APHAppDelegate.h"
#import "UIAlertController+Window.h"

NSString * const STANFORD_STATUS_KEY = @"STANFORD_STATUS_KEY";
NSString * const URL_23ANDME_KEY = @"23andmeUrl";
static NSInteger  const CHECK_STATUS_INTERVAL = 900;
static NSTimer *timer;

@interface APCScheduler (Private)
- (void) clearTaskGroupCache;
@end

@interface APH23AndMeService ()
@property (atomic, strong) APH23AndMeClient* client23andme;
@property (atomic, strong) APHStanfordClient* stanfordClient;
@property (atomic, strong) APH23AndMeUserIdUploader* bridgeUploader;
@end

@implementation APH23AndMeService


+(APH23AndMeService*) createWith23andmeToken:(NSString *)token refreshToken:(NSString*) refreshToken {
    return [[APH23AndMeService alloc]initWith23AndMeClient:[[APH23AndMeClient alloc] initWithBaseUrl:[[NSBundle mainBundle] objectForInfoDictionaryKey:URL_23ANDME_KEY]
                                                                                            andToken:token
                                                                                        refreshToken:refreshToken]
                                            stanfordClient:[APHStanfordClient sharedInstance]
                                            bridgeUploader:[[APH23AndMeUserIdUploader alloc] initWithArchiver:[[APCDataArchive alloc] initWithReference:@"23andmeTask"]
                                                                                                     uploader:[[APCDataArchiveUploader alloc] init]]];
    
}

-(instancetype)initWith23AndMeClient:(APH23AndMeClient *)client23andme
                      stanfordClient:(APHStanfordClient *)stanfordClient
                      bridgeUploader:(APH23AndMeUserIdUploader *)bridgeUploader {
    
    self = [super init];
    if (self) {
        self.client23andme = client23andme;
        self.stanfordClient = stanfordClient;
        self.bridgeUploader = bridgeUploader;
    }
    return self;
}

-(void)processData: (void (^) (APH23andmeProcessStatus* result, NSError* fetch23andmeUserError)) resultHandler {
    
    NSDate * fetchUserStart = [NSDate date];
    [self.client23andme fetchUser:^(APH23AndMeUser *user, NSError *error) {
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:fetchUserStart];
        APH23andmeProcessStatus *result;
        
        if(!error) {
            APCLogEventWithData(@"23andmeFetchUser", (@{@"status": @"complete",
                                                             @"duration" : [NSString stringWithFormat:@"%f", duration]}));
            
            [self uploadUserIdToBridgeAndStanford:user withCompletion:^(APH23andmeProcessStatus *status) {
                resultHandler(status, nil);
            }];
        } else {
            [self logError:error forLocation:@"23andmeFetchUser" withDuration:duration];
            resultHandler(result, error);
        }
        
    }];
}

-(void) uploadUserIdToBridgeAndStanford:(APH23AndMeUser*) user withCompletion:(void (^)(APH23andmeProcessStatus * status))handler {
    __block NSError *bridgeError;
    __block NSError *stanfordError;
    __block APHStanfordDownloadGenomeResponse *stanfordDownloadResponse;
    
    dispatch_group_t uploadGroup = dispatch_group_create();
    
    dispatch_group_enter(uploadGroup);
    NSDate * uploadToBridgeStart = [NSDate date];
    [self.bridgeUploader uploadUserData:user withCompletion:^(NSError *error) {
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:uploadToBridgeStart];
        bridgeError = error;
        if (error) {
            [self logError:error forLocation:@"23andmeUploadToBridge" withDuration:duration];
        } else {
            APCLogEventWithData(@"23andmeUploadToBridge", (@{@"status": @"complete",
                                                             @"duration" : [NSString stringWithFormat:@"%f", duration]}));
        }
        dispatch_group_leave(uploadGroup);
    }];
    
    
    dispatch_group_enter(uploadGroup);
    NSDate * downloadGenomeStart = [NSDate date];
    [self.stanfordClient downloadGenome:user withCompletion:^(APHStanfordDownloadGenomeResponse *response, NSError *error) {
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:downloadGenomeStart];
        stanfordError = error;
        stanfordDownloadResponse = response;
        
        if (stanfordError) {
            [self logError:error forLocation:@"23andmeDownloadGenome" withDuration:duration];
            dispatch_group_leave(uploadGroup);
            return;
        }
        
        APCLogEventWithData(@"23andmeDownloadGenome", (@{@"status": response.status ? response.status: @"",
                                                           @"message" : response.message ? response.message : @"",
                                                           @"daration" : [NSString stringWithFormat:@"%f", duration]}));
        dispatch_group_leave(uploadGroup);
    }];
    
    
    dispatch_group_notify(uploadGroup,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        APH23andmeProcessStatus *status = [[APH23andmeProcessStatus alloc] initWithBridgeError:bridgeError
                                                      stanfordError:stanfordError
                                                     stanfordStatus:stanfordDownloadResponse];
        handler(status);
    });
    
}

-(void) logError: (NSError*) error forLocation: (NSString*) location withDuration: (NSTimeInterval) duration {
    APCLogError2(error);
    APCLogEventWithData(@"23andmeError", (@{@"location" : location,
                                             @"code": error.code ? [@(error.code) stringValue] : @"",
                                             @"domain": error.domain ? error.domain : @"",
                                             @"message" : error.message ? error.message : @"",
                                             @"duration" : [NSString stringWithFormat:@"%f", duration]}));
}

-(void) checkStatus {
    NSString *stanfordStatusKey = [[NSUserDefaults standardUserDefaults] objectForKey: STANFORD_STATUS_KEY];
    
    if (!stanfordStatusKey) {
        return;
    }
    
    NSDate * checkStatusStart = [NSDate date];
    [self.stanfordClient checkStatus:stanfordStatusKey withCompletion:^(APHStanfordBasicResponse *statusDetails, NSError *error) {
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:checkStatusStart];
        
        if (error) {
            [self logError:error forLocation:@"23andmeStatusCheck" withDuration:duration];
            return;
        }
        
        if ([statusDetails isComplete]) {
            [APH23AndMeService stopPeriodicStatusChecks];
            [APH23AndMeService notifyUserWithMessage:@"You have successfuly shared your genetic data." withAction:^(UIAlertAction __unused *action) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey: STANFORD_STATUS_KEY];
            }];
        } else if ([statusDetails hasFailed]) {
            [APH23AndMeService stopPeriodicStatusChecks];
            [APH23AndMeService notifyUserWithMessage:@"There was a problem downloading your genetic data. Please try again." withAction:^(UIAlertAction __unused *action) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey: STANFORD_STATUS_KEY];
                [APH23AndMeService tryReschedule23andmeTask];
            }];
        }
        
        APCLogEventWithData(@"23andmeStatusCheck", (@{@"status": statusDetails.status,
                                                      @"message" : statusDetails.message ? statusDetails.message : @"",
                                                      @"daration" : [NSString stringWithFormat:@"%f", duration]}));
        
        
    }];
    
}

+(void) startPeriodicStatusChecks {
    NSString *stanfordStatusKey = [[NSUserDefaults standardUserDefaults] objectForKey: STANFORD_STATUS_KEY];
    
    if (!stanfordStatusKey) {
        return;
    }
    
    if (timer) {
        return;
    }
    
    APH23AndMeService *service = [APH23AndMeService createWith23andmeToken:@"" refreshToken:@""];
    
    timer = [NSTimer timerWithTimeInterval: CHECK_STATUS_INTERVAL
                                    target: service
                                  selector: @selector(checkStatus)
                                  userInfo: nil
                                   repeats: YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
}

+(void) stopPeriodicStatusChecks {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

+(void)notifyUserWithMessage:(NSString*) message withAction:(void (^)(UIAlertAction *action))action {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"23andMe Integration"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:action];
        
        [alert addAction:defaultAction];
        [alert show];
        
    });
}

+(void) tryReschedule23andmeTask {
    NSPredicate *taskPredicate = [NSPredicate predicateWithFormat: @"%K contains %@",
                                  NSStringFromSelector(@selector(taskClassName)),
                                  NSStringFromClass([APH23andmeTask class])];
    
    NSDate *today = [NSDate date];
    [[APCScheduler defaultScheduler] fetchTaskGroupsFromDate: today
                                                      toDate: today
                                      forTasksMatchingFilter: taskPredicate
                                                  usingQueue: [NSOperationQueue mainQueue]
                                             toReportResults: ^(NSDictionary *todays23andmetasks, NSError * __unused queryError)
     {
         if(todays23andmetasks.count == 0) {
             [APH23AndMeService reschedule23andmeTask:taskPredicate];
         }
         
     }];
}

+(void) reschedule23andmeTask:(NSPredicate*) taskPredicate {
    APCTask *twentyThreeTask = [self find23andmeTask:taskPredicate];
    
    if (twentyThreeTask)
    {
        APCAppDelegate *appDelegate = (APCAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = appDelegate.scheduler.managedObjectContext;
        
        NSDate *today = [NSDate date];
        APCSchedule *schedule   = [APCSchedule newObjectForContext: context];
        schedule.scheduleSource = @(APCScheduleSourceAll);
        schedule.createdAt = today;
        schedule.scheduleType = @"once";
        schedule.startsOn = today.startOfDay;
        schedule.maxCount = nil;
        schedule.reminderOffset = nil;
        schedule.effectiveStartDate = [schedule computeDelayedStartDateFromDate: schedule.startsOn];
        schedule.effectiveEndDate = [schedule computeExpirationDateForScheduledDate: schedule.startsOn];
        [schedule addTasksObject:twentyThreeTask];
        
        BOOL saved = NO;
        NSError *errorSavingSchedule = nil;
        saved = [schedule saveToPersistentStore: &errorSavingSchedule];
        APCLogError2(errorSavingSchedule);
        
        if (saved && appDelegate.tabBarController.selectedIndex == 0) {
            [appDelegate showTabBar];
        }
        
        [appDelegate.scheduler clearTaskGroupCache];
    }
}

+(APCTask*) find23andmeTask:(NSPredicate*) taskPredicate {
    
    APCAppDelegate *appDelegate = (APCAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.scheduler.managedObjectContext;
    NSFetchRequest *request = [APCTask requestWithPredicate: taskPredicate];
    NSError *errorFetchingTasks = nil;
    NSArray *tasks = [context executeFetchRequest: request
                                            error: & errorFetchingTasks];
    APCLogError2(errorFetchingTasks);
    
    if  (tasks.count == 0){
        return nil;
    } else {
        
        NSArray *sortedTasksByVersion = [tasks sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *first = ((APCTask*) obj1).taskVersionNumber;
            NSNumber *second = ((APCTask*) obj2).taskVersionNumber;
            return [first compare:second];
            
        }];
        
        return [sortedTasksByVersion objectAtIndex:0];
    }
}
@end

@implementation APH23andmeProcessStatus

- (instancetype)initWithBridgeError: (NSError*) bridgeError
                      stanfordError: (NSError*) stanfordError
                     stanfordStatus: (APHStanfordDownloadGenomeResponse*) stanfordDownloadResponse {
    self = [super init];
    if (self) {
        _bridgeError = bridgeError;
        _stanfordError = stanfordError;
        _stanfordDownloadResponse = stanfordDownloadResponse;
    }
    return self;
}

-(BOOL) hasFailed {
    return _bridgeError || _stanfordError || [_stanfordDownloadResponse hasFailed];
}

-(BOOL) alreadyDownloaded {
    return [_stanfordDownloadResponse isComplete];
}

@end
