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

#import "CECodeCompletionViewController.h"
#import "CECodeCompletionViewController+Private.h"
#import "CECodeCompletionViewController+NSTableViewDelegate.h"
#import "CECodeCompletionViewController+NSTableViewDataSource.h"
#import "CEPreferences.h"

@implementation CECodeCompletionViewController

@synthesize isOpening = _isOpening;
@synthesize tableView = _tableView;

- ( id )initWithCompletionResults: ( NSArray * )results
{
    if( ( self = [ self init ] ) )
    {
        _results = [ results retain ];
    }
    
    return self;
}

- ( void )dealloc
{
    _tableView.delegate   = nil;
    _tableView.dataSource = nil;
    
    RELEASE_IVAR( _results );
    RELEASE_IVAR( _tableView );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    _tableView.delegate   = self;
    _tableView.dataSource = self;
}

- ( void )openInPopoverRelativeToRect: ( NSRect )rect ofView: ( NSView * )view preferredEdge: ( NSRectEdge )edge delay: ( BOOL )delay
{
    void ( ^ open )( void );
    
    @synchronized( self )
    {
        _cancel = NO;
    }
    
    open = ^( void )
    {
        if( _cancel == NO )
        {
            [ super openInPopoverRelativeToRect: rect ofView: view preferredEdge: edge ];
        }
        
        _isOpening = NO;
    };
    
    if( delay == YES )
    {
        _isOpening = YES;
        
        dispatch_after
        (
            dispatch_time( DISPATCH_TIME_NOW, ( int64_t )( [ [ CEPreferences sharedInstance ] suggestDelay ] * ( CGFloat )1000 ) * ( int64_t )NSEC_PER_MSEC ),
            dispatch_get_main_queue(),
            open
        );
    }
    else
    {
        open();
    }
}

- ( void )keyDown: ( NSEvent * )event
{
    [ self closePopover ];
    [ APPLICATION sendEvent: event ];
}

- ( void )cancelOpening
{
    @synchronized( self )
    {
        _cancel = YES;
    }
}

@end
