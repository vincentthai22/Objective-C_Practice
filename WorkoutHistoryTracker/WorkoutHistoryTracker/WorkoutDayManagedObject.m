//
//  WorkoutDayManagedObject.m
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/13/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//

#import "WorkoutDayManagedObject.h"

@implementation WorkoutDayManagedObject

+ (NSFetchRequest<WorkoutDayManagedObject *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"WorkoutDay"];
}

@dynamic benchPress;
@dynamic date;
@dynamic deadLift;
@dynamic squatPress;
@dynamic weight;
@dynamic icon;
@dynamic imageURL;

@end
