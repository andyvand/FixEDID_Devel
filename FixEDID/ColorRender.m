//
//  ColorRender.m
//  FixEDID
//
//  Created by Andy Vandijck on 28/04/14.
//  Copyright (c) 2014 Andy Vandijck. All rights reserved.
//

#import "ColorRender.h"

@implementation ColorRender

- (id)initWithFrame:(NSRect)frame colorX:(float *)xVals colorY:(float *)yVals
{
    [super initWithFrame:frame];

    xValsB[0] = xVals[0]; // Rx
    xValsB[1] = xVals[1]; // Gx
    xValsB[2] = xVals[2]; // Bx

    yValsB[0] = yVals[0]; // Ry
    yValsB[1] = yVals[1]; // Gy
    yValsB[2] = yVals[2]; // By

    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect dotRect;
    int colorcur = 0;
    int colorcur2 = 0;
    int colorcur3 = 0;
        
    [[NSColor whiteColor] set];
    NSRectFill([self bounds]);   // Equiv to [[NSBezierPath bezierPathWithRect:[self bounds]] fill]
        
    for (colorcur = 0; colorcur < 256; colorcur++)
    {
        for (colorcur2 = 0; colorcur2 < 256; colorcur2++)
        {
            dotRect.origin.x = colorcur;
            dotRect.origin.y = colorcur2;

            colorcur3 = (colorcur / 255.0) + (colorcur2 / 255.0);

            dotRect.size.width  = 1;
            dotRect.size.height = 1;

            [[NSColor colorWithSRGBRed:(colorcur / 255.0) green:(colorcur2 / 255.0) blue:colorcur3 alpha:1.0] set];

            NSRectFill(dotRect);
        }
    }
}

@end
