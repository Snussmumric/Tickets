//
//  CollectionViewCell.m
//  Tickets
//
//  Created by Антон Васильченко on 23.01.2021.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

//@property (nonatomic, strong) UILabel *cityName;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor magentaColor];
        self.cityName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.cityName.textColor = [ UIColor blackColor];
        [self.cityName setTextAlignment:NSTextAlignmentCenter];
        [self.cityName setNumberOfLines:1];
        [self.contentView addSubview:self.cityName];
    }
    return self;
}

@end
