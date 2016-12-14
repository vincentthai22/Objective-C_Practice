//
//  WorkoutDay+CoreDataProperties.m
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/13/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "WorkoutDay+CoreDataProperties.h"

@implementation WorkoutDay (CoreDataProperties)

+ (NSFetchRequest<WorkoutDay *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WorkoutDay"];
}

@dynamic benchPress;
@dynamic date;
@dynamic deadLift;
@dynamic squatPress;
@dynamic weight;

@end
