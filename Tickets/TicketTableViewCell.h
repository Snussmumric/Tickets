//
//  TicketTableViewCell.h
//  Tickets
//
//  Created by Антон Васильченко on 03.01.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"
#import "CoreDataHelper.h"


NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;
@property (nonatomic, strong) UIImageView *airlineLogoView;


@end

NS_ASSUME_NONNULL_END
