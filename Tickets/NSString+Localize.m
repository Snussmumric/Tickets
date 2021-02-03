//
//  NSString+Localize.m
//  Tickets
//
//  Created by Антон Васильченко on 03.02.2021.
//

#import <Foundation/Foundation.h>
#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localize {
    return NSLocalizedString(self, "");
}

@end
