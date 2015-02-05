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

#import "NSString+CE.h"

#define __NSSTRING_CE_STRINGIFY( __v__ ) #__v__

@implementation NSString( CE )

+ ( NSString * )stringForDataSizeWithBytes: ( uint64_t )bytes
{
    return [ self stringForDataSizeWithBytes: bytes unit: CEStringDataSizeTypeAuto numberOfDecimals: 1 ];
}

+ ( NSString * )stringForDataSizeWithBytes: ( uint64_t )bytes numberOfDecimals: ( NSUInteger )decimals
{
    return [ self stringForDataSizeWithBytes: bytes unit: CEStringDataSizeTypeAuto numberOfDecimals: decimals ];
}

+ ( NSString * )stringForDataSizeWithBytes: ( uint64_t )bytes unit: ( CEStringDataSizeType )unit
{
    return [ self stringForDataSizeWithBytes: bytes unit: unit numberOfDecimals: 1 ];
}

+ ( NSString * )stringForDataSizeWithBytes: ( uint64_t )bytes unit: ( CEStringDataSizeType )unit numberOfDecimals: ( NSUInteger )decimals
{
    NSString          * unitKey;
    NSString          * unitName;
    NSString          * unitDefaultName;
    NSNumberFormatter * numberFormatter;
    NSNumber          * number;
    double              divider;
    double              doubleValue;
    
    if( unit == CEStringDataSizeTypeAuto )
    {
        if( bytes >= ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 )
        {
            unit = CEStringDataSizeTypeYottaBytes;
        }
        else if( bytes >= ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 )
        {
            unit = CEStringDataSizeTypeZettaBytes;
        }
        else if( bytes >= ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 )
        {
            unit = CEStringDataSizeTypeExaBytes;
        }
        else if( bytes >= ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 )
        {
            unit = CEStringDataSizeTypePetaBytes;
        }
        else if( bytes >= ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 )
        {
            unit = CEStringDataSizeTypeTeraBytes;
        }
        else if( bytes >= ( uint64_t )1000 * ( uint64_t )1000 * ( uint64_t )1000 )
        {
            unit = CEStringDataSizeTypeGigaBytes;
        }
        else if( bytes >= ( uint64_t )1000 * ( uint64_t )1000 )
        {
            unit = CEStringDataSizeTypeMegaBytes;
        }
        else if( bytes >= ( uint64_t )1000 )
        {
            unit = CEStringDataSizeTypeKiloBytes;
        }
        else
        {
            unit = CEStringDataSizeTypeBytes;
        }
    }
    
    if( unit == CEStringDataSizeTypeBytes )
    {
        unitDefaultName = @"B";
        unitKey         = [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeBytes ) ];
        number          = [ NSNumber numberWithUnsignedLongLong: bytes ];
        numberFormatter = [ [ [ NSNumberFormatter alloc ] init ] autorelease ];
        
        [ numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle ];
        [ numberFormatter setMaximumFractionDigits: 0 ];
        
        unitName = L10N( [ unitKey UTF8String ] );
        
        if( unitName == unitKey )
        {
            unitName = unitDefaultName;
        }
        
        return [ NSString stringWithFormat: @"%@ %@", [ numberFormatter stringFromNumber: number ], unitName ];
    }
    
    divider         = ( unit & 0x100 ) ? ( double )1000 : ( double )1024;
    unitKey         = nil;
    unitDefaultName = nil;
    
    switch( unit )
    {
        case CEStringDataSizeTypeKiloBytes:
            
            unitDefaultName = @"KB";
            unitKey         = [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeKiloBytes ) ];
            
        case CEStringDataSizeTypeKibiBytes:
            
            unitDefaultName = ( unitDefaultName == nil ) ? @"KiB" : unitDefaultName;
            unitKey         = ( unitKey == nil ) ? [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeKibiBytes ) ] : unitKey;
            doubleValue     = ( CGFloat )bytes / divider;
            
            break;
            
        case CEStringDataSizeTypeMegaBytes:
            
            unitDefaultName = @"MB";
            unitKey         = [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeMegaBytes ) ];
            
        case CEStringDataSizeTypeMebiBytes:
            
            unitDefaultName = ( unitDefaultName == nil ) ? @"MiB" : unitDefaultName;
            unitKey         = ( unitKey == nil ) ? [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeMebiBytes ) ] : unitKey;
            doubleValue     = ( ( CGFloat )bytes / divider ) / divider;
            
            break;
            
        case CEStringDataSizeTypeGigaBytes:
            
            unitDefaultName = @"GB";
            unitKey         = [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeGigaBytes ) ];
            
        case CEStringDataSizeTypeGibiBytes:
            
            unitDefaultName = ( unitDefaultName == nil ) ? @"GiB" : unitDefaultName;
            unitKey         = ( unitKey == nil ) ? [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeGibiBytes ) ] : unitKey;
            doubleValue     = ( ( ( CGFloat )bytes / divider ) / divider ) / divider;
            
            break;
            
        case CEStringDataSizeTypeTeraBytes:
            
            unitDefaultName = @"TB";
            unitKey         = [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeTeraBytes ) ];
            
        case CEStringDataSizeTypeTebiBytes:
            
            unitDefaultName = ( unitDefaultName == nil ) ? @"KTB" : unitDefaultName;
            unitKey         = ( unitKey == nil ) ? [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeTebiBytes ) ] : unitKey;
            doubleValue     = ( ( ( ( CGFloat )bytes / divider ) / divider ) / divider ) / divider;
            
            break;
            
        case CEStringDataSizeTypePetaBytes:
            
            unitDefaultName = @"PB";
            unitKey         = [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypePetaBytes ) ];
            
        case CEStringDataSizeTypePebiBytes:
            
            unitDefaultName = ( unitDefaultName == nil ) ? @"PiB" : unitDefaultName;
            unitKey         = ( unitKey == nil ) ? [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypePebiBytes ) ] : unitKey;
            doubleValue     = ( ( ( ( ( CGFloat )bytes / divider ) / divider ) / divider ) / divider ) / divider;
            
            break;
            
        case CEStringDataSizeTypeExaBytes:
            
            unitDefaultName = @"EB";
            unitKey         = [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeExaBytes ) ];
            
        case CEStringDataSizeTypeExbiBytes:
            
            unitDefaultName = ( unitDefaultName == nil ) ? @"EiB" : unitDefaultName;
            unitKey         = ( unitKey == nil ) ? [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeExbiBytes ) ] : unitKey;
            doubleValue     = ( ( ( ( ( ( CGFloat )bytes / divider ) / divider ) / divider ) / divider ) / divider ) / divider;
            
            break;
            
        case CEStringDataSizeTypeZettaBytes:
            
            unitDefaultName = @"ZB";
            unitKey         = [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeZettaBytes ) ];
            
        case CEStringDataSizeTypeZebiBytes:
            
            unitDefaultName = ( unitDefaultName == nil ) ? @"ZiB" : unitDefaultName;
            unitKey         = ( unitKey == nil ) ? [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeZebiBytes ) ] : unitKey;
            doubleValue     = ( ( ( ( ( ( ( CGFloat )bytes / divider ) / divider ) / divider ) / divider ) / divider ) / divider ) / divider;
            
            break;
            
        case CEStringDataSizeTypeYottaBytes:
            
            unitDefaultName = @"YB";
            unitKey         = [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeYottaBytes ) ];
            
        case CEStringDataSizeTypeYobiBytes:
            
            unitDefaultName = ( unitDefaultName == nil ) ? @"YiB" : unitDefaultName;
            unitKey         = ( unitKey == nil ) ? [ NSString stringWithFormat: @"%s", __NSSTRING_CE_STRINGIFY( CEStringDataSizeTypeYobiBytes ) ] : unitKey;
            doubleValue     = ( ( ( ( ( ( ( ( CGFloat )bytes / divider ) / divider ) / divider ) / divider ) / divider ) / divider ) / divider ) / divider;
            
            break;
           
        case CEStringDataSizeTypeAuto:
        case CEStringDataSizeTypeBytes:
        default:
            
            return nil;
    }
    
    number          = [ NSNumber numberWithDouble: doubleValue ];
    numberFormatter = [ [ [ NSNumberFormatter alloc ] init ] autorelease ];
    
    [ numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle ];
    [ numberFormatter setMaximumFractionDigits: decimals ];
    
    unitName = L10N( [ unitKey UTF8String ] );
    
    if( unitName == unitKey )
    {
        unitName = unitDefaultName;
    }
    
    return [ NSString stringWithFormat: @"%@ %@", [ numberFormatter stringFromNumber: number ], unitName ];
}

@end
