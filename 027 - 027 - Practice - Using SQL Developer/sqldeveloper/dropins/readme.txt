This is the JDeveloper extension drop-in directory.  To easily add a new OSGi 
bundle to JDeveloper, simply place the relevant JAR in this directory.  It will
be picked up automatically next time you start JDeveloper.

If multiple bundles with the same name are present in various dropins directories
and/or the main JDeveloper distribution, the bundles will be picked up in the
following order of preference:

1. extension-dt dropins
2. jdeveloper/dropins directory (if not explicitly specified via ide.bundle.search.path)
3. ide.bundle.search.path property entries (in the order specified)
4. check-for-updates dropins
5. core bundles included in JDeveloper

Please note that a reference to the jdeveloper/dropins directory can be included 
in the ide.bundle.search.path property, in which case it will not automatically be
preferred over the rest of the user-specified dropins directories.
