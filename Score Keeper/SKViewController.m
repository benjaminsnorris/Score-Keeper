//
//  SKViewController.m
//  Score Keeper
//
//  Created by Ben Norris on 9/10/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "SKViewController.h"

// This is cleaner because it is a compile-time directive
#define initialNumberOfScores 2
#define margin 15.0
#define scoreViewHeight 100.0

@interface SKViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIBarButtonItem *resetButton;
@property (nonatomic, assign) NSInteger currentNumberOfScores;
@property (nonatomic, strong) UITextField *activeField;

@end

@implementation SKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentNumberOfScores = 0;

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Score Keeper";
    
    // QUESITON: If I set the y to be navAndStatusBarHeight, the scrollView is offset down, but I don't know why
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor grayColor];
    
    self.scrollView.alwaysBounceVertical = YES;
    
    [self initializeViews];
    
    // Listen for the keyboard to show up
    [self registerForKeyboardNotifications];
    // Could dismiss the keyboard when you drag
//    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Add the add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewScore)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Initialize the reset button
    self.resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetScores)];
}

- (void)initializeViews {
    for (NSInteger i=0; i<initialNumberOfScores; i++) {
        [self addScoreView:i];
    }
}

- (void)addNewScore {
    [self addScoreView:self.currentNumberOfScores];
    
    // Set the rest button to be the left button of the nav bar
    self.navigationItem.leftBarButtonItem = self.resetButton;
}

- (void)resetScores {
    // Reset all of the subviews of scrollView
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    self.currentNumberOfScores = 0;
    self.navigationItem.leftBarButtonItem = nil;
    [self initializeViews];
    
}

- (void)addScoreView:(NSInteger) theIndex {
    UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, scoreViewHeight * theIndex + self.currentNumberOfScores, self.view.frame.size.width, scoreViewHeight)];
    [self.scrollView addSubview:scoreView];
    scoreView.backgroundColor = [UIColor whiteColor];
    
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, 125, scoreViewHeight)];
    nameField.placeholder = @"Name";
    nameField.delegate = self;
    // Show clear button while editing
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nameField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
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
    
    self.currentNumberOfScores++;
    
    // Increase the size of the scrollView to hold all of the views
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.currentNumberOfScores * scoreViewHeight + self.currentNumberOfScores);
}

- (void)updateScore:(UIStepper *) scoreStepperUpdating {
    
    // Superview is the scoreView, its subviews are: [0] UITextField, [1] UILabel, [2] UIStepper
    UILabel *scoreLabel = (UILabel *)scoreStepperUpdating.superview.subviews[1];
    // Update the label to the new value of the stepper
    scoreLabel.text = [NSString stringWithFormat:@"%.0f",scoreStepperUpdating.value];
    self.navigationItem.leftBarButtonItem = self.resetButton;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Track the active field so we can make sure it is visible
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Done typing, so no more active field
    self.activeField = nil;
}

- (void)textFieldDidChange {
    // Add the reset button as soon as you start typing a name
    self.navigationItem.leftBarButtonItem = self.resetButton;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // This dismisses the keyboard
    [textField resignFirstResponder];
    return YES;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown: (NSNotification*) aNotification {
    // Get the notification and parse out the keyboard size
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Inset the bottom of the scrollView to the size of the keyboard
    UIEdgeInsets contentInsets = UIEdgeInsetsMake([self navAndStatusBarHeight], 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if(!CGRectContainsRect(aRect, self.activeField.frame)) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden: (NSNotification*) aNotification {
    // Reset the scrollView to be in the original place
    // QUESTION: If I use UIEdgeInsetsZero here, the scrollView is at the top of the window. Why is this different than when initializing it?
    UIEdgeInsets contentInsets = UIEdgeInsetsMake([self navAndStatusBarHeight], 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (CGFloat)navAndStatusBarHeight {
    return self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
