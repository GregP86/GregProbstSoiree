//
//  GGPCreateEventViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/9/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPCreateEventViewController.h"

@interface GGPCreateEventViewController (){
    BOOL startTimeEdited, endTimeEdited, passwordEdit, locationEdit, locationLoaded;
}


@end

@implementation GGPCreateEventViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    startTimeEdited = NO;
    endTimeEdited = NO;
    passwordEdit = NO;
    locationEdit = NO;
    locationLoaded = NO;
    [self.endTimePicker addTarget:self action:@selector(updateEndTime:) forControlEvents:UIControlEventValueChanged];
    [self.startTimePicker addTarget:self action:@selector(updateStartTime:) forControlEvents:UIControlEventValueChanged];
}

//Overload of origional method called eachtime cells are created
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2 && indexPath.row == 1){
        if(startTimeEdited){
            return 219;
        } else{
            return 0;
        }
    }else if(indexPath.section == 2 && indexPath.row == 3){
        if(endTimeEdited){
            return 219;
        } else{
            return 0;
        }
    }else if((indexPath.section == 3 && indexPath.row == 1) || (indexPath.section == 3 && indexPath.row == 2)){
        if(passwordEdit){
            return 45;
        }else{
            return 0;
        }
    }else if(indexPath.section == 1 && !indexPath.row == 0){
        if(locationEdit){
            return 45;
        }else{
            return 0;
        }
    }else{
        return self.tableView.rowHeight;
    }
}


//If selected row equals a date picker display date picker cell is resized accordingly
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2 && indexPath.row == 0){
        startTimeEdited = !startTimeEdited;
        endTimeEdited = NO;
        
    } else if(indexPath.section == 2 && indexPath.row == 2){
        endTimeEdited = !endTimeEdited;
        startTimeEdited = NO;
        
    }else{
        endTimeEdited = NO;
        startTimeEdited = NO;
    }
    [self reloadCellInSection:2 WithCell:1];
    [self reloadCellInSection:2 WithCell:3];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)privateSwitch:(id)sender {
    passwordEdit = self.isPrivate.on?YES:NO;
    endTimeEdited = NO;
    startTimeEdited = NO;
    [self reloadCellInSection:3 WithCell:1];
    [self reloadCellInSection:3 WithCell:2];
    [self reloadCellInSection:2 WithCell:1];
    [self reloadCellInSection:2 WithCell:3];
    
}

- (IBAction)locationSwitch:(id)sender {
    locationEdit = self.isLocationsOn.on?YES:NO;
    endTimeEdited = NO;
    startTimeEdited = NO;
    [self reloadCellInSection:1 WithCell:1];
    [self reloadCellInSection:1 WithCell:2];
    [self reloadCellInSection:1 WithCell:3];
    [self reloadCellInSection:1 WithCell:4];
    [self reloadCellInSection:1 WithCell:5];

    [self reloadCellInSection:2 WithCell:1];
    [self reloadCellInSection:2 WithCell:3];
}


- (IBAction)createEventButton:(id)sender{
    [self GenerateCoords];
//    GGPEvent *event = [self generateEvent];
//    if(passwordEdit){
//       event.password = [self.passwordField.text isEqualToString:self.confirmPasswordField.text]?self.passwordField.text : nil;
//    }else{
//        event.password = nil;
//    }
//    GGPLocation *location = locationEdit?[self generateLocation]:nil;
//    if(location){
//        PFObject *dbReadyLoc = location.getDBReadyObject;
//        event.location = dbReadyLoc;
//    }
//    
//    [event createOrUpdateOnDB];
    
    
}

-(GGPEvent *)generateEvent{
    GGPEvent *event = [[GGPEvent alloc]init];
    event.eventTitle = self.titleField.text;
    event.eventDescription = self.descriptionField.text;
    event.startTime = self.startTimePicker.date;
    event.endTime = self.endTimePicker.date;
    PFUser *user = [PFUser currentUser];
    event.creator = user.username;
    
    return event;
}

-(GGPLocation *)generateLocation{
    GGPLocation *location = [[GGPLocation alloc]init];
    location.locationName = self.locationNamField.text;
    location.streetAddress = self.streetAddressField.text;
    location.city = self.cityField.text;
    location.state = self.stateField.text;
    location.zip = self.zipField.text;
    
    location.latitude = self.coords.latitude;
    location.longitude = self.coords.longitude;

    return location;
}

-(void)GenerateCoords{
    CLGeocoder *geocoder= [[CLGeocoder alloc]init];
    NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@ %@", self.streetAddressField.text, self.cityField.text, self.stateField.text, self.zipField];
    
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            //TODO
        }
        if(placemarks && placemarks.count > 0){
            CLPlacemark *placemark = placemarks[0];
            CLLocation *location = placemark.location;
            self.coords = location.coordinate;
            
            GGPEvent *event = [self generateEvent];
            if(passwordEdit){
                event.password = [self.passwordField.text isEqualToString:self.confirmPasswordField.text]?self.passwordField.text : nil;
            }else{
                event.password = nil;
            }
            GGPLocation *ggplocation = locationEdit?[self generateLocation]:nil;
            if(location){
                PFObject *dbReadyLoc = ggplocation.getDBReadyObject;
                event.location = dbReadyLoc;
            }
            
            [event createOrUpdateOnDB];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)updateStartTime:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy 'at' HH:mm"];
    NSDate *pickerDate = self.startTimePicker.date;
    NSString *selectionString = [formatter stringFromDate:pickerDate];
    self.startTimeLabel.text = selectionString;
}

- (IBAction)updateEndTime:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy 'at' HH:mm"];
    NSDate *pickerDate = self.endTimePicker.date;
    NSString *selectionString = [formatter stringFromDate:pickerDate];
    self.endTimeLabel.text = selectionString;
}

-(void)reloadCellInSection: (int)section WithCell: (int)row{
    [UIView animateWithDuration:.4 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
}

-(void)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
