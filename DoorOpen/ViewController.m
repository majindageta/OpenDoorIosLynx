//
//  ViewController.m
//  DoorOpen
//
//  Created by Davide Ricci on 27/02/17.
//  Copyright © 2017 Davide Ricci. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callSimpleServer)];
    [_mainButton addGestureRecognizer:tap];
    [_mainButton setUserInteractionEnabled:YES];
    [_indicator setHidden:YES];
    [_indicator startAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) callSimpleServer {
    NSURL *url = [NSURL URLWithString:@"http://10.0.2.76?on?json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [_indicator setHidden:NO];
    [_mainButton setHidden:YES];
    [_mainButton setUserInteractionEnabled:NO];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         [_mainButton setHidden:NO];
          [_indicator setHidden:YES];
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSString* result = [greeting objectForKey:@"status"];
             if ([result isEqualToString:@"open"])
                 [_mainButton setImage:[UIImage imageNamed:@"open_green"]];
             else
                 [_mainButton setImage:[UIImage imageNamed:@"open_red"]];
         } else {
             [_mainButton setImage:[UIImage imageNamed:@"open_red"]];
         }
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_mainButton setImage:[UIImage imageNamed:@"open"]];
              [_mainButton setUserInteractionEnabled:YES];
         });
     }];
    
}


@end
