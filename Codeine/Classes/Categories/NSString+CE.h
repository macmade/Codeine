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

typedef enum
{
    CEStringDataSizeTypeAuto        = 0x000,
    CEStringDataSizeTypeBytes       = 0x001,
    
    CEStringDataSizeTypeKiloBytes   = 0x101,
    CEStringDataSizeTypeMegaBytes   = 0x102,
    CEStringDataSizeTypeGigaBytes   = 0x103,
    CEStringDataSizeTypeTeraBytes   = 0x104,
    CEStringDataSizeTypePetaBytes   = 0x105,
    CEStringDataSizeTypeExaBytes    = 0x106,
    CEStringDataSizeTypeZettaBytes  = 0x107,
    CEStringDataSizeTypeYottaBytes  = 0x108,
    
    CEStringDataSizeTypeKibiBytes   = 0x201,
    CEStringDataSizeTypeMebiBytes   = 0x202,
    CEStringDataSizeTypeGibiBytes   = 0x203,
    CEStringDataSizeTypeTebiBytes   = 0x204,
    CEStringDataSizeTypePebiBytes   = 0x205,
    CEStringDataSizeTypeExbiBytes   = 0x206,
    CEStringDataSizeTypeZebiBytes   = 0x207,
    CEStringDataSizeTypeYobiBytes   = 0x208
}
CEStringDataSizeType;

@interface NSString( CE )

+ ( NSString * )stringForDataSizeWithBytes: ( uint64_t )bytes;
+ ( NSString * )stringForDataSizeWithBytes: ( uint64_t )bytes numberOfDecimals: ( NSUInteger )decimals;
+ ( NSString * )stringForDataSizeWithBytes: ( uint64_t )bytes unit: ( CEStringDataSizeType )unit;
+ ( NSString * )stringForDataSizeWithBytes: ( uint64_t )bytes unit: ( CEStringDataSizeType )unit numberOfDecimals: ( NSUInteger )decimals;

@end
