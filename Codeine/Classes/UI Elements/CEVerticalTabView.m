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

#import "CEVerticalTabView.h"
#import "CEVerticalTabView+CEVerticalTabBarDelegate.h"
#import "CEVerticalTabBar.h"

@implementation CEVerticalTabView

@synthesize delegate = _delegate;

- ( id )initWithFrame: ( NSRect )frame
{
    if( ( self = [ super initWithFrame: frame ] ) )
    {
        _tabBarPosition = CEVerticalTabBarPositionLeft;
        _tabBarWidth    = ( CGFloat )64;
        _tabBar         = [ [ CEVerticalTabBar alloc ] initWithFrame: CGRectMake( 0, 0, _tabBarWidth, frame.size.height ) ];
        _contentView    = [ [ NSView alloc ] initWithFrame: CGRectMake( _tabBarWidth, 0, frame.size.width - _tabBarWidth, frame.size.height ) ];
        
        _tabBar.autoresizingMask      = NSViewHeightSizable
                                      | NSViewMinYMargin
                                      | NSViewMaxYMargin;
        _contentView.autoresizingMask = NSViewHeightSizable
                                      | NSViewMinYMargin
                                      | NSViewMaxYMargin;
        
        _tabBar.delegate = self;
        
        [ self addSubview: _tabBar ];
        [ self addSubview: _contentView ];
        
        _views = [ [ NSMutableArray alloc ] initWithCapacity: 10 ];
        
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _tabBar );
    RELEASE_IVAR( _contentView );
    RELEASE_IVAR( _views );
    
    [ super dealloc ];
}

- ( void )setFrame: ( NSRect )frame
{
    [ super setFrame: frame ];
    [ self setTabBarPosition: _tabBarPosition ];
}

- ( CGFloat )tabBarWidth
{
    @synchronized( self )
    {
        return _tabBarWidth;
    }
}

- ( void )setTabBarWidth: ( CGFloat )tabWidth
{
    CGRect frame;
    
    frame = self.bounds;
    
    @synchronized( self )
    {
        _tabBarWidth       = tabWidth;
        _tabBar.frame      = CGRectMake( 0, 0, _tabBarWidth, frame.size.height );
        _contentView.frame = CGRectMake( _tabBarWidth, 0, frame.size.width - _tabBarWidth, frame.size.height );
    }
}

- ( CEVerticalTabBarPosition )tabBarPosition
{
    @synchronized( self )
    {
        return _tabBarPosition;
    }
}

- ( void )setTabBarPosition: ( CEVerticalTabBarPosition )position
{
    CGRect frame;
    
    frame = self.bounds;
    
    @synchronized( self )
    {
        _tabBarPosition = position;
        
        if( _tabBarPosition == CEVerticalTabBarPositionLeft )
        {
            _tabBar.frame      = CGRectMake( ( CGFloat )0, ( CGFloat )0, _tabBarWidth, frame.size.height );
            _contentView.frame = CGRectMake( _tabBarWidth, ( CGFloat )0, frame.size.width - _tabBarWidth, frame.size.height );
        }
        else if( _tabBarPosition == CEVerticalTabBarPositionRight )
        {
            _tabBar.frame      = CGRectMake( frame.size.width - _tabBarWidth, 0, _tabBarWidth, frame.size.height );
            _contentView.frame = CGRectMake( ( CGFloat )0, ( CGFloat )0, frame.size.width - _tabBarWidth, frame.size.height );
        }
        
        [ _tabBar setPosition: position ];
    }
}

- ( void )addView: ( NSView * )view icon: ( NSImage * )icon
{
    [ _views addObject: view ];
    [ _tabBar addItem: icon ];
    
    if( _views.count == 1 )
    {
        [ self verticalTabBar: _tabBar didSelectItemAtIndex: 0 ];
    }
}

- ( void )removeViewAtIndex: ( NSUInteger )index
{
    @try
    {
        [ _views removeObjectAtIndex: index ];
        [ _tabBar removeItemAtIndex: index ];
    }
    @catch(  NSException * e )
    {
        ( void )e;
    }
}

- ( void )removeView: ( NSView * )view
{
    NSUInteger index;
    
    index = [ _views indexOfObject: view ];
    
    if( index != NSNotFound )
    {
        [ self removeViewAtIndex: index ];
    }
}

- ( void )selectViewAtIndex: ( NSUInteger )index
{
    [ _tabBar selectItemAtIndex: index ];
}

@end
