//
//  ADNManager.m
//  Appliance
//
//  Created by Felipe on 8/18/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "ADNManager.h"
#import "AppDelegate.h"
#import "AuthenticationViewController.h"

@implementation ADNManager

#pragma mark - Class Methods

+ (ADNManager *)sharedManager
{
    static dispatch_once_t predicate = 0;
    
    __strong static ADNManager *_sharedManager = nil;
    
    dispatch_once(&predicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - Properties

- (NSDictionary *)adnEndpoints
{
    if (!_adnEndpoints)
    {
        NSString *adnEndpointsPlistPath = [[NSBundle mainBundle] pathForResource:@"ADNEndpoints" ofType:@"plist"];
        _adnEndpoints = [NSDictionary dictionaryWithContentsOfFile:adnEndpointsPlistPath];
    }
    
    return _adnEndpoints;
}

@end
