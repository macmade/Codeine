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

#import "CEDocument.h"
#import "CEDocument+Private.h"
#import "CEFile.h"
#import "CEPreferences.h"
#import "CEUUID.h"

@implementation CEDocument

@synthesize file        = _file;
@synthesize sourceFile  = _sourceFile;
@synthesize name        = _name;
@synthesize uuid        = _uuid;

+ ( id )documentWithPath: ( NSString * )path
{
    return [ [ [ self alloc ] initWithPath: path ] autorelease ];
}

+ ( id )documentWithURL: ( NSURL * )url
{
    return [ [ [ self alloc ] initWithURL: url ] autorelease ];
}

+ ( id )documentWithLanguage: ( CESourceFileLanguage )language
{
    return [ [ [ self alloc ] initWithLanguage: language ] autorelease ];
}

- ( id )initWithPath: ( NSString * )path
{
    if( ( self = [ self initWithURL: [ NSURL fileURLWithPath: path ] ] ) )
    {}
    
    return self;
}

- ( id )initWithURL: ( NSURL * )url
{
    NSDictionary        * types;
    NSString            * extension;
    NSNumber            * value;
    CESourceFileLanguage  language;
    
    if( ( self = [ self init ] ) )
    {
        _file = [ [ CEFile alloc ] initWithURL: url ];
    
        if( _file == nil )
        {
            [ self release ];
            
            return nil;
        }
        
        language = CESourceFileLanguageNone;
        types    = [ [ CEPreferences sharedInstance ] fileTypes ];
        
        for( extension in types )
        {
            if( [ extension.lowercaseString isEqualToString: url.path.pathExtension.lowercaseString ] )
            {
                value    = [ types objectForKey: extension ];
                language = ( CESourceFileLanguage )[ value integerValue ];
                
                break;
            }
        }
        
        _sourceFile = [ [ CESourceFile alloc ] initWithLanguage: language fromFile: _file.path ];
        
        if( _sourceFile == nil )
        {
            [ self release ];
            
            return nil;
        }
        
        _name = [ _file.name copy ];
        _uuid = [ CEUUID new ];
    }
    
    return self;
}

- ( id )initWithLanguage: ( CESourceFileLanguage )language
{
    if( ( self = [ self init ] ) )
    {
        _sourceFile = [ [ CESourceFile alloc ] initWithLanguage: language ];
        
        if( _sourceFile == nil )
        {
            [ self release ];
            
            return nil;
        }
        
        _name = [ [ self nameForNewDocument ] copy ];
        _uuid = [ CEUUID new ];
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _file );
    RELEASE_IVAR( _sourceFile );
    RELEASE_IVAR( _name );
    RELEASE_IVAR( _uuid );
    
    [ super dealloc ];
}

- ( NSImage * )icon
{
    if( _file != nil )
    {
        return _file.icon;
    }
    
    if( _sourceFile != nil )
    {
        switch( _sourceFile.language )
        {
            case CESourceFileLanguageC:
                
                return [ WORKSPACE iconForFileType: @"c" ];
                
            case CESourceFileLanguageCPP:
                
                return [ WORKSPACE iconForFileType: @"cpp" ];
                
            case CESourceFileLanguageObjC:
                
                return [ WORKSPACE iconForFileType: @"m" ];
                
            case CESourceFileLanguageObjCPP:
                
                return [ WORKSPACE iconForFileType: @"mm" ];
                
            case CESourceFileLanguageHeader:
                
                return [ WORKSPACE iconForFileType: @"h" ];
                
            case CESourceFileLanguageNone:
            default:
                
                break;
        }
    }
    
    return [ WORKSPACE iconForFileType: @"" ];
}

- ( void )save
{
    [ self save: NULL ];
}

- ( BOOL )save: ( NSError ** )error
{
    ( void )error;
    
    return YES;
}

- ( BOOL )isEqual: ( id )object
{
    CEDocument * document;
    
    if( [ object isKindOfClass: [ self class ] ] == NO )
    {
        return NO;
    }
    
    document = object;
    
    if( self.file == nil || document.file == nil )
    {
        return [ self.name isEqualToString: document.name ];
    }
    
    return [ self.file.path isEqualToString: document.file.path ] && self.sourceFile.language == document.sourceFile.language;
}

@end
