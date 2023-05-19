#--------------------------------------------------------------------------
#
#  Oracle IDE Boot Configuration File
#  Copyright 2000-2008 Oracle Corporation.
#  All Rights Reserved.
#
#--------------------------------------------------------------------------

#
# The ide.user.dir.var specifies the name of the environment variable
# that points to the root directory for user files.  The system and
# mywork directories will be created there.  If not defined, the IDE
# product will use its base directory as the user directory. (2776343)
#
ide.user.dir.var = IDE_USER_DIR

#
# Text buffer deadlock detection setting (OFF by default.)  Uncomment
# out the following option if encountering deadlocks that you suspect
# buffer deadlocks that may be due to locks not being released properly.
#
#buffer.deadlock.detection = true

#
# Put the xml parser into 9.0.4 compatability mode. We must do this before
# the product starts. Users of products based on the IDE should not
# change the value of this property.
#
oracle.xdkjava.compatibility.version = 9.0.4

#
# Specify the set of extant translations for resources loaded via
# BundleLoader. The format is a comma separated list of locales, for
# example ja,fr_CA. A translation will only be found if included in
# the list.
#
# Comment out the option to force BundleLoader to use the default
# locale. This is different to giving the property no value,
# meaning there are no translations.
#
# Note that this has no impact on ResourceBundle, which will continue
# to try to load locale specific resources even if they are certain not
# to exist.
#
oracle.translated.locales = de,es,fr,it,ja,ko,pt_BR,zh_CN,zh_TW

#
# Specify the set of locales under which the Windows MS Shell Dlg 2
# (usually Tahoma) can be used in the UI.  The format is a comma separated
# list of two-letter language codes, for example en,fr.
#
# Comment out the option to force the default setting of English only.
# This is different to giving the property no value, meaning the shell font
# is never to be used.  Generally, it is safe to use the shell font only
# with single-byte character sets.
#
# This setting is used only when running under JDK 5.0.
#
windows.shell.font.languages = en

#
# Specify the minimum version of Java this product will run on. The
# minimum specified here is a hard requirement of the IDE platform. Products
# can override this to a later version if required.
#
# The IDE will display the "Unsupported Java" alert if the Java version is
# less than the value specified here.
#
# For JDK1.8 and earlier, the accepted version strings are formatted as a version
# optionally followed by an underscore and release number. The version consists
# of 2 or 3 digits separated by periods where the first digit is a '1'. The release
# number is a positive number. Examples: 1.8.0_60, 1.8_120, 1.8, 1.8.0
#
# For JDK9 and higher, the accepted version strings are formatted as a major version
# optionally followed by a period and a minor version. Both the major and minor
# versions are positive numbers. Examples: 9, 9.2, 10.0, 11.23
#
ide.java.minversion=1.8

#
# Specify the maximum version of Java this product will run on.
#
# The IDE will display the "Unsupported Java" alert if the Java version is
# greater than **or equal to** the value specified here. If no value is
# specified, the IDE platform default is used, which is currently "1.9"
#
# See the doc of ide.java.minversion for acceptable version strings
#
ide.java.maxversion=1.9
