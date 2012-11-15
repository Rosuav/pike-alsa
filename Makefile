# Generated automatically from Makefile.in by configure.

# -*- Makefile -*-
#
# Start of make_variables.in
#
# Note: This template is actually used only for make_variables in the
# subdirectories; the one created in the build base dir is just an
# unwanted by-product.

# There's magic to propagate variables to subdir configure scripts and
# to retain those variables when a subdir is reconfigured
# individually:
#
# Lines beginning with "#propagated_variables:" list such variables.
# They are available both as make variables and in the configure
# script environment. The PIKE_RETAIN_VARIABLES macro (called through
# AC_MODULE_INIT) reads them from the propagated_variables file if it
# exists, and assigns them in the environment only if they don't have
# any value already.
#
# Note: The easiest way to force full repropagation is to rerun the
# core configure script (e.g. through "make force_configure" in the
# top directory).

CC=/usr/local/pike/7.9.5/include/pike/smartlink gcc
CXX=/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/smartlink g++
CPP=gcc -E
MOD_LDSHARED=gcc -shared  
AR=/usr/bin/ar
INSTALL=/usr/bin/install -c
BASE_CFLAGS= -g -ggdb3 -m64
BASE_CPPFLAGS= -I/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/bundles/include -I/usr/local/include
CCSHARED= -fPIC -DDYNAMIC_MODULE
BASE_LDFLAGS= -L/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/bundles/lib64 -L/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/bundles/lib/64 -L/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/bundles/lib/. -L/usr/local/lib -R/usr/local/lib -L/usr/lib/gcc/x86_64-linux-gnu/4.5 -R/usr/lib/gcc/x86_64-linux-gnu/4.5 -L/usr/lib -R/usr/lib -L/lib -R/lib -L/usr/lib/x86_64-linux-gnu -R/usr/lib/x86_64-linux-gnu -ldl -lrt -lnsl -lm  -lpthread -lcrypt
OPTIMIZE= -fvisibility=hidden -O3 -pipe
WARN= -W -Wall -Wno-unused -Wcomment -Wformat -Wformat-security -Wimplicit-function-declaration -Wmultichar -Wswitch -Wuninitialized -Wpointer-arith -Wchar-subscripts -Wno-long-long -Wdeclaration-after-statement
PROFIL=
LDSHARED_MODULE_REQS=
TMP_BUILDDIR=/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64
TMP_BINDIR=/home/sikorsky/pike/bin
PIKE_SRC_DIR=/usr/local/pike/7.9.5/include/pike
BUILD_BASE=/usr/local/pike/7.9.5/include/pike
BUILD_PIKE=pike
POST_MODULE_BUILD_TYPE=dynamic
MT_FIX_MODULE_SO=@:
PKG_CONFIG_PATH=/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/bundles/lib/pkgconfig:/usr/local/lib/pkgconfig
#propagated_variables: CC CXX CPP MOD_LDSHARED AR INSTALL
#propagated_variables: BASE_CFLAGS BASE_CPPFLAGS CCSHARED BASE_LDFLAGS
#propagated_variables: OPTIMIZE WARN PROFIL
#propagated_variables: LDSHARED_MODULE_REQS
#propagated_variables: TMP_BUILDDIR TMP_BINDIR PIKE_SRC_DIR BUILD_BASE
#propagated_variables: BUILD_PIKE POST_MODULE_BUILD_TYPE
#propagated_variables: MT_FIX_MODULE_SO PKG_CONFIG_PATH


prefix=/usr/local
exec_prefix=$(prefix)/bin
TMP_LIBDIR=$(TMP_BUILDDIR)/lib
SRCDIR=.

DEFAULT_RUNPIKE=$(TMP_BUILDDIR)/$(BUILD_PIKE) -DNOT_INSTALLED -DPRECOMPILED_SEARCH_MORE -m$(TMP_BUILDDIR)/master.pike $(PIKEOPTS)
FINAL_PIKE=$(TMP_BUILDDIR)/pike -DNOT_INSTALLED -DPRECOMPILED_SEARCH_MORE -m$(TMP_BUILDDIR)/master.pike $(PIKEOPTS)
USE_PIKE=pike $(PIKEOPTS)
RUNPIKE=$(DEFAULT_RUNPIKE)

DEFINES= -I/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/bundles/include -I/usr/local/include  
OTHERFLAGS= -g -ggdb3 -m64 $(OSFLAGS) $(OPTIMIZE) $(WARN) $(PROFIL)
NOOPTFLAGS= -g -ggdb3 -m64 $(OSFLAGS) $(WARN) $(PROFIL)

PMOD_TARGETS=$(SRCDIR)/pikealsa.c
make_variables_in=../../..//usr/local/pike/7.9.5/include/pike/make_variables.in
MODULE_PMOD_IN=
MODULE_WRAPPER_PREFIX=

MODNAME=pikealsa
MODPATH=
MODDIR=

LIBGCC=/usr/lib/gcc/x86_64-linux-gnu/4.5.1/libgcc.a

# End of make_variables.in
OBJS=pikealsa.o
AUTODOC_SRC_IN=
MODDIR=
MODNAME=pikealsa
MODULE_PMOD_IN=
MODULE_LDFLAGS= -L/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/bundles/lib64 -L/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/bundles/lib/64 -L/home/sikorsky/pike/build/linux-2.6.35-32-generic-x86_64/bundles/lib/. -L/usr/local/lib -R/usr/local/lib -L/usr/lib/gcc/x86_64-linux-gnu/4.5 -R/usr/lib/gcc/x86_64-linux-gnu/4.5 -L/usr/lib -R/usr/lib -L/lib -R/lib -L/usr/lib/x86_64-linux-gnu -R/usr/lib/x86_64-linux-gnu -ldl -lrt -lnsl -lm  -lpthread -lcrypt  -lasound
CONFIG_HEADERS=

LC_REQ=-lc

LINKAGE_CPPFLAGS=
DYNAMIC_LINKAGE_CFLAGS= -fPIC -DDYNAMIC_MODULE
STATIC_LINKAGE_CFLAGS=
LINKAGE_CFLAGS=$(DYNAMIC_LINKAGE_CFLAGS)

MODULE_PROGRAM=.$(MODULE_WRAPPER_PREFIX)$(MODNAME)
MODULE_TARGET=$(TMP_MODULE_BASE)/$(MODDIR)$(MODULE_WRAPPER_PREFIX)$(MODNAME).so

# The reason for this is that we can't use targets directly to specify
# the build type; many module makefiles depend on being able to
# override the default target.
all:
	@case "x$$MODULE_BUILD_TYPE" in \
	  xstatic) $(MAKE) $(MAKE_FLAGS) static;; \
	  xdynamic) $(MAKE) $(MAKE_FLAGS) dynamic;; \
	  x) $(MAKE) $(MAKE_FLAGS) static dynamic;; \
	  *) \
	    echo "Invalid MODULE_BUILD_TYPE: $$MODULE_BUILD_TYPE" >&2; \
	    exit 1;; \
	esac

#
# Contains stuff common to both dynamic_module_makefile and
# static_module_makefile.
#
# Modules should NOT use this file directly, but instead use either
# dynamic_module_makefile or static_module_makefile as appropriate.
#

PREFLAGS=-I. -I$(SRCDIR) -I$(BUILD_BASE) -I$(PIKE_SRC_DIR) $(LINKAGE_CPPFLAGS) $(MODULE_CPPFLAGS) $(DEFINES)
CFLAGS=$(MODULE_CFLAGS) $(OTHERFLAGS) $(LINKAGE_CFLAGS)
NOOPT_CFLAGS=$(MODULE_CFLAGS) $(NOOPTFLAGS) $(LINKAGE_CFLAGS)

# MAKE_FLAGS_BASE must not contain LINKAGE_*.
MAKE_FLAGS_BASE = "prefix=$(prefix)" "exec_prefix=$(exec_prefix)" "CC=$(CC)" "OTHERFLAGS=$(OTHERFLAGS)" "TMP_BINDIR=$(TMP_BINDIR)" "DEFINES=$(DEFINES)" "TMP_LIBDIR=$(TMP_LIBDIR)" "RUNPIKE=$(RUNPIKE)" "INSTALL=$(INSTALL)" "AR=$(AR)" "NOOPTFLAGS=$(NOOPTFLAGS)" $(MODULE_MAKE_FLAGS)
MAKE_FLAGS = $(MAKE_FLAGS_BASE) "LINKAGE_CFLAGS=$(LINKAGE_CFLAGS)"

MODULE_BASE=$(BUILD_BASE)/modules
TMP_MODULE_BASE=$(TMP_LIBDIR)/modules

force:
	@:

# Note that module-preamble isn't executed at all for post modules
# when dynamic modules are enabled.
module-preamble: linker_options modlist_segment

module-main: Makefile $(MODULE_TARGET) module.pmod
	@if [ x"$(PIKE_EXTERNAL_MODULE)" = x -a x"$(MODULE_PMOD_IN)" != x ]; then \
	  $(TMP_BINDIR)/install_module module.pmod $(TMP_MODULE_BASE)/$(MODDIR)$(MODNAME).pmod ; \
	fi

$(MODULE_ARCHIVES) ThisIsAPhonyTargetBlaBlaBla: force
	@a=`echo $@ | sed -e 's@/[^/]*$$@@'` ; \
	 m=`echo $@ | sed -e 's@.*/@@g'`; \
	echo Making $(MODNAME)/$$a/$$m ; \
	( rm $$a/remake >/dev/null 2>&1 ||: ; \
	  cd $$a && ( $(MAKE) $(MAKE_FLAGS) $$m || \
	              ( test -f remake ; $(MAKE) $(MAKE_FLAGS) $$m ) ) \
	) || exit $$?

.SUFFIXES:
.SUFFIXES: .c .o .cmod .protos .m .mmod .cc .ccmod

.cmod.c: $(BUILD_BASE)/precompile.sh-stamp $(TMP_BINDIR)/precompile.pike
	$(BUILD_BASE)/precompile.sh precompile.pike $(PRECOMPILER_ARGS) >"$@" "$<" || { rm "$@"; exit 1; }

.mmod.m: $(BUILD_BASE)/precompile.sh-stamp $(TMP_BINDIR)/precompile.pike
	$(BUILD_BASE)/precompile.sh precompile.pike $(PRECOMPILER_ARGS) >"$@" "$<" || { rm "$@"; exit 1; }

.ccmod.cc: $(BUILD_BASE)/precompile.sh-stamp $(TMP_BINDIR)/precompile.pike
	$(BUILD_BASE)/precompile.sh precompile.pike $(PRECOMPILER_ARGS) >"$@" "$<" || { rm "$@"; exit 1; }


# GCC dumps core on some files @ OSF1
# This kluge should work around that...
.c.o:
	@echo "Compiling `echo '$<' | sed -e 's|^$(PIKE_SRC_DIR)/||'`" ; \
	rm -f $@.fail >/dev/null 2>&1; \
	if $(CC) $(PREFLAGS) $(CFLAGS) -c $< -o $@ ; then : ; else \
	  status=$$?; \
	  if test x"yes" = xyes ; then \
	    echo "WARNING: Compiler failure! Trying without optimization!" >&2;\
	    echo "$(CC) $(PREFLAGS) $(CFLAGS) -c $< -o $@" >$@.fail ;\
	    if NO_ULIMIT=yes $(CC) $(PREFLAGS) $(NOOPT_CFLAGS) -c $< -o $@ ; then : ; else \
	      status=$$?; \
	      echo "Compilation command was:" >&2;\
	      echo "$(CC) $(PREFLAGS) $(NOOPT_CFLAGS) -c $< -o $@" >&2 ;\
	      exit $$status; \
	    fi; \
	  else \
	    echo "Compilation command was:" >&2;\
	    echo "$(CC) $(PREFLAGS) $(CFLAGS) -c $< -o $@" >&2 ;\
	    exit $$status; \
	  fi; \
	fi

.c.protos: $(BUILD_BASE)/precompile.sh-stamp
	./precompile.sh --cache fake_dynamic_load.pike >"$@" --cpp --protos \
	  $(CPP) $(PREFLAGS) -DPMOD_EXPORT=PMOD_EXPORT \
	    -DPMOD_PROTO=PMOD_PROTO -DPIKE_PRECOMPILER=1 "$<" || \
	  { rm "$@"; exit 1; }
.m.o:
	@echo "Compiling `echo '$<' | sed -e 's|^$(PIKE_SRC_DIR)/||'`" ; \
	rm -f $@.fail >/dev/null 2>&1; \
	if $(CC) $(PREFLAGS) $(CFLAGS) -c $< -o $@ ; then : ; else \
	  status=$$?; \
	  if test x"yes" = xyes ; then \
	    echo "WARNING: Compiler failure! Trying without optimization!" >&2;\
	    echo "$(CC) $(PREFLAGS) $(CFLAGS) -c $< -o $@" >$@.fail ;\
	    if NO_ULIMIT=yes $(CC) $(PREFLAGS) $(NOOPT_CFLAGS) -c $< -o $@ ; then : ; else \
	      status=$$?; \
	      echo "Compilation command was:" >&2;\
	      echo "$(CC) $(PREFLAGS) $(NOOPT_CFLAGS) -c $< -o $@" >&2 ;\
	      exit $$status; \
	    fi; \
	  else \
	    echo "Compilation command was:" >&2;\
	    echo "$(CC) $(PREFLAGS) $(CFLAGS) -c $< -o $@" >&2 ;\
	    exit $$status; \
	  fi; \
	fi

.m.protos: $(BUILD_BASE)/precompile.sh-stamp
	./precompile.sh --cache fake_dynamic_load.pike >"$@" --cpp --protos \
	  $(CPP) $(PREFLAGS) -DPMOD_EXPORT=PMOD_EXPORT \
	    -DPMOD_PROTO=PMOD_PROTO -DPIKE_PRECOMPILER=1 "$<" || \
	  { rm "$@"; exit 1; }

.cc.o:
	@echo "Compiling `echo '$<' | sed -e 's|^$(PIKE_SRC_DIR)/||'`" ; \
	rm -f $@.fail >/dev/null 2>&1; \
	if $(CXX) $(PREFLAGS) $(CFLAGS) -c $< -o $@ ; then : ; else \
	  status=$$?; \
	  if test x"yes" = xyes ; then \
	    echo "WARNING: Compiler failure! Trying without optimization!" >&2;\
	    echo "$(CXX) $(PREFLAGS) $(CFLAGS) -c $< -o $@" >$@.fail ;\
	    if NO_ULIMIT=yes $(CXX) $(PREFLAGS) $(NOOPT_CFLAGS) -c $< -o $@ ; then : ; else \
	      status=$$?; \
	      echo "Compilation command was:" >&2;\
	      echo "$(CXX) $(PREFLAGS) $(NOOPT_CFLAGS) -c $< -o $@" >&2 ;\
	      exit $$status; \
	    fi; \
	  else \
	    echo "Compilation command was:" >&2;\
	    echo "$(CXX) $(PREFLAGS) $(CFLAGS) -c $< -o $@" >&2 ;\
	    exit $$status; \
	  fi; \
	fi

.cc.protos: $(BUILD_BASE)/precompile.sh-stamp
	./precompile.sh --cache fake_dynamic_load.pike >"$@" --cpp --protos \
	  $(CXXCPP) $(PREFLAGS) -DPMOD_EXPORT=PMOD_EXPORT \
	    -DPMOD_PROTO=PMOD_PROTO -DPIKE_PRECOMPILER=1 "$<" || \
	  { rm "$@"; exit 1; }

propagated_variables:

make_variables: $(make_variables_in) config.status propagated_variables
	CONFIG_FILES="make_variables:$(make_variables_in)" CONFIG_HEADERS="" ./config.status

# $(CONFIG_HEADERS) should exist but they need not be more fresh than
# config.status since it only rewrites them if they actually change,
# but they do need to be regenerated if the configure script has changed.
# We add an intermediate target "stamp-h" that keeps track of when we
# regenerated the headers last.
$(CONFIG_HEADERS) dummy_config_header: stamp-h

stamp-h: config.status
	@if [ x"$(CONFIG_HEADERS)" != x ]; then \
	  echo CONFIG_HEADERS="$(CONFIG_HEADERS)" ./config.status; \
	  CONFIG_HEADERS="$(CONFIG_HEADERS)" ./config.status; \
	fi; \
	touch stamp-h

$(SRCDIR)/configure: $(SRCDIR)/configure.in $(PIKE_SRC_DIR)/aclocal.m4
	cd $(SRCDIR) && $(PIKE_SRC_DIR)/run_autoconfig .

config.status: $(SRCDIR)/configure propagated_variables
	./config.status --recheck

module.pmod: Makefile $(MODULE_PMOD_IN)
	@if [ "x$(MODULE_PMOD_IN)" != "x" ]; then \
	  echo "Making module.pmod" ; \
	  if [ -f "$(MODULE_PMOD_IN)" ]; then \
	    sed -e "s#@module@#$(MODULE_PROGRAM)#" \
	      <"$(MODULE_PMOD_IN)" >module.pmod; \
	  else \
	   if [ -d "$(MODULE_PMOD_IN)" ]; then \
	     find "$(MODULE_PMOD_IN)" -type d -print | sed -e "s#$(MODULE_PMOD_IN)#module.pmod#" | xargs -n 1 mkdir -p ;\
	     for mi in `find "$(MODULE_PMOD_IN)" -type f -print | sed -e "s#$(MODULE_PMOD_IN)##"` ;\
	     do \
	       sed -e "s#@module@#$(MODULE_PROGRAM)#" \
	         <"$(MODULE_PMOD_IN)/$$mi" > "module.pmod/$$mi" ; \
	     done; \
	  else \
	    echo 'Missing source for module.pmod "$(MODULE_PMOD_IN)".' >&2; \
	    exit 1; \
	  fi ;\
	fi; \
	fi


clean_here:
	-rm -f *.o *.fail *.obj *.a *.so stamp-h linker_options modlist_segment testsuite $(MODULE_CLEAN_EXTRA) doc build_type
	-rm -f confdefs.h conftest.* hdrlist.h *.manifest *.pdb *.lib *.exp
	-rm -rf plib refdoc module.pmod doc

clean: clean_here
	@for a in '' $(MODULE_SUBDIRS) ; do \
	  if test "x$$a" = "x"; then :; \
	  else ( cd $$a ; $(MAKE) $(MAKE_FLAGS) clean ) ; fi ; \
	done

spotless: clean_here
	-rm -f config.cache config.log config.status Makefile propagated_variables make_variables dependencies pike_*.feature
	-rm -f core core.* .pure $(MODULE_SPOTLESS_EXTRA)
	@for a in '' $(MODULE_SUBDIRS) ; do \
	  if test "x$$a" = "x"; then :; \
	  else ( cd $$a ; $(MAKE) $(MAKE_FLAGS) spotless ) ; fi ; \
	done


depend: $(SRC_TARGETS) $(PMOD_TARGETS) Makefile
	@gcc -MM -MG $(PREFLAGS) $(SRCDIR)/*.c | $(TMP_BINDIR)/fixdepends.sh "$(SRCDIR)" "$(PIKE_SRC_DIR)" "$(BUILD_BASE)"
	@CONFIG_FILES=Makefile CONFIG_HEADERS="" ./config.status
	@for a in '' $(MODULE_SUBDIRS) ; do \
	  if test "x$$a" = "x"; then :; else \
	    echo Making depend in $$a; \
	    ( cd $$a && { \
	      rm -f remake; \
	      $(MAKE) $(MAKE_FLAGS) depend || \
		if test -f remake; then $(MAKE) $(MAKE_FLAGS) depend; \
		else exit $$?; fi; \
	    }); \
	  fi; \
	done

pike_external_module: plib/modules
	@$(MAKE) $(MAKE_FLAGS) LOCAL_MODULE_PATH="./plib/modules" local_install

refdoc:
	@test -d refdoc || mkdir refdoc

refdoc/modref: refdoc
	@test -d refdoc/modref || mkdir refdoc/modref

plib/doc_build/images: plib/doc_build
	@test -d plib/doc_build/images || mkdir plib/doc_build/images

plib/doc_build: plib
	@test -d plib/doc_build || mkdir plib/doc_build

plib/modules: plib
	@test -d plib/modules || mkdir plib/modules

plib/refdoc: plib
	@test -d plib/refdoc || mkdir plib/refdoc

plib:
	@test -d plib || mkdir plib

#verify / debug
testsuite: $(SRCDIR)/testsuite.in $(REAL_TESTSUITE) $(TMP_BINDIR)/mktestsuite
	@if test "x$(REAL_TESTSUITE)" != x ; then \
	  cp $(SRCDIR)/$(REAL_TESTSUITE) testsuite; \
	else \
	  if test "$$PIKE_PATH_TRANSLATE" = ""; then \
	    $(TMP_BINDIR)/mktestsuite $(SRCDIR)/testsuite.in >testsuite \
	      -DSRCDIR="`echo $(SRCDIR)|$(BUILD_BASE)/posix_to_native.sh`"; \
	  else \
	    $(TMP_BINDIR)/mktestsuite $(SRCDIR)/testsuite.in >testsuite \
	      -DSRCDIR="`echo $(SRCDIR)|sed -e $$PIKE_PATH_TRANSLATE|$(BUILD_BASE)/posix_to_native.sh`"; \
	  fi; \
	fi

extra_tests: $(MODULE_TESTS)

verify: testsuite $(MODULE_TESTS) $(PIKE_EXTERNAL_MODULE)
	$(FINAL_PIKE) -Mplib/modules $(TMP_BINDIR)/test_pike.pike testsuite

verbose_verify: testsuite $(MODULE_TESTS) $(PIKE_EXTERNAL_MODULE)
	@$(FINAL_PIKE) -Mplib/modules $(TMP_BINDIR)/test_pike.pike testsuite --verbose

gdb_verify: testsuite $(PIKE_EXTERNAL_MODULE)
	@echo >.gdbinit handle SIGUSR1 nostop noprint pass
	@echo >>.gdbinit run -DNOT_INSTALLED -m $(TMP_BUILDDIR)/master.pike $(PIKEOPTS) -Mplib/modules $(TMP_BINDIR)/test_pike.pike testsuite -v -v -f
	gdb $(TMP_BUILDDIR)/pike
	@rm .gdbinit

extract_autodoc: $(PIKE_EXTERNAL_MODULE) plib/refdoc plib/doc_build/images
	$(RUNPIKE) -x extract_autodoc --builddir=plib/refdoc --srcdir=plib/modules
	if test "X$(AUTODOC_SRC_IN)" != "X"; then \
	$(RUNPIKE) -x extract_autodoc --builddir=plib/refdoc $(AUTODOC_SRC_IN); \
	fi

join_autodoc: extract_autodoc
	$(RUNPIKE) -x join_autodoc --quiet --post-process  "plib/autodoc.xml" "$(CORE_AUTODOC_PATH)" "plib/refdoc"

modref:	join_autodoc modref.xml
	cd $(SYSTEM_DOC_PATH)/src && $(MAKE) $(MAKE_FLAGS) BUILDDIR="$(FULL_SRCDIR)/plib" DESTDIR="$(SYSTEM_DOC_PATH)" modref

module_join_autodoc: extract_autodoc refdoc/modref
	$(RUNPIKE) -x join_autodoc --quiet --post-process  "plib/autodoc.xml" "plib/refdoc"

module_modref: module_join_autodoc module_modref.xml
	cd $(SYSTEM_DOC_PATH)/src && $(MAKE) $(MAKE_FLAGS) BUILDDIR="$(FULL_SRCDIR)/plib" DESTDIR="$(FULL_SRCDIR)/refdoc/" module_modref

modref.xml: plib/autodoc.xml $(SYSTEM_DOC_PATH)/src/structure/modref.xml
	  $(RUNPIKE) -x assemble_autodoc $(SYSTEM_DOC_PATH)/src/structure/modref.xml \
	  plib/autodoc.xml >plib/modref.xml

module_modref.xml: plib/autodoc.xml $(SYSTEM_DOC_PATH)/src/structure/module_modref.xml
	  $(RUNPIKE) -x assemble_autodoc $(SYSTEM_DOC_PATH)/src/structure/module_modref.xml \
	  plib/autodoc.xml >plib/module_modref.xml

examine_module: $(MODULE_TARGET)
	-nm $(MODULE_TARGET)

build_type:
	@echo dynamic > build_type

static: Makefile $(DUMMY) module-preamble
	@:

# Depend on $(DUMMY) here too for the sake of post modules, where the
# static target never gets called.
dynamic: $(DUMMY) module-main
	@:

linker_options: Makefile
	@if test "x$(LINKER_OPTIONS)" != x ; then \
	  echo "echo $(LINKER_OPTIONS) > linker_options" ; \
	else : ; fi ; \
	echo "$(LINKER_OPTIONS)" >linker_options

modlist_segment: Makefile
	@echo "" >modlist_segment

# Can't depend on $(SRCDIR)/$(CONFIG_HEADERS).in since
# $(CONFIG_HEADERS) isn't always used.
Makefile: $(MODULE_BASE)/dynamic_module_makefile $(SRCDIR)/Makefile.in $(SRCDIR)/dependencies make_variables config.status
	CONFIG_FILES=Makefile CONFIG_HEADERS="$(CONFIG_HEADERS)" ./config.status
	touch remake
	@echo "Run make again" >&2
	@exit 1

$(MODULE_TARGET): module.so
	@if test "x$(OBJS)" = "x" ; then \
	  exit 0; \
	fi; \
	if test "x$(PIKE_EXTERNAL_MODULE)" = "x" ; then \
	  $(TMP_BINDIR)/install_module module.so $(MODULE_TARGET) && \
	  if [ -f $(MODNAME).pdb ]; then \
	    cp $(MODNAME).pdb `echo "$(MODULE_TARGET)" | sed -e 's,[^/]*$$,,'`; \
	  else :; fi; \
	fi

module.so: $(MODULE_ARCHIVES) $(OBJS) $(LDSHARED_MODULE_REQS)
	@if test "x$(OBJS)" = "x" ; then \
	  exit 0; \
	fi; \
	echo "Linking $(MODNAME)" ;\
	modname="$(MODNAME)"; \
	if $(TMP_BINDIR)/smartlink $(MOD_LDSHARED) $(LDFLAGS) -o module.so \
	  $(OBJS) $(MODULE_ARCHIVES) $(MODULE_LDFLAGS) \
	  $(LIBGCC) $(LC_REQ) $(LIBGCC) ; then \
	  if test so != so ; then mv module.so module.so ; else :; fi ;\
	else \
	  echo "Linking failed:" >&2; \
	  echo $(TMP_BINDIR)/smartlink $(MOD_LDSHARED) $(LDFLAGS) -o module.so $(OBJS) $(MODULE_ARCHIVES) $(MODULE_LDFLAGS) $(LIBGCC) $(LC_REQ) $(LIBGCC) >&2 ;\
	  exit 1; \
	fi
	$(MT_FIX_MODULE_SO)

$(OBJS): propagated_variables

#
# install a standard module with optional c component in the system module path
#
install: $(MODULE_INSTALL)
	@if test "x$(OBJS)" != "x" ; then \
	  $(TMP_BINDIR)/install_module module.so $(SYSTEM_MODULE_PATH)/$(MODDIR)$(MODULE_WRAPPER_PREFIX)$(MODNAME).so && \
	  if [ -f $(MODNAME).pdb ]; then \
	    cp $(MODNAME).pdb $(SYSTEM_MODULE_PATH)/$(MODDIR)$(MODULE_WRAPPER_PREFIX); \
	  else :; fi; \
	fi; \
	if test "x$(MODULE_PMOD_IN)" != "x"; then \
	  $(TMP_BINDIR)/install_module module.pmod $(SYSTEM_MODULE_PATH)/$(MODDIR)$(MODNAME).pmod ;\
	fi;

#
# install the module in LOCAL_MODULE_PATH, creating it if it doesn't already exist.
#
local_install: $(MODULE_INSTALL)
	if test ! -d "$(LOCAL_MODULE_PATH)" ; then \
	  mkdir -p $(LOCAL_MODULE_PATH) ; \
	fi; if test "x$(OBJS)" != "x" ; then \
	  $(TMP_BINDIR)/install_module module.so $(LOCAL_MODULE_PATH)/$(MODDIR)$(MODULE_WRAPPER_PREFIX)$(MODNAME).so && \
	  if [ -f $(MODNAME).pdb ]; then \
	    cp $(MODNAME).pdb $(SYSTEM_MODULE_PATH)/$(MODDIR)$(MODULE_WRAPPER_PREFIX); \
	  else :; fi; \
	fi; \
	if test "x$(MODULE_PMOD_IN)" != "x"; then \
	  $(TMP_BINDIR)/install_module module.pmod $(LOCAL_MODULE_PATH)/$(MODDIR)$(MODNAME).pmod ;\
	fi

dump_module: install
	-rm -f dumpmodule.log
	args=$${args:-"--log-file --update-only=dumpversion --report-failed"}; \
	$(FINAL_PIKE) -x dump $$args \
	--recursive "$(SYSTEM_MODULE_PATH)/$(MODDIR)$(MODNAME).pmod"

dump_local_module: install
	-rm -f dumpmodule.log
	args=$${args:-"--log-file --update-only=dumpversion --report-failed"}; \
	$(FINAL_PIKE) -x dump $$args \
	--recursive "$(LOCAL_MODULE_PATH)/$(MODDIR)$(MODNAME).pmod"

pikealsa.o: pikealsa.c $(PIKE_SRC_DIR)/global.h \
 $(PIKE_SRC_DIR)/machine.h \
 $(PIKE_SRC_DIR)/pike_int_types.h \
 $(PIKE_SRC_DIR)/port.h \
 $(PIKE_SRC_DIR)/global.h \
 $(PIKE_SRC_DIR)/dmalloc.h \
 $(PIKE_SRC_DIR)/module.h

