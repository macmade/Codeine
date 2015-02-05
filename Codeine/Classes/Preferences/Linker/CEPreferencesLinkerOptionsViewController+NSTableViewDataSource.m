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

#import "CEPreferencesLinkerOptionsViewController+NSTableViewDataSource.h"
#import "CELinkerObject.h"
#import "CEPreferences.h"

@implementation CEPreferencesLinkerOptionsViewController( NSTableViewDataSource )

- ( NSInteger )numberOfRowsInTableView: ( NSTableView * )tableView
{
    NSArray * objects;
    
    objects = nil;
    
    if( tableView == _frameworksTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeFramework ];
    }
    else if( tableView == _sharedLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeSharedLibrary ];
    }
    else if( tableView == _staticLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeStaticLibrary ];
    }
    
    return ( NSInteger )( objects.count );
}

- ( id )tableView: ( NSTableView * )tableView objectValueForTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    NSArray        * objects;
    CELinkerObject * object;
    
    objects = nil;
    
    if( tableView == _frameworksTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeFramework ];
    }
    else if( tableView == _sharedLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeSharedLibrary ];
    }
    else if( tableView == _staticLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeStaticLibrary ];
    }
    
    if( objects == nil || ( NSUInteger )row >= objects.count )
    {
        return nil;
    }
    
    object = [ objects objectAtIndex: ( NSUInteger )row ];
    
    if( [ tableColumn.identifier isEqualToString: CEPreferencesLinkerOptionsViewControllerTableViewColumnIconIdentifier ] )
    {
        return object.icon;
    }
    else if( [ tableColumn.identifier isEqualToString: CEPreferencesLinkerOptionsViewControllerTableViewColumnNameIdentifier ] )
    {
        return [ object.name stringByDeletingPathExtension ];
    }
    else if( [ tableColumn.identifier isEqualToString: CEPreferencesLinkerOptionsViewControllerTableViewColumnPathIdentifier ] )
    {
        return [ object.path stringByDeletingLastPathComponent ];
    }
    else if( [ tableColumn.identifier isEqualToString: CEPreferencesLinkerOptionsViewControllerTableViewColumnLanguageIdentifier ] )
    {
        return [ NSNumber numberWithInteger: object.language ];
    }
    
    return nil;
}

- ( void )tableView: ( NSTableView * )tableView setObjectValue: ( id )object forTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    NSArray            * objects;
    CELinkerObject     * linkerObject;
    CESourceFileLanguage language;
    
    ( void )tableColumn;
    
    if( tableView == _frameworksTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeFramework ];
    }
    else if( tableView == _sharedLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeSharedLibrary ];
    }
    else if( tableView == _staticLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeStaticLibrary ];
    }
    
    @try
    {
        linkerObject = [ objects objectAtIndex: ( NSUInteger )row ];
    }
    @catch( NSException * e )
    {
        ( void )e;
    }
    
    language = ( CESourceFileLanguage )[ ( NSNumber * )object integerValue ];
    
    [ [ CEPreferences sharedInstance ] setLanguage: language ofLinkerObject: linkerObject ];
    [ tableView reloadData ];
}

@end
