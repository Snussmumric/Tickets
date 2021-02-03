//
//  ProgressView.h
//  Tickets
//
//  Created by Антон Васильченко on 03.02.2021.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;

@end
