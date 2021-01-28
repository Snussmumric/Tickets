//
//  MapViewController.h
//  Tickets
//
//  Created by Антон Васильченко on 22.01.2021.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DataManager.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *cities;
//@property (assign) PlaceType type;
//@property (assign) UIViewController<PlaceViewControllerDelegate> *delegate;

@end
