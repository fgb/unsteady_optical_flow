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
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowH.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowH.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o ${OBJECTDIR}/_ext/1917815105/mac_packet.o ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o ${OBJECTDIR}/_ext/1917815105/ovcam.o ${OBJECTDIR}/_ext/1917815105/fast_queue.o ${OBJECTDIR}/_ext/1917815105/packet_pool.o ${OBJECTDIR}/_ext/1917815105/radio.o ${OBJECTDIR}/_ext/1360930230/init.o ${OBJECTDIR}/_ext/877975035/battery.o ${OBJECTDIR}/_ext/877975035/counter.o ${OBJECTDIR}/_ext/877975035/gyro.o ${OBJECTDIR}/_ext/877975035/init_default.o ${OBJECTDIR}/_ext/877975035/ovcamHS.o ${OBJECTDIR}/_ext/877975035/queue.o ${OBJECTDIR}/_ext/877975035/spi_controller.o ${OBJECTDIR}/_ext/877975035/stopwatch.o ${OBJECTDIR}/_ext/877975035/xl.o ${OBJECTDIR}/_ext/877975035/camera.o ${OBJECTDIR}/_ext/877975035/payload.o ${OBJECTDIR}/_ext/877975035/delay.o ${OBJECTDIR}/_ext/877975035/dfmem.o ${OBJECTDIR}/main.o ${OBJECTDIR}/cmdh.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.d ${OBJECTDIR}/_ext/1917815105/mac_packet.o.d ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.d ${OBJECTDIR}/_ext/1917815105/ovcam.o.d ${OBJECTDIR}/_ext/1917815105/fast_queue.o.d ${OBJECTDIR}/_ext/1917815105/packet_pool.o.d ${OBJECTDIR}/_ext/1917815105/radio.o.d ${OBJECTDIR}/_ext/1360930230/init.o.d ${OBJECTDIR}/_ext/877975035/battery.o.d ${OBJECTDIR}/_ext/877975035/counter.o.d ${OBJECTDIR}/_ext/877975035/gyro.o.d ${OBJECTDIR}/_ext/877975035/init_default.o.d ${OBJECTDIR}/_ext/877975035/ovcamHS.o.d ${OBJECTDIR}/_ext/877975035/queue.o.d ${OBJECTDIR}/_ext/877975035/spi_controller.o.d ${OBJECTDIR}/_ext/877975035/stopwatch.o.d ${OBJECTDIR}/_ext/877975035/xl.o.d ${OBJECTDIR}/_ext/877975035/camera.o.d ${OBJECTDIR}/_ext/877975035/payload.o.d ${OBJECTDIR}/_ext/877975035/delay.o.d ${OBJECTDIR}/_ext/877975035/dfmem.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/cmdh.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o ${OBJECTDIR}/_ext/1917815105/mac_packet.o ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o ${OBJECTDIR}/_ext/1917815105/ovcam.o ${OBJECTDIR}/_ext/1917815105/fast_queue.o ${OBJECTDIR}/_ext/1917815105/packet_pool.o ${OBJECTDIR}/_ext/1917815105/radio.o ${OBJECTDIR}/_ext/1360930230/init.o ${OBJECTDIR}/_ext/877975035/battery.o ${OBJECTDIR}/_ext/877975035/counter.o ${OBJECTDIR}/_ext/877975035/gyro.o ${OBJECTDIR}/_ext/877975035/init_default.o ${OBJECTDIR}/_ext/877975035/ovcamHS.o ${OBJECTDIR}/_ext/877975035/queue.o ${OBJECTDIR}/_ext/877975035/spi_controller.o ${OBJECTDIR}/_ext/877975035/stopwatch.o ${OBJECTDIR}/_ext/877975035/xl.o ${OBJECTDIR}/_ext/877975035/camera.o ${OBJECTDIR}/_ext/877975035/payload.o ${OBJECTDIR}/_ext/877975035/delay.o ${OBJECTDIR}/_ext/877975035/dfmem.o ${OBJECTDIR}/main.o ${OBJECTDIR}/cmdh.o


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
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowH.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=33FJ128MC706A
MP_LINKER_FILE_OPTION=,-Tp33FJ128MC706A.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/877975035/ovcamHS.o: ../../shared/ovcamHS.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/ovcamHS.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/ovcamHS.o.ok ${OBJECTDIR}/_ext/877975035/ovcamHS.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/ovcamHS.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../../shared/ovcamHS.s -o ${OBJECTDIR}/_ext/877975035/ovcamHS.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 --defsym=__MPLAB_DEBUG=1 --defsym=__ICD2RAM=1 --defsym=__DEBUG=1 --defsym=__MPLAB_DEBUGGER_PK3=1 -g  -MD "${OBJECTDIR}/_ext/877975035/ovcamHS.o.d"$(MP_EXTRA_AS_POST)
	
${OBJECTDIR}/_ext/877975035/delay.o: ../../shared/delay.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/delay.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/delay.o.ok ${OBJECTDIR}/_ext/877975035/delay.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/delay.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../../shared/delay.s -o ${OBJECTDIR}/_ext/877975035/delay.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 --defsym=__MPLAB_DEBUG=1 --defsym=__ICD2RAM=1 --defsym=__DEBUG=1 --defsym=__MPLAB_DEBUGGER_PK3=1 -g  -MD "${OBJECTDIR}/_ext/877975035/delay.o.d"$(MP_EXTRA_AS_POST)
	
else
${OBJECTDIR}/_ext/877975035/ovcamHS.o: ../../shared/ovcamHS.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/ovcamHS.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/ovcamHS.o.ok ${OBJECTDIR}/_ext/877975035/ovcamHS.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/ovcamHS.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../../shared/ovcamHS.s -o ${OBJECTDIR}/_ext/877975035/ovcamHS.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 -g  -MD "${OBJECTDIR}/_ext/877975035/ovcamHS.o.d"$(MP_EXTRA_AS_POST)
	
${OBJECTDIR}/_ext/877975035/delay.o: ../../shared/delay.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/delay.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/delay.o.ok ${OBJECTDIR}/_ext/877975035/delay.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/delay.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../../shared/delay.s -o ${OBJECTDIR}/_ext/877975035/delay.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 -g  -MD "${OBJECTDIR}/_ext/877975035/delay.o.d"$(MP_EXTRA_AS_POST)
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o: ../../hhu/C-lib/at86rf231_driver.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.ok ${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.d" -o ${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o ../../hhu/C-lib/at86rf231_driver.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/mac_packet.o: ../../hhu/C-lib/mac_packet.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/mac_packet.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/mac_packet.o.ok ${OBJECTDIR}/_ext/1917815105/mac_packet.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/mac_packet.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/mac_packet.o.d" -o ${OBJECTDIR}/_ext/1917815105/mac_packet.o ../../hhu/C-lib/mac_packet.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/motor_ctrl.o: ../../hhu/C-lib/motor_ctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.ok ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.d" -o ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o ../../hhu/C-lib/motor_ctrl.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/ovcam.o: ../../hhu/C-lib/ovcam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/ovcam.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/ovcam.o.ok ${OBJECTDIR}/_ext/1917815105/ovcam.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/ovcam.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/ovcam.o.d" -o ${OBJECTDIR}/_ext/1917815105/ovcam.o ../../hhu/C-lib/ovcam.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/fast_queue.o: ../../hhu/C-lib/fast_queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/fast_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/fast_queue.o.ok ${OBJECTDIR}/_ext/1917815105/fast_queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/fast_queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/fast_queue.o.d" -o ${OBJECTDIR}/_ext/1917815105/fast_queue.o ../../hhu/C-lib/fast_queue.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/packet_pool.o: ../../hhu/C-lib/packet_pool.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/packet_pool.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/packet_pool.o.ok ${OBJECTDIR}/_ext/1917815105/packet_pool.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/packet_pool.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/packet_pool.o.d" -o ${OBJECTDIR}/_ext/1917815105/packet_pool.o ../../hhu/C-lib/packet_pool.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/radio.o: ../../hhu/C-lib/radio.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/radio.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/radio.o.ok ${OBJECTDIR}/_ext/1917815105/radio.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/radio.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/radio.o.d" -o ${OBJECTDIR}/_ext/1917815105/radio.o ../../hhu/C-lib/radio.c  -fast-math
	
${OBJECTDIR}/_ext/1360930230/init.o: ../lib/init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1360930230 
	@${RM} ${OBJECTDIR}/_ext/1360930230/init.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360930230/init.o.ok ${OBJECTDIR}/_ext/1360930230/init.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1360930230/init.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1360930230/init.o.d" -o ${OBJECTDIR}/_ext/1360930230/init.o ../lib/init.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/battery.o: ../../shared/battery.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/battery.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/battery.o.ok ${OBJECTDIR}/_ext/877975035/battery.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/battery.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/battery.o.d" -o ${OBJECTDIR}/_ext/877975035/battery.o ../../shared/battery.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/counter.o: ../../shared/counter.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/counter.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/counter.o.ok ${OBJECTDIR}/_ext/877975035/counter.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/counter.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/counter.o.d" -o ${OBJECTDIR}/_ext/877975035/counter.o ../../shared/counter.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/gyro.o: ../../shared/gyro.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/gyro.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/gyro.o.ok ${OBJECTDIR}/_ext/877975035/gyro.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/gyro.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/gyro.o.d" -o ${OBJECTDIR}/_ext/877975035/gyro.o ../../shared/gyro.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/init_default.o: ../../shared/init_default.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/init_default.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/init_default.o.ok ${OBJECTDIR}/_ext/877975035/init_default.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/init_default.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/init_default.o.d" -o ${OBJECTDIR}/_ext/877975035/init_default.o ../../shared/init_default.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/queue.o: ../../shared/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/queue.o.ok ${OBJECTDIR}/_ext/877975035/queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/queue.o.d" -o ${OBJECTDIR}/_ext/877975035/queue.o ../../shared/queue.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/spi_controller.o: ../../shared/spi_controller.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/spi_controller.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/spi_controller.o.ok ${OBJECTDIR}/_ext/877975035/spi_controller.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/spi_controller.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/spi_controller.o.d" -o ${OBJECTDIR}/_ext/877975035/spi_controller.o ../../shared/spi_controller.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/stopwatch.o: ../../shared/stopwatch.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/stopwatch.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/stopwatch.o.ok ${OBJECTDIR}/_ext/877975035/stopwatch.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/stopwatch.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/stopwatch.o.d" -o ${OBJECTDIR}/_ext/877975035/stopwatch.o ../../shared/stopwatch.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/xl.o: ../../shared/xl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/xl.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/xl.o.ok ${OBJECTDIR}/_ext/877975035/xl.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/xl.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/xl.o.d" -o ${OBJECTDIR}/_ext/877975035/xl.o ../../shared/xl.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/camera.o: ../../shared/camera.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/camera.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/camera.o.ok ${OBJECTDIR}/_ext/877975035/camera.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/camera.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/camera.o.d" -o ${OBJECTDIR}/_ext/877975035/camera.o ../../shared/camera.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/payload.o: ../../shared/payload.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload.o.ok ${OBJECTDIR}/_ext/877975035/payload.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/payload.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/payload.o.d" -o ${OBJECTDIR}/_ext/877975035/payload.o ../../shared/payload.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/dfmem.o: ../../shared/dfmem.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/dfmem.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/dfmem.o.ok ${OBJECTDIR}/_ext/877975035/dfmem.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/dfmem.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/dfmem.o.d" -o ${OBJECTDIR}/_ext/877975035/dfmem.o ../../shared/dfmem.c  -fast-math
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o.ok ${OBJECTDIR}/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/main.o.d" -o ${OBJECTDIR}/main.o main.c  -fast-math
	
${OBJECTDIR}/cmdh.o: cmdh.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/cmdh.o.d 
	@${RM} ${OBJECTDIR}/cmdh.o.ok ${OBJECTDIR}/cmdh.o.err 
	@${FIXDEPS} "${OBJECTDIR}/cmdh.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/cmdh.o.d" -o ${OBJECTDIR}/cmdh.o cmdh.c  -fast-math
	
else
${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o: ../../hhu/C-lib/at86rf231_driver.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.ok ${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o.d" -o ${OBJECTDIR}/_ext/1917815105/at86rf231_driver.o ../../hhu/C-lib/at86rf231_driver.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/mac_packet.o: ../../hhu/C-lib/mac_packet.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/mac_packet.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/mac_packet.o.ok ${OBJECTDIR}/_ext/1917815105/mac_packet.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/mac_packet.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/mac_packet.o.d" -o ${OBJECTDIR}/_ext/1917815105/mac_packet.o ../../hhu/C-lib/mac_packet.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/motor_ctrl.o: ../../hhu/C-lib/motor_ctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.ok ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/motor_ctrl.o.d" -o ${OBJECTDIR}/_ext/1917815105/motor_ctrl.o ../../hhu/C-lib/motor_ctrl.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/ovcam.o: ../../hhu/C-lib/ovcam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/ovcam.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/ovcam.o.ok ${OBJECTDIR}/_ext/1917815105/ovcam.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/ovcam.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/ovcam.o.d" -o ${OBJECTDIR}/_ext/1917815105/ovcam.o ../../hhu/C-lib/ovcam.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/fast_queue.o: ../../hhu/C-lib/fast_queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/fast_queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/fast_queue.o.ok ${OBJECTDIR}/_ext/1917815105/fast_queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/fast_queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/fast_queue.o.d" -o ${OBJECTDIR}/_ext/1917815105/fast_queue.o ../../hhu/C-lib/fast_queue.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/packet_pool.o: ../../hhu/C-lib/packet_pool.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/packet_pool.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/packet_pool.o.ok ${OBJECTDIR}/_ext/1917815105/packet_pool.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/packet_pool.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/packet_pool.o.d" -o ${OBJECTDIR}/_ext/1917815105/packet_pool.o ../../hhu/C-lib/packet_pool.c  -fast-math
	
${OBJECTDIR}/_ext/1917815105/radio.o: ../../hhu/C-lib/radio.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1917815105 
	@${RM} ${OBJECTDIR}/_ext/1917815105/radio.o.d 
	@${RM} ${OBJECTDIR}/_ext/1917815105/radio.o.ok ${OBJECTDIR}/_ext/1917815105/radio.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1917815105/radio.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1917815105/radio.o.d" -o ${OBJECTDIR}/_ext/1917815105/radio.o ../../hhu/C-lib/radio.c  -fast-math
	
${OBJECTDIR}/_ext/1360930230/init.o: ../lib/init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1360930230 
	@${RM} ${OBJECTDIR}/_ext/1360930230/init.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360930230/init.o.ok ${OBJECTDIR}/_ext/1360930230/init.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1360930230/init.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/1360930230/init.o.d" -o ${OBJECTDIR}/_ext/1360930230/init.o ../lib/init.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/battery.o: ../../shared/battery.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/battery.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/battery.o.ok ${OBJECTDIR}/_ext/877975035/battery.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/battery.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/battery.o.d" -o ${OBJECTDIR}/_ext/877975035/battery.o ../../shared/battery.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/counter.o: ../../shared/counter.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/counter.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/counter.o.ok ${OBJECTDIR}/_ext/877975035/counter.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/counter.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/counter.o.d" -o ${OBJECTDIR}/_ext/877975035/counter.o ../../shared/counter.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/gyro.o: ../../shared/gyro.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/gyro.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/gyro.o.ok ${OBJECTDIR}/_ext/877975035/gyro.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/gyro.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/gyro.o.d" -o ${OBJECTDIR}/_ext/877975035/gyro.o ../../shared/gyro.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/init_default.o: ../../shared/init_default.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/init_default.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/init_default.o.ok ${OBJECTDIR}/_ext/877975035/init_default.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/init_default.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/init_default.o.d" -o ${OBJECTDIR}/_ext/877975035/init_default.o ../../shared/init_default.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/queue.o: ../../shared/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/queue.o.ok ${OBJECTDIR}/_ext/877975035/queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/queue.o.d" -o ${OBJECTDIR}/_ext/877975035/queue.o ../../shared/queue.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/spi_controller.o: ../../shared/spi_controller.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/spi_controller.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/spi_controller.o.ok ${OBJECTDIR}/_ext/877975035/spi_controller.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/spi_controller.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/spi_controller.o.d" -o ${OBJECTDIR}/_ext/877975035/spi_controller.o ../../shared/spi_controller.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/stopwatch.o: ../../shared/stopwatch.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/stopwatch.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/stopwatch.o.ok ${OBJECTDIR}/_ext/877975035/stopwatch.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/stopwatch.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/stopwatch.o.d" -o ${OBJECTDIR}/_ext/877975035/stopwatch.o ../../shared/stopwatch.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/xl.o: ../../shared/xl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/xl.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/xl.o.ok ${OBJECTDIR}/_ext/877975035/xl.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/xl.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/xl.o.d" -o ${OBJECTDIR}/_ext/877975035/xl.o ../../shared/xl.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/camera.o: ../../shared/camera.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/camera.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/camera.o.ok ${OBJECTDIR}/_ext/877975035/camera.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/camera.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/camera.o.d" -o ${OBJECTDIR}/_ext/877975035/camera.o ../../shared/camera.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/payload.o: ../../shared/payload.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/payload.o.ok ${OBJECTDIR}/_ext/877975035/payload.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/payload.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/payload.o.d" -o ${OBJECTDIR}/_ext/877975035/payload.o ../../shared/payload.c  -fast-math
	
${OBJECTDIR}/_ext/877975035/dfmem.o: ../../shared/dfmem.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/877975035 
	@${RM} ${OBJECTDIR}/_ext/877975035/dfmem.o.d 
	@${RM} ${OBJECTDIR}/_ext/877975035/dfmem.o.ok ${OBJECTDIR}/_ext/877975035/dfmem.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/877975035/dfmem.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/_ext/877975035/dfmem.o.d" -o ${OBJECTDIR}/_ext/877975035/dfmem.o ../../shared/dfmem.c  -fast-math
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o.ok ${OBJECTDIR}/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/main.o.d" -o ${OBJECTDIR}/main.o main.c  -fast-math
	
${OBJECTDIR}/cmdh.o: cmdh.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/cmdh.o.d 
	@${RM} ${OBJECTDIR}/cmdh.o.ok ${OBJECTDIR}/cmdh.o.err 
	@${FIXDEPS} "${OBJECTDIR}/cmdh.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -D__IMAGEPROC2 -D__DFMEM_8MBIT -I"./" -I"../lib" -I"../../hhu/C-lib/" -I"../../shared" -MMD -MF "${OBJECTDIR}/cmdh.o.d" -o ${OBJECTDIR}/cmdh.o cmdh.c  -fast-math
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowH.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1 -o dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowH.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}       -fast-math -Wl,--defsym=__MPLAB_BUILD=1,--heap=10000$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_PK3=1
else
dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowH.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowH.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}       -fast-math -Wl,--defsym=__MPLAB_BUILD=1,--heap=10000$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION)
	${MP_CC_DIR}/pic30-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/UnsteadyOpticalFlowH.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -omf=elf
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
