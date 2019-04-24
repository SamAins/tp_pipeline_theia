#include "tp_pipeline_theia/Globals.h"
//#include "tp_pipeline_theia/step_delegates/StubStepDelegate.h"

#include "tp_pipeline/StepDelegateMap.h"

//##################################################################################################
namespace tp_pipeline_theia
{
TDP_DEFINE_ID(                        theiaSID,                            "Theia")

//##################################################################################################
void createStepDelegates(tp_pipeline::StepDelegateMap& stepDelegates, const tp_data::CollectionFactory* collectionFactory)
{
  TP_UNUSED(stepDelegates);
  TP_UNUSED(collectionFactory);
  //stepDelegates.addStepDelegate(new StubStepDelegate);
}

REGISTER_CREATE_STEP_DELEGATES;

//##################################################################################################
int staticInit()
{
  return 0;
}

}
