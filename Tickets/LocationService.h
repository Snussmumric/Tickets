//
//  LocationService.h
//  Tickets
//
//  Created by Антон Васильченко on 22.01.2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kLocationServiceDidUpdateCurrentLocation @"LocationServiceDidUpdateCurrentLocation"

@interface LocationService : NSObject <CLLocationManagerDelegate>
@end
