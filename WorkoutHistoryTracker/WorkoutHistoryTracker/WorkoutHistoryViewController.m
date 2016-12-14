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
    workoutHistoryCoreData = [[WorkoutHistoryCoreData alloc] init];
    workoutDay = workoutHistoryCoreData.getNewWorkoutDay;
    tableData = [[NSMutableArray alloc] initWithCapacity:2];
    workoutData =  [workoutHistoryCoreData fetchRequest];
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
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        workoutDay.date = newEntryAlert.textFields.firstObject.text;
        workoutDay.weight = newEntryAlert.textFields[1].text;
        workoutDay.benchPress = newEntryAlert.textFields[2].text;
        workoutDay.deadLift = newEntryAlert.textFields[3].text;
        workoutDay.squatPress = newEntryAlert.textFields[4].text;
        if (isEditingTable){
            NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow: _indexPath.row inSection:_indexPath.section]];
            tableData[workoutSectionIndex][_indexPath.row] = workoutDay;
            [[self tableView] reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationFade];
        }
        else{
            NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow: [tableData[workoutSectionIndex] count] inSection:workoutSectionIndex]];
            [tableData[workoutSectionIndex] addObject:workoutDay];
            [[self tableView ] insertRowsAtIndexPaths:path withRowAnimation: UITableViewRowAnimationTop];
        }
        //NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow: [tableData[workoutSectionIndex] count] -1 inSection:workoutSectionIndex]];
        //[[self tableView ] insertRowsAtIndexPaths:path withRowAnimation: UITableViewRowAnimationTop];
        isEditingTable = false;
        for(UITextView *textField in newEntryAlert.textFields)
            textField.text = @"";
        [workoutHistoryCoreData save];
    }];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        for(UITextView *textField in newEntryAlert.textFields)
            textField.text =@"";
    }];
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
            WorkoutDayManagedObject *temp = tableData[workoutSectionIndex][indexPath.row];
            [workoutHistoryCoreData remove : temp];
            [tableData[workoutSectionIndex] removeObjectAtIndex:indexPath.row];
            //[workoutHistoryCoreData save];
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

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier;
    UITableViewCell *cell;
    switch ((int)indexPath.section){
        case 0 :
            cellIdentifier = @"ButtonTableViewCell";
            cell = (ButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            printf("%s", "inside case 0");
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                printf("%s", "inside case 0");
            }
            
            return cell;
        case 1:
            cellIdentifier= @"DataTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell == nil) {
                cell = (DataTableViewCell *) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            DataTableViewCell *tempCell = (DataTableViewCell*)cell;
            workoutDay = [tableData[workoutSectionIndex] objectAtIndex: indexPath.row];
            tempCell.weightLabel.text = workoutDay.weight;
            tempCell.dateLabel.text = workoutDay.date;
            tempCell.benchLabel.text = workoutDay.benchPress;
            tempCell.deadliftLabel.text = workoutDay.deadLift;
            tempCell.squatLabel.text = workoutDay.squatPress;
            
            return cell;
    }
    
    return cell;
}

@end
