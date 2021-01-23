//
//  TabBarController.m
//  Tickets
//
//  Created by Антон Васильченко on 22.01.2021.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "CollectionViewController.h"


@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return self;
}

- (NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Поиск" image:[UIImage systemImageNamed:@"magnifyingglass.circle"] selectedImage:[UIImage systemImageNamed:@"magnifyingglass.circle.fill"]];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [controllers addObject:mainNavigationController];
    
    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Карта цен" image:[UIImage systemImageNamed:@"map"] selectedImage:[UIImage systemImageNamed:@"map.fill"]];
    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    [controllers addObject:mapNavigationController];
    
    CollectionViewController *collectionViewController = [[CollectionViewController alloc] init];
    collectionViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Collection" image:[UIImage systemImageNamed:@"calendar.circle"] selectedImage:[UIImage systemImageNamed:@"calendar.circle.fill"]];
    UINavigationController *collectionNavigationController = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
    [controllers addObject:collectionNavigationController];
    
    return controllers;
}

@end
