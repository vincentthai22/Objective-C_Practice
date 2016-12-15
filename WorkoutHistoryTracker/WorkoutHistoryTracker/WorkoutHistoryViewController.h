//
//  ViewController.h
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/8/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "WorkoutHistoryCoreData.h"

@interface WorkoutHistoryViewController : UITableViewController
//Singleton Coredata object
@property WorkoutHistoryCoreData *workoutHistoryCoreData;

//Arrays which represent the UITableView data.
@property (nonatomic) NSMutableArray *tableData;
@property (nonatomic) NSMutableArray * buttonData;
@property (nonatomic) NSMutableArray * workoutData;

//array of images
@property (nonatomic) NSArray *imageArray;

//cache object
@property NSCache *imageCache;

//index value holders
@property (nonatomic) NSUInteger buttonSectionIndex;
@property (nonatomic) NSUInteger workoutSectionIndex;

//instance of WorkoutDayManagedObject used to get and set data into the array
@property (nonatomic)  WorkoutDayManagedObject *workoutDay;

//AlertBox
@property (nonatomic) UIAlertController *addNewEntryAlert;

//index path variable used when editing the table.
@property (nonatomic) NSIndexPath *_indexPath;

//Boolean expression which handles whether the alertbox is going to execute a new entry or edit an existing one.
@property (nonatomic) BOOL *isEditingTable;


@end

