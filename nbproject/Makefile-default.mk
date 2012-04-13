#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
include Makefile

# Environment
# Adding MPLAB X bin directory to path
PATH:=/Applications/Programming/Microchip/mplabx/mplab_ide.app/Contents/Resources/mplab_ide/mplab_ide/modules/../../bin/:$(PATH)
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowS.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowS.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1360930230/init.o ${OBJECTDIR}/_ext/877975035/battery.o ${OBJECTDIR}/_ext/877975035/buffer.o ${OBJECTDIR}/_ext/877975035/delay.o ${OBJECTDIR}/_ext/877975035/dfmem.o ${OBJECTDIR}/_ext/877975035/gyro.o ${OBJECTDIR}/_ext/877975035/init_default.o ${OBJECTDIR}/_ext/877975035/ovcamHS.o ${OBJECTDIR}/_ext/877975035/payload.o ${OBJECTDIR}/_ext/877975035/queue.o ${OBJECTDIR}/_ext/877975035/payload_queue.o ${OBJECTDIR}/_ext/877975035/stopwatch.o ${OBJECTDIR}/cmd.o ${OBJECTDIR}/main.o ${OBJECTDIR}/motor_ctrl.o ${OBJECTDIR}/radio.o ${OBJECTDIR}/ovcam.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1360930230/init.o.d ${OBJECTDIR}/_ext/877975035/battery.o.d ${OBJECTDIR}/_ext/877975035/buffer.o.d ${OBJECTDIR}/_ext/877975035/delay.o.d ${OBJECTDIR}/_ext/877975035/dfmem.o.d ${OBJECTDIR}/_ext/877975035/gyro.o.d ${OBJECTDIR}/_ext/877975035/init_default.o.d ${OBJECTDIR}/_ext/877975035/ovcamHS.o.d ${OBJECTDIR}/_ext/877975035/payload.o.d ${OBJECTDIR}/_ext/877975035/queue.o.d ${OBJECTDIR}/_ext/877975035/payload_queue.o.d ${OBJECTDIR}/_ext/877975035/stopwatch.o.d ${OBJECTDIR}/cmd.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/motor_ctrl.o.d ${OBJECTDIR}/radio.o.d ${OBJECTDIR}/ovcam.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1360930230/init.o ${OBJECTDIR}/_ext/877975035/battery.o ${OBJECTDIR}/_ext/877975035/buffer.o ${OBJECTDIR}/_ext/877975035/delay.o ${OBJECTDIR}/_ext/877975035/dfmem.o ${OBJECTDIR}/_ext/877975035/gyro.o ${OBJECTDIR}/_ext/877975035/init_default.o ${OBJECTDIR}/_ext/877975035/ovcamHS.o ${OBJECTDIR}/_ext/877975035/payload.o ${OBJECTDIR}/_ext/877975035/queue.o ${OBJECTDIR}/_ext/877975035/payload_queue.o ${OBJECTDIR}/_ext/877975035/stopwatch.o ${OBJECTDIR}/cmd.o ${OBJECTDIR}/main.o ${OBJECTDIR}/motor_ctrl.o ${OBJECTDIR}/radio.o ${OBJECTDIR}/ovcam.o


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

# Path to java used to run MPLAB X when this makefile was created
MP_JAVA_PATH="/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/bin/"
OS_CURRENT="$(shell uname -s)"
############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
MP_CC="/Applications/Programming/Microchip/mplabc30/v3.30c/bin/pic30-gcc"
# MP_BC is not defined
MP_AS="/Applications/Programming/Microchip/mplabc30/v3.30c/bin/pic30-as"
MP_LD="/Applications/Programming/Microchip/mplabc30/v3.30c/bin/pic30-ld"
MP_AR="/Applications/Programming/Microchip/mplabc30/v3.30c/bin/pic30-ar"
DEP_GEN=${MP_JAVA_PATH}java -jar "/Applications/Programming/Microchip/mplabx/mplab_ide.app/Contents/Resources/mplab_ide/mplab_ide/modules/../../bin/extractobjectdependencies.jar" 
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps
MP_CC_DIR="/Applications/Programming/Microchip/mplabc30/v3.30c/bin"
# MP_BC_DIR is not defined
MP_AS_DIR="/Applications/Programming/Microchip/mplabc30/v3.30c/bin"
MP_LD_DIR="/Applications/Programming/Microchip/mplabc30/v3.30c/bin"
MP_AR_DIR="/Applications/Programming/Microchip/mplabc30/v3.30c/bin"
# MP_BC_DIR is not defined

.build-conf:  ${BUILD_SUBPROJECTS}
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowS.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=33FJ128MC706A
MP_LINKER_FILE_OPTION=,-Tp33FJ128MC706A.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/877975035/delay.o: ../../shared/delay.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/delay.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/delay.o.ok ${OBJECTDIR}/_ext/877975035/delay.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/delay.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../../shared/delay.s -o ${OBJECTDIR}/_ext/877975035/delay.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 --defsym=__MPLAB_DEBUG=1 --defsym=__ICD2RAM=1 --defsym=__DEBUG=1 --defsym=__MPLAB_DEBUGGER_PK3=1 -g  -MD "${OBJECTDIR}/_ext/877975035/delay.o.d" -I".."$(MP_EXTRA_AS_POST)
	
${OBJECTDIR}/_ext/877975035/ovcamHS.o: ../../shared/ovcamHS.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/ovcamHS.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/ovcamHS.o.ok ${OBJECTDIR}/_ext/877975035/ovcamHS.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/ovcamHS.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../../shared/ovcamHS.s -o ${OBJECTDIR}/_ext/877975035/ovcamHS.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 --defsym=__MPLAB_DEBUG=1 --defsym=__ICD2RAM=1 --defsym=__DEBUG=1 --defsym=__MPLAB_DEBUGGER_PK3=1 -g  -MD "${OBJECTDIR}/_ext/877975035/ovcamHS.o.d" -I".."$(MP_EXTRA_AS_POST)
	
else
${OBJECTDIR}/_ext/877975035/delay.o: ../../shared/delay.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/delay.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/delay.o.ok ${OBJECTDIR}/_ext/877975035/delay.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/delay.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../../shared/delay.s -o ${OBJECTDIR}/_ext/877975035/delay.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 -g  -MD "${OBJECTDIR}/_ext/877975035/delay.o.d" -I".."$(MP_EXTRA_AS_POST)
	
${OBJECTDIR}/_ext/877975035/ovcamHS.o: ../../shared/ovcamHS.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/ovcamHS.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/ovcamHS.o.ok ${OBJECTDIR}/_ext/877975035/ovcamHS.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/ovcamHS.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../../shared/ovcamHS.s -o ${OBJECTDIR}/_ext/877975035/ovcamHS.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 -g  -MD "${OBJECTDIR}/_ext/877975035/ovcamHS.o.d" -I".."$(MP_EXTRA_AS_POST)
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1360930230/init.o: ../lib/init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1360930230 
	@${RM} ${OBJECTDIR}/_ext/1360930230/init.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360930230/init.o.ok ${OBJECTDIR}/_ext/1360930230/init.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1360930230/init.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1360930230/init.o.d" -o ${OBJECTDIR}/_ext/1360930230/init.o ../lib/init.c  
	
${OBJECTDIR}/_ext/877975035/battery.o: ../../shared/battery.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/battery.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/battery.o.ok ${OBJECTDIR}/_ext/877975035/battery.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/battery.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/battery.o.d" -o ${OBJECTDIR}/_ext/877975035/battery.o ../../shared/battery.c  
	
${OBJECTDIR}/_ext/877975035/buffer.o: ../../shared/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/buffer.o.ok ${OBJECTDIR}/_ext/877975035/buffer.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/buffer.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/buffer.o.d" -o ${OBJECTDIR}/_ext/877975035/buffer.o ../../shared/buffer.c  
	
${OBJECTDIR}/_ext/877975035/dfmem.o: ../../shared/dfmem.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/dfmem.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/dfmem.o.ok ${OBJECTDIR}/_ext/877975035/dfmem.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/dfmem.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/dfmem.o.d" -o ${OBJECTDIR}/_ext/877975035/dfmem.o ../../shared/dfmem.c  
	
${OBJECTDIR}/_ext/877975035/gyro.o: ../../shared/gyro.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/gyro.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/gyro.o.ok ${OBJECTDIR}/_ext/877975035/gyro.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/gyro.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/gyro.o.d" -o ${OBJECTDIR}/_ext/877975035/gyro.o ../../shared/gyro.c  
	
${OBJECTDIR}/_ext/877975035/init_default.o: ../../shared/init_default.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/init_default.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/init_default.o.ok ${OBJECTDIR}/_ext/877975035/init_default.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/init_default.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/init_default.o.d" -o ${OBJECTDIR}/_ext/877975035/init_default.o ../../shared/init_default.c  
	
${OBJECTDIR}/_ext/877975035/payload.o: ../../shared/payload.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload.o.ok ${OBJECTDIR}/_ext/877975035/payload.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/payload.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/payload.o.d" -o ${OBJECTDIR}/_ext/877975035/payload.o ../../shared/payload.c  
	
${OBJECTDIR}/_ext/877975035/queue.o: ../../shared/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/queue.o.ok ${OBJECTDIR}/_ext/877975035/queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/queue.o.d" -o ${OBJECTDIR}/_ext/877975035/queue.o ../../shared/queue.c  
	
${OBJECTDIR}/_ext/877975035/payload_queue.o: ../../shared/payload_queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload_queue.o.ok ${OBJECTDIR}/_ext/877975035/payload_queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/payload_queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/payload_queue.o.d" -o ${OBJECTDIR}/_ext/877975035/payload_queue.o ../../shared/payload_queue.c  
	
${OBJECTDIR}/_ext/877975035/stopwatch.o: ../../shared/stopwatch.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/stopwatch.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/stopwatch.o.ok ${OBJECTDIR}/_ext/877975035/stopwatch.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/stopwatch.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/stopwatch.o.d" -o ${OBJECTDIR}/_ext/877975035/stopwatch.o ../../shared/stopwatch.c  
	
${OBJECTDIR}/cmd.o: cmd.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/cmd.o.d 
	@${RM} ${OBJECTDIR}/cmd.o.ok ${OBJECTDIR}/cmd.o.err 
	@${FIXDEPS} "${OBJECTDIR}/cmd.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/cmd.o.d" -o ${OBJECTDIR}/cmd.o cmd.c  
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o.ok ${OBJECTDIR}/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/main.o.d" -o ${OBJECTDIR}/main.o main.c  
	
${OBJECTDIR}/motor_ctrl.o: motor_ctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/motor_ctrl.o.d 
	@${RM} ${OBJECTDIR}/motor_ctrl.o.ok ${OBJECTDIR}/motor_ctrl.o.err 
	@${FIXDEPS} "${OBJECTDIR}/motor_ctrl.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/motor_ctrl.o.d" -o ${OBJECTDIR}/motor_ctrl.o motor_ctrl.c  
	
${OBJECTDIR}/radio.o: radio.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/radio.o.d 
	@${RM} ${OBJECTDIR}/radio.o.ok ${OBJECTDIR}/radio.o.err 
	@${FIXDEPS} "${OBJECTDIR}/radio.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/radio.o.d" -o ${OBJECTDIR}/radio.o radio.c  
	
${OBJECTDIR}/ovcam.o: ovcam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/ovcam.o.d 
	@${RM} ${OBJECTDIR}/ovcam.o.ok ${OBJECTDIR}/ovcam.o.err 
	@${FIXDEPS} "${OBJECTDIR}/ovcam.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/ovcam.o.d" -o ${OBJECTDIR}/ovcam.o ovcam.c  
	
else
${OBJECTDIR}/_ext/1360930230/init.o: ../lib/init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1360930230 
	@${RM} ${OBJECTDIR}/_ext/1360930230/init.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360930230/init.o.ok ${OBJECTDIR}/_ext/1360930230/init.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1360930230/init.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1360930230/init.o.d" -o ${OBJECTDIR}/_ext/1360930230/init.o ../lib/init.c  
	
${OBJECTDIR}/_ext/877975035/battery.o: ../../shared/battery.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/battery.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/battery.o.ok ${OBJECTDIR}/_ext/877975035/battery.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/battery.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/battery.o.d" -o ${OBJECTDIR}/_ext/877975035/battery.o ../../shared/battery.c  
	
${OBJECTDIR}/_ext/877975035/buffer.o: ../../shared/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/buffer.o.ok ${OBJECTDIR}/_ext/877975035/buffer.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/buffer.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/buffer.o.d" -o ${OBJECTDIR}/_ext/877975035/buffer.o ../../shared/buffer.c  
	
${OBJECTDIR}/_ext/877975035/dfmem.o: ../../shared/dfmem.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/dfmem.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/dfmem.o.ok ${OBJECTDIR}/_ext/877975035/dfmem.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/dfmem.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/dfmem.o.d" -o ${OBJECTDIR}/_ext/877975035/dfmem.o ../../shared/dfmem.c  
	
${OBJECTDIR}/_ext/877975035/gyro.o: ../../shared/gyro.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/gyro.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/gyro.o.ok ${OBJECTDIR}/_ext/877975035/gyro.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/gyro.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/gyro.o.d" -o ${OBJECTDIR}/_ext/877975035/gyro.o ../../shared/gyro.c  
	
${OBJECTDIR}/_ext/877975035/init_default.o: ../../shared/init_default.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/init_default.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/init_default.o.ok ${OBJECTDIR}/_ext/877975035/init_default.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/init_default.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/init_default.o.d" -o ${OBJECTDIR}/_ext/877975035/init_default.o ../../shared/init_default.c  
	
${OBJECTDIR}/_ext/877975035/payload.o: ../../shared/payload.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload.o.ok ${OBJECTDIR}/_ext/877975035/payload.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/payload.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/payload.o.d" -o ${OBJECTDIR}/_ext/877975035/payload.o ../../shared/payload.c  
	
${OBJECTDIR}/_ext/877975035/queue.o: ../../shared/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/queue.o.ok ${OBJECTDIR}/_ext/877975035/queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/queue.o.d" -o ${OBJECTDIR}/_ext/877975035/queue.o ../../shared/queue.c  
	
${OBJECTDIR}/_ext/877975035/payload_queue.o: ../../shared/payload_queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload_queue.o.ok ${OBJECTDIR}/_ext/877975035/payload_queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/payload_queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/payload_queue.o.d" -o ${OBJECTDIR}/_ext/877975035/payload_queue.o ../../shared/payload_queue.c  
	
${OBJECTDIR}/_ext/877975035/stopwatch.o: ../../shared/stopwatch.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/stopwatch.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/stopwatch.o.ok ${OBJECTDIR}/_ext/877975035/stopwatch.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/stopwatch.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/stopwatch.o.d" -o ${OBJECTDIR}/_ext/877975035/stopwatch.o ../../shared/stopwatch.c  
	
${OBJECTDIR}/cmd.o: cmd.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/cmd.o.d 
	@${RM} ${OBJECTDIR}/cmd.o.ok ${OBJECTDIR}/cmd.o.err 
	@${FIXDEPS} "${OBJECTDIR}/cmd.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/cmd.o.d" -o ${OBJECTDIR}/cmd.o cmd.c  
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o.ok ${OBJECTDIR}/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/main.o.d" -o ${OBJECTDIR}/main.o main.c  
	
${OBJECTDIR}/motor_ctrl.o: motor_ctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/motor_ctrl.o.d 
	@${RM} ${OBJECTDIR}/motor_ctrl.o.ok ${OBJECTDIR}/motor_ctrl.o.err 
	@${FIXDEPS} "${OBJECTDIR}/motor_ctrl.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/motor_ctrl.o.d" -o ${OBJECTDIR}/motor_ctrl.o motor_ctrl.c  
	
${OBJECTDIR}/radio.o: radio.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/radio.o.d 
	@${RM} ${OBJECTDIR}/radio.o.ok ${OBJECTDIR}/radio.o.err 
	@${FIXDEPS} "${OBJECTDIR}/radio.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/radio.o.d" -o ${OBJECTDIR}/radio.o radio.c  
	
${OBJECTDIR}/ovcam.o: ovcam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/ovcam.o.d 
	@${RM} ${OBJECTDIR}/ovcam.o.ok ${OBJECTDIR}/ovcam.o.err 
	@${FIXDEPS} "${OBJECTDIR}/ovcam.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -fno-short-double -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"./" -I"../lib" -I"../../shared" -MMD -MF "${OBJECTDIR}/ovcam.o.d" -o ${OBJECTDIR}/ovcam.o ovcam.c  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowS.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -o dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowS.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}        -Wl,--defsym=__MPLAB_BUILD=1,--heap=12288,--no-check-sections,-L"../C:/Program Files/Microchip/MPLAB C30/lib",-Map="$(BINDIR_)$(TARGETBASE).map",--report-mem$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_PK3=1
else
dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowS.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowS.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}        -Wl,--defsym=__MPLAB_BUILD=1,--heap=12288,--no-check-sections,-L"../C:/Program Files/Microchip/MPLAB C30/lib",-Map="$(BINDIR_)$(TARGETBASE).map",--report-mem$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION)
	${MP_CC_DIR}/pic30-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowS.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -omf=elf
endif


# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf:
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell "/Applications/Programming/Microchip/mplabx/mplab_ide.app/Contents/Resources/mplab_ide/mplab_ide/modules/../../bin/"mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
