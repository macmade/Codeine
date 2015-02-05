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

#import "CEFile+Private.h"

@implementation CEFile( Private )

- ( void )getPermissions
{
    NSUInteger        u;
    NSUInteger        g;
    NSUInteger        o;
    NSUInteger        i;
    NSUInteger        permissions;
    NSString        * humanPermissions;
    
    _owner      = [ [ _attributes objectForKey: NSFileOwnerAccountName ] retain ];
    _group      = [ [ _attributes objectForKey: NSFileGroupOwnerAccountName ] retain ];
    _ownerID    = [ ( NSNumber * )[ _attributes objectForKey: NSFileOwnerAccountID ] unsignedIntegerValue ];
    _groupID    = [ ( NSNumber * )[ _attributes objectForKey: NSFileGroupOwnerAccountID ] unsignedIntegerValue ];
    
    _permissions = [ ( NSNumber * )[ _attributes objectForKey: NSFilePosixPermissions ] unsignedIntegerValue ];
    permissions  = _permissions;
    
    u = permissions / 64;
    g = ( permissions - ( 64 * u ) ) / 8;
    o = ( permissions - ( 64 * u ) ) - ( 8 * g );
    
    _octalPermissions   = ( u * 100 ) + ( g * 10 ) + o;
    humanPermissions    = @"";
    
    for( i = 0; i < 3; i++ )
    {
        humanPermissions    = [ [ NSString stringWithFormat: @"%@%@%@ ", ( permissions & 4 ) ? @"r" : @"-", ( permissions & 2 ) ? @"w" : @"-", ( permissions & 1 ) ? @"x" : @"-" ] stringByAppendingString: humanPermissions ];
        permissions         = permissions >> 3;
    }
    
    _humanPermissions = [ humanPermissions retain ];
}

@end
