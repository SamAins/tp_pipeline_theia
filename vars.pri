TARGET = tp_pipeline_theia
TEMPLATE = lib

DEFINES += TP_PIPELINE_THEIA_LIBRARY

SOURCES += src/Globals.cpp
HEADERS += inc/tp_pipeline_theia/Globals.h


#-- Delegates --------------------------------------------------------------------------------------
SOURCES += src/step_delegates/StubStepDelegate.cpp
HEADERS += inc/tp_pipeline_theia/step_delegates/StubStepDelegate.h


#-- Members ----------------------------------------------------------------------------------------
SOURCES += src/members/StubMember.cpp
HEADERS += inc/tp_pipeline_theia/members/StubMember.h
