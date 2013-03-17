//
//  ViewController.h
//  ReadJSON
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UITextView * textField;
}

-(IBAction)readFile:(id)sender;
-(IBAction)writeFile:(id)sender;

@end
