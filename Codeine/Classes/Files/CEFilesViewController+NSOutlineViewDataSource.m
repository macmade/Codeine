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

#import "CEFilesViewController+NSOutlineViewDataSource.h"
#import "CEFilesViewController+Private.h"
#import "CEFilesViewItem.h"
#import "CEFile.h"

@implementation CEFilesViewController( NSOutlineViewDataSource )

- ( NSInteger )outlineView: ( NSOutlineView * )outlineView numberOfChildrenOfItem: ( id )item
{
    CEFilesViewItem * fileViewItem;
    
    ( void )outlineView;
    
    if( item == nil )
    {
        return ( NSInteger )( _rootItems.count );
    }
    
    if( [ item isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return 0;
    }
    
    fileViewItem = ( CEFilesViewItem * )item;
    
    return ( NSInteger )( fileViewItem.children.count );
}

- ( BOOL )outlineView: ( NSOutlineView * )outlineView isItemExpandable: ( id )item
{
    CEFilesViewItem * fileViewItem;
    
    ( void )outlineView;
    
    if( [ item isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return NO;
    }
    
    fileViewItem = ( CEFilesViewItem * )item;
    
    return fileViewItem.expandable;
}

- ( id )outlineView: ( NSOutlineView * )outlineView child: ( NSInteger )index ofItem: ( id )item
{
    CEFilesViewItem * fileViewItem;
    
    ( void )outlineView;
    
    if( item == nil )
    {
        @try
        {
            return [ _rootItems objectAtIndex: ( NSUInteger )index ];
        }
        @catch( NSException * e )
        {
            ( void )e;
            
            return nil;
        }
    }
    
    if( [ item isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return nil;
    }
    
    fileViewItem = ( CEFilesViewItem * )item;
    
    @try
    {
        return [ fileViewItem.children objectAtIndex: ( NSUInteger )index ];
    }
    @catch( NSException * e )
    {
        ( void )e;
    }
    
    return nil;
}

- ( id )outlineView: ( NSOutlineView * )outlineView objectValueForTableColumn: ( NSTableColumn * )tableColumn byItem: ( id )item
{
    CEFilesViewItem * fileViewItem;
    
    ( void )outlineView;
    ( void )tableColumn;
    
    if( [ item isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return nil;
    }
    
    fileViewItem = ( CEFilesViewItem * )item;
    
    return ( fileViewItem.type == CEFilesViewItemTypeSection ) ? fileViewItem.displayName : fileViewItem;
}

- ( void )outlineView: ( NSOutlineView * )outlineView setObjectValue: ( id )object forTableColumn: ( NSTableColumn * )tableColumn byItem: ( id )item
{
    CEFilesViewItem  * fileViewItem;
    NSString        * path;
    NSString        * newPath;
    NSString        * newName;
    NSError         * error;
    
    ( void )outlineView;
    ( void )tableColumn;
    
    if( [ object isKindOfClass: [ NSString class ] ] == NO )
    {
        return;
    }
    
    newName = object;
    
    if( [ item isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    fileViewItem = ( CEFilesViewItem * )item;
    path         = fileViewItem.file.path;
    
    if( path.length == 0 || [ path.lastPathComponent isEqualToString: newName ] )
    {
        return;
    }
    
    newPath = [ [ path stringByDeletingLastPathComponent ] stringByAppendingPathComponent: newName ];
    error   = nil;
    
    if( [ FILE_MANAGER moveItemAtPath: path toPath: newPath error: &error ] == NO || error != nil )
    {
        NSBeep();
    }
    else
    {
        {
            id parent;
            
            if( [ fileViewItem.parent isKindOfClass: [ CEFilesViewItem class ] ] == YES )
            {
                parent = fileViewItem.parent;
                
                [ parent reload ];
                
                [ _outlineView reloadItem: parent reloadChildren: YES ];
            }
        }
    }
}

- ( id )outlineView: ( NSOutlineView * )outlineView persistentObjectForItem: ( id )item
{
    CEFilesViewItem * fileViewItem;
    NSDictionary   * dictionary;
    
    ( void )outlineView;
    
    if( [ item isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return nil;
    }
    
    fileViewItem = ( CEFilesViewItem * )item;
    
    if( fileViewItem.type == CEFilesViewItemTypeDocument )
    {
        return nil;
    }
    
    dictionary = [ NSDictionary dictionaryWithObjectsAndKeys: [ NSNumber numberWithInteger: fileViewItem.type ],  @"Type",
                                                              fileViewItem.name,                                  @"Name",
                                                              nil
                 ];
    
    return dictionary;
}

- ( id )outlineView: ( NSOutlineView * )outlineView itemForPersistentObject: ( id )object
{
    CEFilesViewItemType  type;
    NSString           * name;
    CEFilesViewItem    * item;
    
    ( void )outlineView;
    
    if( [ object isKindOfClass: [ NSDictionary class ] ] )
    {
        type = ( CEFilesViewItemType )[ ( NSNumber * )[ ( NSDictionary * )object objectForKey: @"Type" ] integerValue ];
        name = [ ( NSDictionary * )object objectForKey: @"Name" ];
        
        if( type == CEFilesViewItemTypeSection && [ name isEqualToString: CEFilesViewPlacesItemName ] )
        {
            item = [ CEFilesViewItem placesItem ];
        }
        else if( type == CEFilesViewItemTypeSection && [ name isEqualToString: CEFilesViewBookmarksItemName ] )
        {
            item = [ CEFilesViewItem bookmarksItems ];
        }
        else if( type == CEFilesViewItemTypeFS )
        {
            item = [ [ CEFilesViewItem placesItem ] valueForKeyPath: name ];
        }
        else if( type == CEFilesViewItemTypeBookmark )
        {
            item = [ [ CEFilesViewItem bookmarksItems ] valueForKeyPath: name ];
        }
        else
        {
            item = nil;
        }
        
        return item;
    }
    
    return nil;
}

@end
