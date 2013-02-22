/*
 * Copyright (c) 2012-2013, Regents of the University of California
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - Neither the name of the University of California, Berkeley nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
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
 *
 *
 * Camera Row/Frame Bufferer
 *
 * by Humphrey Hu
 *
 * v.0.1
 *
 * Revisions:
 *  Humphrey Hu             2012-06-26      Initial release
 */

#include "carray.h"
#include "cambuff.h"
#include "cam.h"
#include <stdlib.h>
#include <string.h>

#define CAMBUFF_BUFFER_SIZE     (30)

// =========== Static Variables ===============================================
static unsigned char is_ready = 0;

static CircArray full_rows, empty_rows;
static CamRowStruct rows[CAMBUFF_BUFFER_SIZE];

// =========== Function Stubs =================================================
void cambuffIrqHandler(unsigned int irq_cause);

static void copyRows(CamRow dst, CamRow src);

static void enqueueEmptyRow(CamRow row);
static CamRow getEmptyRow(void);
static void enqueueNewFullRow(CamRow row);
static CamRow getOldestFullRow(void);

// =========== Public Functions ===============================================

void cambuffSetup (void)
{
    unsigned int i;

    full_rows = carrayCreate(CAMBUFF_BUFFER_SIZE);
    if ( full_rows == NULL ) return;
    empty_rows = carrayCreate(CAMBUFF_BUFFER_SIZE);
    if ( empty_rows == NULL ) return;

    for ( i = 0; i < CAMBUFF_BUFFER_SIZE; i++ ) enqueueEmptyRow(&rows[i]);

    camSetIrqHandler(&cambuffIrqHandler); // Set row capture handler

    is_ready = 1;
}

unsigned int cambuffHasNewRow(void)
{
    return !carrayIsEmpty(full_rows);
}

CamRow cambuffGetRow(void)
{
    return carrayPopHead(full_rows);
}

void cambuffReturnRow(CamRow row)
{
    enqueueEmptyRow(row);
}

// =========== Private Functions ==============================================
void cambuffIrqHandler(unsigned int irq_cause)
{
    CamRow copy, data;

    data = camGetRow();
    if ( data == NULL ) return; // Should never happen

    copy = getEmptyRow();
    if ( copy == NULL ) return; // Should also never happen

    copyRows(copy, data);       // Copy data row into empty row
    enqueueNewFullRow(copy);    // Add row to full queue
}

static void copyRows(CamRow dst, CamRow src)
{
    if ( dst == NULL || src == NULL ) return;
    memcpy( (unsigned char*)dst, (unsigned char*)src, sizeof(CamRowStruct) );
}

static void enqueueEmptyRow(CamRow row)
{
    carrayAddTail(empty_rows, row);
}

static CamRow getEmptyRow(void)
{
    CamRow row;

    if ( carrayIsEmpty(empty_rows) )
    {
        row = getOldestFullRow();
    } else {
        row = carrayPopHead(empty_rows);
    }

    return row;
}

static void enqueueNewFullRow(CamRow row)
{
    carrayAddTail(full_rows, row);
}

static CamRow getOldestFullRow(void)
{
    return carrayPopHead(full_rows);
}
