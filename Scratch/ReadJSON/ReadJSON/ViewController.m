//
//  ViewController.m
//  ReadJSON
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "ViewController.h"
#import "NewsDataFactory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)readFile:(id)sender {
    [[[NewsDataFactory alloc] init ]test];
}

-(IBAction)writeFile:(id)sender {
    
}

@end
