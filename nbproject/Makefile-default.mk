#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif

# Environment
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
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/921515994/battery.o ${OBJECTDIR}/_ext/921515994/counter.o ${OBJECTDIR}/_ext/921515994/init_default.o ${OBJECTDIR}/_ext/921515994/gyro.o ${OBJECTDIR}/_ext/921515994/ovcam.o ${OBJECTDIR}/_ext/921515994/ovcamHS.o ${OBJECTDIR}/_ext/921515994/at86rf231_driver.o ${OBJECTDIR}/_ext/921515994/mac_packet.o ${OBJECTDIR}/_ext/921515994/init.o ${OBJECTDIR}/_ext/921515994/ppool.o ${OBJECTDIR}/_ext/921515994/radio.o ${OBJECTDIR}/_ext/921515994/cam.o ${OBJECTDIR}/_ext/921515994/delay.o ${OBJECTDIR}/_ext/921515994/dfmem.o ${OBJECTDIR}/_ext/921515994/payload.o ${OBJECTDIR}/_ext/921515994/spi_controller.o ${OBJECTDIR}/_ext/921515994/queue.o ${OBJECTDIR}/_ext/921515994/carray.o ${OBJECTDIR}/_ext/921515994/sclock.o ${OBJECTDIR}/_ext/921515994/interrupts.o ${OBJECTDIR}/main.o ${OBJECTDIR}/cmd.o ${OBJECTDIR}/motor_ctrl.o ${OBJECTDIR}/cambuff.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/921515994/battery.o.d ${OBJECTDIR}/_ext/921515994/counter.o.d ${OBJECTDIR}/_ext/921515994/init_default.o.d ${OBJECTDIR}/_ext/921515994/gyro.o.d ${OBJECTDIR}/_ext/921515994/ovcam.o.d ${OBJECTDIR}/_ext/921515994/ovcamHS.o.d ${OBJECTDIR}/_ext/921515994/at86rf231_driver.o.d ${OBJECTDIR}/_ext/921515994/mac_packet.o.d ${OBJECTDIR}/_ext/921515994/init.o.d ${OBJECTDIR}/_ext/921515994/ppool.o.d ${OBJECTDIR}/_ext/921515994/radio.o.d ${OBJECTDIR}/_ext/921515994/cam.o.d ${OBJECTDIR}/_ext/921515994/delay.o.d ${OBJECTDIR}/_ext/921515994/dfmem.o.d ${OBJECTDIR}/_ext/921515994/payload.o.d ${OBJECTDIR}/_ext/921515994/spi_controller.o.d ${OBJECTDIR}/_ext/921515994/queue.o.d ${OBJECTDIR}/_ext/921515994/carray.o.d ${OBJECTDIR}/_ext/921515994/sclock.o.d ${OBJECTDIR}/_ext/921515994/interrupts.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/cmd.o.d ${OBJECTDIR}/motor_ctrl.o.d ${OBJECTDIR}/cambuff.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/921515994/battery.o ${OBJECTDIR}/_ext/921515994/counter.o ${OBJECTDIR}/_ext/921515994/init_default.o ${OBJECTDIR}/_ext/921515994/gyro.o ${OBJECTDIR}/_ext/921515994/ovcam.o ${OBJECTDIR}/_ext/921515994/ovcamHS.o ${OBJECTDIR}/_ext/921515994/at86rf231_driver.o ${OBJECTDIR}/_ext/921515994/mac_packet.o ${OBJECTDIR}/_ext/921515994/init.o ${OBJECTDIR}/_ext/921515994/ppool.o ${OBJECTDIR}/_ext/921515994/radio.o ${OBJECTDIR}/_ext/921515994/cam.o ${OBJECTDIR}/_ext/921515994/delay.o ${OBJECTDIR}/_ext/921515994/dfmem.o ${OBJECTDIR}/_ext/921515994/payload.o ${OBJECTDIR}/_ext/921515994/spi_controller.o ${OBJECTDIR}/_ext/921515994/queue.o ${OBJECTDIR}/_ext/921515994/carray.o ${OBJECTDIR}/_ext/921515994/sclock.o ${OBJECTDIR}/_ext/921515994/interrupts.o ${OBJECTDIR}/main.o ${OBJECTDIR}/cmd.o ${OBJECTDIR}/motor_ctrl.o ${OBJECTDIR}/cambuff.o


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=33FJ128MC706A
MP_LINKER_FILE_OPTION=,--script=p33FJ128MC706A.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/921515994/battery.o: ../imageproc-lib/battery.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/battery.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/battery.c  -o ${OBJECTDIR}/_ext/921515994/battery.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/battery.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/battery.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/counter.o: ../imageproc-lib/counter.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/counter.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/counter.c  -o ${OBJECTDIR}/_ext/921515994/counter.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/counter.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/counter.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/init_default.o: ../imageproc-lib/init_default.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/init_default.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/init_default.c  -o ${OBJECTDIR}/_ext/921515994/init_default.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/init_default.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/init_default.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/gyro.o: ../imageproc-lib/gyro.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/gyro.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/gyro.c  -o ${OBJECTDIR}/_ext/921515994/gyro.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/gyro.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/gyro.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/ovcam.o: ../imageproc-lib/ovcam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcam.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/ovcam.c  -o ${OBJECTDIR}/_ext/921515994/ovcam.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/ovcam.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ovcam.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/at86rf231_driver.o: ../imageproc-lib/at86rf231_driver.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/at86rf231_driver.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/at86rf231_driver.c  -o ${OBJECTDIR}/_ext/921515994/at86rf231_driver.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/at86rf231_driver.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/at86rf231_driver.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/mac_packet.o: ../imageproc-lib/mac_packet.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/mac_packet.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/mac_packet.c  -o ${OBJECTDIR}/_ext/921515994/mac_packet.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/mac_packet.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/mac_packet.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/init.o: ../imageproc-lib/init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/init.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/init.c  -o ${OBJECTDIR}/_ext/921515994/init.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/init.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/init.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/ppool.o: ../imageproc-lib/ppool.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ppool.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/ppool.c  -o ${OBJECTDIR}/_ext/921515994/ppool.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/ppool.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ppool.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/radio.o: ../imageproc-lib/radio.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/radio.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/radio.c  -o ${OBJECTDIR}/_ext/921515994/radio.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/radio.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/radio.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/cam.o: ../imageproc-lib/cam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/cam.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/cam.c  -o ${OBJECTDIR}/_ext/921515994/cam.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/cam.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/cam.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/dfmem.o: ../imageproc-lib/dfmem.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/dfmem.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/dfmem.c  -o ${OBJECTDIR}/_ext/921515994/dfmem.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/dfmem.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/dfmem.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/payload.o: ../imageproc-lib/payload.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/payload.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/payload.c  -o ${OBJECTDIR}/_ext/921515994/payload.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/payload.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/payload.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/spi_controller.o: ../imageproc-lib/spi_controller.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/spi_controller.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/spi_controller.c  -o ${OBJECTDIR}/_ext/921515994/spi_controller.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/spi_controller.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/spi_controller.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/queue.o: ../imageproc-lib/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/queue.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/queue.c  -o ${OBJECTDIR}/_ext/921515994/queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/queue.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/queue.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/carray.o: ../imageproc-lib/carray.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/carray.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/carray.c  -o ${OBJECTDIR}/_ext/921515994/carray.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/carray.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/carray.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/sclock.o: ../imageproc-lib/sclock.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/sclock.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/sclock.c  -o ${OBJECTDIR}/_ext/921515994/sclock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/sclock.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/sclock.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/interrupts.o: ../imageproc-lib/interrupts.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/interrupts.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/interrupts.c  -o ${OBJECTDIR}/_ext/921515994/interrupts.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/interrupts.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/interrupts.o.d" $(SILENT) 
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/main.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) 
	
${OBJECTDIR}/cmd.o: cmd.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/cmd.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  cmd.c  -o ${OBJECTDIR}/cmd.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/cmd.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/cmd.o.d" $(SILENT) 
	
${OBJECTDIR}/motor_ctrl.o: motor_ctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/motor_ctrl.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  motor_ctrl.c  -o ${OBJECTDIR}/motor_ctrl.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/motor_ctrl.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/motor_ctrl.o.d" $(SILENT) 
	
${OBJECTDIR}/cambuff.o: cambuff.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/cambuff.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  cambuff.c  -o ${OBJECTDIR}/cambuff.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/cambuff.o.d"    -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/cambuff.o.d" $(SILENT) 
	
else
${OBJECTDIR}/_ext/921515994/battery.o: ../imageproc-lib/battery.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/battery.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/battery.c  -o ${OBJECTDIR}/_ext/921515994/battery.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/battery.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/battery.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/counter.o: ../imageproc-lib/counter.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/counter.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/counter.c  -o ${OBJECTDIR}/_ext/921515994/counter.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/counter.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/counter.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/init_default.o: ../imageproc-lib/init_default.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/init_default.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/init_default.c  -o ${OBJECTDIR}/_ext/921515994/init_default.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/init_default.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/init_default.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/gyro.o: ../imageproc-lib/gyro.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/gyro.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/gyro.c  -o ${OBJECTDIR}/_ext/921515994/gyro.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/gyro.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/gyro.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/ovcam.o: ../imageproc-lib/ovcam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcam.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/ovcam.c  -o ${OBJECTDIR}/_ext/921515994/ovcam.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/ovcam.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ovcam.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/at86rf231_driver.o: ../imageproc-lib/at86rf231_driver.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/at86rf231_driver.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/at86rf231_driver.c  -o ${OBJECTDIR}/_ext/921515994/at86rf231_driver.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/at86rf231_driver.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/at86rf231_driver.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/mac_packet.o: ../imageproc-lib/mac_packet.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/mac_packet.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/mac_packet.c  -o ${OBJECTDIR}/_ext/921515994/mac_packet.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/mac_packet.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/mac_packet.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/init.o: ../imageproc-lib/init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/init.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/init.c  -o ${OBJECTDIR}/_ext/921515994/init.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/init.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/init.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/ppool.o: ../imageproc-lib/ppool.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ppool.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/ppool.c  -o ${OBJECTDIR}/_ext/921515994/ppool.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/ppool.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ppool.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/radio.o: ../imageproc-lib/radio.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/radio.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/radio.c  -o ${OBJECTDIR}/_ext/921515994/radio.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/radio.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/radio.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/cam.o: ../imageproc-lib/cam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/cam.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/cam.c  -o ${OBJECTDIR}/_ext/921515994/cam.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/cam.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/cam.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/dfmem.o: ../imageproc-lib/dfmem.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/dfmem.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/dfmem.c  -o ${OBJECTDIR}/_ext/921515994/dfmem.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/dfmem.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/dfmem.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/payload.o: ../imageproc-lib/payload.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/payload.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/payload.c  -o ${OBJECTDIR}/_ext/921515994/payload.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/payload.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/payload.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/spi_controller.o: ../imageproc-lib/spi_controller.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/spi_controller.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/spi_controller.c  -o ${OBJECTDIR}/_ext/921515994/spi_controller.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/spi_controller.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/spi_controller.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/queue.o: ../imageproc-lib/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/queue.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/queue.c  -o ${OBJECTDIR}/_ext/921515994/queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/queue.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/queue.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/carray.o: ../imageproc-lib/carray.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/carray.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/carray.c  -o ${OBJECTDIR}/_ext/921515994/carray.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/carray.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/carray.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/sclock.o: ../imageproc-lib/sclock.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/sclock.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/sclock.c  -o ${OBJECTDIR}/_ext/921515994/sclock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/sclock.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/sclock.o.d" $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/interrupts.o: ../imageproc-lib/interrupts.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/interrupts.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../imageproc-lib/interrupts.c  -o ${OBJECTDIR}/_ext/921515994/interrupts.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/921515994/interrupts.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/interrupts.o.d" $(SILENT) 
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/main.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) 
	
${OBJECTDIR}/cmd.o: cmd.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/cmd.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  cmd.c  -o ${OBJECTDIR}/cmd.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/cmd.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/cmd.o.d" $(SILENT) 
	
${OBJECTDIR}/motor_ctrl.o: motor_ctrl.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/motor_ctrl.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  motor_ctrl.c  -o ${OBJECTDIR}/motor_ctrl.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/motor_ctrl.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/motor_ctrl.o.d" $(SILENT) 
	
${OBJECTDIR}/cambuff.o: cambuff.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/cambuff.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  cambuff.c  -o ${OBJECTDIR}/cambuff.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/cambuff.o.d"    -g -omf=elf -fast-math -O0 -I"./" -I"../imageproc-lib/" -D__IMAGEPROC2 -D__DFMEM_32MBIT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/cambuff.o.d" $(SILENT) 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/921515994/ovcamHS.o: ../imageproc-lib/ovcamHS.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcamHS.o.d 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../imageproc-lib/ovcamHS.s  -o ${OBJECTDIR}/_ext/921515994/ovcamHS.o  -c -mcpu=$(MP_PROCESSOR_OPTION)    -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -Wa,-MD,"${OBJECTDIR}/_ext/921515994/ovcamHS.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,-g,--no-relax$(MP_EXTRA_AS_POST)
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ovcamHS.o.d"  $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/delay.o: ../imageproc-lib/delay.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/delay.o.d 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../imageproc-lib/delay.s  -o ${OBJECTDIR}/_ext/921515994/delay.o  -c -mcpu=$(MP_PROCESSOR_OPTION)    -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -Wa,-MD,"${OBJECTDIR}/_ext/921515994/delay.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,-g,--no-relax$(MP_EXTRA_AS_POST)
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/delay.o.d"  $(SILENT) 
	
else
${OBJECTDIR}/_ext/921515994/ovcamHS.o: ../imageproc-lib/ovcamHS.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcamHS.o.d 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../imageproc-lib/ovcamHS.s  -o ${OBJECTDIR}/_ext/921515994/ovcamHS.o  -c -mcpu=$(MP_PROCESSOR_OPTION)    -omf=elf -fast-math -Wa,-MD,"${OBJECTDIR}/_ext/921515994/ovcamHS.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ovcamHS.o.d"  $(SILENT) 
	
${OBJECTDIR}/_ext/921515994/delay.o: ../imageproc-lib/delay.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/delay.o.d 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../imageproc-lib/delay.s  -o ${OBJECTDIR}/_ext/921515994/delay.o  -c -mcpu=$(MP_PROCESSOR_OPTION)    -omf=elf -fast-math -Wa,-MD,"${OBJECTDIR}/_ext/921515994/delay.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/delay.o.d"  $(SILENT) 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemblePreproc
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)    -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -fast-math -Wl,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,$(MP_LINKER_FILE_OPTION),--heap=10000,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io$(MP_EXTRA_LD_POST) 
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)    -omf=elf -fast-math -Wl,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--heap=10000,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io$(MP_EXTRA_LD_POST) 
	${MP_CC_DIR}/xc16-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -a  -omf=elf 
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell "${PATH_TO_IDE_BIN}"mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
