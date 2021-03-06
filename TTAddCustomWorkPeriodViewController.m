//
//  TTAddCustomWorkPeriodViewController.m
//  Wired In
//
//  Created by Caleb Hicks on 6/9/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "TTAddCustomWorkPeriodViewController.h"
#import "CoreDataHelper.h"
#import "ProjectController.h"

@interface TTAddCustomWorkPeriodViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *finishTimePicker;
@property (weak, nonatomic) IBOutlet UIButton *addWorkPeriodButton;
@property (assign, nonatomic) NSTimeInterval maxDateBeforeNow;

@end

@implementation TTAddCustomWorkPeriodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.maxDateBeforeNow = -60;
//        [self.startTimePicker setMaximumDate:[NSDate date]];
//        [self.finishTimePicker setMaximumDate:[NSDate date]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.finishTimePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:self.maxDateBeforeNow];
    
    self.workPeriod = [NSEntityDescription insertNewObjectForEntityForName:@"WorkPeriod"
                                                    inManagedObjectContext:[[CoreDataHelper sharedInstance]managedObjectContext]];
    
    if (self.workPeriod.startTime) {
        [self.startTimePicker setDate:self.workPeriod.startTime animated:YES];
    }
    
    if (self.workPeriod.finishTime) {
        [self.finishTimePicker setDate:self.workPeriod.finishTime animated:YES];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTimePickerChanged:(id)sender {
    self.workPeriod.startTime = self.startTimePicker.date;
    self.workPeriod.finishTime = self.finishTimePicker.date;
    
    NSDate *finishTimeDate = [self.workPeriod.startTime dateByAddingTimeInterval:3600];
    
    [self.finishTimePicker setMinimumDate:self.workPeriod.startTime];
    [self.finishTimePicker setDate:finishTimeDate animated:YES];
}


- (IBAction)finishTimePickerChanged:(id)sender {
    self.workPeriod.finishTime = self.finishTimePicker.date;
    self.workPeriod.startTime = self.startTimePicker.date;
}

- (IBAction)addWorkPeriodButtonPressed:(id)sender {
    
    self.workPeriod.project = self.project;
    
    [self.project updateDuration];
    
    [[ProjectController sharedInstance]synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
