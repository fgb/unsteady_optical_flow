/***************************************************************************
* Name: test.c
* Desc: test module
* Date: 2010-07-10
* Author: stanbaek
**************************************************************************/

#include "cmd_const.h"
#include "ports.h"
#include "test.h"
#include "lcd.h"
#include "xl.h"
#include "gyro.h"
#include "utils.h"
#include "payload_queue.h"
#include "payload.h"
#include "dfmem.h"
#include "radio.h"
#include "led.h"
#include "stopwatch.h"
#include "wii.h"
#include "filter.h"
#include <stdio.h>      // for NULL
#include <string.h>


char lcdstr_[80];       



void testFilter(void) {

    float xcoeffs[3] = {0.0413, 0.0825, 0.0413};
    float ycoeffs[3] = {1, -1.349, 0.5140};
    float xold[2], yold[2];

    Filter lpf = filterCreate(2, xcoeffs, ycoeffs);

    float x[3] = {1, 2, 3};
    float y[3];
    int i;

    for (i = 0; i < 3; i++) {
        xold[0] = lpf->xold[0];
        yold[0] = lpf->yold[0];
        xold[1] = lpf->xold[1];
        yold[1] = lpf->yold[1];
        y[i] = filterApply(lpf, x[i]);

    }
    
        xold[0] = lpf->xold[0];
        yold[0] = lpf->yold[0];
        xold[1] = lpf->xold[1];
        yold[1] = lpf->yold[1];

}

void testWii(void) {

    static int count = 0;
    unsigned char *str_blobs;

    WiiBlob blobs[4];
    //wiiGetData(blobs);
    str_blobs = wiiReadData();
    //gyroReadXYZ();

    sprintf(lcdstr_, "%d: %d, %d; %d, %d; %d, %d; %d, %d",
                    count++,
                    blobs[0].x, blobs[0].y,
                    blobs[1].x, blobs[1].y,                    
                    blobs[2].x, blobs[2].y,
                    blobs[3].x, blobs[3].y );

    /*
    
    sprintf(lcdstr_, "%d: %x%x%x%x%x%x%x%x", 
                    count++,
                    str_blobs[0], str_blobs[1], 
                    str_blobs[2], str_blobs[3],
                    str_blobs[4], str_blobs[5],
                    str_blobs[6], str_blobs[7] );
    */

    print(lcdstr_);
    
    delay_ms(300);

}


void testTiming(void) {

    unsigned long toc;

    swatchTic();
    xlReadXYZ();  
    toc = swatchToc();
    sprintf(lcdstr_, "%ld", toc);
    print(lcdstr_);
    //print("Sensor Data");
}



void testRadioGetChar(void) {
    /*
    char *ch;

    while(1) {
        if (radioGetChar(ch)) {
            sprintf(lcdstr_, "%c", *ch);
            print(lcdstr_);
        } 

        LED_GREEN = ~LED_GREEN;
        delay_ms(1000);
    }
    */
}


void testQueue(void) {
    /*
    Payload pld;
    unsigned char *str1 = "Hello World";
    unsigned char *str2 = "You wanna be a piece of meat, boy?";
    unsigned char *str3 = "Somebody call for an exterminator?";
    unsigned char *str4 = "Need medical attention?";
    unsigned char *str5 = "Go go go!";
    unsigned char *str6 = "Oh my god, he's whacked!";
    unsigned char *str7 = "How do I get out of this chickenshit outfit?";
    unsigned char *str8 = "Jacked up and good to go.";
    unsigned char *str9 = "Rock & Roll!"; 


    Payload pay1 = payCreateFromString(str1, strlen(str1));
    Payload pay2 = payCreateFromString(str2, strlen(str2));
    Payload pay3 = payCreateFromString(str3, strlen(str3));
    Payload pay4 = payCreateFromString(str4, strlen(str4));
    Payload pay5 = payCreateFromString(str5, strlen(str5));
    Payload pay6 = payCreate(0x45, 0x89, str6, strlen(str6));
    Payload pay7 = payCreate(0x46, 0x99, str7, strlen(str7));
    Payload pay8 = payCreate(0x47, 0xA9, str8, strlen(str8));
    Payload pay9 = payCreate(0x48, 0xB9, str9, strlen(str9));


    PayQueue que = pqInit(5);
    pld = pqPop(que);
    if (pld == NULL) LED_1 = 1;
    
    pqPush(que, pay1);
    pqPush(que, pay2);
    pqPush(que, pay3);
    pqPush(que, pay4);
    pqPush(que, pay5);
    pqPush(que, pay6);

    unsigned char i;

    for (i = 0; i < 4; ++i) {

        pld = pqPop(que);
        sprintf(lcdstr_, "%d, %x, %x, %s", pqGetSize(que), payGetStatus(pld), 
                        payGetType(pld), payGetData(pld));
        print(lcdstr_);
        payDelete(pld);
        delay_ms(3000);

    }


    queuePush(que, pay7);
    queuePush(que, pay8);
    queuePush(que, pay9);

    for (i = 0; i < 4; ++i) {

        pld = pqPop(que);
        sprintf(lcdstr_, "%d, %x, %x, %s", pqGetSize(que), payGetStatus(pld), 
                        payGetType(pld), payGetData(pld));
        print(lcdstr_);
        payDelete(pld);
        delay_ms(3000);

    }

    sprintf(lcdstr_, "Q size is %d", pqGetSize(que));
    print(lcdstr_);
    delay_ms(1000);
    */
}

void testIMU(void) {

    /*
    float xlData[3], gyroData[3], gyroTemp;
    int gyroIntTemp;
    unsigned char* xlStrData;
    unsigned char* gyroStrData;

    gyroReadXYZ();
    gyroReadTemp();
    gyroIntTemp = gyroGetTemp();
    gyroTemp = gyroGetfTemp();
    gyroStrData = gyroGetsTemp();
    gyroGetDegXYZ(gyroData);

    xlReadXYZ();
    xlGetfXYZ(xlData);
    xlStrData = xlGetsXYZ();

    sprintf(lcdstr_, "%2.2f,%3.4f,%3.4f,%3.4f,%1.5f,%1.5f,%1.5f", 
            gyroTemp, gyroData[0], gyroData[1], gyroData[2],
            xlData[0], xlData[1], xlData[2]);
      
    print(lcdstr_);
    */
}

void testDataFlash(void){
    /*
    unsigned char data[512] = {'A','B',};
    unsigned char *str1 = "You wanna be a piece of meat boy?";  //33+1
    unsigned char *str2 = "State the nature of your medical emergency.";  //43+1
    unsigned char *str3 = "How do I get out of this chickenshit outfit?"; //44+1
    unsigned char count;
    Payload pld;

    strcpy(data, str1);
    strcpy(data + strlen(str1), str2);
    strcpy(data + strlen(str1) + strlen(str2), str3);

    dfmemWrite (data, 512, 0x0100, 0, 1);

    pld = payCreateEmpty(strlen(str1)+2);
    dfmemRead(0x0100, 0, strlen(str1), payGetData(pld));
    paySetStatus(pld, 0);
    paySetType(pld, CMD_ECHO);
    radioSendPayload(pld);

    delay_ms(100);
    pld = payCreateEmpty(strlen(str2)+2);
    dfmemRead(0x0100, strlen(str1), strlen(str2), payGetData(pld));
    paySetStatus(pld, 0);
    paySetType(pld, CMD_ECHO);
    radioSendPayload(pld);

    delay_ms(100);
    pld = payCreateEmpty(strlen(str3)+2);
    dfmemRead(0x0100, strlen(str1) + strlen(str2), strlen(str3), payGetData(pld));
    paySetStatus(pld, 0);
    paySetType(pld, CMD_ECHO);
    radioSendPayload(pld);
    */
}


void testNumberStructures(void) {
    /*
    float float_num[2] = {0.1234567, 1.45634e7};
    unsigned char *chrnum;
    float *fnum;

    chrnum = (unsigned char*)float_num;
    fnum = (float*)chrnum;

    sprintf(lcdstr_, "%x %x %x %x, %x %x %x %x, %f, %f",
                    chrnum[0], chrnum[1], chrnum[2], chrnum[3],
                    chrnum[4], chrnum[5], chrnum[6], chrnum[7],
                    fnum[0], fnum[1]);
    print(lcdstr_);
    */
}



void testMatrix(void) {

    /*
    print("Starting matrix test");
    delay_ms(1000);
    Matrix mat1 = matCreate(3, 3, MAT_TYPE_FLOAT);
    Matrix mat2 = matCreate(3, 3, MAT_TYPE_FLOAT);
    //Matrix mat3 = matCreate(2, 2, MAT_TYPE_FLOAT);



    //float matrix_data1[9] = {1,0,0, 0,1,0, 0,0,1};
    float matrix_data2[9] = {0.9649, 0.9572, 0.1419,
                             0.1576, 0.4854, 0.4218,
                             0.9706, 0.8003, 0.9157};  // 
    //float matrix_data3[4] = {1,0,2,1};
    
    //matAssignValues(mat1, matrix_data1);
    matAssignValues(mat2, matrix_data2);
    //matAssignValues(mat3, matrix_data3);

    matToString(mat2, lcdstr_);
    
    //sprintf(lcdstr_, "%f, %f, %f, %f, %f, %f, %f, %f, %f", 
    //                mat2->data[0][0], mat2->data[0][1], mat2->data[0][2],
    //                mat2->data[1][0], mat2->data[1][1], mat2->data[1][2],
    //                mat2->data[2][0], mat2->data[2][1], mat2->data[2][2]);

    */
    
    //matInverse(ptr_mat2, ptr_mat3);
    /*
    sprintf(lcdstr_, "%f, %f, %f, %f, %f, %f, %f, %f, %f", 
                    mat3.data[0][0], mat3.data[0][1], mat3.data[0][2],
                    mat3.data[1][0], mat3.data[1][1], mat3.data[1][2],
                    mat3.data[2][0], mat3.data[2][1], mat3.data[2][2]);
    
    print(lcdstr_);
    delay_ms(1000);
    */

}

void testTrig(void) {
    /*
    sprintf(lcdstr_, "%f, %f, %f, %f, %f", trigCos(0+PI/2), trigCos(PI/5+PI/2), 
            trigSin(PI/4+PI/2), trigSin(PI/3+PI/2), trigSin(PI/2+PI/2));
      
    print(lcdstr_);
    */
}

