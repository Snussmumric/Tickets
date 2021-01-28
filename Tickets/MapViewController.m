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
#import "TicketsViewController.h"


@interface MapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;
@property (nonatomic, strong) MKPointAnnotation *annotation;
@property (nonatomic, strong) NSString * selectedTitle;
@property (nonatomic) SearchRequest searchRequest;


@end

@implementation MapViewController {
    BOOL isFavorites;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Карта цен";
    
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
            _annotation = [[MKPointAnnotation alloc] init];
            _annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            _annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            _annotation.coordinate = price.destination.coordinate;
            [_mapView addAnnotation: _annotation];
            [_mapView setDelegate:self];
            [_mapView viewForAnnotation:_annotation];
        });
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        annotationView.image = [UIImage systemImageNamed:@"star"];
//        annotationView.image
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    [[APIManager sharedInstance] ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
           if (tickets.count > 0) {
               TicketsViewController *ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
               [self.navigationController showViewController:ticketsViewController sender:self];
           } else {
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Увы!" message:@"По данному направлению билетов не найдено" preferredStyle: UIAlertControllerStyleAlert];
               [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:(UIAlertActionStyleDefault) handler:nil]];
               [self presentViewController:alertController animated:YES completion:nil];
           }
       }];
//    MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
//    annotation = view.annotation;
//    _selectedTitle = [NSString stringWithFormat:@"%@",annotation.title];
//
//    if (isFavorites) return;
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что необходимо сделать с выбранным билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *favoriteAction;
//    if ([[CoreDataHelper sharedInstance] isFavorite: [_tickets objectAtIndex:indexPath.row]]) {
//        favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            [[CoreDataHelper sharedInstance] removeFromFavorite:[_tickets objectAtIndex:indexPath.row]];
//        }];
//    } else {
//        favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[CoreDataHelper sharedInstance] addToFavorite:[_tickets objectAtIndex:indexPath.row]];
//        }];

}




@end
