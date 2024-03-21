//
//  EDIDEditor.m
//  FixEDID
//
//  Created by Andy Vandijck on 18/04/14.
//  Copyright (c) 2014 Andy Vandijck. All rights reserved.
//

#import "EDIDEditor.h"
#import "ColorRender.h"

extern int ESize;
extern unsigned char *EData;
EDIDStruct_t *EDataStruct;

@implementation EDIDEditor

-(int)hex2int:(const char *)s
{
    char *charset = "0123456789abcdef";
    char *charsetB = "0123456789ABCDEF";
    int i = (int)strlen(s), len = i, num = 0, j = 0;
    while (i >= 0) {
        for (j = 0; j < 16; j++) {
            if ((charset[j] == s[i]) || (charsetB[j] == s[i])) {
                num += j * (int)pow(16, len-i-1);
                break;
            }
        }
        i--;
    }
    return (num);
}

-(unsigned char)hex2uchar:(const char *)s
{
    unsigned char ret = 0;
    int stringlength = (int)strlen(s);

    switch (s[0])
    {
        case '0':
            ret = 0;
            break;

        case '1':
            if (stringlength == 1)
            {
                return (1);
            } else {
                ret += 1 << 4;
            }
            break;

        case '2':
            if (stringlength == 1)
            {
                return  (2);
            } else {
                ret += 2 << 4;
            }
            break;

        case '3':
            if (stringlength == 1)
            {
                return (3);
            } else {
                ret += 3 << 4;
            }
            break;

        case '4':
            if (stringlength == 1)
            {
                return (4);
            } else {
                ret += 4 << 4;
            }
            break;

        case '5':
            if (stringlength == 1)
            {
                return (5);
            } else {
                ret += 5 << 4;
            }
            break;

        case '6':
            if (stringlength == 1)
            {
                return (6);
            } else {
                ret += 6 << 4;
            }
            break;

        case '7':
            if (stringlength == 1)
            {
                return (7);
            } else {
                ret += 7 << 4;
            }
            break;

        case '8':
            if (stringlength == 1)
            {
                return (8);
            } else {
                ret += 8 << 4;
            }
            break;

        case '9':
            if (stringlength == 1)
            {
                return (9);
            } else {
                ret += 9 << 4;
            }
            break;

        case 'a':
        case 'A':
            if (stringlength == 1)
            {
                return (10);
            } else {
                ret += 10 << 4;
            }
            break;

        case 'b':
        case 'B':
            if (stringlength == 1)
            {
                return (11);
            } else {
                ret += 11 << 4;
            }
            break;
            
        case 'c':
        case 'C':
            if (stringlength == 1)
            {
                return (12);
            } else {
                ret += 12 << 4;
            }
            break;
            
        case 'd':
        case 'D':
            if (stringlength == 1)
            {
                return (13);
            } else {
                ret += 13 << 4;
            }
            break;
            
        case 'e':
        case 'E':
            if (stringlength == 1)
            {
                return (14);
            } else {
                ret += 14 << 4;
            }
            break;
            
        case 'f':
        case 'F':
            if (stringlength == 1)
            {
                return (15);
            } else {
                ret += 15 << 4;
            }
            break;
    }

    switch (s[1])
    {
        case '0':
            break;
            
        case '1':
            ret += 1;
            break;
            
        case '2':
            ret += 2;
            break;
            
        case '3':
            ret += 3;
            break;
            
        case '4':
            ret += 4;
            break;
            
        case '5':
            ret += 5;
            break;
            
        case '6':
            ret += 6;
            break;
            
        case '7':
            ret += 7;
            break;
            
        case '8':
            ret += 8;
            break;
            
        case '9':
            ret += 9;
            break;
            
        case 'a':
        case 'A':
            ret += 10;
            break;
            
        case 'b':
        case 'B':
            ret += 11;
            break;
            
        case 'c':
        case 'C':
            ret += 12;
            break;
            
        case 'd':
        case 'D':
            ret += 13;
            break;
            
        case 'e':
        case 'E':
            ret += 14;
            break;
            
        case 'f':
        case 'F':
            ret += 15;
            break;
    }

    return (ret);
}

-(unsigned char)make_checksum:(unsigned char *)x
{
    unsigned char sum = 0;
    int i = 0;
    
    for (i = 0; i < 127; i++)
        sum += x[i];
    
    return((unsigned char)((((unsigned short)0x100) - sum) & 0xFF));
}

-(char *)get_manufacturer_name:(unsigned char *)x
{
    static char name[4];
    
    name[0] = ((x[0] & 0x7C) >> 2) + '@';
    name[1] = ((x[0] & 0x03) << 3) + ((x[1] & 0xE0) >> 5) + '@';
    name[2] = (x[1] & 0x1F) + '@';
    name[3] = 0;
    
    return name;
}

-(unsigned char *)set_manufacturer_name:(char *)x
{
    static unsigned char name[2];

    name[0] = (((x[0] - '@') << 2) & 0x7C);
    name[0] += (((x[1] - '@') >> 3) & 0x03);
    name[1] = (((x[1] - '@') << 5) & 0xE0);
    name[1] += ((x[2] - '@') & 0x1F);

    return name;
}

-(void)saveChanges:(id)sender
{
    int datasavecurrent = 0;
    int tenparts = 0;
    NSString *dataval = nil;
    unsigned char curdataval = 0;
    int checksumblock = 0;
    int checkskip = 0;
    unsigned char *checksumptr = NULL;

    dataValueList = [dataArray arrangedObjects];
  
    while (ESize > datasavecurrent)
    {
        if (((datasavecurrent % 10) == 0) && (datasavecurrent != 0))
        {
            ++tenparts;
        }

        dataValueEntry = [dataValueList objectAtIndex:tenparts];

        switch (datasavecurrent % 10)
        {
            case 0:
                dataval = [dataValueEntry objectForKey:@"HexA"];
                break;

            case 1:
                dataval = [dataValueEntry objectForKey:@"HexB"];
                break;

            case 2:
                dataval = [dataValueEntry objectForKey:@"HexC"];
                break;

            case 3:
                dataval = [dataValueEntry objectForKey:@"HexD"];
                break;

            case 4:
                dataval = [dataValueEntry objectForKey:@"HexE"];
                break;

            case 5:
                dataval = [dataValueEntry objectForKey:@"HexF"];
                break;

            case 6:
                dataval = [dataValueEntry objectForKey:@"HexG"];
                break;

            case 7:
                dataval = [dataValueEntry objectForKey:@"HexH"];
                break;

            case 8:
                dataval = [dataValueEntry objectForKey:@"HexI"];
                break;

            case 9:
                dataval = [dataValueEntry objectForKey:@"HexJ"];
                break;
        }

        /* Auto correct checksum blocks */
        if ((datasavecurrent % (127 + checkskip)) == 0)
        {
            checkskip = 128*(checksumblock);
            checksumptr = &EData[checkskip];
            curdataval = [self make_checksum:checksumptr];

            printf("Checksum: %u\n", curdataval);

            checksumblock += 1;
        } else {
            curdataval = [self hex2uchar:[dataval cStringUsingEncoding:NSUTF8StringEncoding]];
            EData[datasavecurrent] = curdataval;
        }

        ++datasavecurrent;
    }

    [window close];
}

-(void)awakeFromNib
{
    EDataStruct = (EDIDStruct_t *)EData;

    [self loadEDIDData];

    if (EData == NULL)
    {
        return;
    }

    [dataTable reloadData];

    [[displayType itemAtIndex:0] setTag:0];
    [[displayType itemAtIndex:1] setTag:1];
    [[connectorType itemAtIndex:0] setTag:0];
    [[connectorType itemAtIndex:1] setTag:1];
    [[connectorType itemAtIndex:2] setTag:2];
    [[connectorType itemAtIndex:3] setTag:3];
    [[connectorType itemAtIndex:4] setTag:4];
    [[connectorType itemAtIndex:5] setTag:5];
    [[voltageType itemAtIndex:0] setTag:0];
    [[voltageType itemAtIndex:1] setTag:1];
    [[voltageType itemAtIndex:2] setTag:2];
    [[voltageType itemAtIndex:3] setTag:3];
    [[colorType itemAtIndex:0] setTag:0];
    [[colorType itemAtIndex:1] setTag:1];
    [[colorType itemAtIndex:2] setTag:2];
    [[colorType itemAtIndex:3] setTag:3];
    [[stdList1 itemAtIndex:0] setTag:0];
    [[stdList1 itemAtIndex:1] setTag:1];
    [[stdList1 itemAtIndex:2] setTag:2];
    [[stdList1 itemAtIndex:3] setTag:3];
    [[stdList2 itemAtIndex:0] setTag:0];
    [[stdList2 itemAtIndex:1] setTag:1];
    [[stdList2 itemAtIndex:2] setTag:2];
    [[stdList2 itemAtIndex:3] setTag:3];
    [[stdList3 itemAtIndex:0] setTag:0];
    [[stdList3 itemAtIndex:1] setTag:1];
    [[stdList3 itemAtIndex:2] setTag:2];
    [[stdList3 itemAtIndex:3] setTag:3];
    [[stdList4 itemAtIndex:0] setTag:0];
    [[stdList4 itemAtIndex:1] setTag:1];
    [[stdList4 itemAtIndex:2] setTag:2];
    [[stdList4 itemAtIndex:3] setTag:3];
    [[stdList5 itemAtIndex:0] setTag:0];
    [[stdList5 itemAtIndex:1] setTag:1];
    [[stdList5 itemAtIndex:2] setTag:2];
    [[stdList5 itemAtIndex:3] setTag:3];
    [[stdList6 itemAtIndex:0] setTag:0];
    [[stdList6 itemAtIndex:1] setTag:1];
    [[stdList6 itemAtIndex:2] setTag:2];
    [[stdList6 itemAtIndex:3] setTag:3];
    [[stdList7 itemAtIndex:0] setTag:0];
    [[stdList7 itemAtIndex:1] setTag:1];
    [[stdList7 itemAtIndex:2] setTag:2];
    [[stdList7 itemAtIndex:3] setTag:3];
    [[stdList8 itemAtIndex:0] setTag:0];
    [[stdList8 itemAtIndex:1] setTag:1];
    [[stdList8 itemAtIndex:2] setTag:2];
    [[stdList8 itemAtIndex:3] setTag:3];
}

-(void)getHeader
{
    NSString *header[8];

    dataValueList = [dataArray arrangedObjects];
    dataValueEntry = [dataValueList objectAtIndex:0];

    header[0] = [dataValueEntry objectForKey:@"HexA"];
    header[1] = [dataValueEntry objectForKey:@"HexB"];
    header[2] = [dataValueEntry objectForKey:@"HexC"];
    header[3] = [dataValueEntry objectForKey:@"HexD"];
    header[4] = [dataValueEntry objectForKey:@"HexE"];
    header[5] = [dataValueEntry objectForKey:@"HexF"];
    header[6] = [dataValueEntry objectForKey:@"HexG"];
    header[7] = [dataValueEntry objectForKey:@"HexH"];

    [HeaderA setStringValue:header[0]];
    [HeaderB setStringValue:header[1]];
    [HeaderC setStringValue:header[2]];
    [HeaderD setStringValue:header[3]];
    [HeaderE setStringValue:header[4]];
    [HeaderF setStringValue:header[5]];
    [HeaderG setStringValue:header[6]];
    [HeaderH setStringValue:header[7]];
}

-(void)setVersion:(id)sender
{
    NSString *verMaj = [VersionMajor stringValue];
    NSString *verMin = [VersionMinor stringValue];
    unsigned char verMajD = 0;
    unsigned char verMinD = 0;
    NSString *dataSet[2];

    if ((verMaj == nil) || (verMin == nil))
    {
        return;
    }

    verMajD = atoi([verMaj cStringUsingEncoding:NSUTF8StringEncoding]);
    verMinD = atoi([verMin cStringUsingEncoding:NSUTF8StringEncoding]);

    dataSet[0] = [NSString stringWithFormat:@"%.2X", verMajD];
    dataSet[1] = [NSString stringWithFormat:@"%.2X", verMinD];

    [self writeDataTable:dataSet offset:18 length:2];
}

-(NSString *)determineColumnName:(int)column
{
    switch (column)
    {
        case 0:
            return(@"HexA");
            break;

        case 1:
            return(@"HexB");
            break;

        case 2:
            return(@"HexC");
            break;
            
        case 3:
            return(@"HexD");
            break;
            
        case 4:
            return(@"HexE");
            break;
            
        case 5:
            return(@"HexF");
            break;
            
        case 6:
            return(@"HexG");
            break;
            
        case 7:
            return(@"HexH");
            break;
            
        case 8:
            return(@"HexI");
            break;
            
        case 9:
            return(@"HexJ");
            break;
    }

    return nil;
}

-(void)correctHeader:(id)sender
{
    NSString *correctHeader[8];

    correctHeader[0] = @"00";
    correctHeader[1] = @"FF";
    correctHeader[2] = @"FF";
    correctHeader[3] = @"FF";
    correctHeader[4] = @"FF";
    correctHeader[5] = @"FF";
    correctHeader[6] = @"FF";
    correctHeader[7] = @"00";

    [self writeDataTable:correctHeader offset:0 length:8];
    [self getHeader];
}

NSInteger runAlertPanel(NSString *title, NSString *message, NSString *button1, NSString *button2, NSString *button3)
{
    NSAlert *alert = [[NSAlert alloc] init];
    NSInteger retval = 0;

    if (alert != nil)
    {
        if (title != nil)
        {
            [alert setMessageText:title];
        }

        if (message != nil)
        {
            [alert setInformativeText:message];
        }
        
        if (button1 != nil)
        {
            [alert addButtonWithTitle:button1];
        }

        if (button2 != nil)
        {
            [alert addButtonWithTitle:button2];
        }

        if (button3 != nil)
        {
            [alert addButtonWithTitle:button3];
        }

        retval = [alert runModal];

        [alert release];
    }

    return (NSInteger)retval;
}

-(void)getSerial
{
    char *Manufacturer = NULL;
    unsigned char ManufData[2];
    unsigned short Model = 0;
    unsigned long Serial = 0;
    unsigned char buildWY[2];
	
    dataValueList = [dataArray arrangedObjects];
    dataValueEntry = [dataValueList objectAtIndex:0];
	
    ManufData[0] = [self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:8]] cStringUsingEncoding:NSUTF8StringEncoding]];
    ManufData[1] = [self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:9]] cStringUsingEncoding:NSUTF8StringEncoding]];
	
    Manufacturer = [self get_manufacturer_name:ManufData];
	
    [manufName setStringValue:[NSString stringWithFormat:@"%s", Manufacturer]];
	
    dataValueList = [dataArray arrangedObjects];
    dataValueEntry = [dataValueList objectAtIndex:1];
	
    Model = ([self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:0]] cStringUsingEncoding:NSUTF8StringEncoding]] + ([self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:1]] cStringUsingEncoding:NSUTF8StringEncoding]] << 8));
	
    [model setStringValue:[NSString stringWithFormat:@"%X", Model]];
	
    Serial = ([self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:2]] cStringUsingEncoding:NSUTF8StringEncoding]] + ([self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:3]] cStringUsingEncoding:NSUTF8StringEncoding]] << 8)  + ([self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:4]] cStringUsingEncoding:NSUTF8StringEncoding]] << 16) + ([self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:5]] cStringUsingEncoding:NSUTF8StringEncoding]] << 24));
	
    [serial setStringValue:[NSString stringWithFormat:@"%lX", Serial]];
	
    buildWY[0] = [self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:6]] cStringUsingEncoding:NSUTF8StringEncoding]];
    buildWY[1] = [self hex2uchar:[[dataValueEntry objectForKey:[self determineColumnName:7]] cStringUsingEncoding:NSUTF8StringEncoding]];
	
    if ((buildWY[0] < 55) || (buildWY[1] == 0xff))
    {
        if (buildWY[1] > 0x0f)
        {
            if (buildWY[0] == 0xff)
            {
                [buildWeek setStringValue:[NSString stringWithFormat:@"%hhu", buildWY[0]]];
                [buildYear setStringValue:[NSString stringWithFormat:@"%hhu", buildWY[1]]];
            } else {
                [buildWeek setStringValue:[NSString stringWithFormat:@"%hhu", buildWY[0]]];
                [buildYear setStringValue:[NSString stringWithFormat:@"%u", (buildWY[1] + 1990)]];
            }
        }
    }
}

-(void)setSerialData:(id)sender
{
    unsigned char Manufacturer[2];
    unsigned short Model = 0;
    unsigned long Serial = 0;
    unsigned char Week = 0;
    unsigned short Year = 0;
    char checkedstring[4];
    NSString *manufstring = [manufName stringValue];
    NSString *modelstring = [model stringValue];
    NSString *serialstring = [serial stringValue];
    NSString *weekstring = [buildWeek stringValue];
    NSString *yearstring = [buildYear stringValue];
    const char *manufcstring = [manufstring cStringUsingEncoding:NSUTF8StringEncoding];
    const char *modelcstring = [modelstring cStringUsingEncoding:NSUTF8StringEncoding];
    const char *serialcstring = [serialstring cStringUsingEncoding:NSUTF8StringEncoding];
    const char *weekcstring = [weekstring cStringUsingEncoding:NSUTF8StringEncoding];
    const char *yearcstring = [yearstring cStringUsingEncoding:NSUTF8StringEncoding];
    int curchar = 0;
    unsigned int manufstrlen = (unsigned int)[manufstring length];
    NSString *manusetdata[2];
    NSString *modelsetdata[2];
    NSString *serialsetdata[4];
    NSString *weekyearsetdata[2];

    while (curchar < 3)
    {
        if (manufstrlen > curchar)
        {
            checkedstring[curchar] = toupper(manufcstring[curchar]);
        } else {
            checkedstring[curchar] = '@';
        }

        ++curchar;
    }

    checkedstring[curchar] = 0;
    memcpy(Manufacturer, [self set_manufacturer_name:checkedstring], 2);

    manusetdata[0] = [NSString stringWithFormat:@"%.2X", Manufacturer[0]];
    manusetdata[1] = [NSString stringWithFormat:@"%.2X", Manufacturer[1]];

    [self writeDataTable:manusetdata offset:8 length:2];

    Model = (unsigned short)[self hex2int:modelcstring];

    modelsetdata[0] = [NSString stringWithFormat:@"%.2X", (unsigned int)(Model & 0xFF)];
    modelsetdata[1] = [NSString stringWithFormat:@"%.2X", (unsigned int)((Model & 0xFF00) >> 8)];

    [self writeDataTable:modelsetdata offset:10 length:2];

    Serial = (unsigned long)[self hex2int:serialcstring];

    serialsetdata[0] = [NSString stringWithFormat:@"%.2X", (unsigned int)(Serial & 0xFF)];
    serialsetdata[1] = [NSString stringWithFormat:@"%.2X", (unsigned int)((Serial & 0xFF00) >> 8)];
    serialsetdata[2] = [NSString stringWithFormat:@"%.2X", (unsigned int)((Serial & 0xFF0000) >> 16)];
    serialsetdata[3] = [NSString stringWithFormat:@"%.2X", (unsigned int)((Serial & 0xFF000000) >> 24)];

    [self writeDataTable:serialsetdata offset:12 length:4];

    Week = (unsigned char)atoi(weekcstring);
    Year = (unsigned short)atoi(yearcstring);

    if ((Week > 54) && (Week != 255))
    {
        runAlertPanel(@"Week is invalid!", @"Setting week and year to 0xFF...", @"OK", nil, nil);

        Week = 255;
        Year = 255;
    }

    if (Year < 1990)
    {
        if (Week != 255)
        {
            runAlertPanel(@"Year is invalid!", @"Setting week and year to 0xFF...", @"OK", nil, nil);

            Week = 255;
            Year = 255;
        }
    } else {
        Year -= 1990;
    }

    weekyearsetdata[0] = [NSString stringWithFormat:@"%.2X", Week];
    weekyearsetdata[1] = [NSString stringWithFormat:@"%.2X", Year];

    [self writeDataTable:weekyearsetdata offset:16 length:2];

    [self getSerial];
}

-(void)readDataTable:(NSString **)data offset:(int)startpos length:(int)totallength
{
    int col = startpos % 10;
    int row = startpos / 10;
    int currow = row;
    int curcol = col;
    int curdone = 0;

    dataValueList = [dataArray arrangedObjects];
    dataValueEntry = [dataValueList objectAtIndex:row];

    while (curdone < totallength)
    {
        if (curcol == 10)
        {
            curcol = 0;

            ++currow;

            dataValueEntry = [dataValueList objectAtIndex:currow];
        }

        data[curdone] = [dataValueEntry objectForKey:[self determineColumnName:curcol]];

        ++curcol;
        ++curdone;
    }
}

-(void)writeDataTable:(NSString **)data offset:(int)startpos length:(int)totallength
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    int col = startpos % 10;
    int row = startpos / 10;
    int currow = row;
    int curcol = 0;
    int curdone = 0;

    dataValueList = [dataArray arrangedObjects];
    dataValueEntry = [dataValueList objectAtIndex:row];

    while (curcol < col)
    {
        [dataDict setObject:[dataValueEntry objectForKey:[self determineColumnName:curcol]] forKey:[self determineColumnName:curcol]];

        ++curcol;
    }

    while (curdone < totallength)
    {
        if (curcol == 10)
        {
            [dataArray insertObject:dataDict atArrangedObjectIndex:currow];
            [dataArray removeObjectAtArrangedObjectIndex:(currow+1)];

            [dataDict release];

            dataDict = [[NSMutableDictionary alloc] init];

            ++currow;
            curcol = 0;
        }

        if (data[curdone])
        {
            [dataDict setObject:data[curdone] forKey:[self determineColumnName:curcol]];

            ++curcol;
            ++curdone;
        }
    }

    dataValueList = [dataArray arrangedObjects];
    dataValueEntry = [dataValueList objectAtIndex:currow];

    while (curcol < 10)
    {
        [dataDict setObject:[dataValueEntry objectForKey:[self determineColumnName:curcol]] forKey:[self determineColumnName:curcol]];

        ++curcol;
    }

    [dataArray insertObject:dataDict atArrangedObjectIndex:currow];
    [dataArray removeObjectAtArrangedObjectIndex:(currow+1)];

    [dataDict release];

    [dataTable reloadData];
}

-(void)selectDisplayType:(id)sender
{
    int selection = (int)[sender selectedTag];
    NSString *FirstParam;
    unsigned char FP = 0;

    [self readDataTable:&FirstParam offset:20 length:1];

    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];

    if (selection)
    {
        FP |= 0x80;
    } else {
        FP &= 0x7F;
    }

    FirstParam = [NSString stringWithFormat:@"%.2X", FP];

    [self writeDataTable:&FirstParam offset:20 length:1];

    [self getBasicParams];
}

-(void)sBPCC:(id)sender
{
    NSString *bpcc = [BitsPerColorChannel stringValue];
    NSString *FirstParam;
    unsigned char FP = 0;
    unsigned char bitspercolor = (unsigned char)atoi([bpcc cStringUsingEncoding:NSUTF8StringEncoding]);

    [self readDataTable:&FirstParam offset:20 length:1];
    
    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];

    if (((bitspercolor < 6) && (bitspercolor != 0)) || (bitspercolor >= 11))
    {
        runAlertPanel(@"Bits per color bad!", [NSString stringWithFormat:@"%u is not acceptable, must be between 6 and 10 or 0", bitspercolor], @"OK", nil, nil);

        return;
    }

    if (bitspercolor > 0)
    {
        bitspercolor -= 4;
        bitspercolor <<= 3;
    }
    
    FP &= 0x8F;
    FP |= bitspercolor;

    FirstParam = [NSString stringWithFormat:@"%.2X", FP];

    [self writeDataTable:&FirstParam offset:20 length:1];
}

-(void)sCT:(id)sender
{
    int SelectedConnector = (int)[sender selectedTag];
    NSString *FirstParam;
    unsigned char FP = 0;

    [self readDataTable:&FirstParam offset:20 length:1];
    
    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];

    if (connectorInterface == SelectedConnector)
    {
        return;
    }

    FP &= 0xF0;
    FP |= (unsigned char)(SelectedConnector & 0xF);

    
    FirstParam = [NSString stringWithFormat:@"%.2X", FP];
    
    [self writeDataTable:&FirstParam offset:20 length:1];

    connectorInterface = SelectedConnector;
}

-(void)sDFP:(id)sender
{
    unsigned char DFPOn = (unsigned char)[(NSButton *)sender state];
    NSString *FirstParam;
    unsigned char FP = 0;
    
    [self readDataTable:&FirstParam offset:20 length:1];

    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];

    FP &= 0xFE;
    FP |= (DFPOn & 1);

    FirstParam = [NSString stringWithFormat:@"%.2X", FP];
    
    [self writeDataTable:&FirstParam offset:20 length:1];
}

-(void)sB2B:(id)sender
{
    unsigned char B2BOn = (unsigned char)[(NSButton *)sender state];
    NSString *FirstParam;
    unsigned char FP = 0;

    [self readDataTable:&FirstParam offset:20 length:1];
    
    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];

    B2BOn <<= 4;

    FP &= 0xEF;
    FP |= B2BOn;

    FirstParam = [NSString stringWithFormat:@"%.2X", FP];

    [self writeDataTable:&FirstParam offset:20 length:1];
}

-(void)sSerr:(id)sender
{
    unsigned char SerrOn = (unsigned char)[(NSButton *)sender state];
    NSString *FirstParam;
    unsigned char FP = 0;
    
    [self readDataTable:&FirstParam offset:20 length:1];
    
    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];

    FP &= 0xFE;
    FP |= (SerrOn & 1);
    
    FirstParam = [NSString stringWithFormat:@"%.2X", FP];
    
    [self writeDataTable:&FirstParam offset:20 length:1];
}

-(void)sGreen:(id)sender
{
    unsigned char GreenOn = (unsigned char)[(NSButton *)sender state];
    NSString *FirstParam;
    unsigned char FP = 0;
    
    [self readDataTable:&FirstParam offset:20 length:1];
    
    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];

    GreenOn <<= 1;

    FP &= 0xFD;
    FP |= (GreenOn & 2);
    
    FirstParam = [NSString stringWithFormat:@"%.2X", FP];
    
    [self writeDataTable:&FirstParam offset:20 length:1];
}

-(void)sComp:(id)sender
{
    unsigned char CompOn = (unsigned char)[(NSButton *)sender state];
    NSString *FirstParam;
    unsigned char FP = 0;
    
    [self readDataTable:&FirstParam offset:20 length:1];
    
    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];
    
    CompOn <<= 2;
    
    FP &= 0xFB;
    FP |= (CompOn & 4);
    
    FirstParam = [NSString stringWithFormat:@"%.2X", FP];
    
    [self writeDataTable:&FirstParam offset:20 length:1];
}

-(void)sSep:(id)sender
{
    unsigned char SepOn = (unsigned char)[(NSButton *)sender state];
    NSString *FirstParam;
    unsigned char FP = 0;
    
    [self readDataTable:&FirstParam offset:20 length:1];
    
    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];
    
    SepOn <<= 3;
    
    FP &= 0xF7;
    FP |= (SepOn & 8);
    
    FirstParam = [NSString stringWithFormat:@"%.2X", FP];
    
    [self writeDataTable:&FirstParam offset:20 length:1];
}

-(void)setVolt:(id)sender
{
    int selectedVolt = (int)[sender selectedTag];
    unsigned char newVolt = (unsigned char)((selectedVolt & 3) << 5);
    NSString *FirstParam;
    unsigned char FP = 0;

    [self readDataTable:&FirstParam offset:20 length:1];
    
    FP = [self hex2uchar:[FirstParam cStringUsingEncoding:NSUTF8StringEncoding]];
    
    FP &= 0x9F;
    FP |= newVolt;

    
    FirstParam = [NSString stringWithFormat:@"%.2X", FP];
    
    [self writeDataTable:&FirstParam offset:20 length:1];
}

-(void)setMaxImg:(id)sender
{
    NSString *MaxImgHoriz = [MaximumHorizSize stringValue];
    NSString *MaxImgVert = [MaximumVertSize stringValue];
    const char *cMaxImgHoriz = [MaxImgHoriz cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cMaxImgVert = [MaxImgVert cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char MaxSize[2];
    NSString *MaxSizeData[2];

    MaxSize[0] = (unsigned char)atoi(cMaxImgHoriz);
    MaxSize[1] = (unsigned char)atoi(cMaxImgVert);

    MaxSizeData[0] = [NSString stringWithFormat:@"%.2X", MaxSize[0]];
    MaxSizeData[1] = [NSString stringWithFormat:@"%.2X", MaxSize[1]];

    [self writeDataTable:MaxSizeData offset:21 length:2];

    [self getBasicParams];
}

-(void)setGamma:(id)sender
{
    float Gamma = [GammaValue floatValue];
    unsigned char EGamma = (unsigned char)lrintf((Gamma * 100.0) - 100.0);
    NSString *GammaVal = [NSString stringWithFormat:@"%.2X", EGamma];

    [self writeDataTable:&GammaVal offset:23 length:1];

    [self getBasicParams];
}

-(void)sDPMSOff:(id)sender
{
    unsigned char DPMSOffB = (unsigned char)[(NSButton *)sender state];
    NSString *FifthBP;
    DPMSOffB = ((DPMSOffB & 1) << 5);
    unsigned char FBP = 0;

    [self readDataTable:&FifthBP offset:24 length:1];

    FBP = [self hex2uchar:[FifthBP cStringUsingEncoding:NSUTF8StringEncoding]];
    FBP &= 0xDF;
    FBP |= DPMSOffB;

    FifthBP = [NSString stringWithFormat:@"%.2X", FBP];

    [self writeDataTable:&FifthBP offset:24 length:1];
}

-(void)sDPMSSuspend:(id)sender
{
    unsigned char DPMSSuspendB = (unsigned char)[(NSButton *)sender state];
    NSString *FifthBP;
    DPMSSuspendB = ((DPMSSuspendB & 1) << 6);
    unsigned char FBP = 0;
    
    [self readDataTable:&FifthBP offset:24 length:1];
    
    FBP = [self hex2uchar:[FifthBP cStringUsingEncoding:NSUTF8StringEncoding]];
    FBP &= 0xBF;
    FBP |= DPMSSuspendB;
    
    FifthBP = [NSString stringWithFormat:@"%.2X", FBP];
    
    [self writeDataTable:&FifthBP offset:24 length:1];
}

-(void)sDPMSStandby:(id)sender
{
    unsigned char DPMSStandbyB = (unsigned char)[(NSButton *)sender state];
    NSString *FifthBP;
    DPMSStandbyB = ((DPMSStandbyB & 1) << 7);
    unsigned char FBP = 0;
    
    [self readDataTable:&FifthBP offset:24 length:1];
    
    FBP = [self hex2uchar:[FifthBP cStringUsingEncoding:NSUTF8StringEncoding]];
    FBP &= 0x7F;
    FBP |= DPMSStandbyB;
    
    FifthBP = [NSString stringWithFormat:@"%.2X", FBP];
    
    [self writeDataTable:&FifthBP offset:24 length:1];
}

-(void)sYCrCb444:(id)sender
{
    unsigned char YCrCb444B = (unsigned char)[(NSButton *)sender state];
    NSString *FifthBP;
    YCrCb444B = ((YCrCb444B & 1) << 4);
    unsigned char FBP = 0;
    
    [self readDataTable:&FifthBP offset:24 length:1];
    
    FBP = [self hex2uchar:[FifthBP cStringUsingEncoding:NSUTF8StringEncoding]];
    FBP &= 0xEF;
    FBP |= YCrCb444B;
    
    FifthBP = [NSString stringWithFormat:@"%.2X", FBP];
    
    [self writeDataTable:&FifthBP offset:24 length:1];
}

-(void)sYCrCb422:(id)sender
{
    unsigned char YCrCb422B = (unsigned char)[(NSButton *)sender state];
    NSString *FifthBP;
    YCrCb422B = ((YCrCb422B & 1) << 3);
    unsigned char FBP = 0;
    
    [self readDataTable:&FifthBP offset:24 length:1];
    
    FBP = [self hex2uchar:[FifthBP cStringUsingEncoding:NSUTF8StringEncoding]];
    FBP &= 0xF7;
    FBP |= YCrCb422B;
    
    FifthBP = [NSString stringWithFormat:@"%.2X", FBP];
    
    [self writeDataTable:&FifthBP offset:24 length:1];
}

-(void)sColorType:(id)sender
{
    unsigned char ColorTypeB = (unsigned char)[sender selectedTag];
    NSString *FifthBP;
    ColorTypeB = ((ColorTypeB & 3) << 3);
    unsigned char FBP = 0;

    if (colorTypeVal == ColorTypeB)
    {
        return;
    }

    [self readDataTable:&FifthBP offset:24 length:1];
    
    FBP = [self hex2uchar:[FifthBP cStringUsingEncoding:NSUTF8StringEncoding]];
    FBP &= 0xE4;
    FBP |= ColorTypeB;
    
    FifthBP = [NSString stringWithFormat:@"%.2X", FBP];
    
    [self writeDataTable:&FifthBP offset:24 length:1];

    colorTypeVal = ColorTypeB;
}

-(void)ssRGBPC:(id)sender
{
    unsigned char RGBPCB = (unsigned char)[(NSButton *)sender state];
    NSString *FifthBP;
    RGBPCB = ((RGBPCB & 1) << 2);
    unsigned char FBP = 0;
    
    [self readDataTable:&FifthBP offset:24 length:1];
    
    FBP = [self hex2uchar:[FifthBP cStringUsingEncoding:NSUTF8StringEncoding]];
    FBP &= 0xFB;
    FBP |= RGBPCB;
    
    FifthBP = [NSString stringWithFormat:@"%.2X", FBP];
    
    [self writeDataTable:&FifthBP offset:24 length:1];
}

-(void)sDetPT:(id)sender
{
    unsigned char DetPTB = (unsigned char)[(NSButton *)sender state];
    NSString *FifthBP;
    DetPTB = ((DetPTB & 1) << 1);
    unsigned char FBP = 0;
    
    [self readDataTable:&FifthBP offset:24 length:1];
    
    FBP = [self hex2uchar:[FifthBP cStringUsingEncoding:NSUTF8StringEncoding]];
    FBP &= 0xFD;
    FBP |= DetPTB;
    
    FifthBP = [NSString stringWithFormat:@"%.2X", FBP];
    
    [self writeDataTable:&FifthBP offset:24 length:1];
}

-(void)sSuppGTF:(id)sender
{
    unsigned char SuppGTFB = (unsigned char)[(NSButton *)sender state];
    NSString *FifthBP;
    SuppGTFB = (SuppGTFB & 1);
    unsigned char FBP = 0;
    
    [self readDataTable:&FifthBP offset:24 length:1];
    
    FBP = [self hex2uchar:[FifthBP cStringUsingEncoding:NSUTF8StringEncoding]];
    FBP &= 0xFE;
    FBP |= SuppGTFB;
    
    FifthBP = [NSString stringWithFormat:@"%.2X", FBP];
    
    [self writeDataTable:&FifthBP offset:24 length:1];
}

ColorRender *colorView = nil;

-(void)getChroma
{
    NSString *chromaData[10];
    unsigned char chromaB[10] = { 0 };
    NSRect colorRect = NSMakeRect(0, 0, 256, 256);
    unsigned long redXB = 0;
    unsigned long redYB = 0;
    unsigned long greenXB = 0;
    unsigned long greenYB = 0;
    unsigned long blueXB = 0;
    unsigned long blueYB = 0;
    unsigned long whiteXB = 0;
    unsigned long whiteYB = 0;
    float redXf = 0;
    float redYf = 0;
    float greenXf = 0;
    float greenYf = 0;
    float blueXf = 0;
    float blueYf = 0;
    float whiteXf = 0;
    float whiteYf = 0;
    float colorXSet[3] = { 0, 0, 0   };
    float colorYSet[3] = { 0, 0, 0 };

    [self readDataTable:chromaData offset:25 length:10];

    chromaB[0] = [self hex2uchar:[chromaData[0] cStringUsingEncoding:NSUTF8StringEncoding]];
    chromaB[1] = [self hex2uchar:[chromaData[1] cStringUsingEncoding:NSUTF8StringEncoding]];
    chromaB[2] = [self hex2uchar:[chromaData[2] cStringUsingEncoding:NSUTF8StringEncoding]];
    chromaB[3] = [self hex2uchar:[chromaData[3] cStringUsingEncoding:NSUTF8StringEncoding]];
    chromaB[4] = [self hex2uchar:[chromaData[4] cStringUsingEncoding:NSUTF8StringEncoding]];
    chromaB[5] = [self hex2uchar:[chromaData[5] cStringUsingEncoding:NSUTF8StringEncoding]];
    chromaB[6] = [self hex2uchar:[chromaData[6] cStringUsingEncoding:NSUTF8StringEncoding]];
    chromaB[7] = [self hex2uchar:[chromaData[7] cStringUsingEncoding:NSUTF8StringEncoding]];
    chromaB[8] = [self hex2uchar:[chromaData[8] cStringUsingEncoding:NSUTF8StringEncoding]];
    chromaB[9] = [self hex2uchar:[chromaData[9] cStringUsingEncoding:NSUTF8StringEncoding]];

    redXB   = ((chromaB[0] & 0xC0) >> 6);
    redXB  |= (chromaB[2] << 2);
    redYB   = ((chromaB[0] & 0x30) >> 4);
    redYB  |= (chromaB[3] << 2);
    greenXB = (((chromaB[0] & 0x0C) >> 2) + (chromaB[4] << 2));
    greenYB = ((chromaB[0]  & 0x03)       + (chromaB[5] << 2));
    blueXB  = (((chromaB[1] & 0xC0) >> 6) + (chromaB[6] << 2));
    blueYB  = (((chromaB[1] & 0x30) >> 4) + (chromaB[7] << 2));
    whiteXB = (((chromaB[1] & 0x0C) >> 2) + (chromaB[8] << 2));
    whiteYB = ((chromaB[1]  & 0x03)       + (chromaB[9] << 2));

    redXf = redXB;
    redXf /= 1024;

    redYf = redYB;
    redYf /= 1024;

    greenXf = greenXB;
    greenXf /= 1024;
    
    greenYf = greenYB;
    greenYf /= 1024;
    
    blueXf = blueXB;
    blueXf /= 1024;
    
    blueYf = blueYB;
    blueYf /= 1024;

    whiteXf = whiteXB;
    whiteXf /= 1024;
    
    whiteYf = whiteYB;
    whiteYf /= 1024;

    [redX setFloatValue:redXf];
    [redY setFloatValue:redYf];
    [greenX setFloatValue:greenXf];
    [greenY setFloatValue:greenYf];
    [blueX setFloatValue:blueXf];
    [blueY setFloatValue:blueYf];
    [whiteX setFloatValue:whiteXf];
    [whiteY setFloatValue:whiteYf];

    colorXSet[0] = redXf;
    colorXSet[1] = greenXf;
    colorXSet[2] = blueXf;

    colorYSet[0] = redYf;
    colorYSet[1] = greenYf;
    colorYSet[2] = blueYf;

    colorView = [[ColorRender alloc] initWithFrame:colorRect colorX:(float *)colorXSet colorY:(float *)colorYSet];

    [colorGram setDocumentView:[colorView retain]];
}

-(void)sChroma:(id)sender
{
    NSString *chromaData[10];
    unsigned char chromaVals[10];
    unsigned long redXB = 0;
    unsigned long redYB = 0;
    unsigned long greenXB = 0;
    unsigned long greenYB = 0;
    unsigned long blueXB = 0;
    unsigned long blueYB = 0;
    unsigned long whiteXB = 0;
    unsigned long whiteYB = 0;
    float redXf = 0;
    float redYf = 0;
    float greenXf = 0;
    float greenYf = 0;
    float blueXf = 0;
    float blueYf = 0;
    float whiteXf = 0;
    float whiteYf = 0;

    redXf = [redX floatValue];
    redYf = [redY floatValue];
    greenXf = [greenX floatValue];
    greenYf = [greenY floatValue];
    blueXf = [blueX floatValue];
    blueYf = [blueY floatValue];
    whiteXf = [whiteX floatValue];
    whiteYf = [whiteY floatValue];

    redXf *= 1024;
    redYf *= 1024;
    greenXf *= 1024;
    greenYf *= 1024;
    blueXf *= 1024;
    blueYf *= 1024;
    whiteXf *= 1024;
    whiteYf *= 1024;

    redXB = lrintf(redXf);
    redYB = lrintf(redYf);
    greenXB = lrintf(greenXf);
    greenYB = lrintf(greenYf);
    blueXB = lrintf(blueXf);
    blueYB = lrintf(blueYf);
    whiteXB = lrintf(whiteXf);
    whiteYB = lrintf(whiteYf);

    chromaVals[0]  = ((redXB & 3) << 6);
    chromaVals[0] |= ((redYB & 3) << 4);
    chromaVals[0] |= ((greenXB & 3) << 2);
    chromaVals[0] |=  (greenYB & 3);
    chromaVals[1]  = ((blueXB & 3) << 6);
    chromaVals[1] |= ((blueYB & 3) << 4);
    chromaVals[1] |= ((whiteXB & 3) << 2);
    chromaVals[1] |=  (whiteYB & 3);
    chromaVals[2] =  ((redXB & 0x3FC) >> 2);
    chromaVals[3] =  ((redYB & 0x3FC) >> 2);
    chromaVals[4] =  ((greenXB & 0x3FC) >> 2);
    chromaVals[5] =  ((greenYB & 0x3FC) >> 2);
    chromaVals[6] =  ((blueXB & 0x3FC) >> 2);
    chromaVals[7] =  ((blueYB & 0x3FC) >> 2);
    chromaVals[8] =  ((whiteXB & 0x3FC) >> 2);
    chromaVals[9] =  ((whiteYB & 0x3FC) >> 2);

    chromaData[0] = [NSString stringWithFormat:@"%.2X", chromaVals[0]];
    chromaData[1] = [NSString stringWithFormat:@"%.2X", chromaVals[1]];
    chromaData[2] = [NSString stringWithFormat:@"%.2X", chromaVals[2]];
    chromaData[3] = [NSString stringWithFormat:@"%.2X", chromaVals[3]];
    chromaData[4] = [NSString stringWithFormat:@"%.2X", chromaVals[4]];
    chromaData[5] = [NSString stringWithFormat:@"%.2X", chromaVals[5]];
    chromaData[6] = [NSString stringWithFormat:@"%.2X", chromaVals[6]];
    chromaData[7] = [NSString stringWithFormat:@"%.2X", chromaVals[7]];
    chromaData[8] = [NSString stringWithFormat:@"%.2X", chromaVals[8]];
    chromaData[9] = [NSString stringWithFormat:@"%.2X", chromaVals[9]];

    [self writeDataTable:chromaData offset:25 length:10];

    [self getChroma];
}

-(void)getBasicParams
{
    NSString *BasicParams[5];
    unsigned char bparams[5];
    const char *cbparams[5];
    NSString *minorVer = nil;
    unsigned char bitspercolor = 0;

    [self readDataTable:&minorVer offset:19 length:1];
    minorVersionNumber = [self hex2uchar:[minorVer cStringUsingEncoding:NSUTF8StringEncoding]];

    [self readDataTable:BasicParams offset:20 length:5];

    cbparams[0] = [BasicParams[0] cStringUsingEncoding:NSUTF8StringEncoding];
    cbparams[1] = [BasicParams[1] cStringUsingEncoding:NSUTF8StringEncoding];
    cbparams[2] = [BasicParams[2] cStringUsingEncoding:NSUTF8StringEncoding];
    cbparams[3] = [BasicParams[3] cStringUsingEncoding:NSUTF8StringEncoding];
    cbparams[4] = [BasicParams[4] cStringUsingEncoding:NSUTF8StringEncoding];

    bparams[0] = [self hex2uchar:cbparams[0]];
    bparams[1] = [self hex2uchar:cbparams[1]];
    bparams[2] = [self hex2uchar:cbparams[2]];
    bparams[3] = [self hex2uchar:cbparams[3]];
    bparams[4] = [self hex2uchar:cbparams[4]];

    if (bparams[0] & 0x80)
    {
        [displayType selectItemAtIndex:1];

        if (minorVersionNumber >= 4)
        {
            bitspercolor = ((bparams[0] & 0x70) >> 3);

            if ((bitspercolor == 7) || (bitspercolor == 0))
            {
                [BitsPerColorChannel setStringValue:@"0"];
            } else {
                [BitsPerColorChannel setStringValue:[NSString stringWithFormat:@"%u", (bitspercolor + 4)]];
            }

            connectorInterface = (bparams[0] & 0xF);

            [connectorType selectItemWithTag:connectorInterface];

            [displayTypeView setDocumentView:[display14Type retain]];
        } else if (minorVersionNumber >= 2) {
            if (bparams[0] & 0x1)
            {
                [DFPCompatible setState:1];
            } else {
                [DFPCompatible setState:0];
            }

            [displayTypeView setDocumentView:[display12Type retain]];
        } else {
            [displayTypeView setDocumentView:[displayOtherType retain]];
        }
    } else {
        [displayType selectItemAtIndex:0];

        unsigned char voltage = ((bparams[0] & 0x60) >> 5);
        unsigned char sync = (bparams[0] & 0xF);
        unsigned char b2bsetup = (bparams[0x0] & 0x10);

        [voltageType selectItemWithTag:voltage];

        if (b2bsetup == 0)
        {
            [B2BSet setState:0];
        } else {
            [B2BSet setState:1];
        }

        if (sync & 0x08)
        {
            [SyncSep setState:1];
        } else {
            [SyncSep setState:0];
        }

        if (sync & 0x04)
        {
            [SyncComp setState:1];
        } else {
            [SyncComp setState:0];
        }

        if (sync & 0x02)
        {
            [SyncGreen setState:1];
        } else {
            [SyncGreen setState:0];
        }

        if (sync & 0x01)
        {
            [SyncSerr setState:1];
        } else {
            [SyncSerr setState:0];
        }

        [displayTypeView setDocumentView:[displayAnalogType retain]];
    }

    [MaximumHorizSize setStringValue:[NSString stringWithFormat:@"%u", bparams[1]]];
    [MaximumVertSize setStringValue:[NSString stringWithFormat:@"%u", bparams[2]]];

    [GammaValue setFloatValue:((bparams[3] + 100.0) / 100.0)];

    if (bparams[4] & 0x80)
    {
        [DPMSStandby setState:1];
    } else {
        [DPMSStandby setState:0];
    }

    if (bparams[4] & 0x40)
    {
        [DPMSSuspend setState:1];
    } else {
        [DPMSSuspend setState:0];
    }

    if (bparams[4] & 0x20)
    {
        [DPMSOff setState:1];
    } else {
        [DPMSOff setState:0];
    }

    if (bparams[0] & 0x80)
    {
        if (bparams[4] & 0x10)
        {
            [YCrCb444 setState:1];
        } else {
            [YCrCb444 setState:0];
        }

        if (bparams[4] & 0x08)
        {
            [YCrCb422 setState:1];
        } else {
            [YCrCb422 setState:0];
        }

        [colorFormatView setDocumentView:[colorDigitaView retain]];
    } else {
        colorTypeVal = ((bparams[4] & 0x18) >> 3);
        [colorType selectItemWithTag:colorTypeVal];

        [colorFormatView setDocumentView:[colorAnalogView retain]];
    }

    if (bparams[4] & 0x04)
    {
        [sRGBPC setState:1];
    } else {
        [sRGBPC setState:0];
    }

    if (bparams[4] & 0x02)
    {
        [DetPT setState:1];
    } else {
        [DetPT setState:0];
    }

    if (bparams[4] & 0x01)
    {
        [SuppGTF setState:1];
    } else {
        [SuppGTF setState:0];
    }
}

-(void)setEstaBit:(id)sender
{
    unsigned char bitOn = (unsigned char)[(NSButton *)sender state];
    unsigned int bitnr = (unsigned int)[sender tag];
    unsigned char bytenr = 0;
    unsigned char curmask = 0;
    unsigned char establishedB[3];
    NSString *established[3];

    [self readDataTable:established offset:35 length:3];
    
    establishedB[0] = [self hex2uchar:[established[0] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[1] = [self hex2uchar:[established[1] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[2] = [self hex2uchar:[established[2] cStringUsingEncoding:NSUTF8StringEncoding]];

    if (bitnr > 15)
    {
        bytenr = 2;
        bitnr -= 9;
    } else if (bitnr > 7) {
        bytenr = 1;
        bitnr -= 8;
    } else {
        bytenr = 0;
    }

    curmask = (0xFF - ((unsigned char)(1 << bitnr)));

    establishedB[bytenr] &= curmask;
    establishedB[bytenr] |= (bitOn << bitnr);

    established[0] = [NSString stringWithFormat:@"%.2X", establishedB[0]];
    established[1] = [NSString stringWithFormat:@"%.2X", establishedB[1]];
    established[2] = [NSString stringWithFormat:@"%.2X", establishedB[2]];

    [self writeDataTable:established offset:35 length:3];

    [self getEstaRes];
}

-(void)getEsta3Res;
{
    NSString *established[6];
    unsigned char establishedB[6];
    
    [self readDataTable:established offset:(StartOffset + 6) length:6];
    
    establishedB[0] = [self hex2uchar:[established[0] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[1] = [self hex2uchar:[established[1] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[2] = [self hex2uchar:[established[2] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[3] = [self hex2uchar:[established[3] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[4] = [self hex2uchar:[established[4] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[5] = [self hex2uchar:[established[5] cStringUsingEncoding:NSUTF8StringEncoding]];
    
    if (establishedB[0] & 0x80)
    {
        [established3_Chk1 setState:1];
    } else {
        [established3_Chk1 setState:0];
    }
    
    if (establishedB[0] & 0x40)
    {
        [established3_Chk2 setState:1];
    } else {
        [established3_Chk2 setState:0];
    }
    
    if (establishedB[0] & 0x20)
    {
        [established3_Chk3 setState:1];
    } else {
        [established3_Chk3 setState:0];
    }
    
    if (establishedB[0] & 0x10)
    {
        [established3_Chk4 setState:1];
    } else {
        [established3_Chk4 setState:0];
    }
    
    if (establishedB[0] & 0x8)
    {
        [established3_Chk5 setState:1];
    } else {
        [established3_Chk5 setState:0];
    }
    
    if (establishedB[0] & 0x4)
    {
        [established3_Chk6 setState:1];
    } else {
        [established3_Chk6 setState:0];
    }
    
    if (establishedB[0] & 0x2)
    {
        [established3_Chk7 setState:1];
    } else {
        [established3_Chk7 setState:0];
    }
    
    if (establishedB[0] & 0x1)
    {
        [established3_Chk8 setState:1];
    } else {
        [established3_Chk8 setState:0];
    }

    if (establishedB[1] & 0x80)
    {
        [established3_Chk9 setState:1];
    } else {
        [established3_Chk9 setState:0];
    }
    
    if (establishedB[1] & 0x40)
    {
        [established3_Chk10 setState:1];
    } else {
        [established3_Chk10 setState:0];
    }
    
    if (establishedB[1] & 0x20)
    {
        [established3_Chk11 setState:1];
    } else {
        [established3_Chk11 setState:0];
    }
    
    if (establishedB[1] & 0x10)
    {
        [established3_Chk12 setState:1];
    } else {
        [established3_Chk12 setState:0];
    }
    
    if (establishedB[1] & 0x8)
    {
        [established3_Chk13 setState:1];
    } else {
        [established3_Chk13 setState:0];
    }
    
    if (establishedB[1] & 0x4)
    {
        [established3_Chk14 setState:1];
    } else {
        [established3_Chk14 setState:0];
    }
    
    if (establishedB[1] & 0x2)
    {
        [established3_Chk15 setState:1];
    } else {
        [established3_Chk15 setState:0];
    }
    
    if (establishedB[1] & 0x1)
    {
        [established3_Chk16 setState:1];
    } else {
        [established3_Chk16 setState:0];
    }
    
    if (establishedB[2] & 0x80)
    {
        [established3_Chk17 setState:1];
    } else {
        [established3_Chk17 setState:0];
    }
    
    if (establishedB[2] & 0x40)
    {
        [established3_Chk18 setState:1];
    } else {
        [established3_Chk18 setState:0];
    }
    
    if (establishedB[2] & 0x20)
    {
        [established3_Chk19 setState:1];
    } else {
        [established3_Chk19 setState:0];
    }
    
    if (establishedB[2] & 0x10)
    {
        [established3_Chk20 setState:1];
    } else {
        [established3_Chk20 setState:0];
    }
    
    if (establishedB[2] & 0x8)
    {
        [established3_Chk20 setState:1];
    } else {
        [established3_Chk21 setState:0];
    }
    
    if (establishedB[2] & 0x4)
    {
        [established3_Chk22 setState:1];
    } else {
        [established3_Chk22 setState:0];
    }
    
    if (establishedB[2] & 0x2)
    {
        [established3_Chk23 setState:1];
    } else {
        [established3_Chk23 setState:0];
    }
    
    if (establishedB[2] & 0x1)
    {
        [established3_Chk24 setState:1];
    } else {
        [established3_Chk24 setState:0];
    }

    if (establishedB[3] & 0x80)
    {
        [established3_Chk25 setState:1];
    } else {
        [established3_Chk25 setState:0];
    }
    
    if (establishedB[3] & 0x40)
    {
        [established3_Chk26 setState:1];
    } else {
        [established3_Chk26 setState:0];
    }
    
    if (establishedB[3] & 0x20)
    {
        [established3_Chk27 setState:1];
    } else {
        [established3_Chk27 setState:0];
    }
    
    if (establishedB[3] & 0x10)
    {
        [established3_Chk28 setState:1];
    } else {
        [established3_Chk28 setState:0];
    }
    
    if (establishedB[3] & 0x8)
    {
        [established3_Chk29 setState:1];
    } else {
        [established3_Chk29 setState:0];
    }
    
    if (establishedB[3] & 0x4)
    {
        [established3_Chk30 setState:1];
    } else {
        [established3_Chk30 setState:0];
    }
    
    if (establishedB[3] & 0x2)
    {
        [established3_Chk31 setState:1];
    } else {
        [established3_Chk31 setState:0];
    }
    
    if (establishedB[3] & 0x1)
    {
        [established3_Chk32 setState:1];
    } else {
        [established3_Chk32 setState:0];
    }

    if (establishedB[4] & 0x80)
    {
        [established3_Chk33 setState:1];
    } else {
        [established3_Chk33 setState:0];
    }
    
    if (establishedB[4] & 0x40)
    {
        [established3_Chk34 setState:1];
    } else {
        [established3_Chk34 setState:0];
    }
    
    if (establishedB[4] & 0x20)
    {
        [established3_Chk35 setState:1];
    } else {
        [established3_Chk35 setState:0];
    }
    
    if (establishedB[4] & 0x10)
    {
        [established3_Chk36 setState:1];
    } else {
        [established3_Chk36 setState:0];
    }
    
    if (establishedB[4] & 0x8)
    {
        [established3_Chk37 setState:1];
    } else {
        [established3_Chk37 setState:0];
    }
    
    if (establishedB[4] & 0x4)
    {
        [established3_Chk38 setState:1];
    } else {
        [established3_Chk38 setState:0];
    }
    
    if (establishedB[4] & 0x2)
    {
        [established3_Chk39 setState:1];
    } else {
        [established3_Chk39 setState:0];
    }
    
    if (establishedB[4] & 0x1)
    {
        [established3_Chk40 setState:1];
    } else {
        [established3_Chk40 setState:0];
    }

    if (establishedB[5] & 0x80)
    {
        [established3_Chk41 setState:1];
    } else {
        [established3_Chk41 setState:0];
    }
    
    if (establishedB[5] & 0x40)
    {
        [established3_Chk42 setState:1];
    } else {
        [established3_Chk42 setState:0];
    }
    
    if (establishedB[5] & 0x20)
    {
        [established3_Chk43 setState:1];
    } else {
        [established3_Chk43 setState:0];
    }
    
    if (establishedB[5] & 0x10)
    {
        [established3_Chk44 setState:1];
    } else {
        [established3_Chk44 setState:0];
    }
}

-(void)setEsta3Bit:(id)sender
{
    unsigned char bitOn = (unsigned char)[(NSButton *)sender state];
    unsigned int bitnr = (unsigned int)[sender tag];
    unsigned char bytenr = 0;
    unsigned char curmask = 0;
    unsigned char establishedB[6];
    NSString *established[6];
    
    [self readDataTable:established offset:(StartOffset + 6) length:6];
    
    establishedB[0] = [self hex2uchar:[established[0] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[1] = [self hex2uchar:[established[1] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[2] = [self hex2uchar:[established[2] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[3] = [self hex2uchar:[established[3] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[4] = [self hex2uchar:[established[4] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[5] = [self hex2uchar:[established[5] cStringUsingEncoding:NSUTF8StringEncoding]];
    
    bytenr = bitnr / 8;
    bitnr = bitnr - (bytenr * 8);

    curmask = (0xFF - ((unsigned char)(1 << bitnr)));
    
    establishedB[bytenr] &= curmask;
    establishedB[bytenr] |= (bitOn << bitnr);
    
    established[0] = [NSString stringWithFormat:@"%.2X", establishedB[0]];
    established[1] = [NSString stringWithFormat:@"%.2X", establishedB[1]];
    established[2] = [NSString stringWithFormat:@"%.2X", establishedB[2]];
    established[3] = [NSString stringWithFormat:@"%.2X", establishedB[3]];
    established[4] = [NSString stringWithFormat:@"%.2X", establishedB[4]];
    established[5] = [NSString stringWithFormat:@"%.2X", establishedB[5]];
    
    [self writeDataTable:established offset:(StartOffset + 6) length:6];
    
    [self getEstaRes];
}

-(void)getEstaRes;
{
    NSString *established[3];
    unsigned char establishedB[3];

    [self readDataTable:established offset:35 length:3];

    establishedB[0] = [self hex2uchar:[established[0] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[1] = [self hex2uchar:[established[1] cStringUsingEncoding:NSUTF8StringEncoding]];
    establishedB[2] = [self hex2uchar:[established[2] cStringUsingEncoding:NSUTF8StringEncoding]];

    if (establishedB[0] & 0x80)
    {
        [estaRes1 setState:1];
    } else {
        [estaRes1 setState:0];
    }

    if (establishedB[0] & 0x40)
    {
        [estaRes2 setState:1];
    } else {
        [estaRes2 setState:0];
    }

    if (establishedB[0] & 0x20)
    {
        [estaRes3 setState:1];
    } else {
        [estaRes3 setState:0];
    }

    if (establishedB[0] & 0x10)
    {
        [estaRes4 setState:1];
    } else {
        [estaRes4 setState:0];
    }

    if (establishedB[0] & 0x8)
    {
        [estaRes5 setState:1];
    } else {
        [estaRes5 setState:0];
    }
    
    if (establishedB[0] & 0x4)
    {
        [estaRes6 setState:1];
    } else {
        [estaRes6 setState:0];
    }
    
    if (establishedB[0] & 0x2)
    {
        [estaRes7 setState:1];
    } else {
        [estaRes7 setState:0];
    }
    
    if (establishedB[0] & 0x1)
    {
        [estaRes8 setState:1];
    } else {
        [estaRes8 setState:0];
    }

    if (establishedB[1] & 0x80)
    {
        [estaRes9 setState:1];
    } else {
        [estaRes9 setState:0];
    }
    
    if (establishedB[1] & 0x40)
    {
        [estaRes10 setState:1];
    } else {
        [estaRes10 setState:0];
    }
    
    if (establishedB[1] & 0x20)
    {
        [estaRes11 setState:1];
    } else {
        [estaRes11 setState:0];
    }
    
    if (establishedB[1] & 0x10)
    {
        [estaRes12 setState:1];
    } else {
        [estaRes12 setState:0];
    }
    
    if (establishedB[1] & 0x8)
    {
        [estaRes13 setState:1];
    } else {
        [estaRes13 setState:0];
    }
    
    if (establishedB[1] & 0x4)
    {
        [estaRes14 setState:1];
    } else {
        [estaRes14 setState:0];
    }
    
    if (establishedB[1] & 0x2)
    {
        [estaRes15 setState:1];
    } else {
        [estaRes15 setState:0];
    }
    
    if (establishedB[1] & 0x1)
    {
        [estaRes16 setState:1];
    } else {
        [estaRes16 setState:0];
    }
    
    if (establishedB[2] & 0x80)
    {
        [estaRes17 setState:1];
    } else {
        [estaRes17 setState:0];
    }
}

-(void)getStandardRes
{
    NSString *stdResData[16] = { nil };
    unsigned char stdResDataB[16] = { 0 };
    NSString *minorVer = nil;
    unsigned char minorVerB = 0;
    unsigned int standX[8] = { 0 };
    unsigned int standY[8] = { 0 };
    unsigned int standHz[8] = { 0 };
    unsigned char standEnabled[8] = { 0 };
    unsigned char standAR[8] = { 0 };
    unsigned char cnt = 0;
    
    [self readDataTable:&minorVer offset:19 length:1];
    [self readDataTable:stdResData offset:38 length:16];
    
    stdResDataB[0] = [self hex2uchar:[stdResData[0] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[1] = [self hex2uchar:[stdResData[1] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[2] = [self hex2uchar:[stdResData[2] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[3] = [self hex2uchar:[stdResData[3] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[4] = [self hex2uchar:[stdResData[4] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[5] = [self hex2uchar:[stdResData[5] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[6] = [self hex2uchar:[stdResData[6] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[7] = [self hex2uchar:[stdResData[7] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[8] = [self hex2uchar:[stdResData[8] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[9] = [self hex2uchar:[stdResData[9] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[10] = [self hex2uchar:[stdResData[10] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[11] = [self hex2uchar:[stdResData[11] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[12] = [self hex2uchar:[stdResData[12] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[13] = [self hex2uchar:[stdResData[13] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[14] = [self hex2uchar:[stdResData[14] cStringUsingEncoding:NSUTF8StringEncoding]];
    stdResDataB[15] = [self hex2uchar:[stdResData[15] cStringUsingEncoding:NSUTF8StringEncoding]];

    minorVerB = [self hex2uchar:[minorVer cStringUsingEncoding:NSUTF8StringEncoding]];

    while (cnt < 8)
    {
        if ((stdResDataB[cnt*2] == 0x01) && (stdResDataB[(cnt*2)+1] == 0x01))
        {
            standEnabled[cnt] = 0;

            ++cnt;
            if (standEnabled[0])
            {
                [stdEnabled1 setState:1];
                [stdX1 setEnabled:YES];
                [stdY1 setEnabled:YES];
                [stdHz1 setEnabled:YES];
                [stdList1 setEnabled:YES];
                [stdSet1 setEnabled:YES];
                [stdX1 setIntValue:(int)standX[0]];
                [stdY1 setIntValue:(int)standY[0]];
                [stdHz1 setIntValue:(int)standHz[0]];
                [stdList1 selectItemWithTag:standAR[0]];
                [stdSet1 setEnabled:YES];
            } else {
                [stdEnabled1 setState:0];
                [stdX1 setEnabled:NO];
                [stdY1 setEnabled:NO];
                [stdHz1 setEnabled:NO];
                [stdList1 setEnabled:NO];
                [stdSet1 setEnabled:NO];
            }

            continue;
        }

        standEnabled[cnt] = 1;
        standX[cnt] = ((stdResDataB[cnt*2] + 31) * 8);
        standAR[cnt] = ((stdResDataB[(cnt*2)+1] >> 6) & 3);

        switch (standAR[cnt])
        {
            case 0:
                if (minorVerB >= 3)
                {
                    standY[cnt] = (standX[cnt] * 10) / 16;
                } else {
                    standY[cnt] = standX[cnt];
                }

                break;

            case 1:
                standY[cnt] = (standX[cnt] * 3) / 4;

                break;

            case 2:
                standY[cnt] = (standX[cnt] * 4) / 5;

                break;

            case 3:
                standY[cnt] = (standX[cnt] * 9) / 16;

                break;
        }

        standHz[cnt] = 60 + (stdResDataB[(cnt*2)+1] & 0x3F);

        ++cnt;
    }

    if (standEnabled[0])
    {
        [stdEnabled1 setState:1];
        [stdX1 setEnabled:YES];
        [stdY1 setEnabled:YES];
        [stdHz1 setEnabled:YES];
        [stdList1 setEnabled:YES];
        [stdSet1 setEnabled:YES];
        [stdX1 setIntValue:(int)standX[0]];
        [stdY1 setIntValue:(int)standY[0]];
        [stdHz1 setIntValue:(int)standHz[0]];
        [stdList1 selectItemWithTag:standAR[0]];
        [stdSet1 setEnabled:YES];
    } else {
        [stdEnabled1 setState:0];
        [stdX1 setEnabled:NO];
        [stdY1 setEnabled:NO];
        [stdHz1 setEnabled:NO];
        [stdList1 setEnabled:NO];
        [stdSet1 setEnabled:NO];
    }

    if (standEnabled[1])
    {
        [stdEnabled2 setState:1];
        [stdX2 setEnabled:YES];
        [stdY2 setEnabled:YES];
        [stdHz2 setEnabled:YES];
        [stdList2 setEnabled:YES];
        [stdSet2 setEnabled:YES];
        [stdX2 setIntValue:(int)standX[1]];
        [stdY2 setIntValue:(int)standY[1]];
        [stdHz2 setIntValue:(int)standHz[1]];
        [stdList2 selectItemWithTag:standAR[1]];
        [stdSet2 setEnabled:YES];
    } else {
        [stdEnabled2 setState:0];
        [stdX2 setEnabled:NO];
        [stdY2 setEnabled:NO];
        [stdHz2 setEnabled:NO];
        [stdList2 setEnabled:NO];
        [stdSet2 setEnabled:NO];
    }

    if (standEnabled[2])
    {
        [stdEnabled3 setState:1];
        [stdX3 setEnabled:YES];
        [stdY3 setEnabled:YES];
        [stdHz3 setEnabled:YES];
        [stdList3 setEnabled:YES];
        [stdSet3 setEnabled:YES];
        [stdX3 setIntValue:(int)standX[2]];
        [stdY3 setIntValue:(int)standY[2]];
        [stdHz3 setIntValue:(int)standHz[2]];
        [stdList3 selectItemWithTag:standAR[2]];
        [stdSet3 setEnabled:YES];
    } else {
        [stdEnabled3 setState:0];
        [stdX3 setEnabled:NO];
        [stdY3 setEnabled:NO];
        [stdHz3 setEnabled:NO];
        [stdList3 setEnabled:NO];
        [stdSet3 setEnabled:NO];
    }

    if (standEnabled[3])
    {
        [stdEnabled4 setState:1];
        [stdX4 setEnabled:YES];
        [stdY4 setEnabled:YES];
        [stdHz4 setEnabled:YES];
        [stdList4 setEnabled:YES];
        [stdSet4 setEnabled:YES];
        [stdX4 setIntValue:(int)standX[3]];
        [stdY4 setIntValue:(int)standY[3]];
        [stdHz4 setIntValue:(int)standHz[3]];
        [stdList4 selectItemWithTag:standAR[3]];
        [stdSet4 setEnabled:YES];
    } else {
        [stdEnabled4 setState:0];
        [stdX4 setEnabled:NO];
        [stdY4 setEnabled:NO];
        [stdHz4 setEnabled:NO];
        [stdList4 setEnabled:NO];
        [stdSet4 setEnabled:NO];
    }

    if (standEnabled[4])
    {
        [stdEnabled5 setState:1];
        [stdX5 setEnabled:YES];
        [stdY5 setEnabled:YES];
        [stdHz5 setEnabled:YES];
        [stdList5 setEnabled:YES];
        [stdSet5 setEnabled:YES];
        [stdX5 setIntValue:(int)standX[4]];
        [stdY5 setIntValue:(int)standY[4]];
        [stdHz5 setIntValue:(int)standHz[4]];
        [stdList5 selectItemWithTag:standAR[4]];
        [stdSet5 setEnabled:YES];
    } else {
        [stdEnabled5 setState:0];
        [stdX5 setEnabled:NO];
        [stdY5 setEnabled:NO];
        [stdHz5 setEnabled:NO];
        [stdList5 setEnabled:NO];
        [stdSet5 setEnabled:NO];
    }

    if (standEnabled[5])
    {
        [stdEnabled6 setState:1];
        [stdX6 setEnabled:YES];
        [stdY6 setEnabled:YES];
        [stdHz6 setEnabled:YES];
        [stdList6 setEnabled:YES];
        [stdSet6 setEnabled:YES];
        [stdX6 setIntValue:(int)standX[5]];
        [stdY6 setIntValue:(int)standY[5]];
        [stdHz6 setIntValue:(int)standHz[5]];
        [stdList6 selectItemWithTag:standAR[5]];
        [stdSet6 setEnabled:YES];
    } else {
        [stdEnabled6 setState:0];
        [stdX6 setEnabled:NO];
        [stdY6 setEnabled:NO];
        [stdHz6 setEnabled:NO];
        [stdList6 setEnabled:NO];
        [stdSet6 setEnabled:NO];
    }

    if (standEnabled[6])
    {
        [stdEnabled7 setState:1];
        [stdX7 setEnabled:YES];
        [stdY7 setEnabled:YES];
        [stdHz7 setEnabled:YES];
        [stdList7 setEnabled:YES];
        [stdSet7 setEnabled:YES];
        [stdX7 setIntValue:(int)standX[6]];
        [stdY7 setIntValue:(int)standY[6]];
        [stdHz7 setIntValue:(int)standHz[6]];
        [stdList7 selectItemWithTag:standAR[6]];
        [stdSet7 setEnabled:YES];
    } else {
        [stdEnabled7 setState:0];
        [stdX7 setEnabled:NO];
        [stdY7 setEnabled:NO];
        [stdHz7 setEnabled:NO];
        [stdList7 setEnabled:NO];
        [stdSet7 setEnabled:NO];
    }

    if (standEnabled[7])
    {
        [stdEnabled8 setState:1];
        [stdX8 setEnabled:YES];
        [stdY8 setEnabled:YES];
        [stdHz8 setEnabled:YES];
        [stdList8 setEnabled:YES];
        [stdSet8 setEnabled:YES];
        [stdX8 setIntValue:(int)standX[7]];
        [stdY8 setIntValue:(int)standY[7]];
        [stdHz8 setIntValue:(int)standHz[7]];
        [stdList8 selectItemWithTag:standAR[7]];
        [stdSet8 setEnabled:YES];
    } else {
        [stdEnabled8 setState:0];
        [stdX8 setEnabled:NO];
        [stdY8 setEnabled:NO];
        [stdHz8 setEnabled:NO];
        [stdList8 setEnabled:NO];
        [stdSet8 setEnabled:NO];
    }
}

-(void)sStandardRes:(id)sender
{
    NSString *stdval[2];
    unsigned char stdvalB[2];
    int fieldnr = (int)[sender tag];
    int AR = 0;
    int HZ = 0;
    int X = 0;

    switch (fieldnr)
    {
        case 0:
            HZ = [stdHz1 intValue];
            X = [stdX1 intValue];
            
            if ((X < 256) || (X > 2288))
            {
                runAlertPanel(@"Horizontal resolution bad!", @"Horizontal resolution must be between 256 and 2288!", @"OK", nil, nil);
                
                return;
            }
            
            if ((HZ < 60) || (HZ > 123))
            {
                runAlertPanel(@"Refresh rate bad!", @"Refresh rate must be between 60 and 123 Hz!", @"OK", nil, nil);
                
                return;
            }
            
            AR = (int)[stdList1 selectedTag];
            
            stdvalB[0] = (unsigned char)((X / 8) - 31);
            stdvalB[1] = (unsigned char)((HZ - 60) & 0x3F);
            stdvalB[1] |= (unsigned char)((AR & 3) << 6);
            
            stdval[0] = [NSString stringWithFormat:@"%.2X", stdvalB[0]];
            stdval[1] = [NSString stringWithFormat:@"%.2X", stdvalB[1]];
            
            [self writeDataTable:stdval offset:38 length:2];
            
            break;

        case 1:
            HZ = [stdHz2 intValue];
            X = [stdX2 intValue];
            
            if ((X < 256) || (X > 2288))
            {
                runAlertPanel(@"Horizontal resolution bad!", @"Horizontal resolution must be between 256 and 2288!", @"OK", nil, nil);
                
                return;
            }
            
            if ((HZ < 60) || (HZ > 123))
            {
                runAlertPanel(@"Refresh rate bad!", @"Refresh rate must be between 60 and 123 Hz!", @"OK", nil, nil);
                
                return;
            }
            
            AR = (int)[stdList2 selectedTag];
            
            stdvalB[0] = (unsigned char)((X / 8) - 31);
            stdvalB[1] = (unsigned char)((HZ - 60) & 0x3F);
            stdvalB[1] |= (unsigned char)((AR & 3) << 6);
            
            stdval[0] = [NSString stringWithFormat:@"%.2X", stdvalB[0]];
            stdval[1] = [NSString stringWithFormat:@"%.2X", stdvalB[1]];
            
            [self writeDataTable:stdval offset:40 length:2];
            
            break;

        case 2:
            HZ = [stdHz3 intValue];
            X = [stdX3 intValue];
            
            if ((X < 256) || (X > 2288))
            {
                runAlertPanel(@"Horizontal resolution bad!", @"Horizontal resolution must be between 256 and 2288!", @"OK", nil, nil);
                
                return;
            }
            
            if ((HZ < 60) || (HZ > 123))
            {
                runAlertPanel(@"Refresh rate bad!", @"Refresh rate must be between 60 and 123 Hz!", @"OK", nil, nil);
                
                return;
            }
            
            AR = (int)[stdList3 selectedTag];
            
            stdvalB[0] = (unsigned char)((X / 8) - 31);
            stdvalB[1] = (unsigned char)((HZ - 60) & 0x3F);
            stdvalB[1] |= (unsigned char)((AR & 3) << 6);
            
            stdval[0] = [NSString stringWithFormat:@"%.2X", stdvalB[0]];
            stdval[1] = [NSString stringWithFormat:@"%.2X", stdvalB[1]];
            
            [self writeDataTable:stdval offset:42 length:2];
            
            break;

        case 3:
            HZ = [stdHz4 intValue];
            X = [stdX4 intValue];
            
            if ((X < 256) || (X > 2288))
            {
                runAlertPanel(@"Horizontal resolution bad!", @"Horizontal resolution must be between 256 and 2288!", @"OK", nil, nil);
                
                return;
            }
            
            if ((HZ < 60) || (HZ > 123))
            {
                runAlertPanel(@"Refresh rate bad!", @"Refresh rate must be between 60 and 123 Hz!", @"OK", nil, nil);
                
                return;
            }
            
            AR = (int)[stdList4 selectedTag];
            
            stdvalB[0] = (unsigned char)((X / 8) - 31);
            stdvalB[1] = (unsigned char)((HZ - 60) & 0x3F);
            stdvalB[1] |= (unsigned char)((AR & 3) << 6);
            
            stdval[0] = [NSString stringWithFormat:@"%.2X", stdvalB[0]];
            stdval[1] = [NSString stringWithFormat:@"%.2X", stdvalB[1]];
            
            [self writeDataTable:stdval offset:44 length:2];
            
            break;

        case 4:
            HZ = [stdHz5 intValue];
            X = [stdX5 intValue];
            
            if ((X < 256) || (X > 2288))
            {
                runAlertPanel(@"Horizontal resolution bad!", @"Horizontal resolution must be between 256 and 2288!", @"OK", nil, nil);
                
                return;
            }
            
            if ((HZ < 60) || (HZ > 123))
            {
                runAlertPanel(@"Refresh rate bad!", @"Refresh rate must be between 60 and 123 Hz!", @"OK", nil, nil);
                
                return;
            }
            
            AR = (int)[stdList5 selectedTag];
            
            stdvalB[0] = (unsigned char)((X / 8) - 31);
            stdvalB[1] = (unsigned char)((HZ - 60) & 0x3F);
            stdvalB[1] |= (unsigned char)((AR & 3) << 6);
            
            stdval[0] = [NSString stringWithFormat:@"%.2X", stdvalB[0]];
            stdval[1] = [NSString stringWithFormat:@"%.2X", stdvalB[1]];
            
            [self writeDataTable:stdval offset:46 length:2];
            
            break;

        case 5:
            HZ = [stdHz6 intValue];
            X = [stdX6 intValue];
            
            if ((X < 256) || (X > 2288))
            {
                runAlertPanel(@"Horizontal resolution bad!", @"Horizontal resolution must be between 256 and 2288!", @"OK", nil, nil);
                
                return;
            }
            
            if ((HZ < 60) || (HZ > 123))
            {
                runAlertPanel(@"Refresh rate bad!", @"Refresh rate must be between 60 and 123 Hz!", @"OK", nil, nil);
                
                return;
            }
            
            AR = (int)[stdList6 selectedTag];
            
            stdvalB[0] = (unsigned char)((X / 8) - 31);
            stdvalB[1] = (unsigned char)((HZ - 60) & 0x3F);
            stdvalB[1] |= (unsigned char)((AR & 3) << 6);
            
            stdval[0] = [NSString stringWithFormat:@"%.2X", stdvalB[0]];
            stdval[1] = [NSString stringWithFormat:@"%.2X", stdvalB[1]];
            
            [self writeDataTable:stdval offset:48 length:2];
            
            break;

        case 6:
            HZ = [stdHz7 intValue];
            X = [stdX7 intValue];
            
            if ((X < 256) || (X > 2288))
            {
                runAlertPanel(@"Horizontal resolution bad!", @"Horizontal resolution must be between 256 and 2288!", @"OK", nil, nil);
                
                return;
            }
            
            if ((HZ < 60) || (HZ > 123))
            {
                runAlertPanel(@"Refresh rate bad!", @"Refresh rate must be between 60 and 123 Hz!", @"OK", nil, nil);
                
                return;
            }
            
            AR = (int)[stdList7 selectedTag];
            
            stdvalB[0] = (unsigned char)((X / 8) - 31);
            stdvalB[1] = (unsigned char)((HZ - 60) & 0x3F);
            stdvalB[1] |= (unsigned char)((AR & 3) << 6);
            
            stdval[0] = [NSString stringWithFormat:@"%.2X", stdvalB[0]];
            stdval[1] = [NSString stringWithFormat:@"%.2X", stdvalB[1]];
            
            [self writeDataTable:stdval offset:50 length:2];
            
            break;

        case 7:
            HZ = [stdHz8 intValue];
            X = [stdX8 intValue];
            
            if ((X < 256) || (X > 2288))
            {
                runAlertPanel(@"Horizontal resolution bad!", @"Horizontal resolution must be between 256 and 2288!", @"OK", nil, nil);
                
                return;
            }
            
            if ((HZ < 60) || (HZ > 123))
            {
                runAlertPanel(@"Refresh rate bad!", @"Refresh rate must be between 60 and 123 Hz!", @"OK", nil, nil);
                
                return;
            }
            
            AR = (int)[stdList8 selectedTag];
            
            stdvalB[0] = (unsigned char)((X / 8) - 31);
            stdvalB[1] = (unsigned char)((HZ - 60) & 0x3F);
            stdvalB[1] |= (unsigned char)((AR & 3) << 6);
            
            stdval[0] = [NSString stringWithFormat:@"%.2X", stdvalB[0]];
            stdval[1] = [NSString stringWithFormat:@"%.2X", stdvalB[1]];
            
            [self writeDataTable:stdval offset:52 length:2];
            
            break;
    }

    [self getStandardRes];
}

-(void)sStandardEnab:(id)sender
{
    int enabled = (int)[(NSButton *)sender state];
    int fieldnr = (int)[sender tag];
    BOOL isEnabled = NO;
    NSString *stddis[2];
    NSString *stden[2];

    stddis[0] = @"01";
    stddis[1] = @"01";

    stden[0] = @"01";
    stden[1] = @"00";

    if (enabled)
    {
        isEnabled = YES;
    }

    switch (fieldnr)
    {
        case 0:
            [stdX1 setEnabled:isEnabled];
            [stdY1 setEnabled:isEnabled];
            [stdHz1 setEnabled:isEnabled];
            [stdList1 setEnabled:isEnabled];
            [stdSet1 setEnabled:isEnabled];

            if (isEnabled == YES)
            {
                [self writeDataTable:stden offset:38 length:2];
            } else {
                [self writeDataTable:stddis offset:38 length:2];
            }

            break;

        case 1:
            [stdX2 setEnabled:isEnabled];
            [stdY2 setEnabled:isEnabled];
            [stdHz2 setEnabled:isEnabled];
            [stdList2 setEnabled:isEnabled];
            [stdSet2 setEnabled:isEnabled];
            
            if (isEnabled == YES)
            {
                [self writeDataTable:stden offset:40 length:2];
            } else {
                [self writeDataTable:stddis offset:40 length:2];
            }
            
            break;

        case 2:
            [stdX3 setEnabled:isEnabled];
            [stdY3 setEnabled:isEnabled];
            [stdHz3 setEnabled:isEnabled];
            [stdList3 setEnabled:isEnabled];
            [stdSet3 setEnabled:isEnabled];
            
            if (isEnabled == YES)
            {
                [self writeDataTable:stden offset:42 length:2];
            } else {
                [self writeDataTable:stddis offset:42 length:2];
            }
            
            break;

        case 3:
            [stdX4 setEnabled:isEnabled];
            [stdY4 setEnabled:isEnabled];
            [stdHz4 setEnabled:isEnabled];
            [stdList4 setEnabled:isEnabled];
            [stdSet4 setEnabled:isEnabled];
            
            if (isEnabled == YES)
            {
                [self writeDataTable:stden offset:44 length:2];
            } else {
                [self writeDataTable:stddis offset:44 length:2];
            }
            
            break;

        case 4:
            [stdX5 setEnabled:isEnabled];
            [stdY5 setEnabled:isEnabled];
            [stdHz5 setEnabled:isEnabled];
            [stdList5 setEnabled:isEnabled];
            [stdSet5 setEnabled:isEnabled];
            
            if (isEnabled == YES)
            {
                [self writeDataTable:stden offset:46 length:2];
            } else {
                [self writeDataTable:stddis offset:46 length:2];
            }
            
            break;

        case 5:
            [stdX6 setEnabled:isEnabled];
            [stdY6 setEnabled:isEnabled];
            [stdHz6 setEnabled:isEnabled];
            [stdList6 setEnabled:isEnabled];
            [stdSet6 setEnabled:isEnabled];
            
            if (isEnabled == YES)
            {
                [self writeDataTable:stden offset:48 length:2];
            } else {
                [self writeDataTable:stddis offset:48 length:2];
            }
            
            break;

        case 6:
            [stdX7 setEnabled:isEnabled];
            [stdY7 setEnabled:isEnabled];
            [stdHz7 setEnabled:isEnabled];
            [stdList7 setEnabled:isEnabled];
            [stdSet7 setEnabled:isEnabled];
            
            if (isEnabled == YES)
            {
                [self writeDataTable:stden offset:50 length:2];
            } else {
                [self writeDataTable:stddis offset:50 length:2];
            }
            
            break;

        case 7:
            [stdX7 setEnabled:isEnabled];
            [stdY7 setEnabled:isEnabled];
            [stdHz7 setEnabled:isEnabled];
            [stdList7 setEnabled:isEnabled];
            [stdSet7 setEnabled:isEnabled];
            
            if (isEnabled == YES)
            {
                [self writeDataTable:stden offset:52 length:2];
            } else {
                [self writeDataTable:stddis offset:52 length:2];
            }
            
            break;
    }

    [self getStandardRes];
}

-(void)getCVT3B
{
    NSString *CVTData[12] = { nil };
    unsigned char CVTDataB[12] = { 0 };
    int AR[4] = { 0, 0, 0, 0 };
    int Width[4] = { 0, 0, 0, 0 };
    int Height[4] = { 0, 0, 0, 0 };
    int PrefHz[4] = { 0, 0, 0, 0 };

    [self readDataTable:CVTData offset:(StartOffset + 6) length:12];

    CVTDataB[0] = [self hex2uchar:[CVTData[0] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[1] = [self hex2uchar:[CVTData[1] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[2] = [self hex2uchar:[CVTData[2] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[3] = [self hex2uchar:[CVTData[3] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[4] = [self hex2uchar:[CVTData[4] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[5] = [self hex2uchar:[CVTData[5] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[6] = [self hex2uchar:[CVTData[6] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[7] = [self hex2uchar:[CVTData[7] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[8] = [self hex2uchar:[CVTData[8] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[9] = [self hex2uchar:[CVTData[9] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[10] = [self hex2uchar:[CVTData[10] cStringUsingEncoding:NSUTF8StringEncoding]];
    CVTDataB[11] = [self hex2uchar:[CVTData[11] cStringUsingEncoding:NSUTF8StringEncoding]];

    Height[0] = CVTDataB[0];
    Height[0] |= ((CVTDataB[1] & 0xF0) << 4);
    if (Height[0] > 0)
    {
        Height[0]++;
        Height[0] *= 2;
    }
    [CVTH_1 setIntValue:Height[0]];
    AR[0] = ((CVTDataB[1] & 0xC) >> 2);
    [CVTAR_1 selectItemWithTag:AR[0]];
    switch (AR[0])
    {
        case 0:
            Width[0] = ((Height[0] * 4) / 3);
            break;

        case 1:
            Width[0] = ((Height[0] * 16) / 9);
            break;

        case 2:
            Width[0] = ((Height[0] * 16) / 10);
            break;

        case 3:
            Width[0] = ((Height[0] * 15) / 9);
            break;
    }
    [CVTW_1 setIntValue:Width[0]];
    PrefHz[0] = ((CVTDataB[2] & 0x60) >> 5);
    [CVTPrefHz_1 selectItemWithTag:PrefHz[0]];
    if (CVTDataB[2] & 0x10)
    {
        [CVT50Hz_1 setState:1];
    } else {
        [CVT50Hz_1 setState:0];
    }
    if (CVTDataB[2] & 0x8)
    {
        [CVT60Hz_1 setState:1];
    } else {
        [CVT60Hz_1 setState:0];
    }
    if (CVTDataB[2] & 0x4)
    {
        [CVT75Hz_1 setState:1];
    } else {
        [CVT75Hz_1 setState:0];
    }
    if (CVTDataB[2] & 0x2)
    {
        [CVT85Hz_1 setState:1];
    } else {
        [CVT85Hz_1 setState:0];
    }
    if (CVTDataB[2] & 0x1)
    {
        [CVT60HzRB_1 setState:1];
    } else {
        [CVT60HzRB_1 setState:0];
    }

    Height[1] = CVTDataB[3];
    Height[1] |= ((CVTDataB[4] & 0xF0) << 4);
    if (Height[1] > 0)
    {
        Height[1]++;
        Height[1] *= 2;
    }
    [CVTH_2 setIntValue:Height[1]];
    AR[1] = ((CVTDataB[4] & 0xC) >> 2);
    [CVTAR_2 selectItemWithTag:AR[1]];
    switch (AR[1])
    {
        case 0:
            Width[1] = ((Height[1] * 4) / 3);
            break;
            
        case 1:
            Width[1] = ((Height[1] * 16) / 9);
            break;
            
        case 2:
            Width[1] = ((Height[1] * 16) / 10);
            break;
            
        case 3:
            Width[1] = ((Height[1] * 15) / 9);
            break;
    }
    [CVTW_2 setIntValue:Width[1]];
    PrefHz[1] = ((CVTDataB[5] & 0x60) >> 5);
    [CVTPrefHz_2 selectItemWithTag:PrefHz[1]];
    if (CVTDataB[5] & 0x10)
    {
        [CVT50Hz_2 setState:1];
    } else {
        [CVT50Hz_2 setState:0];
    }
    if (CVTDataB[5] & 0x8)
    {
        [CVT60Hz_2 setState:1];
    } else {
        [CVT60Hz_2 setState:0];
    }
    if (CVTDataB[5] & 0x4)
    {
        [CVT75Hz_2 setState:1];
    } else {
        [CVT75Hz_2 setState:0];
    }
    if (CVTDataB[5] & 0x2)
    {
        [CVT85Hz_2 setState:1];
    } else {
        [CVT85Hz_2 setState:0];
    }
    if (CVTDataB[5] & 0x1)
    {
        [CVT60HzRB_2 setState:1];
    } else {
        [CVT60HzRB_2 setState:0];
    }

    Height[2] = CVTDataB[6];
    Height[2] |= ((CVTDataB[7] & 0xF0) << 4);
    if (Height[2] > 0)
    {
        Height[2]++;
        Height[2] *= 2;
    }
    [CVTH_3 setIntValue:Height[2]];
    AR[2] = ((CVTDataB[7] & 0xC) >> 2);
    [CVTAR_3 selectItemWithTag:AR[2]];
    switch (AR[2])
    {
        case 0:
            Width[2] = ((Height[2] * 4) / 3);
            break;
            
        case 1:
            Width[2] = ((Height[2] * 16) / 9);
            break;
            
        case 2:
            Width[2] = ((Height[2] * 16) / 10);
            break;
            
        case 3:
            Width[2] = ((Height[2] * 15) / 9);
            break;
    }
    [CVTW_3 setIntValue:Width[2]];
    PrefHz[2] = ((CVTDataB[8] & 0x60) >> 5);
    [CVTPrefHz_3 selectItemWithTag:PrefHz[2]];
    if (CVTDataB[8] & 0x10)
    {
        [CVT50Hz_3 setState:1];
    } else {
        [CVT50Hz_3 setState:0];
    }
    if (CVTDataB[8] & 0x8)
    {
        [CVT60Hz_3 setState:1];
    } else {
        [CVT60Hz_3 setState:0];
    }
    if (CVTDataB[8] & 0x4)
    {
        [CVT75Hz_3 setState:1];
    } else {
        [CVT75Hz_3 setState:0];
    }
    if (CVTDataB[8] & 0x2)
    {
        [CVT85Hz_3 setState:1];
    } else {
        [CVT85Hz_3 setState:0];
    }
    if (CVTDataB[8] & 0x1)
    {
        [CVT60HzRB_3 setState:1];
    } else {
        [CVT60HzRB_3 setState:0];
    }

    Height[3] = CVTDataB[9];
    Height[3] |= ((CVTDataB[10] & 0xF0) << 4);
    if (Height[3] > 0)
    {
        Height[3]++;
        Height[3] *= 2;
    }
    [CVTH_4 setIntValue:Height[3]];
    AR[3] = ((CVTDataB[10] & 0xC) >> 2);
    [CVTAR_4 selectItemWithTag:AR[3]];
    switch (AR[3])
    {
        case 0:
            Width[3] = ((Height[3] * 4) / 3);
            break;
            
        case 1:
            Width[3] = ((Height[3] * 16) / 9);
            break;
            
        case 2:
            Width[3] = ((Height[3] * 16) / 10);
            break;
            
        case 3:
            Width[3] = ((Height[3] * 15) / 9);
            break;
    }
    [CVTW_4 setIntValue:Width[3]];
    PrefHz[3] = ((CVTDataB[11] & 0x60) >> 5);
    [CVTPrefHz_4 selectItemWithTag:PrefHz[3]];
    if (CVTDataB[11] & 0x10)
    {
        [CVT50Hz_4 setState:1];
    } else {
        [CVT50Hz_4 setState:0];
    }
    if (CVTDataB[11] & 0x8)
    {
        [CVT60Hz_4 setState:1];
    } else {
        [CVT60Hz_4 setState:0];
    }
    if (CVTDataB[11] & 0x4)
    {
        [CVT75Hz_4 setState:1];
    } else {
        [CVT75Hz_4 setState:0];
    }
    if (CVTDataB[11] & 0x2)
    {
        [CVT85Hz_4 setState:1];
    } else {
        [CVT85Hz_4 setState:0];
    }
    if (CVTDataB[11] & 0x1)
    {
        [CVT60HzRB_4 setState:1];
    } else {
        [CVT60HzRB_4 setState:0];
    }
}

-(void)sCVT3B:(id)sender
{
    NSString *CVTData[3] = { nil, nil, nil };
    unsigned char CVTDataB[3] = { 0, 0, 0 };
    int blocknr = (int)[sender tag];
    int height = 0;
    int AR = 0;
    int PrefHz = 0;
    int Hz50 = 0;
    int Hz60 = 0;
    int Hz75 = 0;
    int Hz85 = 0;
    int Hz60RB = 0;

    switch (blocknr)
    {
        case 0:
            height = [CVTH_1 intValue];
            if ((height > 8192) || (height < 2))
            {
                runAlertPanel(@"Vertical resolution is bad!", @"Resolution must be between 2 and 8192", @"OK", nil, nil);

                return;
            }
            height /= 2;
            height--;
            CVTDataB[0] = (unsigned char)height & 0xFF;
            CVTDataB[1] = (unsigned char)((height & 0xF00) >> 4);
            AR = (int)[CVTAR_1 selectedTag];
            CVTDataB[1] |= (unsigned char)(AR << 2);
            PrefHz = (int)[CVTPrefHz_1 selectedTag];
            CVTDataB[2] = (unsigned char)(PrefHz << 5);
            Hz50 = (int)[CVT50Hz_1 state];
            Hz60 = (int)[CVT60Hz_1 state];
            Hz75 = (int)[CVT75Hz_1 state];
            Hz85 = (int)[CVT85Hz_1 state];
            Hz60RB = (int)[CVT60HzRB_1 state];
            if (Hz50)
            {
                CVTDataB[2] |= 0x10;
            }
            if (Hz60)
            {
                CVTDataB[2] |= 0x8;
            }
            if (Hz75)
            {
                CVTDataB[2] |= 0x4;
            }
            if (Hz85)
            {
                CVTDataB[2] |= 0x2;
            }
            if (Hz60RB)
            {
                CVTDataB[2] |= 0x1;
            }
            break;

        case 1:
            height = [CVTH_2 intValue];
            if ((height > 8192) || (height < 2))
            {
                runAlertPanel(@"Vertical resolution is bad!", @"Resolution must be between 2 and 8192", @"OK", nil, nil);
                
                return;
            }
            height /= 2;
            height--;
            CVTDataB[0] = (unsigned char)height & 0xFF;
            CVTDataB[1] = (unsigned char)((height & 0xF00) >> 4);
            AR = (int)[CVTAR_2 selectedTag];
            CVTDataB[1] |= (unsigned char)(AR << 2);
            PrefHz = (int)[CVTPrefHz_2 selectedTag];
            CVTDataB[2] = (unsigned char)(PrefHz << 5);
            Hz50 = (int)[CVT50Hz_2 state];
            Hz60 = (int)[CVT60Hz_2 state];
            Hz75 = (int)[CVT75Hz_2 state];
            Hz85 = (int)[CVT85Hz_2 state];
            Hz60RB = (int)[CVT60HzRB_2 state];
            if (Hz50)
            {
                CVTDataB[2] |= 0x10;
            }
            if (Hz60)
            {
                CVTDataB[2] |= 0x8;
            }
            if (Hz75)
            {
                CVTDataB[2] |= 0x4;
            }
            if (Hz85)
            {
                CVTDataB[2] |= 0x2;
            }
            if (Hz60RB)
            {
                CVTDataB[2] |= 0x1;
            }
            break;

        case 2:
            height = [CVTH_3 intValue];
            if ((height > 8192) || (height < 2))
            {
                runAlertPanel(@"Vertical resolution is bad!", @"Resolution must be between 2 and 8192", @"OK", nil, nil);
                
                return;
            }
            height /= 2;
            height--;
            CVTDataB[0] = (unsigned char)height & 0xFF;
            CVTDataB[1] = (unsigned char)((height & 0xF00) >> 4);
            AR = (int)[CVTAR_3 selectedTag];
            CVTDataB[1] |= (unsigned char)(AR << 2);
            PrefHz = (int)[CVTPrefHz_3 selectedTag];
            CVTDataB[2] = (unsigned char)(PrefHz << 5);
            Hz50 = (int)[CVT50Hz_3 state];
            Hz60 = (int)[CVT60Hz_3 state];
            Hz75 = (int)[CVT75Hz_3 state];
            Hz85 = (int)[CVT85Hz_3 state];
            Hz60RB = (int)[CVT60HzRB_3 state];
            if (Hz50)
            {
                CVTDataB[2] |= 0x10;
            }
            if (Hz60)
            {
                CVTDataB[2] |= 0x8;
            }
            if (Hz75)
            {
                CVTDataB[2] |= 0x4;
            }
            if (Hz85)
            {
                CVTDataB[2] |= 0x2;
            }
            if (Hz60RB)
            {
                CVTDataB[2] |= 0x1;
            }
            break;

        case 3:
            height = [CVTH_4 intValue];
            if ((height > 8192) || (height < 2))
            {
                runAlertPanel(@"Vertical resolution is bad!", @"Resolution must be between 2 and 8192", @"OK", nil, nil);
                
                return;
            }
            height /= 2;
            height--;
            CVTDataB[0] = (unsigned char)height & 0xFF;
            CVTDataB[1] = (unsigned char)((height & 0xF00) >> 4);
            AR = (int)[CVTAR_4 selectedTag];
            CVTDataB[1] |= (unsigned char)(AR << 2);
            PrefHz = (int)[CVTPrefHz_4 selectedTag];
            CVTDataB[2] = (unsigned char)(PrefHz << 5);
            Hz50 = (int)[CVT50Hz_4 state];
            Hz60 = (int)[CVT60Hz_4 state];
            Hz75 = (int)[CVT75Hz_4 state];
            Hz85 = (int)[CVT85Hz_4 state];
            Hz60RB = (int)[CVT60HzRB_4 state];
            if (Hz50)
            {
                CVTDataB[2] |= 0x10;
            }
            if (Hz60)
            {
                CVTDataB[2] |= 0x8;
            }
            if (Hz75)
            {
                CVTDataB[2] |= 0x4;
            }
            if (Hz85)
            {
                CVTDataB[2] |= 0x2;
            }
            if (Hz60RB)
            {
                CVTDataB[2] |= 0x1;
            }
            break;
    }

    CVTData[0] = [NSString stringWithFormat:@"%.2X", CVTDataB[0]];
    CVTData[1] = [NSString stringWithFormat:@"%.2X", CVTDataB[1]];
    CVTData[2] = [NSString stringWithFormat:@"%.2X", CVTDataB[2]];

    [self writeDataTable:CVTData offset:(StartOffset + 6 + (blocknr * 3)) length:3];

    [self getCVT3B];
}

-(void)getDetailedType
{
    NSString *detailCode[4];
    unsigned char detailCodeB[4];

    [self readDataTable:detailCode offset:StartOffset length:4];

    detailCodeB[0] = [self hex2uchar:[detailCode[0] cStringUsingEncoding:NSUTF8StringEncoding]];
    detailCodeB[1] = [self hex2uchar:[detailCode[1] cStringUsingEncoding:NSUTF8StringEncoding]];
    detailCodeB[2] = [self hex2uchar:[detailCode[2] cStringUsingEncoding:NSUTF8StringEncoding]];
    detailCodeB[3] = [self hex2uchar:[detailCode[3] cStringUsingEncoding:NSUTF8StringEncoding]];

    if ((detailCodeB[0] != 0x00) || (detailCodeB[1] != 0x00) || (detailCodeB[2] != 0x00))
    {
        CurrentDetailed = 10;

        [detailedType selectItemWithTag:10];

        return;
    }

    if (detailCodeB[3] <= 0xF)
    {
        CurrentDetailed = 11;

        [detailedType selectItemWithTag:11];

        return;
    }

    switch (detailCodeB[3])
    {
        case 0x10:
            CurrentDetailed = 0;

            [detailedType selectItemWithTag:0];
            [detailedEntryView setDocumentView:[dummySubView retain]];

            break;

        case 0xF7:
            CurrentDetailed = 1;

            [self getEsta3Res];
            [detailedType selectItemWithTag:1];
            [detailedEntryView setDocumentView:[established3View retain]];

            break;

        case 0xF8:
            CurrentDetailed = 2;

            [self getCVT3B];
            [detailedType selectItemWithTag:2];
            [detailedEntryView setDocumentView:[CVT3BView retain]];
            
            break;

        case 0xF9:
            CurrentDetailed = 3;

            [detailedType selectItemWithTag:3];

            break;

        case 0xFA:
            CurrentDetailed = 4;

            [detailedType selectItemWithTag:4];
            
            break;

        case 0xFB:
            CurrentDetailed = 5;

            [detailedType selectItemWithTag:5];
            
            break;

        case 0xFC:
            CurrentDetailed = 6;

            [detailedType selectItemWithTag:6];
            
            break;

        case 0xFD:
            CurrentDetailed = 7;

            [detailedType selectItemWithTag:7];
            
            break;

        case 0xFE:
            CurrentDetailed = 8;

            [detailedType selectItemWithTag:8];
            
            break;

        case 0xFF:
            CurrentDetailed = 9;

            [detailedType selectItemWithTag:9];
            
            break;
    }
}

-(void)sDetailed:(id)sender
{
    int detailedSelect = (int)[sender selectedTag];
    NSString *detailData[18] = { NULL };

    if (CurrentDetailed == detailedSelect)
    {
        return;
    }

    switch (detailedSelect)
    {
        case 0:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"10";
            detailData[4] = @"00";
            detailData[5] = @"00";
            detailData[6] = @"00";
            detailData[7] = @"00";
            detailData[8] = @"00";
            detailData[9] = @"00";
            detailData[10] = @"00";
            detailData[11] = @"00";
            detailData[12] = @"00";
            detailData[13] = @"00";
            detailData[14] = @"00";
            detailData[15] = @"00";
            detailData[16] = @"00";
            detailData[17] = @"00";
            break;

        case 1:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"F7";
            detailData[4] = @"00";
            detailData[5] = @"0A";
            detailData[6] = @"00";
            detailData[7] = @"00";
            detailData[8] = @"00";
            detailData[9] = @"00";
            detailData[10] = @"00";
            detailData[11] = @"00";
            detailData[12] = @"00";
            detailData[13] = @"00";
            detailData[14] = @"00";
            detailData[15] = @"00";
            detailData[16] = @"00";
            detailData[17] = @"00";
            break;

        case 2:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"F8";
            detailData[4] = @"00";
            detailData[5] = @"01";
            detailData[6] = @"00";
            detailData[7] = @"00";
            detailData[8] = @"00";
            detailData[9] = @"00";
            detailData[10] = @"00";
            detailData[11] = @"00";
            detailData[12] = @"00";
            detailData[13] = @"00";
            detailData[14] = @"00";
            detailData[15] = @"00";
            detailData[16] = @"00";
            detailData[17] = @"00";
            break;

        case 3:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"F9";
            detailData[4] = @"00";
            detailData[5] = @"03";
            detailData[6] = @"00";
            detailData[7] = @"00";
            detailData[8] = @"00";
            detailData[9] = @"00";
            detailData[10] = @"00";
            detailData[11] = @"00";
            detailData[12] = @"00";
            detailData[13] = @"00";
            detailData[14] = @"00";
            detailData[15] = @"00";
            detailData[16] = @"00";
            detailData[17] = @"00";
            break;

        case 4:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"FA";
            detailData[4] = @"00";
            detailData[5] = @"01";
            detailData[6] = @"01";
            detailData[7] = @"01";
            detailData[8] = @"01";
            detailData[9] = @"01";
            detailData[10] = @"01";
            detailData[11] = @"01";
            detailData[12] = @"01";
            detailData[13] = @"01";
            detailData[14] = @"01";
            detailData[15] = @"01";
            detailData[16] = @"01";
            detailData[17] = @"0A";
            break;

        case 5:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"FB";
            detailData[4] = @"00";
            detailData[5] = @"01";
            detailData[6] = @"00";
            detailData[7] = @"00";
            detailData[8] = @"00";
            detailData[9] = @"FF";
            detailData[10] = @"02";
            detailData[11] = @"00";
            detailData[12] = @"00";
            detailData[13] = @"00";
            detailData[14] = @"FF";
            detailData[15] = @"0A";
            detailData[16] = @"20";
            detailData[17] = @"20";
            break;

        case 6:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"FC";
            detailData[4] = @"00";
            detailData[5] = @"0A";
            detailData[6] = @"20";
            detailData[7] = @"20";
            detailData[8] = @"20";
            detailData[9] = @"20";
            detailData[10] = @"20";
            detailData[11] = @"20";
            detailData[12] = @"20";
            detailData[13] = @"20";
            detailData[14] = @"20";
            detailData[15] = @"20";
            detailData[16] = @"20";
            detailData[17] = @"20";
            break;

        case 7:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"FD";
            detailData[4] = @"00";
            detailData[5] = @"00";
            detailData[6] = @"00";
            detailData[7] = @"00";
            detailData[8] = @"00";
            detailData[9] = @"00";
            detailData[10] = @"00";
            detailData[11] = @"00";
            detailData[12] = @"00";
            detailData[13] = @"00";
            detailData[14] = @"00";
            detailData[15] = @"00";
            detailData[16] = @"00";
            detailData[17] = @"00";
            break;

        case 8:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"FE";
            detailData[4] = @"00";
            detailData[5] = @"0A";
            detailData[6] = @"20";
            detailData[7] = @"20";
            detailData[8] = @"20";
            detailData[9] = @"20";
            detailData[10] = @"20";
            detailData[11] = @"20";
            detailData[12] = @"20";
            detailData[13] = @"20";
            detailData[14] = @"20";
            detailData[15] = @"20";
            detailData[16] = @"20";
            detailData[17] = @"20";
            break;

        case 9:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"FF";
            detailData[4] = @"00";
            detailData[5] = @"0A";
            detailData[6] = @"20";
            detailData[7] = @"20";
            detailData[8] = @"20";
            detailData[9] = @"20";
            detailData[10] = @"20";
            detailData[11] = @"20";
            detailData[12] = @"20";
            detailData[13] = @"20";
            detailData[14] = @"20";
            detailData[15] = @"20";
            detailData[16] = @"20";
            detailData[17] = @"20";
            break;

        case 10:
            detailData[0] = @"30";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"00";
            detailData[4] = @"00";
            detailData[5] = @"00";
            detailData[6] = @"00";
            detailData[7] = @"00";
            detailData[8] = @"00";
            detailData[9] = @"00";
            detailData[10] = @"00";
            detailData[11] = @"00";
            detailData[12] = @"00";
            detailData[13] = @"00";
            detailData[14] = @"00";
            detailData[15] = @"00";
            detailData[16] = @"00";
            detailData[17] = @"00";
            break;

        case 11:
            detailData[0] = @"00";
            detailData[1] = @"00";
            detailData[2] = @"00";
            detailData[3] = @"00";
            detailData[4] = @"00";
            detailData[5] = @"00";
            detailData[6] = @"00";
            detailData[7] = @"00";
            detailData[8] = @"00";
            detailData[9] = @"00";
            detailData[10] = @"00";
            detailData[11] = @"00";
            detailData[12] = @"00";
            detailData[13] = @"00";
            detailData[14] = @"00";
            detailData[15] = @"00";
            detailData[16] = @"00";
            detailData[17] = @"00";
            break;
    }

    [self writeDataTable:detailData offset:StartOffset length:18];

    [self getDetailedType];
}

-(void)setEDIDDetailView:(id)sender
{
    int row = (int)[dataTable clickedRow];
    int column = (int)[dataTable clickedColumn];
    int offset = (row * 10) + column;

    if ((row == -1) || (column == -1))
    {
        return;
    }

    if ((offset >= 0) && (offset <= 7))
    {
        [self getHeader];

        [editView setDocumentView:[headerView retain]];

        return;
    }

    if ((offset >= 8) && (offset <= 17))
    {
        [self getSerial];
        
        [editView setDocumentView:[serialView retain]];

        return;
    }

    if ((offset == 18) || (offset == 19))
    {
        [VersionMajor setStringValue:[NSString stringWithFormat:@"%d", EDataStruct->Version[0]]];
        [VersionMinor setStringValue:[NSString stringWithFormat:@"%d", EDataStruct->Version[1]]];

        [editView setDocumentView:[editVersionView retain]];

        return;
    }

    if ((offset >= 20) && (offset <= 24))
    {
        [self getBasicParams];

        [editView setDocumentView:[basicParamsView retain]];

        return;
    }

    if ((offset >= 25) && (offset <= 34))
    {
        [self getChroma];

        [editView setDocumentView:[chromaView retain]];

        return;
    }

    if ((offset >= 35) && (offset <= 37))
    {
        [self getEstaRes];

        [editView setDocumentView:[estaResView retain]];

        return;
    }

    if ((offset >= 38) && (offset <= 53))
    {
        [self getStandardRes];

        [editView setDocumentView:[standardResView retain]];

        return;
    }

    if ((offset >= 54) && (offset <= 71))
    {
        StartOffset = 54;

        [self getDetailedType];

        [editView setDocumentView:[detailedView retain]];

        return;
    }

    if ((offset >= 72) && (offset <= 89))
    {
        StartOffset = 72;

        [self getDetailedType];

        [editView setDocumentView:[detailedView retain]];
        
        return;
    }

    if ((offset >= 90) && (offset <= 107))
    {
        StartOffset = 90;

        [self getDetailedType];

        [editView setDocumentView:[detailedView retain]];
        
        return;
    }

    if ((offset >= 108) && (offset <= 125))
    {
        StartOffset = 108;

        [self getDetailedType];

        [editView setDocumentView:[detailedView retain]];
        
        return;
    }

    [editView setDocumentView:[emptyView retain]];
}

-(void)setEDIDRow:(unsigned char *)data start:(int)strt count:(int)cnt
{
    unsigned char dataval[10] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

    if (cnt >= 10)
    {
        dataval[9] = data[strt+9];
    }

    if (cnt >= 9)
    {
        dataval[8] = data[strt+8];
    }
    
    if (cnt >= 8)
    {
        dataval[7] = data[strt+7];
    }

    if (cnt >= 7)
    {
        dataval[6] = data[strt+6];
    }

    if (cnt >= 6)
    {
        dataval[5] = data[strt+5];
    }

    if (cnt >= 5)
    {
        dataval[4] = data[strt+4];
    }

    if (cnt >= 4)
    {
        dataval[3] = data[strt+3];
    }
        
    if (cnt >= 3)
    {
        dataval[2] = data[strt+2];
    }

    if (cnt >= 2)
    {
        dataval[1] = data[strt+1];
    }

    if (cnt >= 1)
    {
        dataval[0] = data[strt];
    }

    switch (cnt)
    {
        case 10:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", [NSString stringWithFormat:@"%.2X", dataval[1]], @"HexB", [NSString stringWithFormat:@"%.2X", dataval[2]], @"HexC", [NSString stringWithFormat:@"%.2X", dataval[3]], @"HexD", [NSString stringWithFormat:@"%.2X", dataval[4]], @"HexE", [NSString stringWithFormat:@"%.2X", dataval[5]], @"HexF", [NSString stringWithFormat:@"%.2X", dataval[6]], @"HexG", [NSString stringWithFormat:@"%.2X", dataval[7]], @"HexH", [NSString stringWithFormat:@"%.2X", dataval[8]], @"HexI", [NSString stringWithFormat:@"%.2X", dataval[9]], @"HexJ", nil]];
            
            break;

        case 9:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", [NSString stringWithFormat:@"%.2X", dataval[1]], @"HexB", [NSString stringWithFormat:@"%.2X", dataval[2]], @"HexC", [NSString stringWithFormat:@"%.2X", dataval[3]], @"HexD", [NSString stringWithFormat:@"%.2X", dataval[4]], @"HexE", [NSString stringWithFormat:@"%.2X", dataval[5]], @"HexF", [NSString stringWithFormat:@"%.2X", dataval[6]], @"HexG", [NSString stringWithFormat:@"%.2X", dataval[7]], @"HexH", [NSString stringWithFormat:@"%.2X", dataval[8]], @"HexI", nil]];
            
            break;
            
        case 8:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", [NSString stringWithFormat:@"%.2X", dataval[1]], @"HexB", [NSString stringWithFormat:@"%.2X", dataval[2]], @"HexC", [NSString stringWithFormat:@"%.2X", dataval[3]], @"HexD", [NSString stringWithFormat:@"%.2X", dataval[4]], @"HexE", [NSString stringWithFormat:@"%.2X", dataval[5]], @"HexF", [NSString stringWithFormat:@"%.2X", dataval[6]], @"HexG", [NSString stringWithFormat:@"%.2X", dataval[7]], @"HexH", nil]];
            
            break;
            
        case 7:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", [NSString stringWithFormat:@"%.2X", dataval[1]], @"HexB", [NSString stringWithFormat:@"%.2X", dataval[2]], @"HexC", [NSString stringWithFormat:@"%.2X", dataval[3]], @"HexD", [NSString stringWithFormat:@"%.2X", dataval[4]], @"HexE", [NSString stringWithFormat:@"%.2X", dataval[5]], @"HexF", [NSString stringWithFormat:@"%.2X", dataval[6]], @"HexG", nil]];

            break;

        case 6:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", [NSString stringWithFormat:@"%.2X", dataval[1]], @"HexB", [NSString stringWithFormat:@"%.2X", dataval[2]], @"HexC", [NSString stringWithFormat:@"%.2X", dataval[3]], @"HexD", [NSString stringWithFormat:@"%.2X", dataval[4]], @"HexE", [NSString stringWithFormat:@"%.2X", dataval[5]], @"HexF", nil]];
            
            break;
            
        case 5:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", [NSString stringWithFormat:@"%.2X", dataval[1]], @"HexB", [NSString stringWithFormat:@"%.2X", dataval[2]], @"HexC", [NSString stringWithFormat:@"%.2X", dataval[3]], @"HexD", [NSString stringWithFormat:@"%.2X", dataval[4]], @"HexE", nil]];
            
            break;
            
        case 4:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", [NSString stringWithFormat:@"%.2X", dataval[1]], @"HexB", [NSString stringWithFormat:@"%.2X", dataval[2]], @"HexC", [NSString stringWithFormat:@"%.2X", dataval[3]], @"HexD", nil]];
            
            break;
            
        case 3:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", [NSString stringWithFormat:@"%.2X", dataval[1]], @"HexB", [NSString stringWithFormat:@"%.2X", dataval[2]], @"HexC", nil]];

            break;

        case 2:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", [NSString stringWithFormat:@"%.2X", dataval[1]], @"HexB", nil]];

            break;
            
        case 1:
            [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2X", dataval[0]], @"HexA", nil]];
            
            break;
                
    }
}

-(void)loadEDIDData
{
    int currently_done = 0;

    while (currently_done < ESize)
    {
        if ((ESize - currently_done) > 10)
        {
            [self setEDIDRow:EData start:currently_done count:10];

            currently_done += 10;
        } else {
            [self setEDIDRow:EData start:currently_done count:(ESize - currently_done)];

            currently_done += (ESize - currently_done);
        }
    }
}

@end
