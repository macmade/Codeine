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

#import "CEFilesViewController.h"
#import "CEFilesViewController+Private.h"
#import "CEFilesViewController+NSOutlineViewDelegate.h"
#import "CEFilesViewController+NSOutlineViewDataSource.h"
#import "CEFilesViewItem.h"
#import "CEPreferences.h"
#import "CEInfoWindowController.h"
#import "CEApplicationDelegate.h"
#import "CEMainWindowController.h"
#import "CEFile.h"
#import "CEColorLabelMenuItem.h"
#import "CEDocument.h"
#import <Quartz/Quartz.h>

@implementation CEFilesViewController

@synthesize outlineView             = _outlineView;
@synthesize openDocumentMenu        = _openDocumentMenu;
@synthesize bookmarkMenu            = _bookmarkMenu;
@synthesize fsDirectoryMenu         = _fsDirectoryMenu;
@synthesize fsFileMenu              = _fsFileMenu;

- ( void )dealloc
{
    [ NOTIFICATION_CENTER removeObserver: self ];
    [ _mainWindowController removeObserver: self forKeyPath: CEMainWindowControllerDocumentsArrayKey ];
    
    _outlineView.delegate   = nil;
    _outlineView.dataSource = nil;
    
    RELEASE_IVAR( _outlineView );
    RELEASE_IVAR( _rootItems );
    RELEASE_IVAR( _openDocumentMenu );
    RELEASE_IVAR( _bookmarkMenu );
    RELEASE_IVAR( _fsDirectoryMenu );
    RELEASE_IVAR( _fsFileMenu );
    RELEASE_IVAR( _quickLookItem );
    RELEASE_IVAR( _openDocumentsItem );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    _rootItems          = [ [ NSMutableArray alloc ] initWithCapacity: 10 ];
    _openDocumentsItem  = [ [ CEFilesViewItem alloc ] initWithType: CEFilesViewItemTypeSection name: CEFilesViewOpenDocumentsItemName ];
    
    [ _rootItems addObject: _openDocumentsItem ];
    [ _rootItems addObject: [ CEFilesViewItem placesItem ] ];
    [ _rootItems addObject: [ CEFilesViewItem bookmarksItems ] ];
    
    [ self setNextResponder: _outlineView.nextResponder ];
    [ _outlineView setNextResponder: self ];
    
    _outlineView.delegate               = self;
    _outlineView.dataSource             = self;
    _outlineView.autosaveExpandedItems  = YES;
    _outlineView.autosaveName           = NSStringFromClass( [ self class ] );
    
    [ _outlineView reloadItem: _openDocumentsItem                   reloadChildren: YES ];
    [ _outlineView reloadItem: [ CEFilesViewItem placesItem ]       reloadChildren: YES ];
    [ _outlineView reloadItem: [ CEFilesViewItem bookmarksItems ]   reloadChildren: YES ];
    
    [ _outlineView expandItem: _openDocumentsItem expandChildren: NO ];
    
    if( [ [ CEPreferences sharedInstance ] firstLaunch ] == YES )
    {
        [ _outlineView expandItem: [ CEFilesViewItem placesItem ]        expandChildren: NO ];
        [ _outlineView expandItem: [ CEFilesViewItem bookmarksItems ]    expandChildren: NO ];
    }
}

- ( CEMainWindowController * )mainWindowController
{
    @synchronized( self )
    {
        return _mainWindowController;
    }
}

- ( void )setMainWindowController: ( CEMainWindowController * )controller
{
    if( controller != _mainWindowController )
    {
        [ _mainWindowController removeObserver: self forKeyPath: CEMainWindowControllerDocumentsArrayKey ];
        
        _mainWindowController = controller;
        
        [ _mainWindowController addObserver: self forKeyPath: CEMainWindowControllerDocumentsArrayKey options: NSKeyValueObservingOptionNew context: nil ];
    }
}

- ( void )observeValueForKeyPath: ( NSString * )keyPath ofObject: ( id )object change: ( NSDictionary * )change context: ( void * )context
{
    CEFilesViewItem * item;
    CEFilesViewItem * selectedItem;
    CEDocument      * document;
    
    ( void )object;
    ( void )change;
    ( void )context;
    
    if( keyPath == CEMainWindowControllerDocumentsArrayKey )
    {
        [ _openDocumentsItem removeAllChildren ];
        
        selectedItem = nil;
        
        for( document in _mainWindowController.documents )
        {
            item                    = [ CEFilesViewItem fileViewItemWithType: CEFilesViewItemTypeDocument name: document.name ];
            item.representedObject  = document;
            
            if( document == _mainWindowController.activeDocument )
            {
                selectedItem = item;
            }
            
            [ _openDocumentsItem addChild: item ];
        }
        
        [ _outlineView reloadData ];
        [ _outlineView expandItem: _openDocumentsItem ];
        
        if( selectedItem != nil )
        {
            [ _outlineView selectRowIndexes: [ NSIndexSet indexSetWithIndex: ( NSUInteger )[ _outlineView rowForItem: selectedItem ] ] byExtendingSelection: NO ];
        }
    }
}

- ( IBAction )addBookmark: ( id )sender
{
    NSOpenPanel * panel;
    
    ( void )sender;
    
    panel                           = [ NSOpenPanel openPanel ];
    panel.allowsMultipleSelection   = NO;
    panel.canChooseDirectories      = YES;
    panel.canChooseFiles            = NO;
    panel.canCreateDirectories      = YES;
    panel.prompt                    = L10N( "AddBookmark" );
    
    [ panel beginSheetModalForWindow: self.view.window completionHandler: ^( NSInteger result )
        {
            NSString * path;
            
            if( result != NSFileHandlingPanelOKButton )
            {
                return;
            }
            
            path = [ panel.URL path ];
            
            [ [ CEPreferences sharedInstance ] addBookmark: path ];
            [ ( CEFilesViewItem * )[ CEFilesViewItem bookmarksItems ] addChild: [ CEFilesViewItem fileViewItemWithType: CEFilesViewItemTypeBookmark name: path ] ];
            [ _outlineView reloadItem: [ CEFilesViewItem bookmarksItems ] reloadChildren: YES ];
            [ _outlineView expandItem: [ CEFilesViewItem bookmarksItems ] ];
        }
    ];
}

- ( IBAction )removeBookmark: ( id )sender
{
    NSInteger         row;
    CEFilesViewItem * item;
    
    ( void )sender;
    
    row = _outlineView.selectedRow;
    
    if( row == -1 )
    {
        return;
    }
    
    item = [ _outlineView itemAtRow: row ];
    
    if( item == nil || item.type != CEFilesViewItemTypeBookmark )
    {
        return;
    }
    
    [ [ CEPreferences sharedInstance ] removeBookmark: item.name ];
    [ ( CEFilesViewItem * )[ CEFilesViewItem bookmarksItems ] removeChild: item ];
    [ _outlineView reloadItem: [ CEFilesViewItem bookmarksItems ] reloadChildren: YES ];
}

- ( IBAction )menuActionOpen: ( id )sender
{
    NSMenuItem       * menuItem;
    CEFilesViewItem  * item;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
}

- ( IBAction )menuActionClose: ( id )sender
{
    NSMenuItem       * menuItem;
    CEFilesViewItem  * item;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
}

- ( IBAction )menuActionShowInFinder: ( id )sender
{
    NSMenuItem       * menuItem;
    CEFilesViewItem  * item;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
    
    [ WORKSPACE selectFile: item.file.path inFileViewerRootedAtPath: nil ];
}

- ( IBAction )menuActionOpenInDefaultEditor: ( id )sender
{
    NSMenuItem       * menuItem;
    CEFilesViewItem  * item;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
    
    [ WORKSPACE openFile: item.file.path ];
}

- ( IBAction )menuActionDelete: ( id )sender
{
    NSMenuItem       * menuItem;
    CEFilesViewItem  * item;
    NSError          * error;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item  = menuItem.representedObject;
    error = nil;
    
    {
        NSAlert * alert;
        
        alert                   = [ NSAlert new ];
        alert.messageText       = [ NSString stringWithFormat: L10N( "DeleteAlertTitle" ), [ FILE_MANAGER displayNameAtPath: item.file.path ] ];
        alert.informativeText   = L10N( "DeleteAlertText" );
        
        [ alert addButtonWithTitle: L10N( "OK" ) ];
        [ alert addButtonWithTitle: L10N( "Cancel" ) ];
        
        if( [ alert runModal ] != NSAlertFirstButtonReturn )
        {
            return;
        }
    }
    
    if( [ FILE_MANAGER removeItemAtPath: item.file.path error: &error ] == NO || error != nil )
    {
        {
            NSAlert * alert;
            
            alert                   = [ NSAlert new ];
            alert.messageText       = L10N( "DeleteErrorTitle" );
            alert.informativeText   = L10N( "DeleteErrorText" );
            alert.alertStyle        = NSWarningAlertStyle;
            
            [ alert addButtonWithTitle: L10N( "OK" ) ];
            
            NSBeep();
            
            [ alert runModal ];
        }
    }
    else
    {
        {
            id parent;
            
            parent = item.parent;
            
            if( [ parent isKindOfClass: [ CEFilesViewItem class ] ] )
            {
                [ ( CEFilesViewItem * )parent removeChild: item ];
            }
            
            [ _outlineView reloadItem: parent reloadChildren: YES ];
        }
    }
}

- ( IBAction )menuActionRemoveBookmark: ( id )sender
{
    NSMenuItem      * menuItem;
    CEFilesViewItem * item;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
    
    [ [ CEPreferences sharedInstance ] removeBookmark: item.name ];
    [ ( CEFilesViewItem * )[ CEFilesViewItem bookmarksItems ] removeChild: item ];
    [ _outlineView reloadItem: [ CEFilesViewItem bookmarksItems ] reloadChildren: YES ];
}

- ( IBAction )menuActionGetInfo: ( id )sender
{
    NSMenuItem              * menuItem;
    CEFilesViewItem         * item;
    CEInfoWindowController  * controller;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item        = menuItem.representedObject;
    controller  = [ [ CEInfoWindowController alloc ] initWithPath: item.file.path ];
    
    if( controller != nil )
    {
        controller.releaseOnWindowClose = YES;
        
        [ controller.window center ];
        [ controller showWindow: sender ];
        [ controller.window makeKeyAndOrderFront: sender ];
        [ controller autorelease ];
    }
    else
    {
        NSBeep();
    }
}

- ( IBAction )menuActionQuickLook: ( id )sender
{
    NSMenuItem      * menuItem;
    CEFilesViewItem * item;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
    
    [ APPLICATION showQuickLookPanelForItemAtPath: item.file.path sender: sender ];
}

- ( IBAction )menuActionSetColorLabel: ( id )sender
{
    CEColorLabelMenuItem * menuItem;
    CEFilesViewItem      * item;
    NSArray              * colors;
    NSUInteger             index;
    
    if( [ sender isKindOfClass: [ CEColorLabelMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( menuItem.selectedColor == nil )
    {
        return;
    }
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
    
    if( item.file == nil )
    {
        return;
    }
    
    colors = [ WORKSPACE fileLabelColors ];
    index  = [ colors indexOfObject: menuItem.selectedColor ];
    
    if( index < colors.count )
    {
        [ item.file.url setResourceValue: [ NSNumber numberWithUnsignedInteger: index ] forKey: NSURLLabelNumberKey error: NULL ];
        [ _outlineView reloadItem: item reloadChildren: NO ];
    }
}

@end
