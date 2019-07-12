//
//  Ball.m
//  Pong Game
//
//  Created by Vladimir Mazunin on 05/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//

#import "Ball.h"
@interface Ball()

@end

@implementation Ball

- (instancetype) initWithRadius: (CGFloat) radius
{
    self = [super initWithFrame:CGRectMake(0, 0, radius * 2.0, radius * 2.0)];
    self.layer.cornerRadius = radius;
    self.backgroundColor = [UIColor redColor];
    [self recount];
    return self;
}

#pragma mark - Interactions
- (void) stop
{
    self.velocity = CGVectorMake(0, 0);
}

//NOT USED
- (void) moveInDirection: (CGVector) vector fromCurrentPosition: (CGPoint) currentPoint
{
    self.velocity = CGVectorMake(vector.dx, vector.dy);
    self.center = CGPointMake(currentPoint.x + self.velocity.dx, currentPoint.y + self.velocity.dy);
    [self recount];
}

#pragma mark - Area Count
- (void) recount
{
    self.northPoint = CGPointMake(self.center.x, self.center.y + self.layer.cornerRadius);
    self.southPoint = CGPointMake(self.center.x, self.center.y - self.layer.cornerRadius);
    self.westPoint = CGPointMake(self.center.x - self.layer.cornerRadius, self.center.y);
    self.eastPoint = CGPointMake(self.center.x + self.layer.cornerRadius, self.center.y);
}

#pragma mark - Conditions
- (BOOL) isInSafeZone
{
    if ((self.northPoint.y > 0) && (self.southPoint.y < [[UIScreen mainScreen] bounds].size.height) & (self.westPoint.x > 0) & (self.eastPoint.x < [[UIScreen mainScreen] bounds].size.width)) {
        return YES;
    } else {
        return NO;
    }
}



@end
