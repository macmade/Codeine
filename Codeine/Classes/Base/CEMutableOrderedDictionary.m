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

#import "CEMutableOrderedDictionary.h"

@implementation CEMutableOrderedDictionary

- ( id )initWithObjects: ( const id[] )objects forKeys: ( const id< NSCopying >[] )keys count: ( NSUInteger )count
{
    if( ( self = [ super init ] ) )
    {
        _keys    = [ [ NSMutableArray alloc ] initWithObjects: keys    count: count ];
        _objects = [ [ NSMutableArray alloc ] initWithObjects: objects count: count ];
    }
    
    return self;
}

- ( id )initWithCapacity: ( NSUInteger )capacity
{
    if( ( self = [ super init ] ) )
    {
        _keys    = [ [ NSMutableArray alloc ] initWithCapacity: capacity ];
        _objects = [ [ NSMutableArray alloc ] initWithCapacity: capacity ];
    }
    
    return self;
}

- ( NSUInteger )count
{
    return _keys.count;
}

- ( id )objectForKey: ( id )key
{
    NSUInteger i;
    
    i = [ _keys indexOfObject: key ];
    
    if( i == NSNotFound )
    {
        return nil;
    }
    
    return [ _objects objectAtIndex: i ];
}

- ( NSEnumerator * )keyEnumerator
{
    return [ _keys objectEnumerator ];
}

- ( void )setObject: ( id )object forKey: ( id )key
{
    [ _keys    addObject: key ];
    [ _objects addObject: object ];
}

- ( void )removeObjectForKey: ( id )key
{
    NSUInteger i;
    
    i = [ _keys indexOfObject: key ];
    
    if( i == NSNotFound )
    {
        return;
    }
    
    [ _keys    removeObjectAtIndex: i ];
    [ _objects removeObjectAtIndex: i ];
}

- ( NSString * )descriptionWithLocale: ( id )locale
{
    NSString * description;
    NSUInteger i;
    
    description = [ NSString stringWithFormat: @"%@ <%p> {\n", NSStringFromClass( [ self class ] ), self ];
    
    ( void )locale;
    
    for( i = 0; i < _keys.count; i++ )
    {
        description = [ description stringByAppendingFormat: @"\t%@ = %@;\n", [ _keys objectAtIndex: i ], [ _objects objectAtIndex: i ] ];
    }
    
    return [ description stringByAppendingString: @"}" ];
}

- ( id )keyAtIndex: ( NSUInteger )index
{
    if( index >= _keys.count )
    {
        return nil;
    }
    
    return [ _keys objectAtIndex: index ];
}

- ( id )objectAtIndex: ( NSUInteger )index
{
    if( index >= _keys.count )
    {
        return nil;
    }
    
    return [ _objects objectAtIndex: index ];
}

@end
