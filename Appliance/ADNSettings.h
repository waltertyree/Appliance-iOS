//
//  ADNSettings.h
//  Appliance
//
//  Created by Felipe on 8/18/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#ifndef Appliance_ADNSettings_h
#define Appliance_ADNSettings_h

#define DeviceIsPad                 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define DeviceIsPhone               ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define StoryboardMainStoryboard    DeviceIsPhone ? @"MainStoryboard_iPhone" : @""

#endif
