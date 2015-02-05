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

#import "CELinkerObject.h"
#import "CEPreferences.h"

@implementation CELinkerObject

@synthesize type        = _type;
@synthesize language    = _language;
@synthesize path        = _path;

+ ( NSArray * )linkerObjects
{
    NSArray         * rawObjects;
    NSMutableArray  * objects;
    NSDictionary    * rawObject;
    NSString        * path;
    NSNumber        * type;
    NSNumber        * language;
    CELinkerObject  * object;
    
    objects     = [ NSMutableArray arrayWithCapacity: 25 ];
    rawObjects  = [ [  CEPreferences sharedInstance ] linkerObjects ];
    
    for( rawObject in rawObjects )
    {
        path        = [ rawObject objectForKey: @"Path" ];
        type        = [ rawObject objectForKey: @"Type" ];
        language    = [ rawObject objectForKey: @"Language" ];
        
        if( path == nil || type == nil || language == nil )
        {
            continue;
        }
        
        object = [ self linkerObjectWithPath: path type: ( CELinkerObjectType )[ type integerValue ] language: ( CESourceFileLanguage )[ language integerValue ] ];
        
        if( object == nil )
        {
            continue;
        }
        
        [ objects addObject: object ];
    }
    
    return [ NSArray arrayWithArray: objects ];
}

+ ( NSArray * )linkerObjectsWithType: ( CELinkerObjectType )type
{
    NSArray        * allobjects;
    NSMutableArray * objects;
    CELinkerObject * object;
    
    objects     = [ NSMutableArray arrayWithCapacity: 25 ];
    allobjects  = [ self linkerObjects ];
    
    for( object in allobjects )
    {
        if( object.type == type )
        {
            [ objects addObject: object ];
        }
    }
    
    return [ NSArray arrayWithArray: objects ];
}

+ ( id )linkerObjectWithPath: ( NSString * )path type: ( CELinkerObjectType )type
{
    return [ self linkerObjectWithPath: path type: type language: CESourceFileLanguageNone ];
}

+ ( id )linkerObjectWithPath: ( NSString * )path type: ( CELinkerObjectType )type language: ( CESourceFileLanguage )language
{
    return [ [ [ self alloc ] initWithPath: path type: type language: language ] autorelease ];
}

- ( id )initWithPath: ( NSString * )path type: ( CELinkerObjectType )type
{
    return [ self initWithPath: path type: type language: CESourceFileLanguageNone ];
}

- ( id )initWithPath: ( NSString * )path type: ( CELinkerObjectType )type language: ( CESourceFileLanguage )language
{
    if( ( self = [ self init ] ) )
    {
        if( [ FILE_MANAGER fileExistsAtPath: path ] == NO )
        {
            [ self release ];
            
            return nil;
        }
        
        _path       = [ path copy ];
        _type       = type;
        _language   = language;
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _path );
    
    [ super dealloc ];
}

- ( NSString * )name
{
    return [ FILE_MANAGER displayNameAtPath: _path ];
}

- ( NSImage * )icon
{
    return [ WORKSPACE iconForFile: _path ];
}

@end
