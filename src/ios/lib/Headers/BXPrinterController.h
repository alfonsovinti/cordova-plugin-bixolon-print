//
//  BXPrinter.h
//  Demo
//
//  Created on 11. 3. 14..
//  Copyright 2011 BIXOLON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPServerDelegate.h"
#import "BXPrinterControlDelegate.h"
#import "InterfaceFunctionsDelegate.h"
//#import "NetFunctionsDelegate.h"
#import "iControllerDelegate.h"
#import "BXCode.h"

//#import "iController.h"

#define __message(fmt, ...)		/*_logNormal(fmt, ##__VA_ARGS__);	\*/\
	if( [self.delegate respondsToSelector:@selector(message:text:)] ) \
		[Common dispatchSelector:@selector(message:text:) \
						  target:self.delegate \
						 objects:[NSArray arrayWithObjects:self,[NSString stringWithFormat:(fmt), ##__VA_ARGS__],nil] \
					onMainThread:YES]

@class	UDPServer;
//@class	NetFunctions;
//@class	BTFunctions;
@class interfaceFunctions;
@class  BXPrinter;
@class	Section;

@interface BXPrinterController : NSObject <UDPServerDelegate, InterfaceFunctionsDelegate, iControllerDelegate>
{
}

@property (retain, readonly)                NSString        *version;          // SDK 버전
@property (retain, readonly)                NSString        *releaseDate;          // SDK 버전
@property (retain, readonly)                NSString        *manufacturer;          // Manufacturer
@property (assign, nonatomic)				NSInteger		configPassword;
@property (assign, nonatomic)				NSInteger		AutoConnection;
@property (assign, nonatomic)				NSInteger		barcodeSupportRange;

@property (assign, nonatomic)				id<BXPrinterControlDelegate>	delegate;
@property (assign, nonatomic)               BXPrinter       *target;

@property (assign, nonatomic)				CGFloat			lookupDuration;		// 프린터 검색 시간
@property (assign, nonatomic, readonly)     unsigned		lookupRemotePort;	// 프린터 검색시 원격 포트 (WIFI/WLAN)
@property (assign, nonatomic, readonly)     unsigned		lookupLocalPort;	// 프린터 검색시 로컬 포트 (WIFI/WLAN)
@property (assign, nonatomic, readonly)     unsigned		lookupRemotePortEthernet;// 프린터 검색시 원격 포트 (Ethernet)
@property (assign, nonatomic, readonly)     unsigned		lookupLocalPortEthernet;// 프린터 검색시 로컬 포트 (Ethernet)
@property (assign, nonatomic)				unsigned		lookupCount;		// 프린터 검색시 브로드캐스팅 횟수


@property (assign, nonatomic)				NSInteger		alignment;
@property (assign, nonatomic)				NSInteger		attribute;
@property (assign, nonatomic)				NSInteger		textSize;
@property (assign, nonatomic)				char			characterSet;       // Codepage
@property (assign, nonatomic)				char			textPosition;   
@property (assign, nonatomic)				char			internationalCharacterSet;  //Codepage Manual Internatinal CharacterSet 내용 참조.
@property (assign, nonatomic)               long            textEncoding;       // iOS 문자열 Encoding 선택.



@property (assign, nonatomic)				NSInteger		drawerPin;
@property (assign, nonatomic)				NSInteger		drawerOpenLevel;

@property (assign, nonatomic, readonly)     long			state;
@property (assign, nonatomic, readonly)     long			power;

@property (assign, nonatomic)				BOOL			loadConfigurationOnConnect;
@property (assign, nonatomic)				_BXPrinterConfigrationStruct        *config;
@property (assign, nonatomic)				_BXPrinterSettingConfigrationStruct	*settingConfig;
@property (assign, nonatomic)				CGFloat			pendingWaitTime;
@property (assign, nonatomic)               BOOL            imageDitheringWithIgnoreWhite;


+ (BXPrinterController *)getInstance;

- (void)open;
- (void)close;

// 동일 네트워크에 연결된 프린터 검색하기.
- (void)lookup;

// Printer 종류에 따라 프린터 객체 갱신.
- (long) selectTarget;
- (long) selectTarget:(NSInteger)modelID;

// 프린터 초기화
- (long)initializePrinter;

// 프린터 상태 정보 얻기.
- (long)checkPrinter;

// 프린터 상태 정보 얻기.
- (long)checkPrinter:(NSInteger)mask;


// Printer 에 접속
- (BOOL)connect;

//  즉시 Disconnect
- (void)disconnect;

//  SDK 전송 버퍼에 Data가 남아있는 경우 timeout 시간까지 대기 후 Disconnect
- (long)disconnectWithTimeout:(NSInteger)timeout;

//  Timeout 기능은 위와 같으나, 전송버퍼를 모두 비운 후 'afterSleep'만큼 무조건 대기 후 disconnect
- (long)disconnectWithTimeout:(NSInteger)timeout
                   afterSleep:(NSInteger)afterSleep;

//  연결 상태 확인
- (BOOL)isConnected;


// 텍스트 처리
- (long)printText:(NSString *)string;

//  width(단위:line) * height(단위:1글자) 크기의 사각형 영역을 출력. (PageMode에서는 지원되지 않음)
- (long)printBox:(NSInteger)width height:(NSInteger)height;

//  lines에 입력 된 숫자 만큼 용지를 Feeding
- (long)lineFeed:(NSInteger)lines;

//   Label용지 인 경우 다음 인쇄 위치까지 용지를 Feeding
- (long)nextPrintPos;

//  Auto cutter 가 지원되는 모델의 경우 용지를 컷팅함.
- (long)cutPaper;

// 바코드 출력
- (long)printBarcode:(char *)bytes
		   symbology:(long)symbology
			   width:(long)width
			  height:(long)height;

// 바코드 출력(GS1Databar  Type 확장)
- (long)printBarcode:(char *)bytes
           symbology:(long)symbology
               width:(long)width
              height:(long)height
   heightOfSeparator:(long)heightOfSeparator;

// PDF 인쇄
- (long)printPDF:(NSString *)path
      pageNumber:(NSInteger)pageNumber
           width:(long)width
           level:(long)level;

// Image 인쇄 (경로지정)
- (long)printBitmap:(NSString *)path
			  width:(long)width
			  level:(long)level;

// Image 인쇄 (UIImage이용)
- (long)printBitmapWithImage:(UIImage *)image 
			  width:(long)width 
			  level:(long)level;

// 프린터의 NV 영역의 'address'에 저장되어있는 이미지를 삭제
- (long)removeNVImage:(NSInteger)address;

// 프린터의 NV 영역에 저장되어있는 모든 이미지를 삭제
- (long)removeAllNVImages;

// 프린터의 NV 영역의 저장되어있는 Address List를 확인
- (long)nvImageList:(NSArray **)images;

// 프린터의 NV 영역의 'address'에 이미지를 저장
- (long)downloadNVImage:(NSInteger)address withImage:(UIImage *)image;

// 프린터의 NV 영역의 'address'에 이미지를 저장 (밝기 조절 가능)
- (long)downloadNVImage:(NSInteger)address withImage:(UIImage *)image
				  width:(long)width 
				  level:(long)level;

// 프린터의 NV 영역의 'address'에 저장되어있는 이미지를 출력
- (long)printNVImage:(NSInteger)address;


// MSR 카드 처리
- (long)msrReadReady;
- (long)msrReadCancel;
- (long)msrReadCancelEx;
- (BOOL)msrIsReady;
- (long)msrReadTrack:(NSData **)data1 data2:(NSData **)data2 data3:(NSData **)data3;
- (long)msrGetTrack:(NSInteger)track response:(NSData **)response;
- (long)msrReadFullTrack:(NSData **)response;

// IC 카드 처리
- (long)icON:(NSData **)response;
- (long)icOFF;
- (long)icApdu:(NSData *)request response:(NSData **)response;
- (long)icStatus:(NSData **)response;

// Direct IO 처리
- (long)directIO:(NSData *)request 
	requiredSize:(NSInteger)requiredSize
		response:(NSData **)response;

// Cash Drawer 처리
- (long)openDrawer;

// Configuration 
- (long)loadConfiguration;
- (long)saveConfiguration;

// COnfiguration
- (long)loadPrinterConfiguration;
- (long)savePrinterConfiguration;

- (long)enableLSB:(BOOL)bEnable;
- (long)enableUpsideDownMode:(BOOL)bEnable;
- (long)setLabelMode:(BOOL)bEnable;


// 지원 여부 리턴
- (BOOL) isSupport_Barcode;
- (BOOL) isSupport_MSR;
- (BOOL) isSupport_IC;
- (BOOL) isSupport_Config;
- (BOOL) isSupport_CashDrawer;
- (BOOL) isSupport_LSB;
- (BOOL) isSupport_PrinterConfig;
- (NSInteger) isSupport_NVImage;
- (NSMutableArray*)  getBarcodeSupportTable;



// SetObject;

- (void) setConfigPassword:(NSInteger)pw;
- (void) setLookupDuration:(CGFloat)duration;
- (void) setLookupCount:(unsigned)count;
- (void) setAlignment:(NSInteger)set;
- (void) setAttribute:(NSInteger)set;
- (void) setTextSize:(NSInteger)size;
- (void) setCharacterSet:(char)set;
- (void) setTextPosition:(char)position;
- (void) setInternationalCharacterSet:(char)set;
- (void) setLoadConfigurationOnConnect:(BOOL)set;
- (void) setPendingWaitTime:(CGFloat)time;
//- (void) setDelegate:(id <BXPrinterControlDelegate>)_delegate;
//- (void) setTarget:(BXPrinter *)_target;


// setPageModeMode
- (long)setPageArea:(NSInteger)startingX
          startingY:(NSInteger)startingY
              width:(NSInteger)width
             height:(NSInteger)height;

- (long)setLeftPosition:(NSInteger)positionX;
- (long)setVerticalPosition:(NSInteger)positionY;

- (long)printDataInPageMode; 



- (long)transactionMode:(BOOL)bSet; //  YES: 버퍼에 저장   NO: 인쇄
- (long)asyncMode:(BOOL)bSet;

-(void) setTimeoutOnConnection:(CGFloat)timeoutOnConnection;


@end
