//
//  Ball.h
//  Pong Game
//
//  Created by Vladimir Mazunin on 05/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface Ball : UIView

@property (nonatomic) CGVector velocity;
@property (nonatomic) CGPoint northPoint;
@property (nonatomic) CGPoint southPoint;
@property (nonatomic) CGPoint westPoint;
@property (nonatomic) CGPoint eastPoint;

- (instancetype) initWithRadius: (CGFloat) radius;
- (BOOL) isInSafeZone;
- (void) recount;
- (void) moveInDirection: (CGVector) vector fromCurrentPosition: (CGPoint) currentPoint; //NOT USED FUNC
- (void) stop;

@end

NS_ASSUME_NONNULL_END
