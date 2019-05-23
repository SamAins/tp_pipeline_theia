DEPENDENCIES += tp_pipeline_image_utils
DEPENDENCIES += tp_pipeline_math_utils
INCLUDEPATHS += tp_pipeline_theia/inc/
LIBRARIES    += tp_pipeline_theia

TP_STATIC_INIT += tp_pipeline_theia

LIBS += -ltheia_sfm
LIBS += -ltheia_math
LIBS += -ltheia_solvers
LIBS += -ltheia_util
LIBS += -lglog
LIBS += -lgflags
LIBS += -lceres

#SuiteSparse
LIBS += -lamd
LIBS += -lbtf
LIBS += -lcamd
LIBS += -lccolamd
LIBS += -lcholmod
LIBS += -lcolamd
#LIBS += -lcsparse
#LIBS += /Users/tom/theia/usr/suitesparse/lib/libcxsparse.3.1.4_arm64.a
LIBS += -lcxsparse
LIBS += -lklu
LIBS += -lldl
#LIBS += -lspqr
LIBS += -lsuitesparseconfig
