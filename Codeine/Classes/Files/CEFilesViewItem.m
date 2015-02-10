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

#import "CEFilesViewItem.h"
#import "CEFilesViewItemSection.h"
#import "CEFilesViewItemDocument.h"
#import "CEFilesViewItemFS.h"
#import "CEFilesViewItemBookmark.h"
#import "CEPreferences.h"
#import "CEFile.h"

NSString * const CEFilesViewOpenDocumentsItemName    = @"OpenDocuments";
NSString * const CEFilesViewPlacesItemName           = @"Places";
NSString * const CEFilesViewBookmarksItemName        = @"Bookmarks";

static CEFilesViewItem * __placesItem        = nil;
static CEFilesViewItem * __openDocumentsItem = nil;
static CEFilesViewItem * __bookmarksItem     = nil;

static void __exit( void ) __attribute__( ( destructor ) );
static void __exit( void )
{
    [ __placesItem          release ];
    [ __openDocumentsItem   release ];
    [ __bookmarksItem       release ];
}

@implementation CEFilesViewItem

@synthesize type                = _type;
@synthesize representedObject   = _representedObject;
@synthesize name                = _name;
@synthesize displayName         = _displayName;
@synthesize icon                = _icon;
@synthesize parent              = _parent;
@synthesize file                = _file;

+ ( id )placesItem
{
    if( __placesItem == nil )
    {
        __placesItem = [ [ self fileViewItemWithType: CEFilesViewItemTypeSection name: CEFilesViewPlacesItemName ] retain ];
        
        [ __placesItem reload ];
    }
    
    return __placesItem;
}

+ ( id )bookmarksItems
{
    if( __bookmarksItem == nil )
    {
        __bookmarksItem = [ [ self fileViewItemWithType: CEFilesViewItemTypeSection name: CEFilesViewBookmarksItemName ] retain ];
        
        [ __bookmarksItem reload ];
    }
    
    return __bookmarksItem;
}

+ ( id )fileViewItemWithType: ( CEFilesViewItemType )type name: ( NSString * )name
{
    return [ [ [ self alloc ] initWithType: type name: name ] autorelease ];
}

- ( id )initWithType: ( CEFilesViewItemType )type name: ( NSString * )name
{
    id item;
    
    if( [ self class ] != [ CEFilesViewItem class ] )
    {
        if( ( self = [ super init ] ) )
        {
            _type        = type;
            _name        = [ name copy ];
            _displayName = [ name copy ];
            _children    = [ [ NSMutableArray alloc ] initWithCapacity: 100 ];
        }
        
        return self;
    }
    
    switch( type )
    {
        case CEFilesViewItemTypeSection:
            
            item = [ [ CEFilesViewItemSection alloc ] initWithType: type name: name ];
            break;
            
        case CEFilesViewItemTypeDocument:
            
            item = [ [ CEFilesViewItemDocument alloc ] initWithType: type name: name ];
            break;
            
        case CEFilesViewItemTypeFS:
            
            item = [ [ CEFilesViewItemFS alloc ] initWithType: type name: name ];
            break;
            
        case CEFilesViewItemTypeBookmark:
            
            item = [ [ CEFilesViewItemBookmark alloc ] initWithType: type name: name ];
            break;
    }
    
    [ self release ];
    
    return item;
}

- ( void )dealloc
{
    RELEASE_IVAR( _name );
    RELEASE_IVAR( _displayName );
    RELEASE_IVAR( _representedObject );
    RELEASE_IVAR( _children );
    
    [ super dealloc ];
}

- ( id )copyWithZone: ( NSZone * )zone
{
    CEFilesViewItem * item;
    
    item = [ [ [ self class ] allocWithZone: zone ] initWithType: _type name: _name ];
    
    if( item != nil )
    {
        [ item->_displayName        release ];
        [ item->_icon               release ];
        [ item->_representedObject  release ];
        [ item->_children           release ];
        [ item->_file               release ];
        
        item->_displayName          = [ _displayName copyWithZone: zone ];
        item->_icon                 = [ _icon copyWithZone: zone ];
        item->_representedObject    = [ _representedObject retain ];
        item->_children             = [ _children copyWithZone: zone ];
        item->_parent               = _parent;
        item->_file                 = [ _file retain ];
    }
    
    return item;
}

- ( NSArray * )children
{
    @synchronized( self )
    {
        return [ NSArray arrayWithArray: _children ];
    }
}

- ( void )addChild: ( CEFilesViewItem * )child
{
    child->_parent = self;
    
    [ _children addObject: child ];
}

- ( void )removeChild: ( CEFilesViewItem * )child
{
    child->_parent = nil;
    
    [ _children removeObject: child ];
}

- ( void )removeAllChildren
{
    CEFilesViewItem * child;
    
    for( child in _children )
    {
        child->_parent = nil;
    }
    
    [ _children removeAllObjects ];
}

- ( BOOL )expandable
{
    return NO;
}

- ( BOOL )isEqual: ( id )object
{
    CEFilesViewItem * item;
    
    if( [ object isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return NO;
    }
    
    item = ( CEFilesViewItem * )object;
    
    return ( BOOL )( self.type == item.type && [ self.name isEqualToString: item.name ] );
}

- ( NSString * )description
{
    return self.displayName;
}

- ( id )valueForKeyPath: ( NSString * )keyPath
{
    ( void )keyPath;
    
    return nil;
}

- ( void )reload
{
    RELEASE_IVAR( _children );
    
    _children = [ [ NSMutableArray alloc ] initWithCapacity: 100 ];
    
    [ self children ];
}

- ( BOOL )isLeaf
{
    return NO;
}

@end
