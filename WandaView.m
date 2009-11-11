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

#import "WandaView.h"
#import "WandaWindow.h"

#define FRAME_COUNT 8

@implementation WandaView

@synthesize backwards, wandaFrame;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self)
	{
        wandaFrame = 0;
    }
    
	return self;
}

- (void)awakeFromNib
{
	wanda = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"wanda.png"]];
	wandaFlipped = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"wanda-flipped.png"]];
	
	[self updateImageSize];
}

- (void)windowDidResize:(NSNotification *)notification
{
	[self updateImageSize];
}
	 
- (void)updateImageSize
{
	NSSize realSize = [[self window] aspectRatio];
	realSize.width *= FRAME_COUNT;
	
	[wanda setSize:realSize];
	[wandaFlipped setSize:realSize];
}


- (void)drawRect:(NSRect)dirtyRect
{
	NSImage * img = (backwards ? wandaFlipped : wanda);
	NSRect fromRect = NSZeroRect;
	
	fromRect.size = [[self window] aspectRatio];
	fromRect.origin.x = wandaFrame * fromRect.size.width;
    
	[img drawInRect:[self frame] fromRect:fromRect operation:NSCompositeCopy fraction:1.0];
	[[self window] invalidateShadow];
}

- (void)updateFrame
{
	wandaFrame = (wandaFrame + 1) % FRAME_COUNT;
	[self setNeedsDisplay:YES];
}

@end
