//
//  WorkoutHistoryCoreData.m
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/13/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//

#import "WorkoutHistoryCoreData.h"

@implementation WorkoutHistoryCoreData

AppDelegate *appDelegate;
NSManagedObjectContext *managedContext;
NSEntityDescription *entity;


+ (id) sharedWorkoutHistoryData {
    static WorkoutHistoryCoreData *sharedWorkoutHistoryCoreData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWorkoutHistoryCoreData = [[self alloc] init];
    });
    return sharedWorkoutHistoryCoreData;
}

- (instancetype) init
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    managedContext = [[appDelegate persistentContainer] viewContext];
    entity = [NSEntityDescription entityForName:@"WorkoutDay" inManagedObjectContext:managedContext];
    return self;
}
- (NSMutableArray*) fetchRequest {
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest <WorkoutDayManagedObject *> fetchRequestWithEntityName:@"WorkoutDay"];
    
    return (NSMutableArray *)[[managedContext executeFetchRequest:request error:&error] mutableCopy];
}
- (void) remove : (WorkoutDayManagedObject *) workoutDay{
    [managedContext deleteObject:workoutDay];
    
    [self save];
}
- (WorkoutDayManagedObject*) getNewWorkoutDay {
    return [[WorkoutDayManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
}

- (void) save {
    NSError *error = nil;
    if ([managedContext save:&error] == false){
        NSAssert(NO, @"Error in saving", [error localizedDescription], [error userInfo]);
    }
}
@end
