//
//  CollectionViewController.h
//  Tickets
//
//  Created by Антон Васильченко on 22.01.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end


NS_ASSUME_NONNULL_END
