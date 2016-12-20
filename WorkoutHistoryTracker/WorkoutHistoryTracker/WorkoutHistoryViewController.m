//
//  ViewController.m
//  WorkoutHistoryTracker
//
//  Created by Vincent on 12/8/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//
//  Current task : Thread management with large image, save URL and instead of the binary data and load the image only when necessary.

#import "WorkoutHistoryViewController.h"
#import "DataTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "WorkoutDayManagedObject.h"
#import "WorkoutHistoryCoreData.h"
#import <Foundation/Foundation.h>

@implementation WorkoutHistoryViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //initiation of arrays and more.
    self.imageCache = [[NSCache alloc]init];
    self.imageDataFromURL = [[NSData alloc] init];
    self.workoutHistoryCoreData = [WorkoutHistoryCoreData sharedWorkoutHistoryData];
    //self.imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cartoonguy"], [UIImage imageNamed:@"deadlift"], [UIImage imageNamed:@"benchpress"], [UIImage imageNamed:@"squat"], [UIImage imageNamed:@"snatch"], nil];
    self.urlArray = [NSArray arrayWithObjects: @"http://previews.123rf.com/images/nikdoorg/nikdoorg1401/nikdoorg140100014/25118481-Bench-Press-Icon-Stock-Vector.jpg",@"http://previews.123rf.com/images/dolimac/dolimac1511/dolimac151100003/48040026-Vector-cartoon-clip-art-illustration-of-a-tough-mean-weightlifting-beast-man-mascot-with-werewolf-an-Stock-Vector.jpg",@"http://www.toonpool.com/user/6491/files/dead_lift_1646445.jpg",nil];
    self.largeURLArray = [NSArray arrayWithObjects:@"http://spektyr.com/PrintImages/Cerulean%20Cross%203%20Large.jpg",@"http://eskipaper.com/images/large-2.jpg",@"https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg", nil];
    self.tableData = [[NSMutableArray alloc] initWithCapacity:2]; // 2-D Max.
    self.workoutData = [self.workoutHistoryCoreData fetchRequest]; //fetch data CoreData instance
    self.buttonData = [[NSMutableArray alloc]initWithObjects:@"button", nil];    //initialize with size 1 to show only one cell for the button section.
    self.buttonSectionIndex = self.tableData.count; //index = 0
    [self.tableData insertObject:self.buttonData atIndex:0];
    self.workoutSectionIndex = self.tableData.count; //index = 1
    [self.tableData insertObject:self.workoutData atIndex:1];
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    [self setUpAlertControllers];
    
}

/*
 *  Function : setUpAlertController -- initializes placeholders, titles, and buttons of alertbox
 */

- (void) setUpAlertControllers {
    
    self.addNewEntryAlert = [UIAlertController alertControllerWithTitle:@"Enter a New Workout" message:@"Enter Workout Info Below" preferredStyle:UIAlertControllerStyleAlert];
    [self.addNewEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
       textField.placeholder = @"Date";
    }];
    [self.addNewEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Weight";
    }];
    [self.addNewEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
       textField.placeholder = @"Bench";
    }];
    [self.addNewEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Deadlift";
    }];
    [self.addNewEntryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Squat";
    }];
    
    
    self.randomizeImagesAlert = [UIAlertController alertControllerWithTitle:@"Randomize Images" message:@"Large or small sized images?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionLargeImages = [UIAlertAction actionWithTitle:@"Large" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    //OK button handler
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        if(self.isEditingTable)
            self.workoutDay = self.tableData[self.workoutSectionIndex][self._indexPath.row]; //set the instance of WorkoutDayManagedObject to the instance that is being edited
        else//new entry
            self.workoutDay = self.workoutHistoryCoreData.getNewWorkoutDay;
        
        //read textfields
        self.workoutDay.date = self.addNewEntryAlert.textFields.firstObject.text;
        self.workoutDay.weight = self.addNewEntryAlert.textFields[1].text;
        self.workoutDay.benchPress = self.addNewEntryAlert.textFields[2].text;
        self.workoutDay.deadLift = self.addNewEntryAlert.textFields[3].text;
        self.workoutDay.squatPress = self.addNewEntryAlert.textFields[4].text;
        
        if ([self.workoutDay.date  isEqual: @""]) //left blank
            self.workoutDay.date = [NSDateFormatter localizedStringFromDate: [NSDate date]  dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]; //get current date
        
        if (self.isEditingTable){
            
            NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow: self._indexPath.row inSection:self._indexPath.section]];
            self.tableData[self.workoutSectionIndex][self._indexPath.row] = self.workoutDay;
            [[self tableView] reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationFade];
            
        } else { //inserting new entry
            
            NSString *temp = self.largeURLArray[arc4random_uniform((uint32_t)self.largeURLArray.count)];  //get random url
            self.workoutDay.imageURL = temp;

            NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow: [self.tableData[self.workoutSectionIndex] count] inSection:self.workoutSectionIndex]]; //set path for insertion.
            [self.tableData[self.workoutSectionIndex] addObject:self.workoutDay];
            [self.workoutHistoryCoreData insert: self.workoutDay];
            [[self tableView ] insertRowsAtIndexPaths:path withRowAnimation: UITableViewRowAnimationTop];
            
        }
        
        //reset boolean exp
        self.isEditingTable = false;
        for(UITextView *textField in self.addNewEntryAlert.textFields) //clear textfields
            textField.text = @"";
        [self.workoutHistoryCoreData save]; //save changes
        
    }];//end of OK button handler
    
    
    //cancel button handler.
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        for(UITextView *textField in self.addNewEntryAlert.textFields)
            textField.text =@"";
    }];
    //end cancel button handler
    [self.randomizeImagesAlert addAction:actionLargeImages];
    [self.addNewEntryAlert addAction:actionOK];
    [self.addNewEntryAlert addAction:actionCancel];
}
/*
 *  Function: addButtonHandler -- handles the functionality of the add button.
 */
- (IBAction)addButtonHandler:(UIButton *)sender {
    self.addNewEntryAlert.title = @"Enter New Workout";
    [self presentViewController:self.addNewEntryAlert animated:true completion:nil];
}
- (IBAction)diceButtonHandler:(UIButton *)sender {
    
}

/*
 *  Function: viewForHeaderInSection -- overridden function of it's superclass UITableVewController to display a view as the header of each section.
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 150, 50)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 50)];
    [view setBackgroundColor: [UIColor groupTableViewBackgroundColor]];
    
    if(section == self.buttonSectionIndex) {
            label.text = @"New Entry";
            [view addSubview:label];
            return view;
    } else {
            label.text =  @"Workout History";
            [view addSubview:label];
            return view;
    }
    return view;
}
/*
 * Function didReceiveMemoryWarning -- overridden function that handles the case of low memory availability.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.imageCache removeAllObjects];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

/*
 *      Edit table view
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.workoutSectionIndex) {
        WorkoutDayManagedObject *workDay = self.tableData[self.workoutSectionIndex][indexPath.row];
        int index = 0;
        
        for(UITextField *textField in self.addNewEntryAlert.textFields){    //set textfields to the selected cell's data.
            if(index == 0) //date textfield
                textField.text = workDay.date;
            else if (index == 1) //weight textfield
                textField.text = workDay.weight;
            else if (index == 2) //bench textfield
                textField.text = workDay.benchPress;
            else if (index == 3) //deadlift textfield
                textField.text = workDay.deadLift;
            else                //squat textfield
                textField.text = workDay.squatPress;
            index++;
        }
    
    self.isEditingTable = (BOOL*)true;
    self._indexPath = indexPath;
    self.addNewEntryAlert.title = @"Editing Workout Day";
    [self presentViewController:self.addNewEntryAlert animated:true completion:nil];
        
    }
}
/*
 *  Delete cell from tableview
 */

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == self.workoutSectionIndex) {
            [[self imageCache] removeObjectForKey:indexPath];   
            [self.workoutHistoryCoreData remove : self.tableData[self.workoutSectionIndex][indexPath.row]];
            [self.tableData[self.workoutSectionIndex] removeObjectAtIndex:indexPath.row];
            [self.workoutHistoryCoreData save];
            NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
            [[self tableView] deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationLeft];
            
        }//end inner if
    } //end outer if.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == self.buttonSectionIndex) {
        return [self.tableData[self.buttonSectionIndex] count];
    } else {
        return [self.tableData[self.workoutSectionIndex] count];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == self.workoutSectionIndex)
        return 110;
    return 78;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}
/*
 *  Function : willDisplayCell -- only binds data to visible cells.
 */
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DataTableViewCell *tempCell = (DataTableViewCell*) cell;
    
    if (indexPath.section == self.workoutSectionIndex) {
        
        self.workoutDay = [self.tableData[self.workoutSectionIndex] objectAtIndex: indexPath.row];
        tempCell.weightLabel.text = self.workoutDay.weight;
        tempCell.dateLabel.text = self.workoutDay.date;
        tempCell.benchLabel.text = self.workoutDay.benchPress;
        tempCell.deadliftLabel.text = self.workoutDay.deadLift;
        tempCell.squatLabel.text = self.workoutDay.squatPress;
        
        dispatch_async(self.queue, ^{
            
            UIImage *image;
            NSURL *url = [NSURL URLWithString: self.workoutDay.imageURL];
            
            //self.imageDataFromURL = [NSData dataWithContentsOfURL:url];     //pull data from url

            if ([self.imageCache objectForKey:indexPath] == nil) {   // not inside cache
                
                self.imageDataFromURL = [NSData dataWithContentsOfURL:url];//pull data from url
                image = [UIImage imageWithData:self.imageDataFromURL];
                if(image != nil)
                    [self.imageCache setObject:image forKey:indexPath];  //place into cache
                
            } else { // already in cache
                
                image = [self.imageCache objectForKey:indexPath];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                tempCell.iconImageView.image = image;
                
            }); //end of inner dispatch_sync
            
        }); //end of outer dispatch_async
    }
}

/*
 *  Function: cellForRowAtIndexPath -- determines what type of cell to load for each section.
 */
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier;
    UITableViewCell *cell;
    
    if (indexPath.section == self.buttonSectionIndex){
        
        cellIdentifier = @"ButtonTableViewCell";
        cell = (ButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) { //empty case set cell to default UITableViewCell
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        return cell;
        
    } else {
        
        cellIdentifier= @"DataTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) { //empty case set cell to default UITableViewCell
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        return cell;
    }
}

@end
