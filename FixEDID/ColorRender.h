//
//  ColorRender.h
//  FixEDID
//
//  Created by Andy Vandijck on 28/04/14.
//  Copyright (c) 2014 Andy Vandijck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorRender : NSView
{
    float xValsB[3];
    float yValsB[3];
}
- (id)initWithFrame:(NSRect)frame colorX:(float *)xVals colorY:(float *)yVals;
@end
