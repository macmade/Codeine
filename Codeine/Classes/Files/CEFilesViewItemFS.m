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

#import "CEFilesViewItemFS.h"
#import "CEPreferences.h"
#import "CEFile.h"

@implementation CEFilesViewItemFS

- ( id )initWithType: ( CEFilesViewItemType )type name: ( NSString * )name
{
    NSRange range;
    
    if( ( self = [ super initWithType: type name: name ] ) )
    {
        range = [ _name rangeOfString: @":" ];
        
        if( range.location == NSNotFound )
        {
            _path   = [ _name copy ];
            _prefix = nil;
        }
        else
        {
            _path   = [ [ _name substringFromIndex: range.location + 1 ] copy ];
            _prefix = [ [ _name substringToIndex: range.location ] copy ];
        }
        
        if( [ FILE_MANAGER fileExistsAtPath: _path isDirectory: &_isDirectory ] == NO )
        {
            [ self release ];
            
            return nil;
        }
        
        _file = [ [ CEFile alloc ] initWithPath: _path ];
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _path );
    RELEASE_IVAR( _prefix );
    RELEASE_IVAR( _file );
    
    [ super dealloc ];
}

- ( id )copyWithZone: ( NSZone * )zone
{
    CEFilesViewItemFS * item;
    
    item = [ super copyWithZone: zone ];
    
    if( item != nil )
    {
        [ item->_path   release ];
        [ item->_prefix release ];
        
        item->_path        = [ _path   copy ];
        item->_prefix      = [ _prefix copy ];
        item->_isDirectory = _isDirectory;
    }
    
    return item;
}

- ( NSString * )displayName
{
    return [ FILE_MANAGER displayNameAtPath: _path ];
}

- ( NSImage * )icon
{
    return [ WORKSPACE iconForFile: _path ];
}

- ( BOOL )expandable
{
    return _isDirectory && self.children.count > 0;
}

- ( NSArray * )children
{
    NSDirectoryEnumerator * enumerator;
    NSString              * file;
    NSString              * path;
    NSString              * name;
    CEFilesViewItem        * item;
    CFURLRef                url;
    LSItemInfoRecord        info;
    BOOL                    invisible;
    BOOL                    showHidden;
    
    if( super.children.count > 0 )
    {
        return [ super children ];
    }
    
    showHidden = [ [ CEPreferences sharedInstance ] showHiddenFiles ];
    enumerator = [ FILE_MANAGER enumeratorAtPath: _path ];
    
    while( ( file = [ enumerator nextObject ] ) )
    {
        [ enumerator skipDescendants ];
        
        path = [ _path stringByAppendingPathComponent: file ];
        
        if( showHidden == NO )
        {
            if( [ path isEqualToString: @"/dev"  ] ) { continue; }
            if( [ path isEqualToString: @"/home" ] ) { continue; }
            if( [ path isEqualToString: @"/net"  ] ) { continue; }
        }
        
        if( _prefix == nil )
        {
            name = [ _path stringByAppendingFormat: @":%@", path ];
        }
        else
        {
            name = [ _prefix stringByAppendingFormat: @":%@", path ];
        }
        
        item = [ CEFilesViewItem fileViewItemWithType: _type name: name ];
        url  = CFURLCreateWithFileSystemPath( kCFAllocatorDefault, ( CFStringRef )path, kCFURLPOSIXPathStyle, YES );
        
        LSCopyItemInfoForURL( url, kLSRequestAllFlags, &info );
        
        invisible = info.flags & kLSItemInfoIsInvisible;
        
        if( item != nil && ( invisible == NO || showHidden == YES ) )
        {
            [ self addChild: item ];
        }
        
        CFRelease( url );
    }
    
    return super.children;
}

- ( id )valueForKeyPath: ( NSString * )keyPath
{
    CEFilesViewItem * item;
    
    [ self children ];
    
    for( item in self.children )
    {
        if( [ item.name isEqualToString: keyPath ] )
        {
            return item;
        }
        else if( [ keyPath hasPrefix: item.name ] )
        {
            return [ item valueForKeyPath: keyPath ];
        }
    }
    
    return nil;
}

- ( BOOL )isLeaf
{
    return ( _isDirectory == YES ) ? NO : YES;
}

- ( void )reload
{
    RELEASE_IVAR( _file );
    
    _file = [ [ CEFile alloc ] initWithPath: _path ];
}

@end
