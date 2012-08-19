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

- (void)refreshStream;

@end

@implementation StreamViewController

#pragma mark - Private Methods

- (void)refreshStream
{
    NSLog(@"REFRESHING STREAM WITH TOKEN = %@", [ADNManager sharedManager].accessToken);
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = PostCellIdentifier;
    
    PostCell *cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
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
         
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshStream)
                                                 name:ADNNotificationAccessTokenAcquired
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

@end
