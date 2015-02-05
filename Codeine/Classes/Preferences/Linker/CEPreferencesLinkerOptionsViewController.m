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

#import "CEPreferencesLinkerOptionsViewController.h"
#import "CEPreferencesLinkerOptionsViewController+NSTableViewDelegate.h"
#import "CEPreferencesLinkerOptionsViewController+NSTableViewDataSource.h"
#import "CEPreferencesLinkerOptionsViewController+Private.h"
#import "CEPreferencesLinkerOptionsViewController+NSOpenSavePanelDelegate.h"
#import "CEPreferences.h"

NSString * const CEPreferencesLinkerOptionsViewControllerTableViewColumnIconIdentifier      = @"Icon";
NSString * const CEPreferencesLinkerOptionsViewControllerTableViewColumnNameIdentifier      = @"Name";
NSString * const CEPreferencesLinkerOptionsViewControllerTableViewColumnPathIdentifier      = @"Path";
NSString * const CEPreferencesLinkerOptionsViewControllerTableViewColumnLanguageIdentifier  = @"Language";

@implementation CEPreferencesLinkerOptionsViewController

@synthesize frameworksTableView = _frameworksTableView;
@synthesize sharedLibsTableView = _sharedLibsTableView;
@synthesize staticLibsTableView = _staticLibsTableView;

- ( void )dealloc
{
    _frameworksTableView.delegate = nil;
    _sharedLibsTableView.delegate = nil;
    _staticLibsTableView.delegate = nil;
    
    _frameworksTableView.dataSource = nil;
    _sharedLibsTableView.dataSource = nil;
    _staticLibsTableView.dataSource = nil;
    
    RELEASE_IVAR( _frameworksTableView );
    RELEASE_IVAR( _sharedLibsTableView );
    RELEASE_IVAR( _staticLibsTableView );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    _frameworksTableView.delegate   = self;
    _frameworksTableView.dataSource = self;
    _sharedLibsTableView.delegate   = self;
    _sharedLibsTableView.dataSource = self;
    _staticLibsTableView.delegate   = self;
    _staticLibsTableView.dataSource = self;
}

- ( IBAction )addFramework: ( id )sender
{
    NSOpenPanel * panel;
    
    ( void )sender;
    
    panel                           = [ NSOpenPanel openPanel ];
    panel.canChooseDirectories      = YES;
    panel.canChooseFiles            = NO;
    panel.canCreateDirectories      = NO;
    panel.prompt                    = L10N( "AddFramework" );
    panel.allowsMultipleSelection   = NO;
    panel.delegate                  = self;
    
    _openPanelAllowedType = CELinkerObjectTypeFramework;
    
    [ panel beginSheetModalForWindow: self.view.window completionHandler: ^( NSInteger result )
        {
            NSString        * path;
            CELinkerObject  * object;
            
            if( result != NSFileHandlingPanelOKButton )
            {
                return;
            }
            
            path    = [ panel.URL path ];
            object  = [ CELinkerObject linkerObjectWithPath: path type: CELinkerObjectTypeFramework ];
            
            [ [ CEPreferences sharedInstance ] addLinkerObject: object ];
            [ _frameworksTableView reloadData ];
        }
    ];
}

- ( IBAction )removeFramework: ( id )sender
{
    NSInteger row;
    NSArray * objects;
    
    ( void )sender;
    
    objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeFramework ];
    row     = [ _frameworksTableView selectedRow ];
    
    if( row < 0 || ( NSUInteger )row >= objects.count )
    {
        return;
    }
    
    [ [ CEPreferences sharedInstance ] removeLinkerObject: [ objects objectAtIndex: ( NSUInteger )row ] ];
    [ _frameworksTableView reloadData ];
}

- ( IBAction )addSharedLib: ( id )sender
{
    NSOpenPanel * panel;
    
    ( void )sender;
    
    panel                           = [ NSOpenPanel openPanel ];
    panel.canChooseDirectories      = NO;
    panel.canChooseFiles            = YES;
    panel.canCreateDirectories      = NO;
    panel.prompt                    = L10N( "AddSharedLibrary" );
    panel.allowsMultipleSelection   = NO;
    panel.delegate                  = self;
    panel.allowedFileTypes          = [ NSArray arrayWithObject: @"dylib" ];
    
    _openPanelAllowedType = CELinkerObjectTypeSharedLibrary;
    
    [ panel beginSheetModalForWindow: self.view.window completionHandler: ^( NSInteger result )
        {
            NSString        * path;
            CELinkerObject  * object;
            
            if( result != NSFileHandlingPanelOKButton )
            {
                return;
            }
            
            path    = [ panel.URL path ];
            object  = [ CELinkerObject linkerObjectWithPath: path type: CELinkerObjectTypeSharedLibrary ];
            
            [ [ CEPreferences sharedInstance ] addLinkerObject: object ];
            [ _sharedLibsTableView reloadData ];
        }
    ];
}

- ( IBAction )removeSharedLib: ( id )sender
{
    NSInteger row;
    NSArray * objects;
    
    ( void )sender;
    
    objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeSharedLibrary ];
    row     = [ _sharedLibsTableView selectedRow ];
    
    if( row < 0 || ( NSUInteger )row >= objects.count )
    {
        return;
    }
    
    [ [ CEPreferences sharedInstance ] removeLinkerObject: [ objects objectAtIndex: ( NSUInteger )row ] ];
    [ _sharedLibsTableView reloadData ];
}

- ( IBAction )addStaticLib: ( id )sender
{
    NSOpenPanel * panel;
    
    ( void )sender;
    
    panel                           = [ NSOpenPanel openPanel ];
    panel.canChooseDirectories      = NO;
    panel.canChooseFiles            = YES;
    panel.canCreateDirectories      = NO;
    panel.prompt                    = L10N( "AddStaticLibrary" );
    panel.allowsMultipleSelection   = NO;
    panel.delegate                  = self;
    panel.allowedFileTypes          = [ NSArray arrayWithObject: @"a" ];
    
    _openPanelAllowedType = CELinkerObjectTypeStaticLibrary;
    
    [ panel beginSheetModalForWindow: self.view.window completionHandler: ^( NSInteger result )
        {
            NSString        * path;
            CELinkerObject  * object;
            
            if( result != NSFileHandlingPanelOKButton )
            {
                return;
            }
            
            path    = [ panel.URL path ];
            object  = [ CELinkerObject linkerObjectWithPath: path type: CELinkerObjectTypeStaticLibrary ];
            
            [ [ CEPreferences sharedInstance ] addLinkerObject: object ];
            [ _staticLibsTableView reloadData ];
        }
    ];
}

- ( IBAction )removeStaticLib: ( id )sender
{
    NSInteger row;
    NSArray * objects;
    
    ( void )sender;
    
    objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeStaticLibrary ];
    row     = [ _staticLibsTableView selectedRow ];
    
    if( row < 0 || ( NSUInteger )row >= objects.count )
    {
        return;
    }
    
    [ [ CEPreferences sharedInstance ] removeLinkerObject: [ objects objectAtIndex: ( NSUInteger )row ] ];
    [ _staticLibsTableView reloadData ];
}

@end
