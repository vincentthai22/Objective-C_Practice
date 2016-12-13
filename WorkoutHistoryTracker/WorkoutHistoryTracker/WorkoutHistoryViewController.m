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
#import <Foundation/Foundation.h>
@interface WorkoutHistoryViewController ()

@end

@implementation WorkoutHistoryViewController

NSMutableArray *tableData;
NSMutableArray * buttonData;
NSMutableArray * workoutData;

int buttonSectionIndex;
int workoutSectionIndex;

UIAlertController *newEntryAlert;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    tableData = [[NSMutableArray alloc] init];
    workoutData = [[NSMutableArray alloc] init];
    buttonData = [[NSMutableArray alloc]initWithObjects:@"button", nil];
    buttonSectionIndex =  tableData.count;
    [tableData insertObject:buttonData atIndex:0];
    workoutSectionIndex =  tableData.count;
    [tableData insertObject:workoutData atIndex:1];
    printf("%s", "buttonsection index = ");
    printf("%i" ,buttonSectionIndex);
    printf ("%s", "\tworkoutsection index");
    printf( "%i", workoutSectionIndex, '\n');
    
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
        
    }];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [newEntryAlert addAction:actionOK];
    [newEntryAlert addAction:actionCancel];
}

- (IBAction)addButtonHandler:(UIButton *)sender {
    [self presentViewController:newEntryAlert animated:true completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 150, 50)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 50)  ];
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
    return 2;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == buttonSectionIndex) {
        return buttonData.count;
    } else {
        return workoutData.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
            cell = (DataTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell == nil) {
                cell = (DataTableViewCell *) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            ((DataTableViewCell *) cell ).workoutLabel.text = [workoutData objectAtIndex: indexPath.row];
            return cell;
    }
    
    return cell;
}

@end
