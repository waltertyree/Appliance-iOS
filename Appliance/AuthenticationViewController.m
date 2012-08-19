//
//  AuthenticationViewController.m
//  Appliance
//
//  Created by Felipe on 8/18/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "ADNManager.h"
#import "AuthenticationViewController.h"

@interface AuthenticationViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)cancelTapped;

@end

@implementation AuthenticationViewController

#pragma mark - IBActions

- (IBAction)cancelTapped
{
    [self.webView stopLoading];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ADNManager *adnManager = [ADNManager sharedManager];
    
    NSDictionary *authentication= [adnManager.adnEndpoints objectForKey:ADNEndpointsAuthenticationKey];
    NSDictionary *parameters = [authentication objectForKey:ADNEndpointsAuthenticationParameters];
    
    NSMutableString *parametersString = [NSMutableString stringWithString:@""];
    
    NSArray *keys = [parameters.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (int i = 0; i < keys.count; i++)
    {
        NSString *key = [keys objectAtIndex:i];
        
        [parametersString appendFormat:@"%@=%@", key, [parameters objectForKey:key]];
        
        if (i < (keys.count - 1))
        {
            [parametersString appendString:@"&"];
        }
    }
    
    NSString *endpoint = [authentication objectForKey:ADNEndpointsAuthenticationEndpoint];
    NSString *requestString = [NSString stringWithFormat:@"%@?%@", endpoint, [NSString stringWithString:parametersString]];
    
    NSURL *requestURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:requestURL];
    [request setTimeoutInterval:30];
    
    [self.webView loadRequest:request];
}

#pragma mark - Web View Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSArray *components = [request.URL.absoluteString componentsSeparatedByString:@"#"];
        
    if (components.count > 0)
    {
        NSString *parameters = [components lastObject];
        
        components = [parameters componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *requestResults = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < components.count; i++)
        {
            NSArray *keyValuePair = [[components objectAtIndex:i] componentsSeparatedByString:@"="];
            
            if (keyValuePair.count == 2)
            {
                NSString *key = [keyValuePair objectAtIndex:0];
                NSString *value = [keyValuePair lastObject];
                
                [requestResults setObject:value forKey:key];
            }
        }
                
        if ([requestResults objectForKey:@"access_token"])
        {
            NSString *accessToken = [requestResults objectForKey:@"access_token"];
            
            [ADNManager sharedManager].accessToken = accessToken;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ADNNotificationAccessTokenAcquired object:nil];
        
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if ([requestResults objectForKey:@"error"])
        {
            NSString *errorType = [requestResults objectForKey:@"error"];
            
            if ([errorType isEqualToString:@"access_denied"])
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                    message:@"There was an error during login. Please try again later."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }];
        }
    }
    
    return YES;
}

@end
