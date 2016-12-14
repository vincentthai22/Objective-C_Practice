//
//  WorkoutHistoryCoreData.h
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/13/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "WorkoutDayManagedObject.h"

@interface WorkoutHistoryCoreData : NSObject
-(NSMutableArray*) fetchRequest;
-(WorkoutDayManagedObject*) getNewWorkoutDay;
-(void) remove : WorkoutDayManagedObject;
-(void) save;
@end
