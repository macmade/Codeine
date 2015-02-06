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

#import "CESourceFile.h"
#import "CEPreferences.h"

@implementation CESourceFile

@synthesize language        = _language;
@synthesize translationUnit = _translationUnit;

+ ( id )sourceFileWithLanguage: ( CESourceFileLanguage )language
{
    return [ [ [ self alloc ] initWithLanguage: language ] autorelease ];
}

+ ( id )sourceFileWithLanguage: ( CESourceFileLanguage )language fromFile: ( NSString * )path
{
    return [ [ [ self alloc ] initWithLanguage: language fromFile: path ] autorelease ];
}

- ( id )initWithLanguage: ( CESourceFileLanguage )language
{
    if( ( self = [ self initWithLanguage: language fromFile: nil ] ) )
    {}
    
    return self;
}

- ( id )initWithLanguage: ( CESourceFileLanguage )language fromFile: ( NSString * )path
{
    BOOL     isDir;
    NSData * data;
    
    if( ( self = [ self init ] ) )
    {
        isDir     = NO;
        _language = language;
        
        if( [ FILE_MANAGER fileExistsAtPath: path isDirectory: &isDir ] == YES && isDir == NO )
        {
            data = [ FILE_MANAGER contentsAtPath: path ];
            
            if( data != nil )
            {
                self.text = [ [ [ NSString alloc ] initWithData: data encoding: [ [ CEPreferences sharedInstance ] textEncoding ] ] autorelease ];
            }
        }
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _text );
    RELEASE_IVAR( _translationUnit );
    
    [ super dealloc ];
}

- ( NSString * )text
{
    @synchronized( self )
    {
        return _text;
    }
}

- ( void )setText: ( NSString * )text
{
    CKLanguage language;
    NSArray  * args;
    NSBundle * bundle;
    NSString * includes;
    
    @synchronized( self )
    {
        if( text != _text )
        {
            RELEASE_IVAR( _text );
            
            _text = [ text retain ];
        }
        
        if( _language == CESourceFileLanguageNone )
        {
            RELEASE_IVAR( _translationUnit );
            
            return;
        }
        
        if( _translationUnit == nil )
        {
            if( _language == CESourceFileLanguageC )
            {
                language = CKLanguageC;
            }
            else if( _language == CESourceFileLanguageCPP )
            {
                language = CKLanguageCPP;
            }
            else if( _language == CESourceFileLanguageObjC )
            {
                language = CKLanguageObjC;
            }
            else if( _language == CESourceFileLanguageObjCPP )
            {
                language = CKLanguageObjCPP;
            }
            else if( _language == CESourceFileLanguageHeader )
            {
                language = CKLanguageObjCPP;
            }
            else
            {
                language = CKLanguageNone;
            }
            
            @try
            {
                bundle      = [ NSBundle bundleWithPath: [ BUNDLE pathForResource: @"Clang" ofType: @"bundle" ] ];
                includes    = [ bundle pathForResource: @"include" ofType: @"" ];
                args        = [ NSArray arrayWithObjects: @"-I", includes, nil ];
            }
            @catch ( NSException * e )
            {
                ( void )e;
                
                args = nil;
            }
            
            _translationUnit = [ [ CKTranslationUnit alloc ] initWithText: _text language: language args: args ];
        }
        else
        {
            _translationUnit.text = _text;
        }
    }
}

@end
