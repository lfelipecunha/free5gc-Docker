## Process this file with automake to produce Makefile.in

extlib_LTLIBRARIES = acl_wl.la

acl_wl_la_SOURCES = \
	acl_wl.c aw_tree.c

acl_wl_la_DEPENDENCIES = \
	$(top_srcdir)/libfdcore/libfdcore.la \
	$(top_srcdir)/libfdproto/libfdproto.la

acl_wl_la_LIBADD = \
	$(top_srcdir)/libfdcore/libfdcore.la \
	$(top_srcdir)/libfdproto/libfdproto.la

AM_LDFLAGS = \
	-module -avoid-version -shared

AM_CPPFLAGS = \
	-I$(top_srcdir)/include

AM_CFLAGS = \
	-Wall -Werror

MAINTAINERCLEANFILES = Makefile.in
MOSTLYCLEANFILES = *.stackdump
