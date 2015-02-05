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

#import "CEFilesViewItemSection.h"
#import "CEPreferences.h"

@implementation CEFilesViewItemSection

- ( id )initWithType: ( CEFilesViewItemType )type name: ( NSString * )name
{
    if( ( self = [ super initWithType: type name: name ] ) )
    {}
    
    return self;
}

- ( BOOL )expandable
{
    return ( BOOL )( self.children.count > 0 );
}

- ( NSString * )displayName
{
    return L10N( [ _name cStringUsingEncoding: NSUTF8StringEncoding ] );
}

- ( id )valueForKeyPath: ( NSString * )keyPath
{
    NSRange          range;
    CEFilesViewItem * item;
    NSString       * prefix;
    
    range = [ keyPath rangeOfString: @":" ];
    
    if( range.location == NSNotFound )
    {
        for( item in self.children )
        {
            if( [ item.name isEqualToString: keyPath ] )
            {
                return item;
            }
        }
    }
    else
    {
        prefix = [ keyPath substringToIndex: range.location ];
        
        for( item in self.children )
        {
            if( [ item.name isEqualToString: prefix ] )
            {
                return [ item valueForKeyPath: keyPath ];
            }
        }
    }
    
    return nil;
}

- ( void )reload
{
    [ super reload ];
    
    if( [ self.name isEqualToString: CEFilesViewPlacesItemName ] )
    {
        {
            NSString       * rootPath;
            NSString       * userPath;
            NSString       * desktopPath;
            NSString       * documentsPath;
            
            desktopPath     = [ NSSearchPathForDirectoriesInDomains( NSDesktopDirectory, NSUserDomainMask, YES ) objectAtIndex: 0 ];
            documentsPath   = [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex: 0 ];
            userPath        = NSHomeDirectory();
            rootPath        = @"/";
            
            if( desktopPath != nil )
            {
                [ self addChild: [ CEFilesViewItem fileViewItemWithType: CEFilesViewItemTypeFS name: desktopPath ] ];
            }
            
            if( desktopPath != nil )
            {
                [ self addChild: [ CEFilesViewItem fileViewItemWithType: CEFilesViewItemTypeFS name: documentsPath ] ];
            }
            
            if( desktopPath != nil )
            {
                [ self addChild: [ CEFilesViewItem fileViewItemWithType: CEFilesViewItemTypeFS name: userPath ] ];
            }
            
            if( desktopPath != nil )
            {
                [ self addChild: [ CEFilesViewItem fileViewItemWithType: CEFilesViewItemTypeFS name: rootPath ] ];
            }
        }
    }
    else if( [ self.name isEqualToString: CEFilesViewBookmarksItemName ] )
    {
        {
            NSArray  * bookmarks;
            NSString * path;
            
            bookmarks = [ [ CEPreferences sharedInstance ] bookmarks ];
            
            for( path in bookmarks )
            {
                [ self addChild: [ CEFilesViewItem fileViewItemWithType: CEFilesViewItemTypeBookmark name: path ] ];
            }
        }
    }
}

- ( BOOL )isLeaf
{
    return NO;
}

@end
