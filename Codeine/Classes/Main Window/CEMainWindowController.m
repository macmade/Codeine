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

#import "CEMainWindowController.h"
#import "CEMainWindowController+Private.h"
#import "CEMainWindowController+NSOpenSavePanelDelegate.h"
#import "CEMainWindowController+NSSplitViewDelegate.h"
#import "CEEditorViewController.h"
#import "CEDebugViewController.h"
#import "CEFilesViewController.h"
#import "CEFileDetailsViewController.h"
#import "CESourceFile.h"
#import "CETextEncoding.h"
#import "CEPreferences.h"
#import "CEQuickLookItem.h"
#import "CEWindowBadge.h"
#import "CEApplicationDelegate.h"
#import "CEHUDView.h"
#import "CEDocument.h"
#import "CEDiagnosticsViewController.h"
#import "CELanguageWindowController.h"

NSString * const CEMainWindowControllerDocumentsArrayKey = @"documents";

@implementation CEMainWindowController

@synthesize leftView                = _leftView;
@synthesize mainView                = _mainView;
@synthesize bottomView              = _bottomView;
@synthesize encodingPopUp           = _encodingPopUp;
@synthesize horizontalSplitView     = _horizontalSplitView;
@synthesize verticalSplitView       = _verticalSplitView;
@synthesize viewsSegmentedControl   = _viewsSegmentedControl;
@synthesize fullScreen              = _fullScreen;

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        _documents            = [ [ NSMutableArray alloc ] initWithCapacity: 10 ];
        _editorViewController = [ CEEditorViewController new ];
        _debugViewController  = [ CEDebugViewController  new ];
        _fileViewController   = [ CEFilesViewController  new ];
        
        _fileViewController.mainWindowController = self;
    }
    
    return self;
}

- ( void )dealloc
{
    [ NOTIFICATION_CENTER removeObserver: self ];
    
    RELEASE_IVAR( _fileViewController );
    RELEASE_IVAR( _editorViewController );
    RELEASE_IVAR( _debugViewController );
    RELEASE_IVAR( _fileDetailsViewController );
    RELEASE_IVAR( _leftView );
    RELEASE_IVAR( _mainView );
    RELEASE_IVAR( _bottomView );
    RELEASE_IVAR( _languageWindowController );
    RELEASE_IVAR( _encodingPopUp );
    RELEASE_IVAR( _documents );
    RELEASE_IVAR( _activeDocument );
    RELEASE_IVAR( _horizontalSplitView );
    RELEASE_IVAR( _verticalSplitView );
    RELEASE_IVAR( _viewsSegmentedControl );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    NSUInteger  resizingMask;
    CEHUDView * editorHUD;
    
    resizingMask = NSViewWidthSizable
                 | NSViewHeightSizable;
    
    _editorViewController.view.frame = _mainView.bounds;
    _debugViewController.view.frame  = _bottomView.bounds;
    _fileViewController.view.frame   = _leftView.bounds;
    
    _editorViewController.view.autoresizingMask = resizingMask;
    _debugViewController.view.autoresizingMask  = resizingMask;
    _fileViewController.view.autoresizingMask   = resizingMask;
    
    editorHUD                   = [ [ [ CEHUDView alloc ] initWithFrame: NSMakeRect( 100, 100, 200, 50 ) ] autorelease ];
    editorHUD.title             = L10N( "NoEditor" );
    editorHUD.autoresizingMask  = NSViewMinXMargin
                                | NSViewMaxXMargin
                                | NSViewMinYMargin
                                | NSViewMaxYMargin;
    
    [ _mainView addSubview: editorHUD ];
    [ editorHUD centerInSuperview ];
    
    _fileViewController.view.frame  = _leftView.bounds;
    _debugViewController.view.frame = _bottomView.bounds;
    
    [ _leftView addSubview:   _fileViewController.view ];
    [ _bottomView addSubview: _debugViewController.view ];
    
    [ self.window setContentBorderThickness: ( CGFloat )29 forEdge: NSMinYEdge ];
    
    [ _viewsSegmentedControl setImage: [ NSImage imageNamed: @"ShowFiles-On" ]    forSegment: 0 ];
    [ _viewsSegmentedControl setImage: [ NSImage imageNamed: @"ShowDebugger-On" ] forSegment: 1 ];
    
    if( [ [ CEPreferences sharedInstance ] fileBrowserHidden ] == YES )
    {
        [ self toggleFileBrowser: nil ];
    }
    
    if( [ [ CEPreferences sharedInstance ] debugAreaHidden ] == YES )
    {
        [ self toggleDebugArea: nil ];
    }
    
    if( [ [ CEPreferences sharedInstance ] fullScreenStyle ] == CEPreferencesFullScreenStyleNative )
    {
        self.window.collectionBehavior |= NSWindowCollectionBehaviorFullScreenPrimary;
    }
    else
    {
        self.window.collectionBehavior &= ~NSWindowCollectionBehaviorFullScreenPrimary;
    }
    
    _fullScreen = ( self.window.styleMask & NSFullScreenWindowMask ) ? YES : NO;
    
    [ NOTIFICATION_CENTER addObserver: self selector: @selector( preferencesDidChange: ) name: CEPreferencesNotificationValueChanged object: nil ];
    
    _horizontalSplitView.delegate = self;
    _verticalSplitView.delegate   = self;
    
    {
        NSRect          badgeRect;
        CEWindowBadge * badge;
        
        badgeRect              = NSMakeRect( self.window.frame.size.width - 230, self.window.frame.size.height - 20, 200, 20 );
        badge                  = [ [ CEWindowBadge alloc ] initWithFrame: badgeRect ];
        badge.autoresizingMask = NSViewMaxXMargin | NSViewMinYMargin;
        
        [ badge setTitle: [ NSString stringWithFormat: @"Beta version - %lu", ( unsigned long )[ [ BUNDLE objectForInfoDictionaryKey: NSBundleInfoKeyCFBundleVersion ] integerValue ] ] ];
        
        [ ( ( NSView * )self.window.contentView ).superview addSubview: badge ];
        
        [ badge release ];
    }
    
    _debugViewController.diagnosticsViewController.textView = _editorViewController.textView;
}

- ( void )showWindow: ( id )sender
{
    [ super showWindow: sender ];
    
    if( _fileBrowserHidden == NO )
    {
        [ _horizontalSplitView setPosition: [ [ CEPreferences sharedInstance ] fileBrowserWidth ] ofDividerAtIndex: 0 ];
    }
    if( _debugAreaHidden == NO )
    {
        [ _verticalSplitView setPosition: _verticalSplitView.frame.size.height - [ [ CEPreferences sharedInstance ] debugAreaHeight ]  ofDividerAtIndex: 0 ];
    }
    
    if( _documents.count == 0 )
    {
        dispatch_after
        (
            dispatch_time( DISPATCH_TIME_NOW, 250 * NSEC_PER_MSEC ),
            dispatch_get_main_queue(),
            ^( void )
            {
                [ self newDocument: sender ];
            }
        );
    }
    else
    {
        self.activeDocument = [ _documents objectAtIndex: 0 ];
    }
}

- ( CEDocument * )activeDocument
{
    @synchronized( self )
    {
        return _activeDocument;
    }
}

- ( void )setActiveDocument: ( CEDocument * )document
{
    CEDocument * d;
    BOOL         found;
    NSUInteger   i;
    
    @synchronized( self )
    {
        [ self window ];
        
        if( document != _activeDocument )
        {
            RELEASE_IVAR( _activeDocument );
            
            [ _editorViewController.view removeFromSuperview ];
            
            _editorViewController.view.frame = _mainView.bounds;
            
            [ _mainView addSubview: _editorViewController.view ];
            
            found = NO;
            i     = 0;
            
            for( d in _documents )
            {
                if( [ document isEqual: d ] == YES && document.sourceFile.text != nil )
                {
                    found = YES;
                    
                    break;
                }
                
                i++;
            }
            
            _debugViewController.document = document;
            
            if( document.sourceFile.text != nil )
            {
                _activeDocument = [ document retain ];
                
                if( _editorViewController.document != document )
                {
                    _editorViewController.document = document;
                }
                
                if( found == NO )
                {
                    [ [ self mutableArrayValueForKey: CEMainWindowControllerDocumentsArrayKey ] insertObject: document atIndex: 0 ];
                }
                else
                {
                    [ [ self mutableArrayValueForKey: CEMainWindowControllerDocumentsArrayKey ] replaceObjectAtIndex: i withObject: document ];
                }
            }
            else
            {
                if( _fileDetailsViewController == nil )
                {
                    _fileDetailsViewController                       = [ CEFileDetailsViewController new ];
                    _fileDetailsViewController.view.frame            = _mainView.bounds;
                    _fileDetailsViewController.view.autoresizingMask = NSViewWidthSizable
                                                                     | NSViewHeightSizable
                                                                     | NSViewMinXMargin
                                                                     | NSViewMaxXMargin
                                                                     | NSViewMinYMargin
                                                                     | NSViewMaxYMargin;
                }
                
                _fileDetailsViewController.file = document.file;
                
                [ _editorViewController.view removeFromSuperview ];
                
                [ _mainView addSubview: _fileDetailsViewController.view ];
            }
        }
    }
}

- ( IBAction )openDocument: ( id )sender
{
    NSOpenPanel * panel;
    
    ( void )sender;
    
    panel                                   = [ NSOpenPanel openPanel ];
    panel.allowsMultipleSelection           = NO;
    panel.canChooseDirectories              = NO;
    panel.canChooseFiles                    = YES;
    panel.canCreateDirectories              = NO;
    panel.treatsFilePackagesAsDirectories   = YES;
    panel.delegate                          = self;
    
    [ panel beginSheetModalForWindow: self.window completionHandler: ^( NSInteger result )
        {
            if( result != NSFileHandlingPanelOKButton )
            {
                return;
            }
            
            self.activeDocument = [ CEDocument documentWithPath: [ panel.URL path ] ];
        }
    ];
}

- ( IBAction )newDocument: ( id )sender
{
    ( void )sender;
    
    [ self showLanguageWindow ];
}

- ( IBAction )saveDocument: ( id )sender
{
    ( void )sender;
    
    NSLog( @"Save document..." );
}

- ( IBAction )addBookmark: ( id )sender
{
    [ _fileViewController addBookmark: sender ];
}

- ( IBAction )removeBookmark: ( id )sender
{
    [ _fileViewController removeBookmark: sender ];
}

- ( IBAction )clearConsole: ( id )sender
{
    ( void )sender;
    
    NSLog( @"Clear console..." );
}

- ( NSArray * )documents
{
    @synchronized( self )
    {
        return [ NSArray arrayWithArray: _documents ];
    }
}

- ( IBAction )toggleFileBrowser: ( id )sender
{
    CGRect frame;
    
    ( void )sender;
    
    if( _fileBrowserHidden == NO )
    {
        frame              = _leftView.frame;
        frame.size.width   = ( CGFloat )0;
        _fileBrowserHidden = YES;
        _leftView.frame    = frame;
        
        [ _viewsSegmentedControl setImage: [ NSImage imageNamed: @"ShowFiles" ] forSegment: 0 ];
    }
    else
    {
        [ _horizontalSplitView setPosition: [ [ CEPreferences sharedInstance ] fileBrowserWidth ] ofDividerAtIndex: 0 ];
        
        _fileBrowserHidden = NO;
        
        [ _viewsSegmentedControl setImage: [ NSImage imageNamed: @"ShowFiles-On" ] forSegment: 0 ];
    }
    
    [ [ CEPreferences sharedInstance ] setFileBrowserHidden: _fileBrowserHidden ];
}

- ( IBAction )toggleDebugArea: ( id )sender
{
    CGRect frame;
    
    ( void )sender;
    
    if( _debugAreaHidden == NO )
    {
        frame             = _bottomView.frame;
        frame.size.height = ( CGFloat )0;
        _debugAreaHidden  = YES;
        _bottomView.frame = frame;
        
        [ _verticalSplitView setDividerStyle: NSSplitViewDividerStyleThin ];
        [ _viewsSegmentedControl setImage: [ NSImage imageNamed: @"ShowDebugger" ] forSegment: 1 ];
    }
    else
    {
        [ _verticalSplitView setDividerStyle: NSSplitViewDividerStylePaneSplitter ];
        [ _verticalSplitView setPosition: _verticalSplitView.frame.size.height - [ [ CEPreferences sharedInstance ] debugAreaHeight ] ofDividerAtIndex: 0 ];
        
        _debugAreaHidden = NO;
        
        [ _viewsSegmentedControl setImage: [ NSImage imageNamed: @"ShowDebugger-On" ] forSegment: 1 ];
    }
    
    [ [ CEPreferences sharedInstance ] setDebugAreaHidden: _debugAreaHidden ];
}

- ( IBAction )toggleViews: ( id )sender
{
    if( _viewsSegmentedControl.selectedSegment == 0 )
    {
        [ self toggleFileBrowser: sender ];
    }
    else if( _viewsSegmentedControl.selectedSegment == 1 )
    {
        [ self toggleDebugArea: sender ];
    }
}

- ( IBAction )toggleLineNumbers: ( id )sender
{
    BOOL value;
    
    ( void )sender;
    
    value = [ [ CEPreferences sharedInstance ] showLineNumbers ];
    
    [ [ CEPreferences sharedInstance ] setShowLineNumbers: ( value == YES ) ? NO : YES ];
}

- ( IBAction )toggleSoftWrap: ( id )sender
{
    BOOL value;
    
    ( void )sender;
    
    value = [ [ CEPreferences sharedInstance ] softWrap ];
    
    [ [ CEPreferences sharedInstance ] setSoftWrap: ( value == YES ) ? NO : YES ];
}

- ( IBAction )toggleInvisibleCharacters: ( id )sender
{
    BOOL value;
    
    ( void )sender;
    
    value = [ [ CEPreferences sharedInstance ] showInvisibles ];
    
    [ [ CEPreferences sharedInstance ] setShowInvisibles: ( value == YES ) ? NO : YES ];
}

- ( IBAction )toggleFullScreenMode: ( id )sender
{
    if( _fullScreen == NO )
    {
        [ self enterFullScreenMode: sender ];
    }
    else
    {
        [ self exitFullScreenMode: sender ];
    }
}

- ( IBAction )enterFullScreenMode: ( id )sender
{
    NSView       * view;
    NSInteger      value;
    NSDictionary * options;
    
    ( void )sender;
    
    if( _fullScreen == YES )
    {
        return;
    }
    
    _fullScreen = YES;
    
    if( [ [ CEPreferences sharedInstance ] fullScreenStyle ] == CEPreferencesFullScreenStyleNative )
    {
        [ self.window toggleFullScreen: sender ];
    }
    else
    {
        view    = ( NSView * )( self.window.contentView );
        value   = NSApplicationPresentationAutoHideMenuBar | NSApplicationPresentationAutoHideDock;
        options = [ NSDictionary dictionaryWithObject: [ NSNumber numberWithInteger: value ] forKey: NSFullScreenModeApplicationPresentationOptions ];
        
        [ view enterFullScreenMode: self.window.screen withOptions: options ];
    }
}

- ( IBAction )exitFullScreenMode: ( id )sender
{
    NSView * view;
    
    ( void )sender;
    
    if( _fullScreen == NO )
    {
        return;
    }
    
    _fullScreen = NO;
    
    if( [ [ CEPreferences sharedInstance ] fullScreenStyle ] == CEPreferencesFullScreenStyleNative )
    {
        [ self.window toggleFullScreen: sender ];
    }
    else
    {
        view = ( NSView * )( self.window.contentView );
        
        [ view exitFullScreenModeWithOptions: nil ];
    }
}

@end
