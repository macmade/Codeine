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

#import "CEApplicationDelegate.h"
#import "CEApplicationDelegate+Private.h"
#import "CEApplicationDelegate+NSOpenSavePanelDelegate.h"
#import "CEMainWindowController.h"
#import "CEPreferencesWindowController.h"
#import "CEAboutWindowController.h"
#import "CEAlternateAboutWindowController.h"
#import "CEPreferences.h"
#import "CEDocument.h"
#import "CERegistrationWindowController.h"

@implementation CEApplicationDelegate

@synthesize activeMainWindowController = _activeMainWindowController;

+ ( CEApplicationDelegate * )sharedInstance
{
    return ( CEApplicationDelegate * )( APPLICATION.delegate );
}

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        [ CEPreferences sharedInstance ];
        [ self installApplicationSupportFiles ];
        [ self firstLaunch ];
        
        _mainWindowControllers = [ [ NSMutableArray alloc ] initWithCapacity: 10 ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ NOTIFICATION_CENTER removeObserver: self ];
    
    RELEASE_IVAR( _mainWindowControllers );
    RELEASE_IVAR( _preferencesWindowController );
    RELEASE_IVAR( _aboutWindowController );
    RELEASE_IVAR( _alternateAboutWindowController );
    RELEASE_IVAR( _activeMainWindowController );
    
    [ super dealloc ];
}

- ( void )applicationDidFinishLaunching: ( NSNotification * )notification
{
    ( void )notification;
    
    [ CEPreferences sharedInstance ];
    [ self installApplicationSupportFiles ];
    [ self firstLaunch ];
    
    [ NOTIFICATION_CENTER addObserver: self selector: @selector( windowDidClose: )     name: NSWindowWillCloseNotification    object: nil ];
    [ NOTIFICATION_CENTER addObserver: self selector: @selector( windowDidBecomeKey: ) name: NSWindowDidBecomeKeyNotification object: nil ];
    
    if( _mainWindowControllers.count == 0 )
    {
        [ self newWindow: nil ];
    }
}

- ( void )applicationWillTerminate: ( NSNotification * )notification
{
    ( void )notification;
    
    [ [ CEPreferences sharedInstance ] setFirstLaunch: NO ];
}

- ( IBAction )showPreferencesWindow: ( id )sender
{
    ( void )sender;
    
    if( _preferencesWindowController == nil )
    {
        _preferencesWindowController = [ CEPreferencesWindowController new ];
    }
    
    [ APPLICATION runModalForWindow: _preferencesWindowController.window ];
}

- ( IBAction )showAboutWindow: ( id )sender
{
    if( _aboutWindowController == nil )
    {
        _aboutWindowController = [ CEAboutWindowController new ];
    }
    
    [ _aboutWindowController.window center ];
    [ _aboutWindowController showWindow: sender ];
    [ _aboutWindowController.window makeKeyAndOrderFront: sender ];
}

- ( IBAction )showAlternateAboutWindow: ( id )sender
{
    if( _alternateAboutWindowController == nil )
    {
        _alternateAboutWindowController = [ CEAlternateAboutWindowController new ];
    }
    
    [ _alternateAboutWindowController.window center ];
    [ _alternateAboutWindowController showWindow: sender ];
    [ _alternateAboutWindowController.window makeKeyAndOrderFront: sender ];
}

- ( IBAction )showRegistrationWindow: ( id )sender
{
    ( void )sender;
    
    if( _registrationWindowController == nil )
    {
        _registrationWindowController = [ CERegistrationWindowController new ];
    }
    
    [ _registrationWindowController.window center ];
    [ APPLICATION runModalForWindow: _registrationWindowController.window ];
}

- ( IBAction )newWindow: ( id )sender
{
    CEMainWindowController * controller;
    
    controller = [ CEMainWindowController new ];
    
    [ _mainWindowControllers addObject: controller ];
    
    [ controller.window center ];
    [ controller showWindow: sender ];
    [ controller.window makeKeyAndOrderFront: sender ];
}

- ( IBAction )newDocument: ( id )sender
{
    ( void )sender;
    
    if(_mainWindowControllers.count > 0 )
    {
        [ self.activeMainWindowController newDocument: sender ];
    }
    else
    {
        [ self newWindow: sender ];
    }
}

- ( IBAction )openDocument: ( id )sender
{
            NSOpenPanel            * panel;
    __block CEMainWindowController * controller;
    
    if( _mainWindowControllers.count > 0 )
    {
        controller = self.activeMainWindowController;
        
        [ controller.window makeKeyAndOrderFront: sender ];
        [ controller showWindow: sender ];
        [ controller openDocument: sender ];
        
        return;
    }
    
    panel                                   = [ NSOpenPanel openPanel ];
    panel.allowsMultipleSelection           = NO;
    panel.canChooseDirectories              = NO;
    panel.canChooseFiles                    = YES;
    panel.canCreateDirectories              = NO;
    panel.treatsFilePackagesAsDirectories   = YES;
    panel.delegate                          = self;
    
    [ panel beginWithCompletionHandler: ^( NSInteger result )
        {
            if( result != NSFileHandlingPanelOKButton )
            {
                return;
            }
            
            controller                  = [ CEMainWindowController new ];
            controller.activeDocument   = [ CEDocument documentWithPath: [ panel.URL path ] ];
            
            [ _mainWindowControllers addObject: controller ];
            
            [ controller.window center ];
            [ controller showWindow: sender ];
            [ controller.window makeKeyAndOrderFront: sender ];
        }
    ];
}

- ( BOOL )application: ( NSApplication * )application openFile: ( NSString * )filename
{
    CEMainWindowController * controller;
    CEDocument             * document;
    
    ( void )application;
    
    document = [ CEDocument documentWithPath: filename ];
    
    if( document.sourceFile.text == nil )
    {
        return NO;
    }
    
    if( _mainWindowControllers.count > 0 )
    {
        controller = self.activeMainWindowController;
    }
    else
    {
        controller = [ CEMainWindowController new ];
        
        [ _mainWindowControllers addObject: controller ];
        [ controller.window center ];
    }
    
    [ controller setActiveDocument: document ];
    [ controller showWindow: nil ];
    [ controller.window makeKeyAndOrderFront: nil ];
    
    return YES;
}

- ( IBAction )resetColorThemes: ( id )sender
{
    NSString * path;
    
    ( void )sender;
    
    path = [ [ FILE_MANAGER applicationSupportDirectory ] stringByAppendingPathComponent: @"Themes" ];

    [ FILE_MANAGER removeItemAtPath: path error: NULL ];
    [ self installApplicationSupportFiles ];
}

@end
