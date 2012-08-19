//
//  ADNManager.h
//  Appliance
//
//  Created by Felipe on 8/18/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ADNEndpointsAuthenticationKey                               @"authentication"
    #define ADNEndpointsAuthenticationEndpoint                      @"endpoint"
    #define ADNEndpointsAuthenticationParameters                    @"parameters"
        #define ADNEndpointsAuthenticationParameterClientID         @"client_id"
        #define ADNEndpointsAuthenticationParameterResponseType     @"response_type"
        #define ADNEndpointsAuthenticationParameterRedirectURI      @"redirect_uri"
        #define ADNEndpointsAuthenticationParameterScope            @"scope"

#define ADNNotificationAccessTokenAcquired                          @"accessTokenAcquired"

@interface ADNManager : NSObject

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSDictionary *adnEndpoints;

+ (ADNManager *)sharedManager;

@end
