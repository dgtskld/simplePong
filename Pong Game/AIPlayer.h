//
//  AIPlayer.h
//  Pong Game
//
//  Created by Vladimir Mazunin on 09/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIPlayer : UIView

@property (nonatomic) CGVector velocity;
@property (nonatomic) CGPoint northPoint;
@property (nonatomic) CGPoint southPoint;
@property (nonatomic) CGPoint westPoint;
@property (nonatomic) CGPoint eastPoint;

@property (nonatomic) CGVector prospectiveDirection;
@property (nonatomic) CGPoint startPosition;

- (instancetype) initAIPlayerWithWidth: (CGFloat) width andHeight: (CGFloat) height;
- (void) recount;
- (CGPoint) interceptTheObject: (CGPoint) center withSpeed:(CGVector) velocity;
- (void) normalizeProspectiveDirection;

@end

NS_ASSUME_NONNULL_END
