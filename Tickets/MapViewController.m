//
//  MapViewController.m
//  Tickets
//
//  Created by Антон Васильченко on 22.01.2021.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "APIManager.h"
#import "DataManager.h"
#import "MapPrice.h"
#import "CoreDataHelper.h"
#import "APIManager.h"
#import "Ticket.h"



@interface MapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray<MapPrice*>* prices;
//@property (nonatomic, strong) MKPointAnnotation *annotation;
@property (nonatomic, strong) NSString * selectedTitle;
@property (nonatomic) SearchRequest searchRequest;
@property (nonatomic, strong) MapPrice *selectedPrice;
@property (nonatomic, weak, readwrite) NSNumber* indexSelectedMapPrice;




@end

@implementation MapViewController {
    BOOL isFavorites;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"map_price_header", "");
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}



- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
 
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@", price.destination.name];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [self->_mapView addAnnotation: annotation];
            [self->_mapView setDelegate:self];
            [self->_mapView viewForAnnotation:annotation];
        });
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSString *identifier = @"Map View";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    annotationView.canShowCallout = YES;
    annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
    
    UIButton *addToFavoriteButoon = [UIButton buttonWithType: UIButtonTypeContactAdd];
    annotationView.rightCalloutAccessoryView = addToFavoriteButoon;
    [addToFavoriteButoon addTarget: self action: @selector(addToFavorites) forControlEvents: UIControlEventTouchUpInside];
    
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"didSelectAnnotationView %@", view.annotation.description);
    
    NSUInteger index = [mapView.annotations indexOfObject:view.annotation];
    NSLog(@"index no %lu",(unsigned long)index);
    NSLog(@"City %@ - price %ld", self.prices[index].destination, (long)self.prices[index].value);
    
    NSString * selectedTitle = [NSString stringWithFormat:@"%@",view.annotation.title];
    
    for (int i = 0; i < self.prices.count; i++) {
        MapPrice* price = self.prices[i];
//        i=330;
        City* city = price.destination;
        if ([city.name isEqualToString: selectedTitle]) {
            NSLog(@"You selected index: %d and City: %@", i , self.prices[i].destination.name);
            self.indexSelectedMapPrice = [NSNumber numberWithInt: i];
        }
    }
    

}

- (void) addToFavorites {
      
    NSInteger indexSelectedMapPrice = [self.indexSelectedMapPrice integerValue];
    MapPrice* selectedPrice = self.prices[indexSelectedMapPrice];
    Ticket* ticket = [Ticket new];
    
    ticket.airline = @"mapTicket";
    ticket.departure = selectedPrice.departure;
    ticket.flightNumber = selectedPrice.flightNumber;
    ticket.from = selectedPrice.origin.code;
    ticket.to = selectedPrice.destination.code;
    ticket.price = selectedPrice.value;
    ticket.returnDate = selectedPrice.returnDate;
    
    NSString* message = [NSString stringWithFormat: @"Do you want add to favorites ticket: %@ - %@ price: %@ ", ticket.from, ticket.to, ticket.price];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add to favorites?" message: message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //button click event
        NSLog(@"YES Add");
        [[CoreDataHelper sharedInstance] addToFavorite: ticket];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];

    NSLog(@"Action ADD!");
    
}




@end
