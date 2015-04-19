//
//  EDIDEditor.h
//  FixEDID
//
//  Created by Andy Vandijck on 18/04/14.
//  Copyright (c) 2014 Andy Vandijck. All rights reserved.
//

#ifndef EDIDEDITOR_H
#define EDIDEDITOR_H 1

#import <Foundation/Foundation.h>
#import <QuartzCore/CoreImage.h>

#import "AppDelegate.h"

@interface EDIDEditor : NSObject
{
    IBOutlet NSArrayController *dataArray;
    IBOutlet NSTableView *dataTable;
    IBOutlet NSWindow *window;

    IBOutlet NSScrollView *editView;
    IBOutlet NSScrollView *displayTypeView;
    IBOutlet NSScrollView *colorFormatView;
    IBOutlet NSScrollView *colorGram;
    IBOutlet NSScrollView *detailedEntryView;

    IBOutlet NSView *detailedView;
    IBOutlet NSView *dummySubView;
    IBOutlet NSPopUpButton *detailedType;

    IBOutlet NSView *CVT3BView;
    IBOutlet NSTextField *CVTH_1;
    IBOutlet NSTextField *CVTW_1;
    IBOutlet NSPopUpButton *CVTPrefHz_1;
    IBOutlet NSPopUpButton *CVTAR_1;
    IBOutlet NSButton *CVT50Hz_1;
    IBOutlet NSButton *CVT60Hz_1;
    IBOutlet NSButton *CVT75Hz_1;
    IBOutlet NSButton *CVT85Hz_1;
    IBOutlet NSButton *CVT60HzRB_1;
    IBOutlet NSTextField *CVTH_2;
    IBOutlet NSTextField *CVTW_2;
    IBOutlet NSPopUpButton *CVTPrefHz_2;
    IBOutlet NSPopUpButton *CVTAR_2;
    IBOutlet NSButton *CVT50Hz_2;
    IBOutlet NSButton *CVT60Hz_2;
    IBOutlet NSButton *CVT75Hz_2;
    IBOutlet NSButton *CVT85Hz_2;
    IBOutlet NSButton *CVT60HzRB_2;
    IBOutlet NSTextField *CVTH_3;
    IBOutlet NSTextField *CVTW_3;
    IBOutlet NSPopUpButton *CVTPrefHz_3;
    IBOutlet NSPopUpButton *CVTAR_3;
    IBOutlet NSButton *CVT50Hz_3;
    IBOutlet NSButton *CVT60Hz_3;
    IBOutlet NSButton *CVT75Hz_3;
    IBOutlet NSButton *CVT85Hz_3;
    IBOutlet NSButton *CVT60HzRB_3;
    IBOutlet NSTextField *CVTH_4;
    IBOutlet NSTextField *CVTW_4;
    IBOutlet NSPopUpButton *CVTPrefHz_4;
    IBOutlet NSPopUpButton *CVTAR_4;
    IBOutlet NSButton *CVT50Hz_4;
    IBOutlet NSButton *CVT60Hz_4;
    IBOutlet NSButton *CVT75Hz_4;
    IBOutlet NSButton *CVT85Hz_4;
    IBOutlet NSButton *CVT60HzRB_4;

    IBOutlet NSView *established3View;
    IBOutlet NSButton *established3_Chk1;
    IBOutlet NSButton *established3_Chk2;
    IBOutlet NSButton *established3_Chk3;
    IBOutlet NSButton *established3_Chk4;
    IBOutlet NSButton *established3_Chk5;
    IBOutlet NSButton *established3_Chk6;
    IBOutlet NSButton *established3_Chk7;
    IBOutlet NSButton *established3_Chk8;
    IBOutlet NSButton *established3_Chk9;
    IBOutlet NSButton *established3_Chk10;
    IBOutlet NSButton *established3_Chk11;
    IBOutlet NSButton *established3_Chk12;
    IBOutlet NSButton *established3_Chk13;
    IBOutlet NSButton *established3_Chk14;
    IBOutlet NSButton *established3_Chk15;
    IBOutlet NSButton *established3_Chk16;
    IBOutlet NSButton *established3_Chk17;
    IBOutlet NSButton *established3_Chk18;
    IBOutlet NSButton *established3_Chk19;
    IBOutlet NSButton *established3_Chk20;
    IBOutlet NSButton *established3_Chk21;
    IBOutlet NSButton *established3_Chk22;
    IBOutlet NSButton *established3_Chk23;
    IBOutlet NSButton *established3_Chk24;
    IBOutlet NSButton *established3_Chk25;
    IBOutlet NSButton *established3_Chk26;
    IBOutlet NSButton *established3_Chk27;
    IBOutlet NSButton *established3_Chk28;
    IBOutlet NSButton *established3_Chk29;
    IBOutlet NSButton *established3_Chk30;
    IBOutlet NSButton *established3_Chk31;
    IBOutlet NSButton *established3_Chk32;
    IBOutlet NSButton *established3_Chk33;
    IBOutlet NSButton *established3_Chk34;
    IBOutlet NSButton *established3_Chk35;
    IBOutlet NSButton *established3_Chk36;
    IBOutlet NSButton *established3_Chk37;
    IBOutlet NSButton *established3_Chk38;
    IBOutlet NSButton *established3_Chk39;
    IBOutlet NSButton *established3_Chk40;
    IBOutlet NSButton *established3_Chk41;
    IBOutlet NSButton *established3_Chk42;
    IBOutlet NSButton *established3_Chk43;
    IBOutlet NSButton *established3_Chk44;

    IBOutlet NSView *standardResView;
    IBOutlet NSTextField *stdX1;
    IBOutlet NSTextField *stdY1;
    IBOutlet NSTextField *stdHz1;
    IBOutlet NSButton *stdSet1;
    IBOutlet NSButton *stdEnabled1;
    IBOutlet NSPopUpButton *stdList1;
    IBOutlet NSTextField *stdX2;
    IBOutlet NSTextField *stdY2;
    IBOutlet NSTextField *stdHz2;
    IBOutlet NSButton *stdSet2;
    IBOutlet NSButton *stdEnabled2;
    IBOutlet NSPopUpButton *stdList2;
    IBOutlet NSTextField *stdX3;
    IBOutlet NSTextField *stdY3;
    IBOutlet NSTextField *stdHz3;
    IBOutlet NSButton *stdSet3;
    IBOutlet NSButton *stdEnabled3;
    IBOutlet NSPopUpButton *stdList3;
    IBOutlet NSTextField *stdX4;
    IBOutlet NSTextField *stdY4;
    IBOutlet NSTextField *stdHz4;
    IBOutlet NSButton *stdSet4;
    IBOutlet NSButton *stdEnabled4;
    IBOutlet NSPopUpButton *stdList4;
    IBOutlet NSTextField *stdX5;
    IBOutlet NSTextField *stdY5;
    IBOutlet NSTextField *stdHz5;
    IBOutlet NSButton *stdSet5;
    IBOutlet NSButton *stdEnabled5;
    IBOutlet NSPopUpButton *stdList5;
    IBOutlet NSTextField *stdX6;
    IBOutlet NSTextField *stdY6;
    IBOutlet NSTextField *stdHz6;
    IBOutlet NSButton *stdSet6;
    IBOutlet NSButton *stdEnabled6;
    IBOutlet NSPopUpButton *stdList6;
    IBOutlet NSTextField *stdX7;
    IBOutlet NSTextField *stdY7;
    IBOutlet NSTextField *stdHz7;
    IBOutlet NSButton *stdSet7;
    IBOutlet NSButton *stdEnabled7;
    IBOutlet NSPopUpButton *stdList7;
    IBOutlet NSTextField *stdX8;
    IBOutlet NSTextField *stdY8;
    IBOutlet NSTextField *stdHz8;
    IBOutlet NSButton *stdSet8;
    IBOutlet NSButton *stdEnabled8;
    IBOutlet NSPopUpButton *stdList8;

    IBOutlet NSView *estaResView;
    IBOutlet NSButton *estaRes1;
    IBOutlet NSButton *estaRes2;
    IBOutlet NSButton *estaRes3;
    IBOutlet NSButton *estaRes4;
    IBOutlet NSButton *estaRes5;
    IBOutlet NSButton *estaRes6;
    IBOutlet NSButton *estaRes7;
    IBOutlet NSButton *estaRes8;
    IBOutlet NSButton *estaRes9;
    IBOutlet NSButton *estaRes10;
    IBOutlet NSButton *estaRes11;
    IBOutlet NSButton *estaRes12;
    IBOutlet NSButton *estaRes13;
    IBOutlet NSButton *estaRes14;
    IBOutlet NSButton *estaRes15;
    IBOutlet NSButton *estaRes16;
    IBOutlet NSButton *estaRes17;

    IBOutlet NSView *editVersionView;
    IBOutlet NSView *headerView;
    IBOutlet NSView *serialView;
    IBOutlet NSView *emptyView;
    IBOutlet NSView *basicParamsView;
    IBOutlet NSView *chromaView;

    IBOutlet NSTextField *redX;
    IBOutlet NSTextField *redY;
    IBOutlet NSTextField *greenX;
    IBOutlet NSTextField *greenY;
    IBOutlet NSTextField *blueX;
    IBOutlet NSTextField *blueY;
    IBOutlet NSTextField *whiteX;
    IBOutlet NSTextField *whiteY;

    IBOutlet NSPopUpButton *displayType;
    IBOutlet NSPopUpButton *connectorType;
    IBOutlet NSPopUpButton *voltageType;
    IBOutlet NSPopUpButton *colorType;
    IBOutlet NSButton *DFPCompatible;
    IBOutlet NSButton *B2BSet;
    IBOutlet NSButton *SyncSep;
    IBOutlet NSButton *SyncComp;
    IBOutlet NSButton *SyncGreen;
    IBOutlet NSButton *SyncSerr;
    IBOutlet NSButton *DPMSStandby;
    IBOutlet NSButton *DPMSSuspend;
    IBOutlet NSButton *DPMSOff;
    IBOutlet NSButton *YCrCb444;
    IBOutlet NSButton *YCrCb422;
    IBOutlet NSButton *sRGBPC;
    IBOutlet NSButton *DetPT;
    IBOutlet NSButton *SuppGTF;
    IBOutlet NSTextField *BitsPerColorChannel;
    IBOutlet NSTextField *MaximumHorizSize;
    IBOutlet NSTextField *MaximumVertSize;
    IBOutlet NSTextField *GammaValue;
    IBOutlet NSView *display14Type;
    IBOutlet NSView *display12Type;
    IBOutlet NSView *displayOtherType;
    IBOutlet NSView *displayAnalogType;
    IBOutlet NSView *colorDigitaView;
    IBOutlet NSView *colorAnalogView;

    IBOutlet NSTextField *VersionMajor;
    IBOutlet NSTextField *VersionMinor;

    IBOutlet NSTextField *manufName;
    IBOutlet NSTextField *model;
    IBOutlet NSTextField *serial;
    IBOutlet NSTextField *buildWeek;
    IBOutlet NSTextField *buildYear;

    IBOutlet NSTextField *HeaderA;
    IBOutlet NSTextField *HeaderB;
    IBOutlet NSTextField *HeaderC;
    IBOutlet NSTextField *HeaderD;
    IBOutlet NSTextField *HeaderE;
    IBOutlet NSTextField *HeaderF;
    IBOutlet NSTextField *HeaderG;
    IBOutlet NSTextField *HeaderH;

    NSMutableDictionary *dataEntry;

    NSMutableArray *dataValueList;
    NSMutableDictionary *dataValueEntry;

    unsigned char minorVersionNumber;
    unsigned char connectorInterface;
    unsigned char colorTypeVal;
    unsigned int StartOffset;
    int CurrentDetailed;
}
-(NSString *)determineColumnName:(int)column;
-(unsigned char)hex2uchar:(const char *)s;
-(int)hex2int:(const char *)s;
-(void)setEDIDRow:(unsigned char *)data start:(int)strt count:(int)cnt;
-(void)loadEDIDData;
-(void)getHeader;
-(void)getBasicParams;
-(void)getChroma;
-(void)getEstaRes;
-(void)getStandardRes;
-(void)getDetailedType;
-(void)getEsta3Res;
-(void)getCVT3B;
-(unsigned char)make_checksum:(unsigned char *)x;
-(unsigned char *)set_manufacturer_name:(char *)x;
-(char *)get_manufacturer_name:(unsigned char *)x;
-(IBAction)saveChanges:(id)sender;
-(IBAction)setVersion:(id)sender;
-(IBAction)setSerialData:(id)sender;
-(IBAction)setEDIDDetailView:(id)sender;
-(IBAction)correctHeader:(id)sender;
-(IBAction)selectDisplayType:(id)sender;
-(IBAction)sBPCC:(id)sender;
-(IBAction)sCT:(id)sender;
-(IBAction)sDFP:(id)sender;
-(IBAction)sB2B:(id)sender;
-(IBAction)sSerr:(id)sender;
-(IBAction)sGreen:(id)sender;
-(IBAction)sComp:(id)sender;
-(IBAction)sSep:(id)sender;
-(IBAction)setVolt:(id)sender;
-(IBAction)setMaxImg:(id)sender;
-(IBAction)setGamma:(id)sender;
-(IBAction)sDPMSOff:(id)sender;
-(IBAction)sDPMSSuspend:(id)sender;
-(IBAction)sDPMSStandby:(id)sender;
-(IBAction)sYCrCb444:(id)sender;
-(IBAction)sYCrCb422:(id)sender;
-(IBAction)sColorType:(id)sender;
-(IBAction)ssRGBPC:(id)sender;
-(IBAction)sDetPT:(id)sender;
-(IBAction)sSuppGTF:(id)sender;
-(IBAction)sChroma:(id)sender;
-(IBAction)setEstaBit:(id)sender;
-(IBAction)sStandardRes:(id)sender;
-(IBAction)sStandardEnab:(id)sender;
-(IBAction)sDetailed:(id)sender;
-(IBAction)setEsta3Bit:(id)sender;
-(IBAction)sCVT3B:(id)sender;
-(void)readDataTable:(NSString **)data offset:(int)startpos length:(int)totallength;
-(void)writeDataTable:(NSString **)data offset:(int)startpos length:(int)totallength;
@end

#endif