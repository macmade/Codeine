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

typedef enum
{
    CELinkerObjectTypeFramework     = 0x00,
    CELinkerObjectTypeSharedLibrary = 0x01,
    CELinkerObjectTypeStaticLibrary = 0x02
}
CELinkerObjectType;

@interface CELinkerObject: NSObject
{
@protected
    
    CELinkerObjectType   _type;
    CESourceFileLanguage _language;
    NSString           * _path;
    
@private
    
    RESERVED_IVARS( CELinkerObject, 5 );
}

@property( atomic, readonly ) CELinkerObjectType    type;
@property( atomic, readonly ) CESourceFileLanguage  language;
@property( atomic, readonly ) NSString            * path;
@property( atomic, readonly ) NSString            * name;
@property( atomic, readonly ) NSImage             * icon;

+ ( NSArray * )linkerObjects;
+ ( NSArray * )linkerObjectsWithType: ( CELinkerObjectType )type;
+ ( id )linkerObjectWithPath: ( NSString * )path type: ( CELinkerObjectType )type;
+ ( id )linkerObjectWithPath: ( NSString * )path type: ( CELinkerObjectType )type language: ( CESourceFileLanguage )language;
- ( id )initWithPath: ( NSString * )path type: ( CELinkerObjectType )type;
- ( id )initWithPath: ( NSString * )path type: ( CELinkerObjectType )type language: ( CESourceFileLanguage )language;

@end
