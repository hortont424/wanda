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

#import <Cocoa/Cocoa.h>
#import "WandaWindow.h"
#import "WandaView.h"

@interface WandaController : NSObject
{
	IBOutlet WandaView * view;
	IBOutlet WandaWindow * window;
	
	NSTimer * timer;
}

- (void)updateTimer:(bool)fast;

@end
