//
//  ContentViewController.h
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWebView.h>

@interface ContentViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) NSString * template;

@end

