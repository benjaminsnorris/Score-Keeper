//
//  SKViewController.m
//  Score Keeper
//
//  Created by Ben Norris on 9/10/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "SKViewController.h"

int initialNumberOfScores = 4;
int currentNumberOfScores = 0;
static CGFloat const margin = 15;
static CGFloat scoreViewHeight = 100;

@interface SKViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Score Keeper";
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    [self initializeViews];
    
    // Deal with the nav bar buttons
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewScore)];
    self.navigationItem.rightBarButtonItem = addButton;
        
}

- (void)initializeViews {
    for (int i=0; i<initialNumberOfScores; i++) {
        [self addScoreView:i];
    }
}

- (void)addNewScore {
    [self addScoreView:currentNumberOfScores];
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetScores)];
    self.navigationItem.leftBarButtonItem = resetButton;

}

- (void)resetScores {
    // Reset all of the subviews of scrollView
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    currentNumberOfScores = 0;
    self.navigationItem.leftBarButtonItem = nil;
    [self initializeViews];
    
}

- (void)addScoreView:(int) theIndex {
    UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, scoreViewHeight * theIndex, self.view.frame.size.width, scoreViewHeight)];
    [self.scrollView addSubview:scoreView];
    scoreView.backgroundColor = [UIColor whiteColor];
    scoreView.layer.borderColor = [UIColor blackColor].CGColor;
    scoreView.layer.borderWidth = 1;
    
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, 125, scoreViewHeight)];
    nameField.placeholder = @"Name";
    nameField.delegate = self;
    [scoreView addSubview:nameField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin + 125, 0, 75, scoreViewHeight)];
    [scoreView addSubview:label];
    
    UIStepper *scoreStepper = [[UIStepper alloc] initWithFrame:CGRectMake(margin + 200, 35, 100, scoreViewHeight)];
    scoreStepper.minimumValue = -1000;
    scoreStepper.maximumValue = 1000;
    [scoreView addSubview:scoreStepper];
    
    label.text = [NSString stringWithFormat:@"%.0f",scoreStepper.value];
    
    // Calling this method is going to pass in the stepper—I want to understand this better!
    [scoreStepper addTarget:self action:@selector(updateScore:) forControlEvents:UIControlEventValueChanged];
    
    currentNumberOfScores++;
    
    // Increase the size of the scrollView to hold all of the views
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, currentNumberOfScores * scoreViewHeight);
}

- (void)updateScore:(UIStepper *) scoreStepperUpdating {
    
    // Superview is the scoreView, its subviews are: [0] UITextField, [1] UILabel, [2] UIStepper
    UILabel *scoreLabel = (UILabel *)scoreStepperUpdating.superview.subviews[1];
    // Update the label to the new value of the stepper
    scoreLabel.text = [NSString stringWithFormat:@"%.0f",scoreStepperUpdating.value];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
