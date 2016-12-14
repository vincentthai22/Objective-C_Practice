//
//  ViewController.m
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/8/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//

#import "WorkoutHistoryViewController.h"
#import "DataTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "WorkoutDayManagedObject.h"
#import "WorkoutHistoryCoreData.h"
#import <Foundation/Foundation.h>

@implementation WorkoutHistoryViewController

WorkoutHistoryCoreData *workoutHistoryCoreData;

NSMutableArray *tableData;
NSMutableArray * buttonData;
NSMutableArray * workoutData;

NSArray *imageArray;

NSCache *imageCache;

int buttonSectionIndex;
int workoutSectionIndex;

NSString *date, *weight, *deadlift, *squat, *bench;

WorkoutDayManagedObject *workoutDay;

UIAlertController *newEntryAlert;

NSIndexPath *_indexPath;

BOOL *isEditingTable;

- (void)viewDidLoad {

    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    imageCache = [[NSCache alloc]init];
    workoutHistoryCoreData = [WorkoutHistoryCoreData sharedWorkoutHistoryData];
    imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cartoonguy"], [UIImage imageNamed:@"deadlift"], [UIImage imageNamed:@"benchpress"], [UIImage imageNamed:@"squat"], [UIImage imageNamed:@"snatch"], nil];
    tableData = [[NSMutableArray alloc] initWithCapacity:2];
    workoutData = [workoutHistoryCoreData fetchRequest];//[[NSMutableArray alloc] init]; //
    buttonData = [[NSMutableArray alloc]initWithObjects:@"button", nil];
    buttonSectionIndex =   tableData.count;
    [tableData insertObject:buttonData atIndex:0];
    workoutSectionIndex =  tableData.count;
    [tableData insertObject:workoutData atIndex:1];
    printf("%s", "buttonsection index = ");
    printf("%i" ,buttonSectionIndex);
    printf ("%s", "\tworkoutsection index");
    [self setUpAlertControllers];
    
}



- (void) setUpAlertControllers {
    
    printf("%s", "we are setting up alert controllers now\n");
    newEntryAlert = [UIAlertController alertControllerWithTitle:@"Enter a New Workout" message:@"Enter Workout Info Below" preferredStyle:UIAlertControllerStyleAlert];
    [newEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
       textField.placeholder = @"Date";
    }];
    [newEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Weight";
    }];
    [newEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
       textField.placeholder = @"Bench";
    }];
    [newEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Deadlift";
    }];
    [newEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Squat";
    }];
    
    //OK button handler
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        if(isEditingTable)
            workoutDay = tableData[workoutSectionIndex][_indexPath.row];
        else
            workoutDay = workoutHistoryCoreData.getNewWorkoutDay;
        
        //read textfields
        workoutDay.date = newEntryAlert.textFields.firstObject.text;
        workoutDay.weight = newEntryAlert.textFields[1].text;
        workoutDay.benchPress = newEntryAlert.textFields[2].text;
        workoutDay.deadLift = newEntryAlert.textFields[3].text;
        workoutDay.squatPress = newEntryAlert.textFields[4].text;
        if ([workoutDay.date  isEqual: @""])
            workoutDay.date = [NSDateFormatter localizedStringFromDate: [NSDate date]  dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        if (isEditingTable){
            //workoutDay.icon = UIImagePNGRepresentation([[tableData[workoutSectionIndex][_indexPath.row] iconImageView] image]);
            NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow: _indexPath.row inSection:_indexPath.section]];
            tableData[workoutSectionIndex][_indexPath.row] = workoutDay;
            [[self tableView] reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationFade];
        }
        else { //inserting new entry
            workoutDay.icon = UIImagePNGRepresentation(imageArray[arc4random_uniform(imageArray.count)]);
            NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow: [tableData[workoutSectionIndex] count] inSection:workoutSectionIndex]];
            [tableData[workoutSectionIndex] addObject:workoutDay];
            [workoutHistoryCoreData insert: workoutDay];
            [[self tableView ] insertRowsAtIndexPaths:path withRowAnimation: UITableViewRowAnimationTop];
        }
        //NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow: [tableData[workoutSectionIndex] count] -1 inSection:workoutSectionIndex]];
        //[[self tableView ] insertRowsAtIndexPaths:path withRowAnimation: UITableViewRowAnimationTop];
        isEditingTable = false;
        for(UITextView *textField in newEntryAlert.textFields)
            textField.text = @"";
        [workoutHistoryCoreData save];
    }];
    //end of OK button handler
    
    //cancel button handler.
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        for(UITextView *textField in newEntryAlert.textFields)
            textField.text =@"";
    }];
    //end cancel button handler
    
    [newEntryAlert addAction:actionOK];
    [newEntryAlert addAction:actionCancel];
}

- (IBAction)addButtonHandler:(UIButton *)sender {
    newEntryAlert.title = @"Enter New Workout";
    [self presentViewController:newEntryAlert animated:true completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 150, 50)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 50)];
    [view setBackgroundColor: [UIColor groupTableViewBackgroundColor]];
    switch (section) {
        case 0:
            label.text = @"New Entry";
            [view addSubview:label];
            return view;
        case 1:
            label.text =  @"Workout History";
            [view addSubview:label];
            return view;
    }
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [imageCache removeAllObjects];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableData.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == workoutSectionIndex) {
        WorkoutDayManagedObject *workDay = tableData[workoutSectionIndex][indexPath.row];
        int index = 0;
        for(UITextField *textField in newEntryAlert.textFields){
            if(index == 0)
                textField.text = workDay.date;
            else if (index == 1)
                textField.text = workDay.weight;
            else if (index == 2)
                textField.text = workDay.benchPress;
            else if (index == 3)
                textField.text = workDay.deadLift;
            else
                textField.text = workDay.squatPress;
            index++;
        }
    
    isEditingTable = (BOOL*)true;
    _indexPath = indexPath;
    newEntryAlert.title = @"Editing Workout Day";
    [self presentViewController:newEntryAlert animated:true completion:nil];
    }
}


- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == workoutSectionIndex) {
            printf("%s", "Deleting if-statement accessed");
            printf("%lu", (unsigned long)[tableData[workoutSectionIndex] count]);
            printf("%li", (long)indexPath.row);
            NSLog(@"%@", NSStringFromClass([workoutData class]));
            [workoutHistoryCoreData remove : tableData[workoutSectionIndex][indexPath.row]];
            [tableData[workoutSectionIndex] removeObjectAtIndex:indexPath.row];
            [workoutHistoryCoreData save];
            NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
            [[self tableView] deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == buttonSectionIndex) {
        return [tableData[buttonSectionIndex] count];
    } else {
        return [tableData[workoutSectionIndex] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == workoutSectionIndex)
        return 110;
    return 78;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    DataTableViewCell *tempCell = (DataTableViewCell*) cell;
    
    if (indexPath.section == workoutSectionIndex) {
        
        workoutDay = [tableData[workoutSectionIndex] objectAtIndex: indexPath.row];
        tempCell.weightLabel.text = workoutDay.weight;
        tempCell.dateLabel.text = workoutDay.date;
        tempCell.benchLabel.text = workoutDay.benchPress;
        tempCell.deadliftLabel.text = workoutDay.deadLift;
        tempCell.squatLabel.text = workoutDay.squatPress;
        
        dispatch_async(queue, ^{
            UIImage *image;
          //  NSArray *path = [NSArray array]
            if ([imageCache objectForKey:indexPath] == nil) {           // not inside cache
                image = [UIImage imageWithData:workoutDay.icon];
                [imageCache setObject:image forKey:indexPath];          //place into cache
            } else { // already in cache
                image = [imageCache objectForKey:indexPath];
                printf("%s", "Cache accessed");
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                tempCell.iconImageView.image = image;
            });
            
        });
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier;
    UITableViewCell *cell;
    if (indexPath.section == buttonSectionIndex){
        cellIdentifier = @"ButtonTableViewCell";
        cell = (ButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        printf("%s", "inside case 0");
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            printf("%s", "inside case 0");
        }
        return cell;
    } else {
        cellIdentifier= @"DataTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        return cell;
    }
}

@end
