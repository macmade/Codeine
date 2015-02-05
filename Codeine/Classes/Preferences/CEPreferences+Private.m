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

#import "CEPreferences+Private.h"

@implementation CEPreferences( Private )

- ( NSColor * )colorForKey: ( NSString * )key
{
    CGFloat        r;
    CGFloat        g;
    CGFloat        b;
    NSDictionary * colorValues;
    
    colorValues = [ DEFAULTS objectForKey: key ];
    r           = ( CGFloat )( [ ( NSNumber * )[ colorValues objectForKey: @"R" ] doubleValue ] / ( CGFloat )255 );
    g           = ( CGFloat )( [ ( NSNumber * )[ colorValues objectForKey: @"G" ] doubleValue ] / ( CGFloat )255 );
    b           = ( CGFloat )( [ ( NSNumber * )[ colorValues objectForKey: @"B" ] doubleValue ] / ( CGFloat )255 );
    
    return [ NSColor colorWithDeviceRed: r green: g blue: b alpha: ( CGFloat )1 ];
}

- ( NSColor * )colorForKey: ( NSString * )key inDictionary: ( NSDictionary * )dictionary
{
    CGFloat        r;
    CGFloat        g;
    CGFloat        b;
    NSDictionary * colorValues;
    
    colorValues = [ dictionary objectForKey: key ];
    r           = ( CGFloat )( [ ( NSNumber * )[ colorValues objectForKey: @"R" ] doubleValue ] / ( CGFloat )255 );
    g           = ( CGFloat )( [ ( NSNumber * )[ colorValues objectForKey: @"G" ] doubleValue ] / ( CGFloat )255 );
    b           = ( CGFloat )( [ ( NSNumber * )[ colorValues objectForKey: @"B" ] doubleValue ] / ( CGFloat )255 );
    
    return [ NSColor colorWithDeviceRed: r green: g blue: b alpha: ( CGFloat )1 ];
}

- ( void )setColor: ( NSColor * )color forKey: ( NSString * )key
{
    CGFloat        r;
    CGFloat        g;
    CGFloat        b;
    CGFloat        a;
    NSDictionary * colorValues;
    
    color = [ color colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    
    r = ( CGFloat )0;
    g = ( CGFloat )0;
    b = ( CGFloat )0;
    a = ( CGFloat )0;
    
    [ color getRed: &r green: &g blue: &b alpha: &a ];
    
    colorValues = [ NSDictionary dictionaryWithObjectsAndKeys:  [ NSNumber numberWithDouble: ( double )r * ( double )255 ], @"R",
                                                                [ NSNumber numberWithDouble: ( double )g * ( double )255 ], @"G",
                                                                [ NSNumber numberWithDouble: ( double )b * ( double )255 ], @"B",
                                                                nil
                  ];
    
    [ DEFAULTS setObject: colorValues forKey: key ];
    [ DEFAULTS synchronize ];
}

@end
