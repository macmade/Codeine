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

#import "CEColorTheme.h"
#import "CEColorTheme+Private.h"

@implementation CEColorTheme

@synthesize name                = _name;
@synthesize foregroundColor     = _foregroundColor;
@synthesize backgroundColor     = _backgroundColor;
@synthesize selectionColor      = _selectionColor;
@synthesize currentLineColor    = _currentLineColor;
@synthesize invisibleColor      = _invisibleColor;
@synthesize keywordColor        = _keywordColor;
@synthesize commentColor        = _commentColor;
@synthesize stringColor         = _stringColor;
@synthesize predefinedColor     = _predefinedColor;
@synthesize projectColor        = _projectColor;
@synthesize preprocessorColor   = _preprocessorColor;
@synthesize numberColor         = _numberColor;

+ ( NSArray * )defaultColorThemes
{
    NSMutableArray        * themes;
    NSString              * applicationSupportPath;
    NSString              * themesDirectory;
    NSDirectoryEnumerator * enumerator;
    NSString              * path;
    NSString              * name;
    NSDictionary          * themeDict;
    CEColorTheme          * theme;
    BOOL                    isDir;
    
    themes                  = [ NSMutableArray arrayWithCapacity: 25 ];
    applicationSupportPath  = [ FILE_MANAGER applicationSupportDirectory ];
    
    if( applicationSupportPath == nil )
    {
        return [ NSArray arrayWithArray: themes ];
    }
    
    themesDirectory = [ applicationSupportPath stringByAppendingPathComponent: @"Themes" ];
    isDir           = NO;
    
    if( [ FILE_MANAGER fileExistsAtPath: themesDirectory isDirectory: &isDir ] == NO || isDir == NO )
    {
        return [ NSArray arrayWithArray: themes ];
    }
    
    enumerator = [ FILE_MANAGER enumeratorAtPath: themesDirectory ];
    
    while( ( path = [ enumerator nextObject ] ) )
    {
        [ enumerator skipDescendants ];
        
        if( [ [ path pathExtension ] isEqualToString: @"plist" ] == NO )
        {
            continue;
        }
        
        path        = [ themesDirectory stringByAppendingPathComponent: path ];
        themeDict   = [ NSDictionary dictionaryWithContentsOfFile: path ];
        name        = [ [ path lastPathComponent ] stringByDeletingPathExtension ];
        theme       = [ self colorThemeWithName: name ];
        
        [ theme setColorFromDictionary: themeDict name: @"Foreground"   selector: @selector( setForegroundColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"Background"   selector: @selector( setBackgroundColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"Selection"    selector: @selector( setSelectionColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"CurrentLine"  selector: @selector( setCurrentLineColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"Invisible"    selector: @selector( setInvisibleColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"Keyword"      selector: @selector( setKeywordColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"Comment"      selector: @selector( setCommentColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"String"       selector: @selector( setStringColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"Predefined"   selector: @selector( setPredefinedColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"Project"      selector: @selector( setProjectColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"Preprocessor" selector: @selector( setPreprocessorColor: ) ];
        [ theme setColorFromDictionary: themeDict name: @"Number"       selector: @selector( setNumberColor: ) ];
        
        [ themes addObject: theme ];
    }
    
    return [ NSArray arrayWithArray: themes ];
}

+ ( id )defaultColorThemeWithName: ( NSString * )name
{
    NSArray      * themes;
    CEColorTheme * theme;
    
    themes = [ self defaultColorThemes ];
    
    for( theme in themes )
    {
        if( [ theme.name isEqualToString: name ] )
        {
            return theme;
        }
    }
    
    return nil;
}

+ ( id )colorThemeWithName: ( NSString * )name
{
    return [ [ ( CEColorTheme * )[ self alloc ] initWithName: name ] autorelease ];
}

- ( id )initWithName: ( NSString * )name
{
    if( ( self = [ self init ] ) )
    {
        _name = [ name copy ];
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _name );
    RELEASE_IVAR( _foregroundColor );
    RELEASE_IVAR( _backgroundColor );
    RELEASE_IVAR( _selectionColor );
    RELEASE_IVAR( _currentLineColor );
    RELEASE_IVAR( _invisibleColor );
    RELEASE_IVAR( _keywordColor );
    RELEASE_IVAR( _commentColor );
    RELEASE_IVAR( _stringColor );
    RELEASE_IVAR( _predefinedColor );
    RELEASE_IVAR( _projectColor );
    RELEASE_IVAR( _preprocessorColor );
    RELEASE_IVAR( _numberColor );
    
    [ super dealloc ];
}

@end
