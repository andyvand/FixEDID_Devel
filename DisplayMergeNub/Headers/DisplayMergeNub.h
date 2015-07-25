#ifndef _IOKIT_DisplayMergeNub_H
#define _IOKIT_DisplayMergeNub_H

#include <IOKit/IOService.h>

#ifndef APPLE_KEXT_OVERRIDE
#define APPLE_KEXT_OVERRIDE
#endif /* APPLE_KEXT_OVERRIDE */

class DisplayMergeNub : public IOService
{
    OSDeclareDefaultStructors(DisplayMergeNub);

public:
    IOService *			probe(IOService *provider, SInt32 *score) APPLE_KEXT_OVERRIDE;
    bool                start(IOService *provider) APPLE_KEXT_OVERRIDE;
    virtual bool 		MergeDictionaryIntoProvider(IOService *  provider, OSDictionary *  mergeDict);
    virtual bool		MergeDictionaryIntoDictionary(OSDictionary *  sourceDictionary,  OSDictionary *  targetDictionary);
};

#endif
