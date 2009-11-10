/*
 * Wanda, the Cocoa port of GNOME Wanda
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * The program from which this was derived can be found at:
 *     http://git.gnome.org/cgit/gnome-panel/tree/gnome-panel/nothing.cP
 *
 * (C) 2009 Tim Horton
 *
 */

#import "WandaWindow.h"


@implementation WandaWindow

- (id) initWithContentRect:(NSRect)contentRect
                 styleMask:(NSUInteger)aStyle
                   backing:(NSBackingStoreType)bufferingType
                     defer:(BOOL)flag
{
    if (self = [super initWithContentRect:contentRect
                                styleMask:NSBorderlessWindowMask
                                  backing:bufferingType
                                    defer:flag])
		
    {
		[self setMovableByWindowBackground:NO];
		[self setBackgroundColor:[NSColor clearColor]];
		[self setLevel:NSFloatingWindowLevel];
		[self setOpaque:NO];
		[self setHasShadow:NO];
		
		// This MUST be set to the actual size of a single frame in the image.
		[self setAspectRatio:NSMakeSize(90.0, 55.0)];
		
		// Generate a random initial direction
		xDirection = (rand() % 2 ? -1 : 1) * 2;
		yDirection = (rand() % 2 ? -1 : 1);
		swimToHiding = hid = NO;
		
		// Generate a random initial position
		NSRect screenFrame = [[self screen] visibleFrame];
		[self setFrameOrigin:NSMakePoint(rand() % (int)(screenFrame.size.width - contentRect.size.width),
										 rand() % (int)(screenFrame.size.height - contentRect.size.height))];
    }
    
    return self;
}

- (void)awakeFromNib
{
	NSRect newFrame = [self frame];
	newFrame.size.width = 36.0;
	newFrame.size.height = ([self aspectRatio].height /
							[self aspectRatio].width) * newFrame.size.width;
	
	[self setFrame:newFrame display:YES];
	
	swimTimer = [NSTimer scheduledTimerWithTimeInterval:0.12
												 target:self
											   selector:@selector(updateFrame:)
											   userInfo:nil
												repeats:YES];
	
	[self updateFrame:nil];
}

- (void)mouseDown:(NSEvent *)event
{
	swimToHiding = YES;
	[swimTimer invalidate];
	swimTimer = [NSTimer scheduledTimerWithTimeInterval:0.08
												 target:self
											   selector:@selector(updateFrame:)
											   userInfo:nil
												repeats:YES];
}

- (void)updateFrame:(id)userData
{
	NSRect newFrame = [self frame];
	NSRect screenFrame = [[self screen] visibleFrame];
	
	if(swimToHiding)
		screenFrame = [[self screen] frame];
	
	// Occasionally come out of hiding
	if(rand() % 2000 == 0 && swimToHiding && hid)
	{
		[wanda layer].opacity = 1.0;
		swimToHiding = hid = NO;
		newFrame.origin.x = 0;
		newFrame.origin.y = (rand() % (int)(screenFrame.size.height - newFrame.size.height));
		xDirection = abs(xDirection);
		yDirection = abs(yDirection);
		xLastSwapped = yLastSwapped = 0;
		[swimTimer invalidate];
		swimTimer = [NSTimer scheduledTimerWithTimeInterval:0.12
													 target:self
												   selector:@selector(updateFrame:)
												   userInfo:nil
													repeats:YES];
	}
	
	if(hid)
		return;
	
	// Occasionally randomly change direction, but only if we haven't recently
	// done so, in order to reduce sudden movements, and only if we're not hiding
	if(rand() % 50 == 0 && yLastSwapped > 20 && !swimToHiding)
	{
		yDirection = -yDirection;
		yLastSwapped = 0;
	}
	if(rand() % 200 == 0 && xLastSwapped > 50 && !swimToHiding)
	{
		xDirection = -xDirection;
		xLastSwapped = 0;
	}
	
	xLastSwapped++;
	yLastSwapped++;
	
	// Don't go past the bounds of the display, unless we're trying to hide!!
	if(newFrame.origin.x >= ((screenFrame.size.width + screenFrame.origin.x) - newFrame.size.width))
		if(swimToHiding)
		{
			[self fishHid];
			return;
		}
		else
		{
			xDirection = -abs(xDirection);
			xLastSwapped = 0;
		}
	else if(newFrame.origin.x <= screenFrame.origin.x)
		if(swimToHiding)
		{
			[self fishHid];
			return;
		}
		else
		{
			xDirection = abs(xDirection);
			xLastSwapped = 0;
		}	
	if(newFrame.origin.y >= ((screenFrame.size.height + screenFrame.origin.y) - newFrame.size.height))
		if(swimToHiding)
		{
			[self fishHid];
			return;
		}
		else
		{
			yDirection = -abs(yDirection);
			yLastSwapped = 0;
		}
	else if(newFrame.origin.y <= screenFrame.origin.y)
		if(swimToHiding)
		{
			[self fishHid];
			return;
		}
		else
		{
			yDirection = abs(yDirection);
			yLastSwapped = 0;
		}
	
	newFrame.origin.x += xDirection * (swimToHiding ? 3.5 : 1.0);
	newFrame.origin.y += yDirection;
	
	[wanda setBackwards:(xDirection >= 0 ? YES : NO)];
	
	[self setFrame:newFrame display:YES];
}

- (void)fishHid
{
	[wanda layer].opacity = 0.0;
	hid = YES;
}

@end
