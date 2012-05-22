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
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/921515994/delay.o ${OBJECTDIR}/_ext/921515994/dfmem.o ${OBJECTDIR}/_ext/921515994/gyro.o ${OBJECTDIR}/_ext/921515994/init.o ${OBJECTDIR}/_ext/921515994/init_default.o ${OBJECTDIR}/_ext/921515994/interrupts.o ${OBJECTDIR}/_ext/921515994/ovcam.o ${OBJECTDIR}/_ext/921515994/ovcamHS.o ${OBJECTDIR}/_ext/921515994/stopwatch.o ${OBJECTDIR}/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/921515994/delay.o.d ${OBJECTDIR}/_ext/921515994/dfmem.o.d ${OBJECTDIR}/_ext/921515994/gyro.o.d ${OBJECTDIR}/_ext/921515994/init.o.d ${OBJECTDIR}/_ext/921515994/init_default.o.d ${OBJECTDIR}/_ext/921515994/interrupts.o.d ${OBJECTDIR}/_ext/921515994/ovcam.o.d ${OBJECTDIR}/_ext/921515994/ovcamHS.o.d ${OBJECTDIR}/_ext/921515994/stopwatch.o.d ${OBJECTDIR}/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/921515994/delay.o ${OBJECTDIR}/_ext/921515994/dfmem.o ${OBJECTDIR}/_ext/921515994/gyro.o ${OBJECTDIR}/_ext/921515994/init.o ${OBJECTDIR}/_ext/921515994/init_default.o ${OBJECTDIR}/_ext/921515994/interrupts.o ${OBJECTDIR}/_ext/921515994/ovcam.o ${OBJECTDIR}/_ext/921515994/ovcamHS.o ${OBJECTDIR}/_ext/921515994/stopwatch.o ${OBJECTDIR}/main.o


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
MP_LINKER_FILE_OPTION=,-Tp33FJ128MC706A.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/921515994/delay.o: ../imageproc-lib/delay.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/delay.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/delay.o.ok ${OBJECTDIR}/_ext/921515994/delay.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/delay.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../imageproc-lib/delay.s -o ${OBJECTDIR}/_ext/921515994/delay.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 --defsym=__MPLAB_DEBUG=1 --defsym=__ICD2RAM=1 --defsym=__DEBUG=1 --defsym=__MPLAB_DEBUGGER_ICD3=1 -g  -MD "${OBJECTDIR}/_ext/921515994/delay.o.d" -I".."$(MP_EXTRA_AS_POST)
	
${OBJECTDIR}/_ext/921515994/ovcamHS.o: ../imageproc-lib/ovcamHS.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcamHS.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcamHS.o.ok ${OBJECTDIR}/_ext/921515994/ovcamHS.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ovcamHS.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../imageproc-lib/ovcamHS.s -o ${OBJECTDIR}/_ext/921515994/ovcamHS.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 --defsym=__MPLAB_DEBUG=1 --defsym=__ICD2RAM=1 --defsym=__DEBUG=1 --defsym=__MPLAB_DEBUGGER_ICD3=1 -g  -MD "${OBJECTDIR}/_ext/921515994/ovcamHS.o.d" -I".."$(MP_EXTRA_AS_POST)
	
else
${OBJECTDIR}/_ext/921515994/delay.o: ../imageproc-lib/delay.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/delay.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/delay.o.ok ${OBJECTDIR}/_ext/921515994/delay.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/delay.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../imageproc-lib/delay.s -o ${OBJECTDIR}/_ext/921515994/delay.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 -g  -MD "${OBJECTDIR}/_ext/921515994/delay.o.d" -I".."$(MP_EXTRA_AS_POST)
	
${OBJECTDIR}/_ext/921515994/ovcamHS.o: ../imageproc-lib/ovcamHS.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcamHS.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcamHS.o.ok ${OBJECTDIR}/_ext/921515994/ovcamHS.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ovcamHS.o.d" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE)  ../imageproc-lib/ovcamHS.s -o ${OBJECTDIR}/_ext/921515994/ovcamHS.o -omf=elf -p=$(MP_PROCESSOR_OPTION) --defsym=__MPLAB_BUILD=1 -g  -MD "${OBJECTDIR}/_ext/921515994/ovcamHS.o.d" -I".."$(MP_EXTRA_AS_POST)
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/921515994/dfmem.o: ../imageproc-lib/dfmem.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/dfmem.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/dfmem.o.ok ${OBJECTDIR}/_ext/921515994/dfmem.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/dfmem.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/dfmem.o.d" -o ${OBJECTDIR}/_ext/921515994/dfmem.o ../imageproc-lib/dfmem.c  
	
${OBJECTDIR}/_ext/921515994/gyro.o: ../imageproc-lib/gyro.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/gyro.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/gyro.o.ok ${OBJECTDIR}/_ext/921515994/gyro.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/gyro.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/gyro.o.d" -o ${OBJECTDIR}/_ext/921515994/gyro.o ../imageproc-lib/gyro.c  
	
${OBJECTDIR}/_ext/921515994/init.o: ../imageproc-lib/init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/init.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/init.o.ok ${OBJECTDIR}/_ext/921515994/init.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/init.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/init.o.d" -o ${OBJECTDIR}/_ext/921515994/init.o ../imageproc-lib/init.c  
	
${OBJECTDIR}/_ext/921515994/init_default.o: ../imageproc-lib/init_default.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/init_default.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/init_default.o.ok ${OBJECTDIR}/_ext/921515994/init_default.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/init_default.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/init_default.o.d" -o ${OBJECTDIR}/_ext/921515994/init_default.o ../imageproc-lib/init_default.c  
	
${OBJECTDIR}/_ext/921515994/interrupts.o: ../imageproc-lib/interrupts.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/interrupts.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/interrupts.o.ok ${OBJECTDIR}/_ext/921515994/interrupts.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/interrupts.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/interrupts.o.d" -o ${OBJECTDIR}/_ext/921515994/interrupts.o ../imageproc-lib/interrupts.c  
	
${OBJECTDIR}/_ext/921515994/ovcam.o: ../imageproc-lib/ovcam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcam.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcam.o.ok ${OBJECTDIR}/_ext/921515994/ovcam.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ovcam.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/ovcam.o.d" -o ${OBJECTDIR}/_ext/921515994/ovcam.o ../imageproc-lib/ovcam.c  
	
${OBJECTDIR}/_ext/921515994/stopwatch.o: ../imageproc-lib/stopwatch.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/stopwatch.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/stopwatch.o.ok ${OBJECTDIR}/_ext/921515994/stopwatch.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/stopwatch.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/stopwatch.o.d" -o ${OBJECTDIR}/_ext/921515994/stopwatch.o ../imageproc-lib/stopwatch.c  
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o.ok ${OBJECTDIR}/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/main.o.d" -o ${OBJECTDIR}/main.o main.c  
	
else
${OBJECTDIR}/_ext/921515994/dfmem.o: ../imageproc-lib/dfmem.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/dfmem.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/dfmem.o.ok ${OBJECTDIR}/_ext/921515994/dfmem.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/dfmem.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/dfmem.o.d" -o ${OBJECTDIR}/_ext/921515994/dfmem.o ../imageproc-lib/dfmem.c  
	
${OBJECTDIR}/_ext/921515994/gyro.o: ../imageproc-lib/gyro.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/gyro.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/gyro.o.ok ${OBJECTDIR}/_ext/921515994/gyro.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/gyro.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/gyro.o.d" -o ${OBJECTDIR}/_ext/921515994/gyro.o ../imageproc-lib/gyro.c  
	
${OBJECTDIR}/_ext/921515994/init.o: ../imageproc-lib/init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/init.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/init.o.ok ${OBJECTDIR}/_ext/921515994/init.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/init.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/init.o.d" -o ${OBJECTDIR}/_ext/921515994/init.o ../imageproc-lib/init.c  
	
${OBJECTDIR}/_ext/921515994/init_default.o: ../imageproc-lib/init_default.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/init_default.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/init_default.o.ok ${OBJECTDIR}/_ext/921515994/init_default.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/init_default.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/init_default.o.d" -o ${OBJECTDIR}/_ext/921515994/init_default.o ../imageproc-lib/init_default.c  
	
${OBJECTDIR}/_ext/921515994/interrupts.o: ../imageproc-lib/interrupts.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/interrupts.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/interrupts.o.ok ${OBJECTDIR}/_ext/921515994/interrupts.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/interrupts.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/interrupts.o.d" -o ${OBJECTDIR}/_ext/921515994/interrupts.o ../imageproc-lib/interrupts.c  
	
${OBJECTDIR}/_ext/921515994/ovcam.o: ../imageproc-lib/ovcam.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcam.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/ovcam.o.ok ${OBJECTDIR}/_ext/921515994/ovcam.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/ovcam.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/ovcam.o.d" -o ${OBJECTDIR}/_ext/921515994/ovcam.o ../imageproc-lib/ovcam.c  
	
${OBJECTDIR}/_ext/921515994/stopwatch.o: ../imageproc-lib/stopwatch.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/921515994 
	@${RM} ${OBJECTDIR}/_ext/921515994/stopwatch.o.d 
	@${RM} ${OBJECTDIR}/_ext/921515994/stopwatch.o.ok ${OBJECTDIR}/_ext/921515994/stopwatch.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/921515994/stopwatch.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/_ext/921515994/stopwatch.o.d" -o ${OBJECTDIR}/_ext/921515994/stopwatch.o ../imageproc-lib/stopwatch.c  
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o.ok ${OBJECTDIR}/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -D__IMAGEPROC2 -D__DFMEM_32MBIT -I"../imageproc-lib" -MMD -MF "${OBJECTDIR}/main.o.d" -o ${OBJECTDIR}/main.o main.c  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -o dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}        -Wl,--defsym=__MPLAB_BUILD=1,--no-check-sections,-L"/opt/microchip/mplabc30/v3.24/lib",-Map="$(BINDIR_)$(TARGETBASE).map",--report-mem$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1
else
dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}        -Wl,--defsym=__MPLAB_BUILD=1,--no-check-sections,-L"/opt/microchip/mplabc30/v3.24/lib",-Map="$(BINDIR_)$(TARGETBASE).map",--report-mem$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION)
	${MP_CC_DIR}/pic30-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/unsteady_optical_flow.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -omf=elf
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
