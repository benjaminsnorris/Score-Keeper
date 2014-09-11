//
//  SKViewController.m
//  Score Keeper
//
//  Created by Ben Norris on 9/10/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "SKViewController.h"

int myIndex = 0;
static CGFloat const margin = 15;
static CGFloat scoreViewHeight = 100;

@interface SKViewController ()

@property (nonatomic, strong) NSMutableArray *scoreLabels;

@end

@implementation SKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Score Keeper";
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:scrollView];
    
//    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.5);

//    UIView *view = [self createSubviewForViewController];
//    [scrollView addSubview:view];
    for (int i=0; i<4; i++) {
        [self addScoreView:i toView:scrollView];
    }
}

- (void)addScoreView:(int) theIndex toView:(UIView *) addToView {
    UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, scoreViewHeight * theIndex, self.view.frame.size.width, scoreViewHeight)];
    [addToView addSubview:scoreView];
    scoreView.backgroundColor = [UIColor whiteColor];
    scoreView.layer.borderColor = [UIColor blackColor].CGColor;
    scoreView.layer.borderWidth = 1;
    
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, 125, scoreViewHeight)];
    nameField.placeholder = @"Name";
    [scoreView addSubview:nameField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin + 125, 0, 75, scoreViewHeight)];
    [scoreView addSubview:label];
    
    UIStepper *scoreStepper = [[UIStepper alloc] initWithFrame:CGRectMake(margin + 200, 35, 100, scoreViewHeight)];
    scoreStepper.minimumValue = -1000;
    scoreStepper.maximumValue = 1000;
    [scoreView addSubview:scoreStepper];
    
    label.text = [NSString stringWithFormat:@"%.0f",scoreStepper.value];
}

- (UIView *)createSubviewForViewController {
    
    
    UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 100)];
    scoreView.backgroundColor = [UIColor greenColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
    label.text = @"Change me";
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 10, 200, 50)];
    [button setTitle:@"Click to change text" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(changeLabelText:label:) forControlEvents:UIControlEventTouchUpInside];
    
    [scoreView addSubview:label];
    [scoreView addSubview:button];
    
    return scoreView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
