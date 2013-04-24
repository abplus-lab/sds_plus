//  Copyright (C) 2003  ABplus Inc. kazHIDA.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  1. Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer
//     as the first lines of this file unmodified.
//  2. Redistributions  in  binary  form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
//  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
//  The following is Japanese.
//  以下は、日本語版
//
//  ソースあるいはバイナリー形式での再配布/使用は、改変を加える場合も、
//  加えない場合も、下記の条件を満たした場合に許諾される。
//
//  1.  ソースコードでの再配布物には、必ず上記の著作権表示、この条件リスト、
//      および以下の免責事項を、改変せずにこのファイルの最初の数行に入れな
//      ければならない。
//  2.  バイナリー形式での再配布は、必ず上記の著作権表示、この条件リスト、
//      以下の免責事項の複製をドキュメンテーション内、あるいは配布物と共に
//      提供されるものに含めなければならない。
//
//  このソフトウェアは、著作者により、「現状のまま」で提供され、
//  著作者は直接的、非直接的、偶発的、特殊な、典型的、あるいは必然の
//  いかなる場合においても、いかなる損害に一切責任は負わない。
//  その損害は以下の内容も含み、しかもそれに限定されない。
//  代用となる物やサービスの調達、効果・データ・利益の低下、商取引の障害、
//  また、どのような責務の論理においても、それが契約に関するものであろうと、
//  厳格な責務であろうと、不正行為（不注意やその他の場合も含む）であろうと、
//  このソフトウェアを使用することによって生じるそれらの損害の、
//  一切の責任から著作者は免れている。
//  たとえ事前にそれらすべての損害への可能性が示唆されていた場合においても
//  同様である。
//
unit SDScore;
//  $Id: SDScore.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $

interface

{:Note::
  sds.h(厳密にはsds_bc.h)をDelphi-Languageに置き換えているユニット
  一応、生APIは意味のわからないものも含め一通り提供し、
  自分が必要なものについては、ちょっと工夫したラッパーを提供している。

  だけのはずだったんだけど、
  エントリ・ポイント関連も加えている。
  というわけで、このユニットを組み込めば、
  それだけでSDS固有のうざったい所は記述不要になるという便利ユニット。
  そこまでのおせっかいは不要という人は、
  条件定義(NO_SDSENTRY)で無効にできる。
::Note*}

uses
  Windows, SysUtils;

const

  {:Note::
    単純に全部定義しているので、本当に必要かどうかは不明
    てゆうか、これとは別に列挙型で定義していたりするものもある
  ::Note:}

  //  sds_point[]やsds_matrix[][]の添え字に使う定数
  SDS_X = 0;
  SDS_Y = 1;
  SDS_Z = 2;
  SDS_T = 3;

  //  論理値  Trueの値はDelphi-Languageと異なる
  SDS_TRUE  = 1;
  SDS_FALSE = 0;

  //  sds_command()で入力待ちに使う定数
  SDS_PAUSE = '\';

  //  何に使うのか不明
  SDS_RSG_NONULL    = $0001;
  SDS_RSG_NOZERO    = $0002;
  SDS_RSG_NONEG     = $0004;
  SDS_RSG_NOLIM     = $0008;
  SDS_RSG_GETZ      = $0010;
  SDS_RSG_DASH      = $0020;
  SDS_RSG_2D        = $0040;
  SDS_RSG_OTHER     = $0080;
  SDS_RSG_NOPMENU   = $0100;
  SDS_RSG_NOCANCEL  = $0200;
  SDS_RSG_NOVIEWCHG = $0400;
  SDS_RSG_NODOCCHG  = $0800;

  //  SDSへのリクエスト・コード
  SDS_RQSAVE    =   14;
  SDS_RQEND     =   15;
  SDS_RQQUIT    =   16;
  SDS_RQCFG     =   22;
  SDS_RQXLOAD   =  100;
  SDS_RQXUNLD   =  101;
  SDS_RQSUBR    =  102;
  SDS_RQHUP     =  105;
  SDS_RQXHELP   =  118;

  //  SDSへのリクエストに対するリザルト・コード
  SDS_RSRSLT    =  1;
  SDS_RSERR     =  3;

  //  リザルト・バッファのrestypeに使う定数
  //  SDSライブラリ関数の返り値も混ざってたりする
  SDS_RTERROR   = -5001;
  SDS_RTCAN     = -5002;
  SDS_RTREJ     = -5003;
  SDS_RTFAIL    = -5004;
  SDS_RTKWORD   = -5005;
  SDS_RTNONE    =  5000;
  SDS_RTREAL    =  5001;
  SDS_RTPOINT   =  5002;
  SDS_RTSHORT   =  5003;
  SDS_RTANG     =  5004;
  SDS_RTSTR     =  5005;
  SDS_RTENAME   =  5006;
  SDS_RTPICKS   =  5007;
  SDS_RTORINT   =  5008;
  SDS_RT3DPOINT =  5009;
  SDS_RTLONG    =  5010;
  SDS_RTVOID    =  5014;
  SDS_RTLB      =  5016;
  SDS_RTLE      =  5017;
  SDS_RTDOTE    =  5018;
  SDS_RTNIL     =  5019;
  SDS_RTDXF0    =  5020;
  SDS_RTT       =  5021;
  SDS_RTBINARY  =  5022;
  SDS_RTRESBUF  =  5023;
  SDS_RTNORM    =  5100;
  SDS_RTDRAGPT  =  5500;

  //  何に使うのか不明
  COND_OP_CODE  = -4;

  //  何に使うのか不明
  SDS_MODE_ENABLE   = 0;
  SDS_MODE_DISABLE  = 1;
  SDS_MODE_SETFOCUS = 2;
  SDS_MODE_SETSEL   = 3;
  SDS_MODE_FLIP     = 4;

  //  タイル関連の制限値
  SDS_MAX_TILE_STR   =  40;
  SDS_TILE_STR_LIMIT = 255;

  //  コールバック・フラグ
  SDS_CBCMDBEGIN         =  0;
  SDS_CBCMDEND           =  1;
  SDS_CBMOUSEMOVE        =  2;
  SDS_CBLBUTTONDN        =  3;
  SDS_CBLBUTTONUP        =  4;
  SDS_CBLBUTTONDBLCLK    =  5;
  SDS_CBRBUTTONDN        =  6;
  SDS_CBRBUTTONUP        =  7;
  SDS_CBXFORMSS          =  8;
  SDS_CBENTUNDO          =  9;
  SDS_CBENTREDO          = 10;
  SDS_CBPALETTECHG       = 11;
  SDS_CBOPENDOC          = 12;
  SDS_CBNEWDOC           = 13;
  SDS_CBCLOSEDOC         = 14;
  SDS_CBSAVEDOC          = 15;
  SDS_CBVIEWDOCCHG       = 16;
  SDS_CBENTDEL           = 17;
  SDS_CBENTMAKE          = 18;
  SDS_CBENTMOD           = 19;
  SDS_CBGRIPEDITBEG      = 20;
  SDS_CBGRIPEDITEND      = 21;
  SDS_CBVIEWCHANGE       = 22;
  SDS_CBMOUSEMOVEUCS     = 23;
  SDS_CBLBUTTONDNUCS     = 24;
  SDS_CBLBUTTONUPUCS     = 25;
  SDS_CBLBUTTONDBLCLKUCS = 26;
  SDS_CBRBUTTONDNUCS     = 27;
  SDS_CBRBUTTONUPUCS     = 28;
  SDS_CBBEGINPAINT       = 29;
  SDS_CBENDPAINT         = 30;
  SDS_CBENDMOUSEMOVE     = 31;
  SDS_CBDOCCHG           = 32;
  SDS_CBBEGINCLONE       = 33;
  SDS_CBENDCLONE         = 34;
  SDS_CBMBUTTONDN        = 35;
  SDS_CBMBUTTONUP        = 36;
  SDS_CBMBUTTONDNUCS     = 37;
  SDS_CBMBUTTONUPUCS     = 38;

  //  UNDO,REDOの時の通知に使う定数
  SDS_ADD_NOTICE    = 1;
  SDS_MODIFY_NOTICE = 2;
  SDS_DELETE_NOTICE = 3;

  //  sds_name_nil()、sds_name_clear()の変わりに使う定数
  SDS_NIL_NAME = 0;

  //  SDSのAPIを提供するホストアプリケーション
  SDS_HOSTAPP = 'icad.exe';

type

  {:Note::
    まずは、簡単なデータ型
    Delphiの流儀に従って頭にTをつけている。
    アンダースコアをなくして、文節の頭を大文字にしているのは、
    ワシの好み（アンダースコアは嫌い)。
  ::Note:}

  TSdsReal = Double;
  //  これは、たぶん使わない

  TSdsPoint = array [SDS_X..SDS_Z] of Double;
  PSdsPoint = ^TSdsPoint;
  //  2次元の点の時はどうしよう？

  TSdsName = Int64;
  PSdsName = ^TSdsName;
  //  longint2個ってことは64bit整数なんで、そっちを使った方が楽だと思う。

  TSdsXYZT = ( SdsMX, SdsMY, SdsMZ, SdsMT );
  TSdsMatrix = array [SDS_X..SDS_T] of array [SDS_X..SDS_T] of Double;
  PSdsMatrix = ^TSdsMatrix;
  //  座標変換用のマトリクス？
  //  使い方はよくわからない。

  {:Note::
    一応、リザルトバッファも定義しておくけど、
    これをこのまま使うのは、なんだかなという気はする。
  ::Note:}

  TSdsBinary = record
    clen: SmallInt;
    buf:  Pointer;    //  sds.hではchar*だけど、こっちの方がいいでそ
  end;
  //  リザルトバッファで使用するバイナリデータ

  TSdsResBufDump = array [0..23] of Byte;
  //  ResBufの中身がよく分からなくても扱えるようにするためのもの
  //  sds.hにはない

  PSdsResBuf = ^TSdsResbuf;
  PPSdsResBuf = ^PSdsResbuf;
  TSdsResBuf = record
    rbnext:  PSdsResBuf;
    restype: SmallInt;
    case Integer of
    0 : ();
    1 : (rreal:   Double);
    2 : (rpoint:  TSdsPoint);
    3 : (rint:    SmallInt);
    4 : (rstring: PChar);
    5 : (rlname:  TSdsName);
    6 : (rlong:   LongInt);
    7 : (rbinary: TSdsBinary);
    100 : (DebDump: TSdsResBufDump);
    101 : (Head: PSdsResBuf; Tail: PSdsResBuf; List: TObject);
  end;
  {:Note::
    sds.hでは、いったんsds_u_valという共用体を作って、
    それを可変部に使用しているけど、
    Delphi-Languageでは、部分的な可変部を持ったデータ構造を使えるので不要
    DebDumpは解説用に付け加えたもの
    TSdsPointが含まれているので、最低でも24バイトはあるはず
    Head,Tail,SubListは、SDSplus用の拡張なので、普通は使っちゃだめ。
  ::Note:}
  TSdsResBufType = (SdsRUnkown,
                    SdsRReal,
                    SdsRPoint,
                    SdsRInt,
                    SdsRString,
                    SdsRName,
                    SdsRLong,
                    SdsRBinary);
  {:Note::
    sds.hにはないのだけど、ResBuf内のデータの種類を識別するために
    必要なので追加した。
  ::Note:}

  // これはよくわかりません
  PSdsDObjll = ^TSdsDObjll;
  TSdsDObjll = record
    types:  Char;
    color:  Smallint;
    npts:   Smallint;
    chain:  PDouble;
    next:   PSdsDObjll;
  end;

  // Block関連の構造体　これもよくわかりません
  PSdsBlockTree = ^TSdsBlockTree;
  TSdsBlockTree = record
    p_next:       PSdsBlockTree;
    p_contents:   PSdsBlockTree;
    bname:        PChar;          // block name
    path:         PChar;          // NULL for block, saved file name for xref
    entity_name:  TSdsName;       // entity's SDS internal name
    tblrec_name:  TSdsName;       // The record's SDS internal name in block table
    types:        Integer;
    bitmap:       Pointer;        // bitmap & WMF image buffer
    wmf:          Pointer;
    bmpsz:        Integer;        // bitmap & WMF buffer size
    wmfsz:        Integer;
    p_hook:       Pointer;        // The hook for adding expanded data to instances of this structure.
                                  // Isn't used by SDS functions. You can use it at own discretion.
                                  // Is initialized as NULL.
                                  // (!) sds_relBlockTree() will not delete p_hook.
  end;


  //  関数/コマンド定義テーブル用の構造体とその動的配列
  TSdsUserFunc = function(var rb: PSdsResBuf): Integer;
  TSdsFuncDef = record
    funcName: String; //PChar;
    func:     TSdsUserFunc;
  end;
  TSdsFuncDefTable = array of TSdsFuncDef;
  //  TSdsUserFuncでは、自分でrbを解放する場合は、
  //  rbをnilにしておく必要がある(このユニットのSDS_EntryPointを使う場合)
  //  そうでない場合、SDS_EntryPoint内で、rbを解放しようとするので、
  //  まずいことになりそう。

  //  コールバック関数型
  TSdsCallbackFunc = function(flag: Integer;
                              arg1: Pointer;
                              arg2: Pointer;
                              arg3: Pointer): Integer; cdecl;

  TSdsDragEnts1 = function(arg: Pointer): Integer; cdecl;
  TSdsDragEnts2 = function(ptCursorLoc: PSdsPoint; mxTransform: PSdsMatrix): Integer; cdecl;

  //  ありそうでなかった、ハンドルなどを指すポインタ
  PHINST = ^HINST;
  PHWND  = ^HWND;
  PPChar = ^PChar;
  PHDC   = ^HDC;

  ESdsException = class(Exception);
  //  SDScoreやSDSplusで使用する例外のベース

  ESdsResTypeError = class(ESdsException);
  //  restypeとバッファ内のデータ型が不一致だった場合の例外

  ESdsErrNotFound = class(ESdsException);
  //  ???get系で、見つからなかった時に発生する例外

  ESdsNoMoreLoop = class(ESdsException);
  //  ???next系で、見つからなかった時に発生する例外
  //  ループの終了に使用するためのものなので、
  //  デバッガ・オプションで無視する例外に指定しておいた方がよい


{$IFNDEF NO_SDSENTRY}

  TSdsUserProc   = procedure();
  TSdsUserProcAt = (SdsAtXLOAD,
                    SdsAtXUNLD,
                    SdsAtSAVE,
                    SdsAtEND,
                    SdsAtQUIT,
                    SdsAtCFG,
                    SdsAtHUP,
                    SdsAtXHELP);
  //  ユーザ処理を登録するための手続き型と、
  //  それを実行するタイミングを指定する識別子、
  //  通常は、SdsAtLOAD、SdsAtUNLOADを指定して使えば十分のはず
  //  ただし、SDS_RQSUBRについては、ユーザ定義関数の実行専用になっているので、
  //  ユーザ処理は実行できない。
  //  詳しくは、SdsAddUserProc()を参照

{$ENDIF}

{:Note::
  以下のexternal宣言は、likiさん作のsdslib.pasをベースに、
  型の宣言等を変えている。
::Note:}

//  void SDS_main(int nARGC, char *nARGV[]);
function  SDS_GetGlobals(appname: PChar; hwnd: PHWND; hInstance: PHINST): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getviewhdc(): PHDC; cdecl; external SDS_HOSTAPP;
function  sds_getrgbvalue(nColor: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getpalette(): HPALETTE; cdecl; external SDS_HOSTAPP;
function  sds_getviewhwnd(): HWND; cdecl; external SDS_HOSTAPP;
function  sds_getmainhwnd(): HWND; cdecl; external SDS_HOSTAPP;
//function  sds_drawLinePattern(h_dc: HDC; rect: RECT; lineParam: Psds_resbuf): Integer; cdecl; external SDS_HOSTAPP;

procedure sds_abort(const szAbortMsg: PChar); cdecl; external SDS_HOSTAPP;
procedure sds_abortintellicad; cdecl; external SDS_HOSTAPP;
function  sds_agetcfg(const szSymbol: PChar; szVariable: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_agetenv(const szSymbol: PChar; szVariable: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_alert(const szAlertMsg: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_angle(const ptStart: PSdsPoint; const ptEnd: PSdsPoint): Double; cdecl; external SDS_HOSTAPP;
function  sds_angtof(const szAngle: PChar; nUnitType: Integer; pdAngle: PDouble): Integer; cdecl; external SDS_HOSTAPP;
// function  sds_angtof_absolute(const szAngle: PChar; nUnitType: Integer; pdAngle: PDouble): Integer; cdecl; external SDS_HOSTAPP;
function  sds_angtos(dAngle: Double; nUnitType: Integer; nPrecision: Integer; szAngle: PChar): Integer; cdecl; external SDS_HOSTAPP;
// function  sds_angtos_end(dAngle: Double; nUnitType: Integer; nPrecision: Integer; szAngle: PChar): Integer; cdecl; external SDS_HOSTAPP;
// function  sds_angtos_convert(ignoremode: Integer; dAngle: Double; nUnitType: Integer; nPrecision: Integer; szAngle: PChar): Integer; cdecl; external SDS_HOSTAPP;
// function  sds_angtos_dim(ignoremode: Integer; dAngle: Double; nUnitType: Integer; nPrecision: Integer; szAngle: PChar): Integer; cdecl; external SDS_HOSTAPP;
// function  sds_angtos_absolute(dAngle: Double; nUnitType: Integer; nPrecision: Integer; szAngle: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_arxload(const szARXProgram: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_arxloaded(): PSdsResBuf; cdecl; external SDS_HOSTAPP;
function  sds_arxunload(const szARXProgram: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_asetcfg(const szSymbol: PChar; const szValue: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_asetenv(const szSymbol: PChar; const szValue: PChar): Integer; cdecl; external SDS_HOSTAPP;

function  sds_buildBlockTree(type_mask: Integer): PSdsBlockTree; cdecl; external SDS_HOSTAPP;
function  sds_buildlist(nRType : Integer): PSdsResbuf; cdecl; varargs; external SDS_HOSTAPP;

function  sds_callinmainthread(fnDragEnts: TSdsDragEnts1; pUserData: Pointer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_calloc(sizeHowMany: Integer; sizeByteEach: Integer): Pointer; cdecl; external SDS_HOSTAPP;
function  sds_cmd(const prbCmdList: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_command(nRType: Integer): Integer; cdecl; varargs; external SDS_HOSTAPP;
function  sds_cvunit(dOldNum: Double; const szOldUnit: PChar; const szNewUnit: PChar; pdNewNum: PDouble): Integer; cdecl; external SDS_HOSTAPP;

function  sds_defun(const szFuncName: PChar; nFuncCode: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_dictadd(const nmDict: PSdsName; const szAddThis: PChar; const nmNonGraph: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_dictdel(const nmDict: PSdsName; const szDelThis: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_dictnext(const nmDict: PSdsName; swFirst: Integer): PSdsResBuf; cdecl; external SDS_HOSTAPP;
function  sds_dictrename(const nmDict: PSdsName; const szOldName: PChar; szNewName: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_dictsearch(const nmDict: PSdsName; const szFindThis: PChar; swFirst: Integer): PSdsResBuf; cdecl; external SDS_HOSTAPP;
function  sds_dispobjs(const nmEntity: PSdsName; nDispMode: Integer): TSdsDObjll; cdecl; external SDS_HOSTAPP;
function  sds_distance(const ptFrom: PSdsPoint; const prTo: PSdsPoint): Double; cdecl; external SDS_HOSTAPP;
function  sds_distof(const szDistance: PChar; nUnitType: Integer; pdDistance: PDouble): Integer; cdecl; external SDS_HOSTAPP;
function  sds_draggen(const nmSelSet: PSdsName; const szDragMsg: PChar; nCursor: Integer; fnDragEnts: TSdsDragEnts2; ptDestPoint: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_entdel(const nmEntity: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_entget(const nmEntity: PSdsName): PSdsResBuf; cdecl; external SDS_HOSTAPP;
function  sds_entgetx(const nmEntity: PSdsName; const prbAppList: PSdsResBuf): PSdsResBuf; cdecl; external SDS_HOSTAPP;
function  sds_entlast(nmLastEnt: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_entmake(const prbEntList: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_entmakex(const prbEntList: PSdsResBuf; nmNewEnt: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_entmod(const prbEntList: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_entnext(const nmKnownEnt: PSdsName; nmNextEnt: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_entsel(const szSelectMsg: PChar; nmEntity: PSdsName; ptSelcted: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_entupd(const nmEntity: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
procedure sds_exit(swAbnormalExit: Integer); cdecl; external SDS_HOSTAPP;

procedure sds_fail(const szFailMsg: PChar); cdecl; external SDS_HOSTAPP;
function  sds_findfile(const szLookFor: PChar; szPathFound: PChar): Integer; cdecl; external SDS_HOSTAPP;
procedure sds_free(pMemLoc: Pointer); cdecl; external SDS_HOSTAPP;
procedure sds_freedispobjs(pDispObjs: PSdsDObjll); cdecl; external SDS_HOSTAPP;

function  sds_getangle(const ptStart: PSdsPoint; const szAngleMsg: PChar; pdRadians: PDouble): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getappname: PChar; cdecl; external SDS_HOSTAPP;
function  sds_getargs: PSdsResBuf; cdecl; external SDS_HOSTAPP;
function  sds_getcfg(const szSymbol: PChar; szVariable: PChar; nLength: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getcname(const szOtherLang: PChar; pszEnglish: PPChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getcorner(const ptStart: PSdsPoint; const szCornerMsg: PChar; ptOpposite: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getdist(const ptStart: PSdsPoint; const szDistMsg: PChar; pdDistance: PDouble): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getdoclist(): PSdsResBuf; cdecl; external SDS_HOSTAPP;
function  sds_getfiled(const szTitle: PChar; const szDefaultPath: PChar; const szExtension: PChar; bsOptions: Integer; prbFileName: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getfuncode: Integer; cdecl; external SDS_HOSTAPP;
function  sds_getinput(szEntry: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getint(const szIntMsg: PChar; pnInteger: PInteger): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getkword(const szKWordMsg: PChar; szKWord: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getortent(const ptStart: PSdsPoint; const szOrientMsg: PChar; pdRadians: PDouble): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getpoint(const ptReference: PSdsPoint; const szPointMsg: PChar; ptPoint: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getreal(const szRealMsg: PChar; pdReal: PDouble): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getstring(swSpaces: Integer; const szStringMsg: PChar; szString: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getsym(const szSymbol: PChar; pprbSymbolInfo: PPSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_gettbpos(const pToolBarName: PChar; ptTbPos: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_getvar(const szSysVar: PChar; prbVarInfo: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_graphscr(): Integer; cdecl; external SDS_HOSTAPP;
function  sds_grclear(): Integer; cdecl; external SDS_HOSTAPP;
// function  sds_grarc(const ptCenter: PSdsPoint; dRadius: Double; dStartAngle: Double; dEngAngle: Double; nColor: Integer; swHighlight: Integer): Integer; cdecl; external SDS_HOSTAPP;
// function  sds_grfill(const pptPoints: PSdsPoint; nNumPoints: Integer; nColor: Integer; swHighlight: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_grdraw(const ptFrom: PSdsPoint; const ptTo: PSdsPoint; nColor: Integer; swHighlight: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_grread(bsAllowed: Integer; pnInputType: PInteger; prbInputValue: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_grtext(nWhere: Integer; const szTextMsg: PChar; swHighlight: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_grvecs(const prbVectList: PSdsResBuf; mxDispTrans: PSdsMatrix): Integer; cdecl; external SDS_HOSTAPP;

function  sds_handent(const szEntHandle: PChar; nmEntity: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_help(szHelpFile: PChar; szContextID: PChar; nMapNumber: Integer): Integer; cdecl; external SDS_HOSTAPP;

function  sds_init(nARGC: Integer; nARGV: PPChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_initget(bsAllowed: Integer; const szKeyWordList: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_inters(const ptFrom1: PSdsPoint; const ptTo1: PSdsPoint; const ptFrom2: PSdsPoint; const ptTo2: PSdsPoint; swFinite: Integer; ptIntersection: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_invoke(const prbArguments: PSdsResBuf; pprbReturn: PPSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_isalnum(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_isalpha(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_iscntrl(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_isdigit(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_isgraph(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_islower(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_isprint(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_ispunct(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_isspace(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_isupper(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_isxdigit(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;

function  sds_link(nRSMsg: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_loaded(): PSdsResBuf; cdecl; external SDS_HOSTAPP;

function  sds_malloc(sizeBytes: Integer): Pointer; cdecl; external SDS_HOSTAPP;
function  sds_menucmd(const szPartToDisplay: PChar): Integer; cdecl; external SDS_HOSTAPP;
// function  sds_menugroup(pMenuGroupName: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_msize(pvBuffer: Pointer): Integer; cdecl; external SDS_HOSTAPP;

function  sds_namedobjdict(nmDict: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_nentsel(const szNEntMsg: PChar; nmEntity: PSdsName; ptEntPoint: PSdsPoint; ptECStoWCS: PSdsPoint; pprbNestBlkList: PPSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_nentselp(const szNEntMsg: PChar; nmEntity: PSdsName; ptEntPoint: PSdsPoint; swUserPick: Integer; mxECStoWCS: PSdsMatrix; ppbrNestBlkList: PPSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_newrb(nTypeOrDXF: Integer): PSdsResBuf; cdecl; external SDS_HOSTAPP;

function  sds_osnap(const ptAperCtr: PSdsPoint; const szSnapModes: PChar; ptPoint: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;

procedure sds_polar(const ptPolarCtr: PSdsPoint; dAngle: Double; dDistance: Double; ptPoint: PSdsPoint); cdecl; external SDS_HOSTAPP;
function  sds_printf(const szPrintThis: PChar): Integer; cdecl; varargs; external SDS_HOSTAPP;
function  sds_prograsspercent(iPercentDone: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_progressstart: Integer; cdecl; external SDS_HOSTAPP;
function  sds_progressstop: Integer; cdecl; external SDS_HOSTAPP;
function  sds_prompt(const szPromptMsg: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_putsym(const szSymbol: PChar; prbSymbolInfo: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;

function  sds_readaliasfile(szAliasFile: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_realloc(pOldMemLoc: Pointer; sizeBytes: Integer): Pointer; cdecl; external SDS_HOSTAPP;
function  sds_redraw(const nmEntity: PSdsName; nHowToDraw: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_regapp(const szApplication: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_regappx(const szApplication: PChar; swSaveAsR12: Integer): Integer; cdecl; external SDS_HOSTAPP;
//function  sds_regfunc(nFuncName: function(); nFuncCode: Integer): Integer; cdecl; external SDS_HOSTAPP;
procedure sds_relBlockTree(pTree: PSdsBlockTree); cdecl; external SDS_HOSTAPP;
function  sds_relrb(prbReleaseThis: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_retint(nReturnInt: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_retlist(const prbReturnList: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_retname(const nmReturnName: PSdsName; nReturnType: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_retnil(): Integer; cdecl; external SDS_HOSTAPP;
function  sds_retpoint(const ptReturn3D: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_retreal(dReturnReal: Double): Integer; cdecl; external SDS_HOSTAPP;
function  sds_retstr(const szReturnString: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_rett(): Integer; cdecl; external SDS_HOSTAPP;
function  sds_retval(const prbReturnValue: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_retvoid(): Integer; cdecl; external SDS_HOSTAPP;
function  sds_rp2pix(dNumberX: Double; dNumberY: Double; pPixelX: PInteger; pPixelY: PInteger): Integer; cdecl; external SDS_HOSTAPP;
function  sds_rtos(dNumber: Double; nUnitType: Integer; nPrecision: Integer; szNumber: PChar): Integer; cdecl; external SDS_HOSTAPP;

function  sds_sendmessage(szCommandMsg: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_setcallbackfunc(cbfnptr: TSdsCallbackFunc): Integer; cdecl; external SDS_HOSTAPP;
function  sds_setfunhelp(szFunctionName: PChar; szHelpFile: PChar; szContextID: PChar; nMapNumber: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_setvar(const szSysVar:PChar; const prbVarInfo: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_setview(const prbViews: PSdsResBuf; nWhichVPort: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_snvalid(const szTableName: PChar; swAllowPipe: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_ssadd(const nmEntToAdd: PSdsName; const nmSelSet: PSdsName; nmNewSet: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_ssdel(const nmEntToDel: PSdsName; const nmSelSet: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_ssfree(nmSetToFree: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_ssget(const szSelMethod: PChar; const pFirstPoint: Pointer; const pSecondPoint: Pointer; const prbFilter: PSdsResBuf; nmNewSet: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_ssgetfirst(pprbHaveGrips: PPSdsResBuf; pprbAreSelected: PPSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_sslength(const nmSelSet: PSdsName; plNumberOfEnts: PLongint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_ssmemb(const nmEntity: PSdsName; nmSelSet: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_ssname(const nmSelSet: PSdsName; lSetIndex: Longint; nmEntity: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_ssnamex(pprbEntName: PPSdsResBuf; const nmSelSet: PSdsName; const iIndex: Longint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_sssetfirst(const nmGiveGrips: PSdsName; const nmSelectThese: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_swapscreen(): Integer; cdecl; external SDS_HOSTAPP;

function  sds_tablet(const prbGetOrSet: PSdsResBuf; pprbCalibration: PPSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_tblnext(const szTable: PChar; swFirst: Integer): PSdsResBuf; cdecl; external SDS_HOSTAPP;
function  sds_tblobjname(const szTable: PChar; const szEntInTable: PChar; nmEntName: PSdsName): Integer; cdecl; external SDS_HOSTAPP;
function  sds_tblsearch(const szTable: PChar; const szFindThis: PChar; swNextItem: Integer): PSdsResBuf; cdecl; external SDS_HOSTAPP;
function  sds_textbox(const prbTextEnt: PSdsResBuf; ptCorner: PSdsPoint; ptOpposite: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_textpage(): Integer; cdecl; external SDS_HOSTAPP;
function  sds_textscr():  Integer; cdecl; external SDS_HOSTAPP;
function  sds_tolower(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_toupper(nASCIIValue: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_trans(const ptVectOrPtFrom: PSdsPoint; prbCoordFrom: PSdsResBuf; const prbCoordTo: PSdsResBuf; swVectOrDisp: Integer; ptVectOrPtTo: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;

function  sds_ucs2rp(ptSour3D: PSdsPoint; ptDest3D: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_update(nWhichVPort: Integer; const ptCorner1: PSdsPoint; ptCorner2: PSdsPoint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_undef(const szFuncName: PChar; nFuncCode: Integer): Integer; cdecl; external SDS_HOSTAPP;
function  sds_usrbrk(): Integer; cdecl; external SDS_HOSTAPP;

function  sds_vports(prbViewSpecs: PPSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;

function  sds_wcmatch(const szCompareThis: PChar; const szToThis: PChar): integer; cdecl; external SDS_HOSTAPP;

function  sds_xdroom(const nmEntity: PSdsName; plMemAvail: PLongint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_xdsize(const prbEntData: PSdsResBuf; plMemUsed: PLongint): Integer; cdecl; external SDS_HOSTAPP;
function  sds_xformss(const nmSetName: PSdsName; mxTransform: PSdsMatrix): Integer; cdecl; external SDS_HOSTAPP;
function  sds_xload(const szApplication: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_xref(action: Char; param: PSdsResBuf): Integer; cdecl; external SDS_HOSTAPP;
function  sds_xstrcase(szString: PChar): Integer; cdecl; external SDS_HOSTAPP;
function  sds_xstrsave(szSource: PChar; pszDest: PPChar): PChar; cdecl; external SDS_HOSTAPP;
function  sds_xunload(const szApplication: PChar): Integer; cdecl; external SDS_HOSTAPP;


{:Note::
  生APIだと、ポインタを多用しているため、呼び出し側で、@演算子の連発になって
  いやんな感じなので、ラッパーを用意することにした。
  一応、本来のLisp関数と同じ感じで使えるようになっている。
  ただし、Lispと異なり、nilを返すことができない場合が多いので、
  例外で代用している。
  Lispの曖昧さをカバーするため、overloadと省略可能引数を使いまくり。
  自分の使うAPIしか作っていないので、必要に応じて増えていく予定。
::Note:}

function  SdsHandEnt(const hand: String): TSdsName;
function  SdsEntGet(const ent: TSdsName): PSdsResBuf; 

function  SdsSSGet(const method: String; filter: PSdsResBuf = nil): TSdsName;                                             overload;
function  SdsSSGet(const method: String; const pt: TSdsPoint; filter: PSdsResBuf = nil): TSdsName;                        overload;
function  SdsSSGet(const method: String; const pt1: TSdsPoint; const pt2: TSdsPoint; filter: PSdsResBuf = nil): TSdsName; overload;
function  SdsSSGet(filter: PSdsResBuf = nil): TSdsName;                                                                   overload;
function  SdsSSGet(const pt: TSdsPoint; filter: PSdsResBuf = nil): TSdsName;                                              overload;
function  SdsSSGet(const pt1: TSdsPoint; const pt2: TSdsPoint; filter: PSdsResBuf = nil): TSdsName;                       overload;
function  SdsSSName(const ss: TSdsName; idx: Longint = 0): TSdsName;
function  SdsSSFree(var ss: TSdsName): Integer;
//  ssgetファミリ

function  SdsEntNext: TSdsName;                                                 overload;
function  SdsEntNext(const known: TSdsName; first: Boolean = False): TSdsName;  overload;
//  entnextファミリ

function  SdsEntSel(const msg: String; var pos: TSdsPoint):  TSdsName; overload;
function  SdsEntSel(const msg: String): TSdsName;                      overload;
function  SdsEntSel(var pos: TSdsPoint): TSdsName;                     overload;
function  SdsEntSel: TSdsName;                                         overload;
//  entselファミリ

procedure SdsRelRB(var rb: PSdsResBuf);
//  sds_relrb()のラッパー、解放した後、rbをnilにしてくれるところが親切

function  SdsNamedObjDict: TSdsName;
function  SdsDictNext(dict: TSdsName;
                      first: Boolean = False;
                      raiseException: Boolean = False): PSdsResBuf;
function  SdsDictSearch(dict: TSdsName; const
                        find: String; needNext: Boolean = False;
                        raiseException: Boolean = False): PSdsResBuf;
function  SdsTblNext(table: String; first: Boolean = False;
                      raiseException: Boolean = False): PSdsResBuf;
function  SdsTblSearch(const table: String; const find: String;
                        needNext: Boolean = False;
                        raiseException: Boolean = False): PSdsResBuf;
function  SdsTblObjName(const table: String; const name: String): TSdsName;
//  dict,table関連
//  raiseExceptionをTrueにすると、失敗した場合に例外を発生させる

function SdsAssoc(const trg: Smallint;   rb: PSdsResBuf): PSdsResBuf;
//  いわゆるassoc
//  ただし、lisp本来の連想リストからの検索ではなく
//  trgがrbのrestypeが一致するものを探す
//  また、本来のlispでの動作とは異なり、
//  コピーを作成しないでrbに連なるリスト内のものを返す


function  SdsPrintf(const fmt: String; const args: array of const): Integer;  overload;
function  SdsPrintf(const str: String): Integer;                              overload;
function  SdsCommand(const cmd: String): Integer;
//  その他
//  SdsPrintfの可変引数版は、実は内部でFormat関数で文字列化しているので、
//  書式(fmt)の指定は、sds_printfのそれではなくDelphiのFormat関数に従う

function  SdsResTypeToComment(restype: Integer): String;
function  SdsResTypeToBufType(restype: Integer): TSdsResBufType;
function  SdsResTypeToBufTypeOnDXF(restype: Integer): TSdsResBufType;
//  これは、SDS API 自体とは全く関係ないのだけど、
//  ResType(XDFのグループコードに相当すると考える)に対応するResBuf内の
//  データの型を判別する関数
//  AutoCAD2002の資料に基づいているので
//  IntelliCADでそのまま通用するかどうかは不明
//  一部の扱いがDXF上と、実行時で異なるので、DXFでの内容をOnDXFとしている

function  SdsMakeList(const Args: array of const): PSdsResBuf;
//  これも、SDS API にはないのだけど、sds_buildlistのお手軽版
//  restypeは、この関数内で勝手に判断してくれるので、値だけを指定すればいい
//  SDS_RTREAL, SDS_RTLONG, SDS_RTENAME, SDS_RTSTR しか作れないけど
//  まぁ、これだけで事足りることも、ままあるわけでよしとする

function SdsResBuf(restype: Smallint; const value): TSdsResBuf;
//  sds_buildlistではなく、Delphiの世界でTSdsResBufを作る関数
//  解放しなくていいので便利
//  ただし、restypeとvalueの整合性の保証はユーザ側で行う必要がある
//  特に、Binary(のポインタ)や文字列の場合には、valueとして渡された
//  もののポインタを代入しているので、valueの実体が寿命を終えると、
//  不正な状態になってしまうので注意
//  また、型の判別はSdsResTypeToBufType()が正しいという前提で行っているので、
//  微妙なrestypeは指定しないほうがよい


{$IFNDEF NO_SDSENTRY}

{:Note::
  ここからは、エントリポイント用のprocedure/function群

  これを使う場合、エントリポイントの内容は固定されてしまうので、
  何か特別なことをしたい場合(普通、ユーザ定義関数の登録とか、
  削除をするはず)は、SdsAddUserProc()で、procedureを登録しておく
  といっても、SDS_EntryPointは、SDSアプリケーションがロードされると
  直ちに実行されてしまうので、
  登録自体は、ユニットの初期化部(initialization)で行う必要がある
  まぁ、普通はSdsAtXLOADでcallbackを登録するとかするくらいのはず。

  ちなみに、SdsAddUserFunc()でユーザ定義関数を登録しておけば、
  SdsAtXLOAD時に登録、SdsAtXUNLD時に削除してくれるので、
  それについては、ユーザ側でやる必要はない

  ユーザ処理、ユーザ定義関数とも、その中で発生した例外は
  (Exceptionの派生であれば)SDS_EntryPointで捕捉して、
  メッセージを表示するようになっている。
:::Note:}

procedure SDS_EntryPoint(hWnd: HWND); stdcall;
//  IntelliCADのSDSとして必要なエントリポイント

procedure SdsAddUserProc(proc: TSdsUserProc; at: TSdsUserProcAt);
//  ユーザ側の処理の登録
//  これで登録しておくと、atで指定されたタイミングでprocを実行する

procedure SdsAddUserFunc(const name: String; const func: TSdsUserFunc); overload;
procedure SdsAddUserFunc(const funcdef: TSdsFuncDef);                   overload;
procedure SdsAddUserFunc(const funcdefs: array of TSdsFuncDef);         overload;
//  ユーザ関数定義の追加

function SdsAppName:    String; //  アプリケーション名(フルパス)
function SdsHWndAcad:   HWND;   //  IntelliCAD のWindowHandle
function SdsHInstAcad:  HINST;  //  IntelliCAD のInstanceHandle
//  エントリポイントで設定された情報を取り出す関数群

exports
  SDS_EntryPoint;

{$ENDIF}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
implementation

{$IFNDEF NO_SDSENTRY}
var
  sdsw_AppName:   array [0..511] of Char;
  sdsw_hwndAcad:  HWND;
  sdsw_hInstance: HINST;
  //  IntelliCADのインスタンスの情報を保持する変数

  UserProcs: array [TSdsUserProcAt] of array of TSdsUserProc;
  UserFuncs: array of TSdsFuncDef;
  //  ユーザ処理とユーザ定義関数を保持する動的配列

{$ENDIF}

///////////////////////////////////////////////////////////////////////////
{ エントリポイント関連 }

{$IFNDEF NO_SDSENTRY}

function SdsAppName: String;
begin
  Result := sdsw_AppName;
end;

function SdsHWndAcad: HWND;
begin
  Result := sdsw_hwndAcad;
end;

function SdsHInstAcad: HINST;
begin
  Result := sdsw_hInstance;
end;

procedure SdsAddUserProc(proc: TSdsUserProc; at: TSdsUserProcAt);
var
  n: Integer;
begin
  n := Length(UserProcs[at]);
  SetLength(UserProcs[at], n + 1);
  UserProcs[at][n] := proc;
end;

procedure SdsAddUserFunc(const name: String; const func: TSdsUserFunc);
var
  funcdef: TSdsFuncDef;
begin
  funcdef.funcName := name;
  funcdef.func     := func;
  SdsAddUserFunc(funcdef);
end;

procedure SdsAddUserFunc(const funcdef: TSdsFuncDef);
var
  n: Integer;
begin
  n := Length(UserFuncs);
  SetLength(UserFuncs, n + 1);
  UserFuncs[n] := funcdef;
end;

procedure SdsAddUserFunc(const funcdefs: array of TSdsFuncDef);
var
  i: Integer;
begin
  if Length(funcdefs) > 0
  then for i := Low(funcdefs) to High(funcdefs) do SdsAddUserFunc(funcdefs[i]);
end;

//  UserProcとして登録して使う
procedure DefUserFuncs;
var
  i: Integer;
begin
  if Length(UserFuncs) > 0 then for i := Low(UserFuncs) to High(UserFuncs) do
  begin
    if sds_defun(PChar(UserFuncs[i].funcName), i - Low(UserFuncs)) < 0
    then SdsPrintf(#10'error: in adding (%s)', [UserFuncs[i].funcName])
    else if UpperCase(Copy(UserFuncs[i].funcName, 1, 2)) = 'C:'
    then SdsPrintf(#10'added: (%s) command',   [UserFuncs[i].funcName])
    else SdsPrintf(#10'added: (%s) function',  [UserFuncs[i].funcName]);
  end;
  SdsPrintf(#10);
end;

//  UserProcとして登録して使う
procedure UndefUserFuncs;
var
  i: Integer;
begin
  if Length(UserFuncs) > 0 then for i := Low(UserFuncs) to High(UserFuncs) do
  begin
    sds_undef(PChar(UserFuncs[i].funcName), i);
  end;
end;

//  ユーザ定義関数の実行
function ExecUserFunc: Integer;
var
  rb:  PSdsResBuf;
  idx: Integer;
begin
  idx := sds_getfuncode;
  rb  := sds_getargs;

  if      Low(UserFuncs)  > idx then Result := SDS_RSERR
  else if High(UserFuncs) < idx then Result := SDS_RSERR
	else
  begin
    try
      Result := UserFuncs[idx].func(rb);
    except
      on e: Exception do
      begin
        SdsPrintf(#10'%s ', [e.Message]);
        Result := SDS_RSERR;
      end;
    end;
  end;
  if Assigned(rb) then sds_relrb(rb);

  {:Note::
    正常終了時は、SDS_RTNORMを返すのが慣習らしい。
    でも、SDSの仕様では、返り値は SDS_RSRSLT、SDS_RSERRのどちらかであるらしい。
    そういうわけで、返り値を変更する。
    なんかふに落ちないけど
  ::Note:}
  if Result = SDS_RTNORM
  then Result := SDS_RSRSLT
  else Result := SDS_RSERR;
end;

procedure SDS_EntryPoint(hWnd: HWND); stdcall;
var
  rslt: Integer;
  stat: Integer;

  function execUserProc(at: TSdsUserProcAt): Integer;
  var
    i: Integer;
  begin
    Result := SDS_RSRSLT;
    if Length(UserProcs[at]) > 0
    then for i := Low(UserProcs[at]) to High(UserProcs[at]) do
    begin
      try
        UserProcs[at][i];
      except
        on e: Exception do
        begin
          SdsPrintf(#10'%s ', [e.Message]);
          Result := SDS_RSERR;
        end;
      end;
    end
  end;

begin
  // 初期化
  SDS_GetGlobals(@sdsw_AppName[0], @sdsw_hwndAcad, @sdsw_hInstance);
  sds_init(1, @sdsw_AppName);

  //  ユーザ定義関数関連の処理の登録
  SdsAddUserProc(DefUserFuncs,   SdsAtXLOAD);
  SdsAddUserProc(UndefUserFuncs, SdsAtXUNLD);

  //  メイン・ループ
  rslt := SDS_RSRSLT;
  while True do
  begin
    stat := sds_link(rslt);
		// リクエスト番号による分岐
		case stat of
      SDS_RQXLOAD:  rslt := execUserProc(SdsAtXLOAD);
      SDS_RQXUNLD:  rslt := execUserProc(SdsAtXUNLD);
 			SDS_RQSUBR:	  rslt := ExecUserFunc;
			SDS_RQSAVE:   rslt := execUserProc(SdsAtSAVE);
			SDS_RQEND:    rslt := execUserProc(SdsAtEND);
			SDS_RQQUIT:   rslt := execUserProc(SdsAtQUIT);
			SDS_RQCFG:    rslt := execUserProc(SdsAtCFG);
			SDS_RQHUP:    rslt := execUserProc(SdsAtHUP);
			SDS_RQXHELP:  rslt := execUserProc(SdsAtXHELP);
    else
      if stat < 0 then sds_exit(-1);
		end;
	end;
end;

{$ENDIF}


///////////////////////////////////////////////////////////////////////////
{ SDS API ラッパー関連 }

function SdsPrintf(const fmt: String; const args: array of const): Integer;
var
  s: String;
  f: String;
begin
  f := '%s';
  if Length(Args) = 0
  then s := fmt
  else s := Format(fmt, args);
  Result := sds_printf(PChar(f), PChar(s));
end;

function SdsPrintf(const str: String): Integer;
var
  f: String;
begin
  f := '%s';
  Result := sds_printf(PChar(f), PChar(str));
end;

function  SdsCommand(const cmd: String): Integer;
var
  rb: PSdsResBuf;
begin
  rb := sds_buildlist(SDS_RTSTR, PChar(cmd), 0);
  try
    Result := sds_cmd(rb);
  finally
    sds_relrb(rb);
  end;
end;

function SdsHandEnt(const hand: String): TSdsName;
begin
  if sds_handent(PChar(hand), @Result) <> SDS_RTNORM
  then raise ESdsErrNotFound.Create('SdsHandEnt is failed.');
end;

function  SdsEntGet(const ent: TSdsName): PSdsResBuf;
begin
  Result := sds_entget(@ent);
end;

procedure SdsRelRB(var rb: PSdsResBuf);
begin
  if Assigned(rb) then
  begin
    sds_relrb(rb);
    rb := nil;
  end;
end;

function SdsAssoc(const trg: Smallint;   rb: PSdsResBuf): PSdsResBuf;
begin
  Result := rb;
  while Assigned(Result) and (Result.restype <> trg)
  do Result := Result.rbnext;
end;

////////////////////////////////////////////////////////
{ SdsSSGet ファミリ }

function SdsSSGet(const mp: PChar; const p1: Pointer; const p2: Pointer; const fp: PSdsResBuf): TSdsName; overload;
begin
  if sds_ssget(mp, p1, p2, fp, @Result) <> SDS_RTNORM
  then raise ESdsErrNotFound.Create('SdsSSGet is failed.');
end;

function  SdsSSGet(const method: String; filter: PSdsResBuf = nil): TSdsName;
begin
  Result := SdsSSGet(PChar(method), nil, nil, filter);
end;

function  SdsSSGet(const method: String; const pt: TSdsPoint; filter: PSdsResBuf = nil): TSdsName;
begin
  Result := SdsSSGet(PChar(method), @pt, nil, filter);
end;

function  SdsSSGet(const method: String; const pt1: TSdsPoint; const pt2: TSdsPoint; filter: PSdsResBuf = nil): TSdsName;
begin
  Result := SdsSSGet(PChar(method), @pt1, @pt2, filter);
end;

function  SdsSSGet(filter: PSdsResBuf = nil): TSdsName;
begin
  Result := SdsSSGet(nil, nil, nil, filter);
end;

function  SdsSSGet(const pt: TSdsPoint; filter: PSdsResBuf = nil): TSdsName;
begin
  Result := SdsSSGet(nil, @pt, nil, filter);
end;

function  SdsSSGet(const pt1: TSdsPoint; const pt2: TSdsPoint; filter: PSdsResBuf = nil): TSdsName;
begin
  Result := SdsSSGet(nil, @pt1, @pt2, filter);
end;

function SdsSSName(const ss: TSdsName; idx: Longint): TSdsName;
begin
  if sds_ssname(@ss, idx, @Result) <> SDS_RTNORM
  then raise ESdsErrNotFound.Create('SdsSSName is failed.');
end;

function SdsSSFree(var ss: TSdsName): Integer;
begin
  Result := sds_ssfree(@ss);
  ss := 0;    //for safety!
end;

////////////////////////////////////////////////////////
{ SdsEntNext ファミリ }

function  SdsEntNext: TSdsName;
begin
  if sds_entnext(nil, @Result) <> SDS_RTNORM
  then raise ESdsNoMoreLoop.Create('SdsEntNext is finished.');
end;

function  SdsEntNext(const known: TSdsName; first: Boolean): TSdsName;
var
  ret: Integer;
begin
  if first
  then ret := sds_entnext(nil,    @Result)
  else ret := sds_entnext(@known, @Result);

  if ret <> SDS_RTNORM
  then raise ESdsNoMoreLoop.Create('SdsEntNext is finished.');
end;

////////////////////////////////////////////////////////
{ SdsEntSel ファミリ }

function  SdsEntSel(const msg: String; var pos: TSdsPoint):  TSdsName;
begin
  if sds_entsel(PChar(msg), @Result, @pos) <> SDS_RTNORM
  then raise ESdsErrNotFound.Create('SdsEntSel is failed.');
end;

function  SdsEntSel(const msg: String): TSdsName;
var
  pos: TSdsPoint;
begin
  Result := SdsEntSel(msg, pos);
end;

function  SdsEntSel(var pos: TSdsPoint): TSdsName;
begin
  if sds_entsel(nil, @Result, @pos) <> SDS_RTNORM
  then raise ESdsErrNotFound.Create('SdsEntSel is failed.');
end;

function  SdsEntSel(): TSdsName;
var
  pos: TSdsPoint;
begin
  Result := SdsEntSel(pos);
end;


////////////////////////////////////////////////////////
{ dict,table ファミリ }

function  SdsNamedObjDict: TSdsName;
begin
  if sds_namedobjdict(@Result) <> SDS_RTNORM
  then raise ESdsErrNotFound.Create('SdsNamedObjDict is failed.');
end;

function  SdsDictNext(dict: TSdsName; first: Boolean;
                      raiseException: Boolean): PSdsResBuf;
begin
  if first
  then Result := sds_dictnext(@dict, 1)
  else Result := sds_dictnext(@dict, 0);

  if raiseException and (not Assigned(Result))
  then raise ESdsNoMoreLoop.Create('SdsDictNext is finished.');
end;

function  SdsDictSearch(dict: TSdsName; const find: String;
                        needNext: Boolean;
                        raiseException: Boolean): PSdsResBuf;
begin
  if needNext
  then Result := sds_dictsearch(@dict, PChar(find), 1)
  else Result := sds_dictsearch(@dict, PChar(find), 0);

  if raiseException and (not Assigned(Result))
  then raise ESdsErrNotFound.Create('SdsDictSearch is failed.');
end;


function  SdsTblNext(table: String; first: Boolean;
                      raiseException: Boolean): PSdsResBuf;
begin
  if first
  then Result := sds_tblnext(PChar(table), 1)
  else Result := sds_tblnext(PChar(table), 0);

  if raiseException and (not Assigned(Result))
  then raise ESdsNoMoreLoop.Create('SdsTblNext is finished.');
end;

function  SdsTblSearch(const table: String; const find: String;
                      needNext: Boolean;
                      raiseException: Boolean): PSdsResBuf;
begin
  if needNext
  then Result := sds_tblsearch(PChar(table), PChar(find), 1)
  else Result := sds_tblsearch(PChar(table), PChar(find), 0);

  if raiseException and (not Assigned(Result))
  then raise ESdsErrNotFound.Create('SdsTblSearch is failed.');
end;

function  SdsTblObjName(const table: String; const name: String): TSdsName;
begin
  if sds_tblobjname(PChar(table), PChar(name), @Result) <> SDS_RTNORM
  then raise ESdsErrNotFound.Create('SdsTblObjName is failed.');
end;

////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
{ RestType関連 }

{:Note::
  この内容は、XDF Referenceを参考にした。
  詳細は、
  http://usa.autodesk.com/adsk/item/0,,752569-123112,00.html
  あたりで公開されているドキュメントを参照してね。
  5000番台については、ドキュメントには記載がなかったので、
  SDS_RT????を使用した。
::Note:}
function  SdsResTypeToBufType(restype: Integer): TSdsResBufType;
begin
  case restype of
    -1:             Result := SdsRName;
    110..112:       Result := SdsRPoint;
    210:            Result := SdsRPoint;
    330..369:       Result := SdsRName;
    1010..1013:     Result := SdsRPoint;
    SDS_RTNONE:     Result := SdsRUnkown;   //'No result';
    SDS_RTREAL:     Result := SdsRReal;     //'Real number';
    SDS_RTPOINT:    Result := SdsRPoint;    //'2-D point (x, y)';
    SDS_RTSHORT:    Result := SdsRInt;      //'Short integer';
    SDS_RTANG:      Result := SdsRPoint;    //'Angle';
    SDS_RTSTR:      Result := SdsRString;   //'String';
    SDS_RTENAME:    Result := SdsRName;     //'Entity name';
    SDS_RTPICKS:    Result := SdsRUnkown;   //'Pick set';  SdsRNameかも(?)
    SDS_RTORINT:    Result := SdsRReal;     //'Orientation';
    SDS_RT3DPOINT:  Result := SdsRPoint;    //'3-D point (x, y, z)';
    SDS_RTLONG:     Result := SdsRLong;     //'Long integer';
    SDS_RTVOID:     Result := SdsRUnkown;   //'Blank symbol';
    SDS_RTLB:       Result := SdsRUnkown;   //'Begin list';
    SDS_RTLE:       Result := SdsRUnkown;   //'End of list';
    SDS_RTDOTE:     Result := SdsRUnkown;   //'Dotted pair';
    SDS_RTNIL:      Result := SdsRUnkown;   //'Nil';
    SDS_RTDXF0:     Result := SdsRUnkown;   //'DXF code 0 (for sds_buildlist)';
    SDS_RTT:        Result := SdsRUnkown;   //'T (true) atom';
    SDS_RTBINARY:   Result := SdsRBinary;
    SDS_RTRESBUF:   Result := SdsRUnkown;
    SDS_RTNORM:     Result := SdsRUnkown;
    SDS_RTDRAGPT:   Result := SdsRPoint;
  else              Result := SdsRUnkown;
  end;
  //Note::  330..369については、DXF上では、String representing hex object IDs
  //Note::  とあるけど、実行時にはEntity nameだったと思う
 if Result = SdsRUnkown then Result := SdsResTypeToBufTypeOnDXF(restype);

end;

function  SdsResTypeToBufTypeOnDXF(restype: Integer): TSdsResBufType;
begin
  case restype of
    40..59:     Result := SdsRReal;
    110..119:   Result := SdsRReal;
    120..129:   Result := SdsRReal;
    130..139:   Result := SdsRReal;
    140..149:   Result := SdsRReal;
    210..239:   Result := SdsRReal;
    1010..1059: Result := SdsRReal;
    60..79:     Result := SdsRInt;
    170..179:   Result := SdsRInt;
    270..279:   Result := SdsRInt;
    280..289:   Result := SdsRInt;
    290..299:   Result := SdsRInt;
    370..379:   Result := SdsRInt;
    380..389:   Result := SdsRInt;
    400..409:   Result := SdsRInt;
    1060..1070: Result := SdsRInt;
    90..99:     Result := SdsRLong;
    1071:       Result := SdsRLong;
    10..39:     Result := SdsRPoint;
    0..9,100:   Result := SdsRString;
    102, 105:   Result := SdsRString;
    300..369:   Result := SdsRString;
    390..399:   Result := SdsRString;
    410..419:   Result := SdsRString;
    999..1009:  Result := SdsRString;
  else          Result := SdsRUnkown;
  end;
  //  100,102は255文字まで、それ以外は字数制限はないとのこと
end;

function  SdsResTypeToComment(restype: Integer): String;
begin
  case restype of
    -5:       Result := 'パーシステントなリアクタ・チェイン(？) [APP]';       //'persistent reactor chain (APP)';
    -4:       Result := '条件付オペレータ(？) [APP]';                         //'conditional operator (APP)';
    -3:       Result := 'XDATA(拡張データ)の区切り *';                        //'* XDATA sentinel (APP)';
    -2:       Result := 'エンティティ名参照(？) * [APP]';                     //'* Entity name reference (APP)';
    -1:       Result := 'エンティティ名(64bit整数) * [APP])';                 //'* Entity name (APP)';
    0:        Result := 'エンティティ・タイプ *';                             //'* Entity type';
    1:        Result := 'エンティティの主要な文字列';                         //'Primary text value for an entity';
    2:        Result := '名前(TAGやブロック名等)';                            //'Name (tag, block name, and so on)';
    3..4:     Result := 'その他の名前';                                       //'Other text or name values';
    5:        Result := 'エンティティ・ハンドル *';                           //'* Entity handle';
    6:        Result := '線種名 *';                                           //'Linetype name';
    7:        Result := 'テキスト・スタイル名 *';                             //'Text style name';
    8:        Result := '画層(レイヤ)名 *';                                   //'Layer name';
    9:        Result := '変数名 [DXF]';                                       //'Variable name identifier (DXF)';
    10:       Result := '主要な3D座標 DXFではX座標';                          //'Primary point';
    11..18:   Result := 'その他の3D座標 DXFではX座標';                        //'Other points';
    20:       Result := '主要なY座標 [DXF]';                                  //'Y values of the primary point (DXF)';
    30:       Result := '主要なZ座標 [DXF]';                                  //'Z values of the primary point (DXF)';
    21..28:   Result := 'その他のY座標 [DXF]';                                //'Y values of other points (DXF)';
    31..37:   Result := 'その他のZ座標 [DXF]';                                //'Y values of other points (DXF)';
    38:       Result := 'エンティティの高さ(0でない場合)';                    //'Elevation of entity if nonzero (DXF)';
    39:       Result := 'エンティティの厚さ(0でない場合) *';                  //'Thickness of Entity if nonzero';
    40..47:   Result := '文字の高さやスケールファクタ等';                     //'Text height, scale factors, and so on';
    48:       Result := '線種のスケール(?)';                                  //'Linetype scale';
    49:       Result := 'LTYPEテーブルのダッシュの長さなど';                  //'Such as the dash lengths in the LTYPE table';
    50..58:   Result := '角度(DXFでは度、APPではrad)';                        //'Angles (degrees at DXF, radians at APP)';
    60:       Result := 'エンティティの可視性';                               //'Entity visibility';
    62:       Result := 'カラー番号 *';                                       //* Color number';
    66:       Result := 'エンティティに付随するフラグ(?) *';                  //'* "Entities follow" flag';
    67:       Result := 'モデル空間かペーパー空間かの区別 *';                 //'* Space?that is, model or paper space';
    68:       Result := 'ビューポートがONかどうか [APP]';                     //'Viewport is on ? (APP)';
    69:       Result := 'ビューポートID番号 [APP]';                           //'Viewport identification number (APP)';
    70..78:   Result := '繰返し回数や、フラグ・ビット、モードなど';           //'Such as repeat counts, flag bits, or modes';
    90..99:   Result := '32bit整数値';                                        //'32-bit integer values';
    100:      Result := 'サブクラス・マーカ';                                 //'Subclass data marker.';
    102:      Result := '制御文字列("{????" か "}")';                         //'Control string, followed by "{<arbitrary name>" or "}".';
    105:      Result := 'DIMSTYLEテーブルのオブジェクト・ハンドル';           //'Object handle for DIMVAR symbol table entry';
    110:      Result := 'UCSの原点の3D座標 DXFではX座標';                     //'UCS origin (appears only if code 72 is set to 1)';
    111:      Result := 'UCSのX軸方向 DXFではX成分';                          //X-axis (appears only if code 72 is set to 1)';
    112:      Result := 'UCSのY軸方向 DXFではX成分';                          //'UCS Y-axis (appears only if code 72 is set to 1)';
    120:      Result := 'UCSの原点のY座標 [DXF]';                             //'Y value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    121:      Result := 'UCSのX軸方向のY成分 [DXF]';                          //'Y value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    122:      Result := 'UCSのY軸方向のY成分 [DXF]';                          //Y value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    130:      Result := 'UCSの原点のY座標 [DXF]';                             //'Z value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    131:      Result := 'UCSのX軸方向のZ成分 [DXF]';                          //'Z value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    132:      Result := 'UCSのY軸方向のZ成分 [DXF]';                          //'Z value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    140..149: Result := '座標や、高さ、DIMSTYLE設定など';                     //'Points, elevation, and DIMSTYLE settings, for example';
    170..179: Result := 'フラグ・ビットやDIMSTYLE設定など';                   //'Such as flag bits representing DIMSTYLE settings';
    210:      Result := '押出し方向 DXFではX成分 *';                          //'* Extrusion direction';
    220:      Result := '押出し方向 DXFではX成分';                            //'Y values of the extrusion direction (DXF)';
    230:      Result := '押出し方向 DXFではX成分';                            //'Z values of the extrusion direction (DXF)';
    270..279: Result := '16bit整数値';                                        //'16-bit integer values';
    280..289: Result := '16bit整数値';                                        //'16-bit integer values';
    290..299: Result := '論理フラグ';                                         //'Boolean flag value';
    300..309: Result := '任意の文字列';                                       //'Arbitrary text strings';
    310..319: Result := '任意のバイナリ(with hexadecimal strings？)';         //Arbitrary binary chunks with hexadecimal strings';
    320..329: Result := '任意のオブジェクト・ハンドル';                       //'Arbitrary object handles';
    330..339: Result := 'ソフト・ポインタ(64bit整数) DXFではハンドル';        //'Soft-pointer handle';
    340..349: Result := 'ハード・ポインタ(64bit整数) DXFではハンドル';        //'Hard-pointer handle';
    350..359: Result := 'ソフト・オーナ(64bit整数) DXFではハンドル';          //Soft-owner handle';
    360..369: Result := 'ハード・オーナ(64bit整数) DXFではハンドル';          //Hard-owner handle';
    370..379: Result := 'ラインウェイト(?)の順序番号(?)';                     //'Lineweight enum value (AcDb::LineWeight).';
    380..389: Result := 'プロットスタイルの順序番号';                         //'PlotStyleName type enum (AcDb::PlotStyleNameType).';
    390..399: Result := 'ハンドル値を繰り返した文字列';                       //'String representing handle value';
    400..409: Result := '16bit整数値';                                        //'16-bit Integers';
    410..419: Result := '文字列';                                             //'String';
    999:      Result := 'コメント文字列 [DXF]';                               //'Comment string (DXF)';
    1000:     Result := '[XDATA] 文字列(255byteまで)';                        //'ASCII string in XDATA (up to 255 bytes long)';
    1001:     Result := '[XDATA] アプリケーション名(31byteまで)';             //'Application name for XDATA (up to 31 bytes long)';
    1002:     Result := '[XDATA] 制御文字列("{" か "}")';                     //'XDATA control string ("{" or "}")';
    1003:     Result := '[XDATA] 画層(レイヤ)名';                             //'XDATA layer name';
    1004:     Result := '[XDATA] バイナリデータ(127byteまで)';                //'Chunk of bytes in XDATA (up to 127 bytes long)';
    1005:     Result := '[XDATA] エンティティ・ハンドル';                     //'Entity handle in XDATA';
    1010:     Result := '[XDATA] 3D座標 DXFではX座標';                        //'A point in XDATA';
    1020:     Result := '[XDATA] Y座標 [DXF]';                                //'Y values of a point in XDATA (DXF)';
    1030:     Result := '[XDATA] Z座標 [DXF]';                                //'Z values of a point in XDATA (DXF)';
    1011:     Result := '[XDATA] ワールド空間の3D座標 DXFではX座標';          //'A 3D world space position in XDATA';
    1021:     Result := '[XDATA] ワールド空間のY座標 [DXF]';                  //'Y values of a world space position in XDATA (DXF)';
    1031:     Result := '[XDATA] ワールド空間のZ座標 [DXF]';                  //'Z values of a world space position in XDATA (DXF)';
    1012:     Result := '[XDATA] ワールド空間変位(?)の3D座標 DXFではX座標';   //'A 3D world space displacement in XDATA';
    1022:     Result := '[XDATA] ワールド空間変位(?)のY座標 [DXF]';           //'Y values of a world space displacement in XDATA (DXF)';
    1032:     Result := '[XDATA] ワールド空間変位(?)のZ座標 [DXF]';           //'Z values of a world space displacement in XDATA (DXF)';
    1013:     Result := '[XDATA] ワールド空間の方向 DXFではX成分';            //'A 3D world space direction in XDATA';
    1023:     Result := '[XDATA] ワールド空間の方向のY成分 [DXF]';            //'Y values of a world space direction in XDATA (DXF)';
    1033:     Result := '[XDATA] ワールド空間の方向のZ成分 [DXF]';            //'Z values of a world space direction in XDATA (DXF)';
    1040:     Result := '[XDATA] 実数値';                                     //'Extended data double precision floating point value';
    1041:     Result := '[XDATA] 距離';                                       //'Extended data distance value';
    1042:     Result := '[XDATA] スケール・ファクタ';                         //'Extended data scale factor';
    1070:     Result := '[XDATA] 16bit整数値';                                //'Extended data 16-bit signed integer';
    1071:     Result := '[XDATA] 32bit整数値';                                //'Extended data 32-bit signed long';
    SDS_RTNONE:     Result := 'データなし(sds_buildlist()の終端)';            //'No result';
    SDS_RTREAL:     Result := '実数(リスト作成用)';                           //'Real number';
    SDS_RTPOINT:    Result := '2D座標(リスト作成用)';                         //'2-D point (x, y)';
    SDS_RTSHORT:    Result := '16bit整数値(リスト作成用)';                    //'Short integer';
    SDS_RTANG:      Result := '角度(リスト作成用)';                           //'Angle';
    SDS_RTSTR:      Result := '文字列(sds_buildlist()用)';                    //'String';
    SDS_RTENAME:    Result := 'エンティティ名(64bit整数 リスト作成用)';       //'Entity name';
    SDS_RTPICKS:    Result := 'Pick set(って何？) (リスト作成用)';            //'Pick set';
    SDS_RTORINT:    Result := '方向(リスト作成用)';                           //'Orientation';
    SDS_RT3DPOINT:  Result := '3D座標(リスト作成用)';                         //'3-D point (x, y, z)';
    SDS_RTLONG:     Result := '32bit整数値(リスト作成用)';                    //'Long integer';
    SDS_RTVOID:     Result := '空欄(?)(リスト作成用)';                        //'Blank symbol';
    SDS_RTLB:       Result := '"("開き括弧(リスト作成用)';                    //'Begin list';
    SDS_RTLE:       Result := '"("閉じ括弧(リスト作成用)';                    //'End of list';
    SDS_RTDOTE:     Result := 'ドット・ペアのドット(リスト作成用)';           //'Dotted pair';
    SDS_RTNIL:      Result := 'nil(リスト作成用)';                            //'Nil';
    SDS_RTDXF0:     Result := '0 (sds_buildlist()での0の代わり)';             //'DXF code 0 (for sds_buildlist)';
    SDS_RTT:        Result := 'T (真値 リスト作成用)';                        //'T (true) atom';
    SDS_RTBINARY:   Result := 'バイナリ・データ(リスト作成用)';               //'Binary data';
    SDS_RTRESBUF:   Result := 'リザルト・バッファ(?) (リスト作成用)';         //'Result buffer';
    SDS_RTDRAGPT:   Result := 'ドラッグ・ポイント(?) (リスト作成用)';         //'Drag point';
  else        Result := 'unknown';
  end;
end;

//////////////////////////////////////////
{ ResBufを作るやつ }

function SdsResBuf(restype: Smallint; const value): TSdsResBuf;
begin
  Result.restype := restype;
  Result.rbnext  := nil;
  case SdsResTypeToBufType(restype) of
    SdsRUnkown: Result.DebDump := TSdsResBufDump(value);  //  無理矢理コピー
    SdsRReal:   Result.rreal   := Double(value);
    SdsRPoint:  Result.rpoint  := TSdsPoint(value);
    SdsRInt:    Result.rint    := Smallint(value);
    SdsRString: Result.rstring := PChar(value);
    SdsRName:   Result.rlname  := TSdsName(value);
    SdsRLong:   Result.rlong   := Longint(value);
    SdsRBinary: Result.rbinary := TSdsBinary(value);
  end;
  //  文字列の場合のvalueの寿命については目をつぶる
end;

function SdsMakeList(const Args: array of const): PSdsResBuf;
const
  BoolVals: array[Boolean] of Integer = (0, 1);
var
  i: Integer;
  tail: PSdsResBuf;

  function buildListStr(s: String): PSdsResBuf;
  begin
    Result := sds_buildlist(SDS_RTSTR, PChar(s), 0);
  end;

  function buildListDbl(v: Double): PSdsResBuf;
  begin
    Result := sds_buildlist(SDS_RTREAL, @v, 0);
  end;

  function buildBuf(v: TVarRec): PSdsResBuf;
  begin
    Result := nil;
    case v.VType of
      vtInteger:    Result := sds_buildlist(SDS_RTLONG, v.VInteger, 0);
      vtBoolean:    Result := sds_buildlist(SDS_RTLONG, boolVals[v.VBoolean], 0);
      vtExtended:   Result := buildListDbl(v.VExtended^);
      vtInt64:      Result := sds_buildlist(SDS_RTENAME, @v.VInt64, 0);
      vtPChar:      Result := sds_buildlist(SDS_RTSTR, v.VPChar, 0);
      vtChar:       Result := buildListStr(v.VChar);
      vtString:     Result := buildListStr(String(v.VString^));
      vtAnsiString: Result := buildListStr(String(v.VAnsiString));
      //vtPointer:    Result := sds_buildlist(SDS_RTBINARY, v.VPointer, 0);
    end;
  end;

begin
  Result := nil;
  if Length(Args) = 0 then Exit;

  Result := buildBuf(Args[0]);
  tail := Result;
  if tail = nil then Exit;

  if Length(Args) > 1 then for i := 1 to Length(Args) - 1 do
  begin
    tail^.rbnext := buildBuf(Args[i]);
    tail := tail^.rbnext;
    if tail = nil then
    begin
      //  なんか失敗した
      sds_relrb(Result);
      Result := nil;
      Exit;
    end;
  end;
end;
{:Note::
  sds_buildlist()が可変引数を受け付けてくれるので、
  不要かなと思ったのだけど、指定するタイプと実際に渡す変数の整合性が
  ユーザまかせで、怖いものがあるので、名前を変えて残した。
  # けっこう深いところをついているコードなので、
  # 捨てるのがもったいないというのもある
  sds_buildlist()とは異なり、この関数内で型の面倒は見てくれるので、
  引数の配列には変数のみを並べればよい。

  可変引数をいっきに渡すことができないので、
  １つづつResBufを作って、それを自分でつないでいる
  こうして作ったリストをSdsRelRB()に渡したときにちゃんと
  全部リリースしてくれるのか不安がないではないが、
  Lispのセル単位でメモリの管理してくれているのであれば、
  大丈夫なはず。
  もし、sds_buildbuf()されるごと、必要な分をまとめてmalloc()とか
  してるのだとすると(まず考えられないが)、見事にメモリリークする。
  時間がとれたら確認することにしよう。

  ということで以下のコメントアウトされているprocedureで確認した。
    ・resbufは、1セルにつき32バイト割り当てられる
      # pの値の間隔が最短で32バイトだった。
    ・sds_buildlist()で、まとめてアロケートしているのではないらしい
      # pのアドレスがバラバラ
    ・rstringの内容は、それぞれのセル毎にコピーされる
      # 個々のp.rstringと元のsのどれも別のアドレスになっていた
    ・rstring用に確保される領域のサイズは不明
      # ちなみに、元の文字列が7バイトの時の最短の間隔は24バイトだった
  ということで、
    ・セルのメモリ管理は、きちんとやっているので、
      sds_buildlistの結果をこっちでつなぎ直しても、まず問題ないと思う
    ・やっぱり、rstringは参照のみに使用して、値を変えたりしない方が無難
      # SampleにあるShowURLなんかだと、
      # rstringにstrcpy()とかしちゃってたりするけど。
::Note:}

{:CommentOut::
procedure SdsResBufTest;
var
  rb: PSdsResBuf;
  p: PSdsResBuf;
  s: String;
  t: String;

  function dump(s: String): String;
  var
    i, v: Integer;
  begin
    Result := '';
    if Length(s) > 0 then for i := 1 to Length(s) do
    begin
      v := Ord(s[i]);
      Result := Result + Copy('0123456789ABCDEF', v div 16 + 1, 1);
      Result := Result + Copy('0123456789ABCDEF', v mod 16 + 1, 1);
      Result := Result + ' ';
    end;
  end;

begin

  //s := 'dummy of long long string. ';
  //s := s + 'なんだかもうやんなっちゃうくらい長い文字列を';
  //s := s + '作らなきゃならないんだけど。';
  //s := s + 'そんな文字列を作ること自体がやんなっちゃうわけで、';
  //s := s + 'いい加減このくらいあれば比較対照としては、十分なんだろうか？';
  //s := s + 'でもやっぱり、この手のものとしては、';
  //s := s + '最低でも２５６バイトは超えていないと長いとはいえないわけで。';
  //s := s + 'と、この辺までくればいいだろう。';

  s := 'dummy.';

  SetLength(t, 256);
  rb := sds_buildlist(SDS_RTSTR, PChar(s),  // 0
                      SDS_RTSTR, PChar(s),  // 1
                      SDS_RTSTR, PChar(s),  // 2
                      SDS_RTSTR, PChar(s),  // 3
                      SDS_RTSTR, PChar(s),  // 4
                      SDS_RTSTR, PChar(s),  // 5
                      SDS_RTSTR, PChar(s),  // 6
                      SDS_RTSTR, PChar(s),  // 7
                      SDS_RTSTR, PChar(s),  // 8
                      SDS_RTSTR, PChar(s),  // 9
                      0);
  //  一度に、まとめてbuildlistする

  try
    SdsPrintf(#10'@s = ' + IntToHex(Cardinal(PChar(s)), 8));
    SdsPrintf( #9's(%d) = %s', [ Length(s), s]);
    SdsPrintf( #9 + dump(s));
    p := rb;
    while p <> nil do
    begin
      SdsPrintf(#10'@s = ' + IntToHex(Cardinal(p.rstring), 8));
      SdsPrintf( #9'@p = ' + IntToHex(Cardinal(p), 8));
      Move(p.rstring^, t[1], 256);
      SdsPrintf(#9 + dump(t));
      p := p.rbnext;
    end;
    //  いろんな情報を出力
  finally
    if Assigned(rb) then sds_relrb(rb);
  end;
end;
::CommentOut:}


end.
