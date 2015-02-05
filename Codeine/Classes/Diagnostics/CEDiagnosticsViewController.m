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

#import "CEDiagnosticsViewController.h"
#import "CEDiagnosticsViewController+Private.h"
#import "CEDiagnosticsViewController+NSTableViewDataSource.h"
#import "CEDiagnosticsViewController+NSTableViewDelegate.h"
#import "CEDiagnosticsViewController+CETableViewDelegate.h"
#import "CEMainWindowController.h"
#import "CEDocument.h"
#import "CESourceFile.h"
#import "CEHUDView.h"

NSString * const CEDiagnosticsViewControllerTableColumnIdentifierIcon       = @"Icon";
NSString * const CEDiagnosticsViewControllerTableColumnIdentifierLine       = @"Line";
NSString * const CEDiagnosticsViewControllerTableColumnIdentifierColumn     = @"Column";
NSString * const CEDiagnosticsViewControllerTableColumnIdentifierMessage    = @"Message";

@implementation CEDiagnosticsViewController

@synthesize tableView = _tableView;

- ( void )dealloc
{
	[ NOTIFICATION_CENTER removeObserver: self ];
	
    _tableView.delegate   = nil;
    _tableView.dataSource = nil;
	
    [ _hud removeFromSuperview ];
    [ _document.sourceFile.translationUnit removeObserver: self forKeyPath: @"text" ];
    [ self.view removeObserver: self forKeyPath: @"frame" ];
    
    RELEASE_IVAR( _tableView );
    RELEASE_IVAR( _document );
    RELEASE_IVAR( _diagnostics );
    RELEASE_IVAR( _hud );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    
    [ NOTIFICATION_CENTER addObserver: self selector: @selector( applicationStateDidChange: ) name: NSApplicationDidBecomeActiveNotification object: APPLICATION ];
    [ NOTIFICATION_CENTER addObserver: self selector: @selector( applicationStateDidChange: ) name: NSApplicationDidResignActiveNotification object: APPLICATION ];
    
    _diagnostics = [ [ NSMutableArray alloc ] initWithCapacity: 25 ];
    
    _hud                   = [ [ CEHUDView alloc ] initWithFrame: NSMakeRect( 0, 0, 200, 50 ) ];
    _hud.title             = L10N( "NoError" );
    _hud.autoresizingMask  = NSViewMinXMargin
                           | NSViewMaxXMargin
                           | NSViewMinYMargin
                           | NSViewMaxYMargin;
    
    [ self.view addSubview: _hud ];
    [ _hud centerInSuperview ];
    
    [ self.view addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil ];
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
            [ _document.sourceFile.translationUnit removeObserver: self forKeyPath: @"text" ];
            
            RELEASE_IVAR( _document );
            
            _document = [ document retain ];
            
            [ self getDiagnostics ];
            
            [ _document.sourceFile.translationUnit addObserver: self forKeyPath: @"text" options: NSKeyValueObservingOptionNew context: nil ];
            [ _tableView reloadData ];
        }
    }
}

- ( NSTextView * )textView
{
    @synchronized( self )
    {
        return _textView;
    }
}

- ( void )setTextView: ( NSTextView * )textView
{
    @synchronized( self )
    {
        if( _textView != textView )
        {
            [ NOTIFICATION_CENTER removeObserver: self name: NSTextViewDidChangeSelectionNotification object: _textView ];
            
            RELEASE_IVAR( _textView );
            
            _textView = [ textView retain ];
            
            [ NOTIFICATION_CENTER addObserver: self selector: @selector( textViewSelectionDidChange: ) name: NSTextViewDidChangeSelectionNotification object: _textView ];
        }
    }
}

- ( void )observeValueForKeyPath: ( NSString * )keyPath ofObject: ( id )object change: ( NSDictionary * )change context: ( void * )context
{
    ( void )change;
    ( void )context;
    
    if( object == _document.sourceFile.translationUnit && [ keyPath isEqualToString: @"text" ] )
    {
        [ self getDiagnostics ];
        [ _tableView reloadData ];
    }
    else if( object == self.view && [ keyPath isEqualToString: @"frame" ] )
    {
        [ _hud centerInSuperview ];
    }
}

@end
