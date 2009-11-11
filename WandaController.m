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

#import "WandaController.h"

@implementation WandaController

- (void)awakeFromNib
{
	timer = nil;
	[self updateTimer:NO];
}

- (void)updateTimer:(bool)fast
{
	if(timer != nil)
		[timer invalidate];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:(fast ? 0.08 : 0.12)
											 target:self
										   selector:@selector(updateFrame:)
										   userInfo:nil
											repeats:YES];
}

- (void)updateFrame:(id)userData
{
	[window updateFrame];
	[view updateFrame];
}

@end
