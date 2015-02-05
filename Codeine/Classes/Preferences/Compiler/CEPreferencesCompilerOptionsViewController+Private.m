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

#import "CEPreferencesCompilerOptionsViewController+Private.h"
#import "CEMutableOrderedDictionary.h"
#import "CEPreferences.h"

@implementation CEPreferencesCompilerOptionsViewController( Private )

- ( void )getWarningFlags
{
    NSDictionary * flags;
    NSArray      * keys;
    NSString     * key;
    
    RELEASE_IVAR( _flags );
    
    flags = [ [ CEPreferences sharedInstance ] warningFlags ];
    keys  = [ [ flags allKeys ] sortedArrayUsingComparator: ^ NSComparisonResult( id obj1, id obj2 )
                {
                    NSString * flag1;
                    NSString * flag2;
                    
                    flag1 = ( NSString * )obj1;
                    flag2 = ( NSString * )obj2;
                    
                    return [ flag1 compare: flag2 ];
                }
            ];
    
    _flags = [ [ CEMutableOrderedDictionary alloc ] initWithCapacity: keys.count ];
    
    for( key in keys )
    {
        [ _flags setObject: [ flags objectForKey: key ] forKey: key ];
    }
}

@end
