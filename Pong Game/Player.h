//
//  Player.h
//  Pong Game
//
//  Created by Vladimir Mazunin on 05/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Player : UIView

@property (nonatomic) CGVector velocity;
@property (nonatomic) CGPoint northPoint;
@property (nonatomic) CGPoint southPoint;
@property (nonatomic) CGPoint westPoint;
@property (nonatomic) CGPoint eastPoint;

@property (nonatomic) CGPoint previousPosition;
@property (nonatomic) CGPoint currentPosition;

- (instancetype) initPlayerWithWidth: (CGFloat) width andHeight: (CGFloat) height;
- (void) recount;

@end

NS_ASSUME_NONNULL_END
