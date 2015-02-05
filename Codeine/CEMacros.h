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

#ifndef __CE_MACROS_H__
#define __CE_MACROS_H__

#define L10N( __label__ )                       NSLocalizedString( [ NSString stringWithCString: __label__ encoding: NSUTF8StringEncoding ], nil )

#define RELEASE_IVAR( __ivar__ )                [ __ivar__ release ]; __ivar__ = nil

#define RESERVED_IVARS( __cls__, __num__ )     id _ ## __cls__ ## _Reserved[ __num__ ] __attribute__( ( unused ) )

#define NOTIFICATION_CENTER                     ( ( NSNotificationCenter * )[ NSNotificationCenter  defaultCenter ] )
#define FILE_MANAGER                            ( ( NSFileManager        * )[ NSFileManager         defaultManager ] )
#define APPLICATION                             ( ( NSApplication        * )[ NSApplication         sharedApplication ] )
#define DEFAULTS                                ( ( NSUserDefaults       * )[ NSUserDefaults        standardUserDefaults ] )
#define BUNDLE                                  ( ( NSBundle             * )[ NSBundle              mainBundle ] )
#define WORKSPACE                               ( ( NSWorkspace          * )[ NSWorkspace           sharedWorkspace ] )

#define Log( object )                                                           \
    NSLog                                                                       \
    (                                                                           \
        @"\n"                                                                   \
        @"\n"                                                                   \
        @"\tFile:           %@\n"                                               \
        @"\tLine:           %u\n"                                               \
        @"\tSymbol:         %s\n"                                               \
        @"\tAddress:        %p\n"                                               \
        @"\tRetain count:   %lu\n"                                              \
        @"\tClass:          %@\n"                                               \
        @"\tSuper class:    %@\n"                                               \
        @"\n"                                                                   \
        @"\tDescription:"                                                       \
        @"\n"                                                                   \
        @"\t%@\n"                                                               \
        @"\n",                                                                  \
        [ [ NSString stringWithFormat: @"%s", __FILE__ ] lastPathComponent ],   \
        __LINE__,                                                               \
        #object,                                                                \
        ( void * )object,                                                       \
        [ object retainCount ],                                                 \
        NSStringFromClass( [ object class ] ),                                  \
        NSStringFromClass( [ object superclass ] ),                             \
        object                                                                  \
    )

#define LogPoint( point )                       \
    NSLog                                       \
    (                                           \
        @"NSPoint:\n"                           \
        @"    X: %f\n"                          \
        @"    Y: %f",                           \
        point.x,                                \
        point.y                                 \
    )

#define LogSize( size )                         \
    NSLog                                       \
    (                                           \
        @"NSSize:\n"                            \
        @"    Width:  %f\n"                     \
        @"    Height: %f",                      \
        size.width,                             \
        size.height                             \
    )
 
#define LogRect( rect )                         \
    NSLog                                       \
    (                                           \
        @"NSRect:\n"                            \
        @"    X:      %f\n"                     \
        @"    Y:      %f\n"                     \
        @"    Width:  %f\n"                     \
        @"    Height: %f",                      \
        ( rect ).origin.x,                      \
        ( rect ).origin.y,                      \
        ( rect ).size.width,                    \
        ( rect ).size.height                    \
    )

#define LogRange( range )                       \
    NSLog                                       \
    (                                           \
        @"NSRange:\n"                           \
        @"    Location: %lu\n"                  \
        @"    Length:   %lu\n",                 \
        ( unsigned long )range.location,        \
        ( unsigned long )range.length           \
    )
    
#define FLOAT_EQUAL( __a__, __b__ )     ( bool )( fabsf( ( float )__a__ - ( float )__b__ ) < FLT_EPSILON )
#define FLOAT_ZERO( __a__ )             ( bool )( fabsf( ( float )__a__ ) < FLT_EPSILON )
#define DOUBLE_EQUAL( __a__, __b__ )    ( bool )( fabs( ( double )__a__ - ( double )__b__ ) < DBL_EPSILON )
#define DOUBLE_ZERO( __a__ )            ( bool )( fabs( ( double )__a__ ) < DBL_EPSILON )
#define LDOUBLE_EQUAL( __a__, __b__ )   ( bool )( fabsl( ( long double )__a__ - ( long double )__b__ ) < LDBL_EPSILON )
#define LDOUBLE_ZERO( __a__ )           ( bool )( fabsl( ( long double )__a__ ) < LDBL_EPSILON )
#define CGFLOAT_EQUAL( __a__, __b__ )   ( bool )( fabs( ( CGFloat )__a__ - ( CGFloat )__b__ ) < DBL_EPSILON )
#define CGFLOAT_ZERO( __a__ )           ( bool )( fabs( ( CGFloat )__a__ ) < DBL_EPSILON )

#endif /* __CE_MACROS_H__ */
