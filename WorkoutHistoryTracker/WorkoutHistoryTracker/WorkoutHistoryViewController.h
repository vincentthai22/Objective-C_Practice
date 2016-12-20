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
@property (nonatomic, strong) NSMutableArray * tableData;
@property (nonatomic, strong) NSMutableArray * buttonData;
@property (nonatomic, strong) NSMutableArray * workoutData;


//array of images
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray * urlArray;
@property (nonatomic, strong) NSArray * largeURLArray;

//image data holder from URL
@property (nonatomic, strong) NSData *imageDataFromURL;

//queue used for background thread
@property (nonatomic, strong) dispatch_queue_t queue;

//cache object
@property (nonatomic, strong) NSCache *imageCache;

//index value holders
@property (nonatomic) NSUInteger buttonSectionIndex;
@property (nonatomic) NSUInteger workoutSectionIndex;

//instance of WorkoutDayManagedObject used to get and set data into the array
@property (nonatomic, strong)  WorkoutDayManagedObject *workoutDay;

//AlertBox -- new entry
@property (nonatomic, strong) UIAlertController *addNewEntryAlert;

//AlertBox -- randomize pictures
@property (nonatomic, strong) UIAlertController *randomizeImagesAlert;

//index path variable used when editing the table.
@property (nonatomic, strong) NSIndexPath *_indexPath;

//Boolean expression which handles whether the alertbox is going to execute a new entry or edit an existing one.
@property (nonatomic) BOOL *isEditingTable;

@end

