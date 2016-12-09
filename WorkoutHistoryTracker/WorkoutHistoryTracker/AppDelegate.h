//
//  AppDelegate.h
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/8/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

