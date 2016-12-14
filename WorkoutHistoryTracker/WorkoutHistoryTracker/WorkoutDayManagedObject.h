//
//  WorkoutDayManagedObject.h
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/13/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WorkoutDayManagedObject : NSManagedObject

+  (NSFetchRequest<WorkoutDayManagedObject *> * _Nonnull) fetchRequest;

@property (nullable, nonatomic, copy) NSString *benchPress;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *deadLift;
@property (nullable, nonatomic, copy) NSString *squatPress;
@property (nullable, nonatomic, copy) NSString *weight;
@property (nullable, nonatomic, copy) NSData *icon;

@end
