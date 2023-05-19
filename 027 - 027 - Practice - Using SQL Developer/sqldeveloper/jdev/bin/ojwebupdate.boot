#--------------------------------------------------------------------------
#
#  Oracle JDeveloper Audit Boot Configuration File
#  Copyright 2006-2010 Oracle Corporation.
#  All Rights Reserved.
#
#--------------------------------------------------------------------------
include ide.boot

#
# The ide.user.dir.var specifies the name of the environment variable
# that points to the root directory for user files.  The system and
# mywork directories will be created there.  If not defined, the IDE
# product will use its base directory as the user directory.
#
# Needs to be here to honor env variables
ide.user.dir.var = JDEV_USER_HOME,JDEV_USER_DIR


ide.starter.bundle=oracle.webupdate-rt-boot
ide.starter.class=oracle.ideimpl.webupdate.boot.WebupdateStarter
ide.runner.bundle=oracle.webupdate-rt
ide.runner.class=oracle.ideimpl.webupdate.WebupdateRunner
initial.classpath=ide/lib/webupdate-rt-boot.jar
display.logger.mode=headless
oracle.ide.performance.PerformanceTracker=on
java.awt.headless=true
