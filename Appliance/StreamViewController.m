//
//  StreamViewController.m
//  Appliance
//
//  Created by Felipe on 8/18/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "ADNManager.h"
#import "AuthenticationViewController.h"
#import "PostCell.h"
#import "StreamViewController.h"

@interface StreamViewController ()

@property (strong, nonatomic) NSArray *streamArray;

- (void)refreshStream;

@end

@implementation StreamViewController

#pragma mark - Private Methods

- (void)refreshStream
{    
    NSDictionary *api = [[ADNManager sharedManager].adnEndpoints objectForKey:ADNEndpointsAPIKey];
    NSDictionary *post = [[ADNManager sharedManager].adnEndpoints objectForKey:ADNEndpointsPostKey];
    
    NSString *userStreamEndpoint = [NSString stringWithFormat:@"%@%@", [api objectForKey:ADNEndpointsAPIEndpoint],
                                                                       [post objectForKey:ADNEndpointsPostUserStream]];
    NSString *userStreamParameters = [NSString stringWithFormat:@"%@=%@", [api objectForKey:ADNEndpointsAPIAccessToken], [ADNManager sharedManager].accessToken];
    NSString *userStreamURL = [NSString stringWithFormat:@"%@?%@", userStreamEndpoint, userStreamParameters];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:userStreamURL]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:[[api objectForKey:ADNEndpointsAPITimeoutInterval] doubleValue]];
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response;
        NSError *error;
        
        NSData *userStreamData = [NSURLConnection sendSynchronousRequest:request
                                                       returningResponse:&response
                                                                   error:&error];
        
        if (error)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            self.streamArray = [NSJSONSerialization JSONObjectWithData:userStreamData options:NSJSONReadingMutableLeaves error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    });
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = PostCellIdentifier;
    
    PostCell *cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *post = [self.streamArray objectAtIndex:indexPath.row];
    NSDictionary *user = [post objectForKey:@"user"];
    
    cell.usernameLabel.text = [user objectForKey:@"username"];
    cell.postLabel.text = [post objectForKey:@"text"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.streamArray.count;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - View Lifecycle

- (void)didReceiveMemoryWarning
{
    if (![self.view window])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshStream)
                                                 name:ADNNotificationAccessTokenAcquired
                                               object:nil];
    
    if (![ADNManager sharedManager].accessToken)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:StoryboardMainStoryboard bundle:nil];
        
        AuthenticationViewController *authenticationViewController = [mainStoryboard instantiateViewControllerWithIdentifier:AuthenticationViewControllerIdentifier];
        
        [self presentModalViewController:authenticationViewController animated:YES];
    }
}

@end
