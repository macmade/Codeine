/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina - www.xs-labs.com
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *  -   Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *  -   Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *  -   Neither the name of 'Jean-David Gadina' nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************/
 
/* $Id$ */

#import "CEInfoWindowController+Private.h"

@implementation CEInfoWindowController( Private )

- ( void )resizeWindow: ( BOOL )animate
{
    void ( ^ resize )( void );
    
    resize = ^
    {
        NSRect  frame;
        NSRect  rect;
        CGFloat height;
        
        frame               = self.window.frame;
        rect                = [ _outlineView rectOfRow: ( [ _outlineView numberOfRows ] - 1 ) ];
        height              = rect.origin.y + rect.size.height + ( CGFloat )25;
        frame.origin.y      = frame.origin.y + ( frame.size.height - height );
        frame.size.height   = height;
        
        if( animate == NO )
        {
            [ self.window setFrame: frame display: NO animate: NO ];
        }
        else
        {
            {
                NSDictionary    * windowResize;
                NSViewAnimation * animation;
                
                windowResize = [ NSDictionary dictionaryWithObjectsAndKeys: self.window, NSViewAnimationTargetKey, [ NSValue valueWithRect: frame ], NSViewAnimationEndFrameKey, nil ];
                animation    = [ [ NSViewAnimation alloc ] initWithViewAnimations: [ NSArray arrayWithObjects: windowResize, nil ] ];
                
                [ animation setAnimationBlockingMode: NSAnimationBlocking ];
                [ animation setAnimationCurve: NSAnimationEaseIn ];
                [ animation setDuration: 0.2 ];
                [ animation startAnimation ];
                [ animation autorelease ];
            }
        }
    };
    
    if( animate == YES )
    {
        dispatch_after
        (
            dispatch_time( DISPATCH_TIME_NOW, 10 * NSEC_PER_MSEC ),
            dispatch_get_main_queue(),
            resize
        );
    }
    else
    {
        resize();
    }
}

@end
