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

#import "CEDebugViewController.h"
#import "CEDebugViewController+Private.h"
#import "CEDebugViewController+CEVerticalTabViewDelegate.h"
#import "CEPreferences.h"
#import "CEVerticalTabView.h"
#import "CEConsoleViewController.h"
#import "CEDiagnosticsViewController.h"
#import "CEDocument.h"

@implementation CEDebugViewController

@synthesize tabView                   = _tabView;
@synthesize consoleViewController     = _consoleViewController;
@synthesize diagnosticsViewController = _diagnosticsViewController;

- ( void )dealloc
{
    RELEASE_IVAR( _tabView );
    RELEASE_IVAR( _consoleViewController );
    RELEASE_IVAR( _diagnosticsViewController );
    RELEASE_IVAR( _document );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    _consoleViewController      = [ CEConsoleViewController     new ];
    _diagnosticsViewController  = [ CEDiagnosticsViewController new ];
    
    [ _tabView setTabBarWidth: ( CGFloat )48 ];
    
    [ _tabView addView: _consoleViewController.view icon: [ NSImage imageNamed: @"Console" ] ];
    [ _tabView addView: _diagnosticsViewController.view icon: [ NSImage imageNamed: @"Diagnostics" ] ];
    
    [ _tabView setTabBarPosition: CEVerticalTabBarPositionRight ];
    [ _tabView selectViewAtIndex: [ [ CEPreferences sharedInstance ] debugAreaSelectedIndex ] ];
    [ _tabView setDelegate: self ];
}

- ( CEDocument * )document
{
    @synchronized( self )
    {
        return _document;
    }
}

- ( void )setDocument: ( CEDocument * )document
{
    @synchronized( self )
    {
        if( document != _document )
        {
            RELEASE_IVAR( _document );
            
            _document                           = [ document retain ];
            _diagnosticsViewController.document = document;
        }
    }
}

@end
