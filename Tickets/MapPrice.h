//
//  MapPrice.h
//  Tickets
//
//  Created by Антон Васильченко on 22.01.2021.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface MapPrice : NSObject

@property (strong, nonatomic) City *destination;
@property (strong, nonatomic) City *origin;
@property (strong, nonatomic) NSDate *departure;
@property (strong, nonatomic) NSDate *returnDate;
@property (nonatomic) NSInteger numberOfChanges;
@property (nonatomic) NSNumber* value;
@property (nonatomic) NSInteger distance;
@property (nonatomic) BOOL actual;
@property (nonatomic, assign) NSNumber* flightNumber;
@property (nonatomic, strong) NSString* destinationIATA;
@property (nonatomic, strong) NSString* originIATA;



- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin: (City *)origin;

@end
