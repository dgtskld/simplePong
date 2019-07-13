//
//  AIPlayer.m
//  Pong Game
//
//  Created by Vladimir Mazunin on 09/07/2019.
//  Copyright © 2019 Vladimir Mazunin. All rights reserved.
//

#import "AIPlayer.h"

@implementation AIPlayer

- (instancetype) initAIPlayerWithWidth: (CGFloat) width andHeight: (CGFloat) height
{
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    self.backgroundColor = [UIColor yellowColor];
    self.northPoint = CGPointMake(self.center.x, self.center.y + height);
    self.southPoint = CGPointMake(self.center.x, self.center.y - height);
    self.westPoint = CGPointMake(self.center.x - width, self.center.y);
    self.eastPoint = CGPointMake(self.center.x + width, self.center.y);
    self.velocity = CGVectorMake(0.0, 0.0);
    return self;
}

- (CGPoint) interceptTheObject: (CGPoint) center withSpeed:(CGVector) velocity
{
    CGPoint point = center;
    CGVector vector = velocity;
    while (point.y > [[UIScreen mainScreen] bounds].size.height * 0.1)
    {
        point = CGPointMake(point.x + vector.dx/10.0, point.y + vector.dy/10.0);
//        NSLog(@"%f   %f   %f", point.x, point.y, [[UIScreen mainScreen] bounds].size.height * 0.1);
    }
    return point;
}

- (void) normalizeProspectiveDirection
{
//    if (self.prospectiveDirection.dx >= self.prospectiveDirection.dy) {
//        self.prospectiveDirection = CGVectorMake((self.prospectiveDirection.dx/self.prospectiveDirection.dx) * 10.0, (self.prospectiveDirection.dy / self.prospectiveDirection.dx) * 10.0);
//    } else {
//        self.prospectiveDirection = CGVectorMake((self.prospectiveDirection.dx/self.prospectiveDirection.dy) * 10.0, (self.prospectiveDirection.dy / self.prospectiveDirection.dy) * 10.0);
//    }
}

- (void) recount
{
    self.northPoint = CGPointMake(self.center.x, self.center.y + self.frame.size.height/2.0);
    self.southPoint = CGPointMake(self.center.x, self.center.y - self.frame.size.height/2.0);
    self.westPoint = CGPointMake(self.center.x - self.frame.size.width/2.0, self.center.y);
    self.eastPoint = CGPointMake(self.center.x + self.frame.size.width/2.0, self.center.y);
}

@end
