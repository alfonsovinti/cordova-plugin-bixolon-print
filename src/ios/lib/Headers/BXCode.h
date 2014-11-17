/*
 *  BXCode.h
 *  Demo
 *
 *  Copyright 2011 BIXOLON. All rights reserved.
 *
 */
#define DOT_LENGTH_203dpi_4inch   832   // 104mm * 8dot
#define DOT_LENGTH_203dpi_3inch   576   //  72mm * 8dot
#define DOT_LENGTH_203dpi_2inch   384   //  48mm * 8dot

#define DOT_LENGTH_180dpi_3inch   512

#define DOT_LENGTH_160dpi_3inch   400 


#define	R300_DOT_LENGTH			DOT_LENGTH_203dpi_3inch //576
#define R200_DOT_LENGTH			DOT_LENGTH_203dpi_2inch //384

#define	F310_DOT_LENGTH			DOT_LENGTH_180dpi_3inch //512


//  Model ID Define
#define	BXL_MODEL_ID_MYL                    0x12000002        //+ 02(II)
#define	BXL_MODEL_ID_MY3L                   0x13000000
#define	BXL_MODEL_ID_MY4L                   0x14000000


//  Model ID Define
#define	BXL_MODEL_ID_SPPR200II				0x12000002        //+ 02(II)
//#define	BXL_MODEL_ID_EM220II				0x12001002        //+ 02(II)
#define	BXL_MODEL_ID_SPPR300				0x13000000
#define	BXL_MODEL_ID_SPPR400				0x14000000
#define	BXL_MODEL_ID_SPPR210				0x12100000

// 350계열
#define	BXL_MODEL_ID_SRP340				0x23400000        // 340
#define	BXL_MODEL_ID_SRP350II				0x23500002        // 350  +  02(II)
#define	BXL_MODEL_ID_SRP350plus				0x23507000        // p:0x70
#define	BXL_MODEL_ID_SRP352plus				0x23527000        // p:0x70
#define	BXL_MODEL_ID_SRP350plusII           0x23507002        // p:0x70
#define	BXL_MODEL_ID_SRP352plusII			0x23527002        // p:0x70


#define	BXL_MODEL_ID_SRP350III				0x23500003        // 350  +  03(III)
#define	BXL_MODEL_ID_SRP352III				0x23520003        // 352  +  03(III)

#define	BXL_MODEL_ID_SRP350plusIII          0x23507003        // 350 + [p:0x70]  +  03(III)
#define	BXL_MODEL_ID_SRP352plusIII			0x23527003        // 350 + [p:0x70]  +  03(III)

// Dot
#define	BXL_MODEL_ID_SRP275				0x32750000        // 275

// 310계열
#define	BXL_MODEL_ID_SRPF310				0x93100000
#define	BXL_MODEL_ID_SRPF312				0x93120000



//////////////////////////////////////////////////////////////////
//Result Code
#define BXL_CS_NOTSET           -1
#define	BXL_CS_PC437			0
#define	BXL_CS_Katakana			1
#define	BXL_CS_PC850			2
#define	BXL_CS_PC860			3
#define	BXL_CS_PC863			4
#define	BXL_CS_PC865			5
#define	BXL_CS_PC1252			16
#define	BXL_CS_PC866			17
#define	BXL_CS_PC852			18
#define	BXL_CS_PC858			19
#define	BXL_CS_PC864			22
#define	BXL_CS_THAI42			23
#define	BXL_CS_WPC1253			24
#define	BXL_CS_WPC1254			25
#define	BXL_CS_WPC1257			26
#define	BXL_CS_FARSI			27
#define	BXL_CS_WPC1251			28
#define	BXL_CS_PC737			29
#define	BXL_CS_PC775			30
#define	BXL_CS_THAI14			31
#define BXL_CS_PC862			33
#define BXL_CS_PC855			36
#define BXL_CS_PC857			37
#define BXL_CS_PC928			38
#define BXL_CS_THAI16			39
#define BXL_CS_WPC1256			40
#define	BXL_CS_WPC1250			41
#define	BXL_CS_WPC1258			42
#define	BXL_CS_KHMER			43
#define BXL_CS_THAI11			44
#define BXL_CS_THAI18			45
#define BXL_CS_WPC1255			46
#define BXL_CS_HEBREW			47
#define BXL_CS_WPC1252          48

#define BXL_CS_USER			   255


//////////////////////////////////////////////////////////////////
//Result Code 
#define BXL_SUCCESS				0

#define BXL_responseBuffer_EMPTY	1

#define BXL_OTHERPTR_OPENED		100
#define BXL_NOT_OPENED			101
#define BXL_CREATE_ERROR		102
#define BXL_STATUS_ERROR		103
#define BXL_WATING_OPEN			104
#define BXL_CONNECT_ERROR		105
#define BXL_BDADDR_ERROR		106
#define BXL_NOT_SUPPORT			107
#define BXL_BAD_ARGUMENT		108 //[2007/10/13 JOON] = Baudrate 기능 추가에 따른 에러 루틴 추가.
#define BXL_BUFFER_ERROR		109 //2007 12 12 JOON MSR 버퍼가 정상적이지 않는다면 이에러 발생
#define BXL_NOT_CONNECTED		110
#define BXL_RGBA_ERROR			111	// 이미지 데이터를 RGBA 데이터로 변경할 수 없음.
#define BXL_MEMORY_ERROR		112	// 메모리 할당 실패시 이 에러가 발생됨.
#define BXL_TOO_LARGE_IMAGE		113	// 너무 큰 이미지인 경우 이 에러가 발생됨.
#define	BXL_NOT_SUPPORT_DEVICE	114

#define BXL_REGISTRY_ERROR		200
#define BXL_WRITE_ERROR			300
#define BXL_READ_ERROR			301

#define BXL_BITMAPLOAD_ERROR	400
#define BXL_BITMAPDATA_ERROR	401

#define BXL_BC_DATA_ERROR		500
#define BXL_BC_NOT_SUPPORT		501

//MSR State Return
#define BXLMSR_FAILEDMODE		601
#define BXLMSR_NOTREADY			602
#define BXLMSR_DATAEMPTY		603
#define	BXLMSR_NOTFINISHED		604

// mask of do to check printer status  
#define BXL_MASK_DEFAULT		0x00	// Only Printer ID
#define	BXL_MASK_COVERSTATUS	0x01
#define BXL_MASK_PAPERSTATUS	0x02
#define BXL_MASK_POWERSTATUS	0x04
#define BXL_MASK_MODELNAME		0x08
#define BXL_MASK_VERSION		0x10
#define BXL_MASK_CASHDRAWER		0x20
#define BXL_MASK_ALL			0xFF


//Printer Status flag
#define BXL_STS_NORMAL			0x0000		//0	
#define BXL_STS_PAPEREMPTY		0x0001		//1
#define BXL_STS_COVEROPEN		0x0002		//2
#define BXL_STS_POWEROVER		0x0004		//4
#define BXL_STS_MSR_READY		0x0008		//8
#define BXL_STS_PRINTING		0x0010		//16
#define BXL_STS_ERROR			0x0020		//32
#define BXL_STS_NOT_OPEN		0x0040		//64
#define BXL_STS_ERROR_OCCUR		0x0080		//128
#define	BXL_STS_OFFLINE			0x0100		//256
#define	BXL_STS_CASHDRAWER_OPEN	0x0200		//512
#define BXL_STS_MSR_CANCEL		0xFFF7

//added status flag SMART CARD IC
//#define BXL_STS_IC_ON		256

//#define BXL_MSR_READYCOMPLETE	105

// Connection Control Mode
#define	BXL_CONNECTIONMODE_NOAUTO			100	//  Default
#define	BXL_CONNECTIONMODE_AUTO				0

// Connection Type
#define BXL_CONNECTIONCLASS_WIFI            0x0000
#define BXL_CONNECTIONCLASS_ETHERNET        0x0001
#define BXL_CONNECTIONCLASS_BT              0x0002 
#define BXL_CONNECTIONCLASS_USB             0x0003  // current not support
#define BXL_CONNECTIONCLASS_LPT             0x0004  // current not support
#define BXL_CONNECTIONCLASS_SERIAL          0x0005  // current not support


#define BXL_SETTING_NO_CHANGE			0

// Code Page
#define	BXL_SETTING_CODEPAGE_PC437			1
#define	BXL_SETTING_CODEPAGE_Katakana		2
#define	BXL_SETTING_CODEPAGE_PC850			3
#define	BXL_SETTING_CODEPAGE_PC860			4
#define	BXL_SETTING_CODEPAGE_PC863			5
#define	BXL_SETTING_CODEPAGE_PC865			6
#define	BXL_SETTING_CODEPAGE_PC1252			7
#define	BXL_SETTING_CODEPAGE_PC866			8
#define	BXL_SETTING_CODEPAGE_PC852			9
#define	BXL_SETTING_CODEPAGE_PC858			10
#define	BXL_SETTING_CODEPAGE_PC864			11
#define	BXL_SETTING_CODEPAGE_THAI42			12
#define	BXL_SETTING_CODEPAGE_WPC1253		13
#define	BXL_SETTING_CODEPAGE_WPC1254		14
#define	BXL_SETTING_CODEPAGE_WPC1257		15
#define	BXL_SETTING_CODEPAGE_FARSI			16
#define	BXL_SETTING_CODEPAGE_WPC1251		17
#define	BXL_SETTING_CODEPAGE_PC737			18
#define	BXL_SETTING_CODEPAGE_PC775			19
#define	BXL_SETTING_CODEPAGE_THAI14			20
#define BXL_SETTING_CODEPAGE_PC862			21
#define BXL_SETTING_CODEPAGE_PC855			22
#define BXL_SETTING_CODEPAGE_PC857			23
#define BXL_SETTING_CODEPAGE_PC928			24
#define BXL_SETTING_CODEPAGE_THAI16			25
#define BXL_SETTING_CODEPAGE_WPC1256		26
#define	BXL_SETTING_CODEPAGE_WPC1250        27
#define	BXL_SETTING_CODEPAGE_WPC1258		28
#define	BXL_SETTING_CODEPAGE_KHMER			29
#define BXL_SETTING_CODEPAGE_THAI11			30
#define BXL_SETTING_CODEPAGE_THAI18			31
#define BXL_SETTING_CODEPAGE_WPC1255		32
#define BXL_SETTING_CODEPAGE_HEBREW			33
#define BXL_SETTING_CODEPAGE_WPC1252        34




// Emulation (setting)
#define BXL_SETTING_EMULATION_1			1
#define BXL_SETTING_EMULATION_2			2
#define BXL_SETTING_EMULATION_3			3
#define BXL_SETTING_EMULATION_4			4
#define BXL_SETTING_EMULATION_5			5

// Printing Speed (setting) -
#define BXL_SETTING_PRINTING_SPEED0		1   // slow
#define BXL_SETTING_PRINTING_SPEED1		2   // slow
#define BXL_SETTING_PRINTING_SPEED2		3
#define BXL_SETTING_PRINTING_SPEED3     4   // fast

// Printing Density (setting)
#define BXL_SETTING_PRINTING_DENSITY0	1   // normal
#define BXL_SETTING_PRINTING_DENSITY1	2   // normal
#define BXL_SETTING_PRINTING_DENSITY2	3   // deep
#define BXL_SETTING_PRINTING_DENSITY3   4   // more deep
#define BXL_SETTING_PRINTING_DENSITY4   5
#define BXL_SETTING_PRINTING_DENSITY5   6
#define BXL_SETTING_PRINTING_DENSITY6   7
#define BXL_SETTING_PRINTING_DENSITY7   8
#define BXL_SETTING_PRINTING_DENSITY8   9

// Font Type (setting)
#define BXL_SETTING_FONT_A		1
#define BXL_SETTING_FONT_B		2
#define BXL_SETTING_FONT_C      3

// MSR Trigger Mode (setting)
#define BXL_SETTING_MSRTRIGGER_NO_USE   1
#define BXL_SETTING_MSRTRIGGER_CMD_123  2
#define BXL_SETTING_MSRTRIGGER_AT_1     3
#define BXL_SETTING_MSRTRIGGER_AT_2     4
#define BXL_SETTING_MSRTRIGGER_AT_3     5
#define BXL_SETTING_MSRTRIGGER_AT_12    6
#define BXL_SETTING_MSRTRIGGER_AT_23    7
#define BXL_SETTING_MSRTRIGGER_AT_123   8
#define BXL_SETTING_MSRTRIGGER_NOT_SET 0

// MSR Data Mode (setting)
#define BXL_SETTING_MSRMODE_NORMAL        1
#define BXL_SETTING_MSRMODE_SENTINEL1     2
#define BXL_SETTING_MSRMODE_SENTINELMULTI 3


// Select Printting Speed  - use to MSW or DipSW (setting)
#define BXL_SETTING_SELECT_SETTING_USED_BY_DSW        0
#define BXL_SETTING_SELECT_SETTING_USED_BY_MSW        1


// PAPER SAVE Mode (setting)
#define BXL_SETTING_PAPER_SAVEMODE_DISABLE        1
#define BXL_SETTING_PAPER_SAVEMODE_LEVEL1         2
#define BXL_SETTING_PAPER_SAVEMODE_LEVEL2         3
#define BXL_SETTING_PAPER_SAVEMODE_LEVEL3         4

// 2Inch Mode (setting)
#define BXL_SETTING_2INCH_DISABLE                1
#define BXL_SETTING_2INCH_LEFT                   2
#define BXL_SETTING_2INCH_CENTER                 3


//Power Status
#define BXL_PWR_HIGH			0
#define BXL_PWR_MIDDLE			1
#define BXL_PWR_LOW				2
#define BXL_PWR_SMALL			3
#define BXL_PWR_NOT				4

// Font Alignment

#define	BXL_ALIGNMENT_LEFT		0
#define BXL_ALIGNMENT_CENTER	1
#define BXL_ALIGNMENT_RIGHT		2

//////////////////////////////////////////////////////////////////////////
//Text Attribute
// 8 7 6 5 4 3  2      1 
//             BOLD   FONT AorB
//Font Attribute 기본 값 : not Bold, FontA, not Underline, not reverse

#define BXL_FT_DEFAULT			0   //
#define BXL_FT_FONTB			1   // 00000001
#define BXL_FT_FONTC			16  // 00010000
#define BXL_FT_BOLD				2   // 00000010
#define BXL_FT_UNDERLINE		4	// 00000100
#define BXL_FT_REVERSE			8   // 00001000
#define BXL_ExFT_CHINA_FONTA	0   // 00000000
#define BXL_ExFT_CHINA_FONTB	32  // 00100000
#define BXL_FC_RED              64  // 01000000

//Text Size Attribute
#define BXL_TS_0WIDTH			0
#define BXL_TS_1WIDTH			16
#define BXL_TS_2WIDTH			32
#define BXL_TS_3WIDTH			48
#define BXL_TS_4WIDTH			64
#define BXL_TS_5WIDTH			80
#define BXL_TS_6WIDTH			96
#define BXL_TS_7WIDTH			112

#define BXL_TS_0HEIGHT			0	
#define BXL_TS_1HEIGHT			1
#define BXL_TS_2HEIGHT			2
#define BXL_TS_3HEIGHT			3
#define BXL_TS_4HEIGHT			4
#define BXL_TS_5HEIGHT			5
#define BXL_TS_6HEIGHT			6
#define BXL_TS_7HEIGHT			7

//////////////////////////////////////////////////////////////////////////
// Width Full
//////////////////////////////////////////////////////////////////////////
#define BXL_WIDTH_FULL	-1
#define BXL_WIDTH_NONE	-2

//////////////////////////////////////////////////////////////////////////
// BARCODE SUPPORT RANGE
//////////////////////////////////////////////////////////////////////////
#define BXL_BC_SUPPORT_NORMAL      0
#define BXL_BC_SUPPORT_GS1DATABAR	1

//////////////////////////////////////////////////////////////////////////
// BARCODE SYMBOLOGY
//////////////////////////////////////////////////////////////////////////
#define BXL_BCS_PDF417			200
#define BXL_BCS_QRCODE_MODEL2	202 
#define BXL_BCS_QRCODE_MODEL1	203 
#define BXL_BCS_DATAMATRIX		204 //2009 4 15 added
#define BXL_BCS_MAXICODE_MODE2	205 //2009 4 15 updated
#define BXL_BCS_MAXICODE_MODE3	206 //2009 4 15 updated
#define BXL_BCS_MAXICODE_MODE4	207 //2009 4 15 updated
#define BXL_BCS_GS1_RSS14                       208 // GS1 DataBar Omnidirectional
#define BXL_BCS_GS1_RSS14TRUNCATED              209 // GS1 DataBar Truncated
#define BXL_BCS_GS1_RSS14STACKED                210 // GS1 DataBar Stacked
#define BXL_BCS_GS1_RSS14STACKEDOMNIDIRECTIONAL 211 // GS1 DataBar Stacked Omnidirectional
#define BXL_BCS_GS1_RSSLIMITED                  212 // GS1 DataBar Limited
#define BXL_BCS_GS1_RSSEXPANDED                 213 // GS1 DataBar Expanded
#define BXL_BCS_GS1_UPCA                        214
#define BXL_BCS_GS1_UPCE                        215
#define BXL_BCS_GS1_EAN13                       216
#define BXL_BCS_GS1_EAN8                        217
#define BXL_BCS_GS1_EAN128CC_AB                 218
#define BXL_BCS_GS1_EAN128CC_C                  219


#define BXL_BCS_UPCA			101
#define BXL_BCS_UPCE			102
#define BXL_BCS_EAN8			103
#define BXL_BCS_EAN13			104
#define BXL_BCS_JAN8			105
#define BXL_BCS_JAN13			106
#define BXL_BCS_ITF				107
#define BXL_BCS_Codabar			108
#define BXL_BCS_Code39			109
#define BXL_BCS_Code93			110
#define BXL_BCS_Code128			111

/////////////////////////////////////////////////////////////////
//Barcode text position
#define BXL_BC_TEXT_NONE		0
#define BXL_BC_TEXT_ABOVE		1
#define BXL_BC_TEXT_BELOW		2


//MSR Mode 
#define BXL_MSRMODE_CMDTRACK12		0
#define BXL_MSRMODE_CMDTRACK23		1
#define BXL_MSRMODE_AUTOTRACK1		2
#define BXL_MSRMODE_AUTOTRACK2_1	3
#define BXL_MSRMODE_AUTOTRACK12		4
#define BXL_MSRMODE_AUTOTRACK2_2	5
#define BXL_MSRMODE_AUTOTRACK3		6
#define BXL_MSRMODE_AUTOTRACK23		7

#define BXL_MSG_TRACK1		0x01
#define BXL_MSG_TRACK2		0x02
#define BXL_MSG_TRACK3		0x04
#define BXL_MSG_TRACK_ENCRIPTION 0x08

///////////////////////////////////////////////////////////////////
// define Cash Drawer Pin
#define BXL_CASHDRAWER_PIN_2			0
#define BXL_CASHDRAWER_PIN_5			1

#define BXL_CASHDRAWER_OPENLEVEL_LOW	0
#define BXL_CASHDRAWER_OPENLEVEL_HIGH	1

