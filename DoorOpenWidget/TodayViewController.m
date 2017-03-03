//
//  TodayViewController.m
//  DoorOpenWidget
//
//  Created by Davide Ricci on 03/03/17.
//  Copyright © 2017 Davide Ricci. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIButton *mainButton;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mainButton addTarget:self action:@selector(callSimpleServer) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    completionHandler(NCUpdateResultNewData);
}

-(void) callSimpleServer {
    NSURL *url = [NSURL URLWithString:@"http://10.0.2.76?on?json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    
    [_mainButton setHidden:YES];
    [_mainButton setUserInteractionEnabled:NO];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         [_mainButton setHidden:NO];
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSString* result = [greeting objectForKey:@"status"];
             if ([result isEqualToString:@"open"])
                 [_mainButton setImage:[UIImage imageNamed:@"open_green"] forState:UIControlStateNormal];
             else
                 [_mainButton setImage:[UIImage imageNamed:@"open_red"] forState:UIControlStateNormal];
         } else {
             [_mainButton setImage:[UIImage imageNamed:@"open_red"] forState:UIControlStateNormal];
         }
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_mainButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
             [_mainButton setUserInteractionEnabled:YES];
         });
     }];
    
}

@end
