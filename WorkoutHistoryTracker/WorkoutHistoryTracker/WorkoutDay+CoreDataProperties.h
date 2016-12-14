//
//  WorkoutDay+CoreDataProperties.h
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/13/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "WorkoutDay+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WorkoutDay (CoreDataProperties)

+ (NSFetchRequest<WorkoutDay *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *benchPress;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *deadLift;
@property (nullable, nonatomic, copy) NSString *squatPress;
@property (nullable, nonatomic, copy) NSString *weight;

@end

NS_ASSUME_NONNULL_END
