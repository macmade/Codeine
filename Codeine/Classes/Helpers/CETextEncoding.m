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

#import "CETextEncoding.h"

#define __NUMBER_OF_TEXT_ENCODINGS  23

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpadded"
#endif
struct __textEncoding
{
    unsigned int value;
    const char * name;
};
#ifdef __clang__
#pragma clang diagnostic pop
#endif

static struct __textEncoding __encodings[ __NUMBER_OF_TEXT_ENCODINGS ] =
{
    { NSUTF8StringEncoding,                 "NSUTF8StringEncoding" },
    { NSUTF16StringEncoding,                "NSUTF16StringEncoding" },
    { NSUTF16BigEndianStringEncoding,       "NSUTF16BigEndianStringEncoding" },
    { NSUTF16LittleEndianStringEncoding,    "NSUTF16LittleEndianStringEncoding" },
    { NSUTF32StringEncoding,                "NSUTF32StringEncoding" },
    { NSUTF32BigEndianStringEncoding,       "NSUTF32BigEndianStringEncoding" },
    { NSUTF32LittleEndianStringEncoding,    "NSUTF32LittleEndianStringEncoding" },
    { NSISOLatin1StringEncoding,            "NSISOLatin1StringEncoding" },
    { NSISOLatin2StringEncoding,            "NSISOLatin2StringEncoding" },
    { NSASCIIStringEncoding,                "NSASCIIStringEncoding" },
    { NSNonLossyASCIIStringEncoding,        "NSNonLossyASCIIStringEncoding" },
    { NSMacOSRomanStringEncoding,           "NSMacOSRomanStringEncoding" },
    { NSWindowsCP1251StringEncoding,        "NSWindowsCP1251StringEncoding" },
    { NSWindowsCP1252StringEncoding,        "NSWindowsCP1252StringEncoding" },
    { NSWindowsCP1253StringEncoding,        "NSWindowsCP1253StringEncoding" },
    { NSWindowsCP1254StringEncoding,        "NSWindowsCP1254StringEncoding" },
    { NSWindowsCP1250StringEncoding,        "NSWindowsCP1250StringEncoding" },
    { NSUnicodeStringEncoding,              "NSUnicodeStringEncoding" },
    { NSNEXTSTEPStringEncoding,             "NSNEXTSTEPStringEncoding" },
    { NSJapaneseEUCStringEncoding,          "NSJapaneseEUCStringEncoding" },
    { NSISO2022JPStringEncoding,            "NSISO2022JPStringEncoding" },
    { NSShiftJISStringEncoding,             "NSShiftJISStringEncoding" },
    { NSSymbolStringEncoding,               "NSSymbolStringEncoding" }
};

@implementation CETextEncoding

@synthesize encodingValue = _encodingValue;
@synthesize name          = _name;

+ ( NSArray * )availableEncodings
{
    NSUInteger               i;
    const NSStringEncoding * encodings;
    NSMutableArray         * array;
    CETextEncoding         * encoding;
    
    array     = [ NSMutableArray arrayWithCapacity: 100 ];
    encodings = [ NSString availableStringEncodings ];
    
    if( encodings == NULL )
    {
        return [ NSArray array ];
    }
    
    while( *( encodings ) != 0 )
    {
        for( i = 0; i < __NUMBER_OF_TEXT_ENCODINGS; i++ )
        {
            if( __encodings[ i ].value == *( encodings ) )
            {
                encoding         = [ [ CETextEncoding alloc ] init ];
                encoding->_value = __encodings[ i ].value;
                encoding->_name  = [ [ NSString stringWithCString: __encodings[ i ].name encoding: NSASCIIStringEncoding ] retain ];
                
                [ array addObject: encoding ];
                [ encoding release ];
                
                break;
            }
        }
        
        encodings++;
    }
    
    [ array sortUsingComparator: ( NSComparator ) ^ ( id obj1, id obj2 )
        {
            CETextEncoding * enc1;
            CETextEncoding * enc2;
            
            enc1 = ( CETextEncoding * )obj1;
            enc2 = ( CETextEncoding * )obj2;
            
            return [ enc1.localizedName localizedCaseInsensitiveCompare: enc2.localizedName ];
        }
    ];
    
    return [ NSArray arrayWithArray: array ];
}

- ( void )dealloc
{
    RELEASE_IVAR( _name );
    
    [ super dealloc ];
}

- ( NSString * )localizedName
{
    NSString * name;
    
    @synchronized( self )
    {
        name = NSLocalizedString( _name, nil );
        
        if( name == nil || name.length == 0 )
        {
            return _name;
        }
        
        return name;
    }
}

@end
