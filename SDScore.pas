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
//  �ȉ��́A���{���
//
//  �\�[�X���邢�̓o�C�i���[�`���ł̍Ĕz�z/�g�p�́A���ς�������ꍇ���A
//  �����Ȃ��ꍇ���A���L�̏����𖞂������ꍇ�ɋ��������B
//
//  1.  �\�[�X�R�[�h�ł̍Ĕz�z���ɂ́A�K����L�̒��쌠�\���A���̏������X�g�A
//      ����шȉ��̖Ɛӎ������A���ς����ɂ��̃t�@�C���̍ŏ��̐��s�ɓ����
//      ����΂Ȃ�Ȃ��B
//  2.  �o�C�i���[�`���ł̍Ĕz�z�́A�K����L�̒��쌠�\���A���̏������X�g�A
//      �ȉ��̖Ɛӎ����̕������h�L�������e�[�V�������A���邢�͔z�z���Ƌ���
//      �񋟂������̂Ɋ܂߂Ȃ���΂Ȃ�Ȃ��B
//
//  ���̃\�t�g�E�F�A�́A����҂ɂ��A�u����̂܂܁v�Œ񋟂���A
//  ����҂͒��ړI�A�񒼐ړI�A�����I�A����ȁA�T�^�I�A���邢�͕K�R��
//  �����Ȃ�ꍇ�ɂ����Ă��A�����Ȃ鑹�Q�Ɉ�ؐӔC�͕���Ȃ��B
//  ���̑��Q�͈ȉ��̓��e���܂݁A����������Ɍ��肳��Ȃ��B
//  ��p�ƂȂ镨��T�[�r�X�̒��B�A���ʁE�f�[�^�E���v�̒ቺ�A������̏�Q�A
//  �܂��A�ǂ̂悤�ȐӖ��̘_���ɂ����Ă��A���ꂪ�_��Ɋւ�����̂ł��낤�ƁA
//  ���i�ȐӖ��ł��낤�ƁA�s���s�ׁi�s���ӂ₻�̑��̏ꍇ���܂ށj�ł��낤�ƁA
//  ���̃\�t�g�E�F�A���g�p���邱�Ƃɂ���Đ����邻���̑��Q�́A
//  ��؂̐ӔC���璘��҂͖Ƃ�Ă���B
//  ���Ƃ����O�ɂ���炷�ׂĂ̑��Q�ւ̉\������������Ă����ꍇ�ɂ����Ă�
//  ���l�ł���B
//
unit SDScore;
//  $Id: SDScore.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $

interface

{:Note::
  sds.h(�����ɂ�sds_bc.h)��Delphi-Language�ɒu�������Ă��郆�j�b�g
  �ꉞ�A��API�͈Ӗ��̂킩��Ȃ����̂��܂߈�ʂ�񋟂��A
  �������K�v�Ȃ��̂ɂ��ẮA������ƍH�v�������b�p�[��񋟂��Ă���B

  �����̂͂��������񂾂��ǁA
  �G���g���E�|�C���g�֘A�������Ă���B
  �Ƃ����킯�ŁA���̃��j�b�g��g�ݍ��߂΁A
  ���ꂾ����SDS�ŗL�̂������������͋L�q�s�v�ɂȂ�Ƃ����֗����j�b�g�B
  �����܂ł̂����������͕s�v�Ƃ����l�́A
  ������`(NO_SDSENTRY)�Ŗ����ɂł���B
::Note*}

uses
  Windows, SysUtils;

const

  {:Note::
    �P���ɑS����`���Ă���̂ŁA�{���ɕK�v���ǂ����͕s��
    �Ă䂤���A����Ƃ͕ʂɗ񋓌^�Œ�`���Ă����肷����̂�����
  ::Note:}

  //  sds_point[]��sds_matrix[][]�̓Y�����Ɏg���萔
  SDS_X = 0;
  SDS_Y = 1;
  SDS_Z = 2;
  SDS_T = 3;

  //  �_���l  True�̒l��Delphi-Language�ƈقȂ�
  SDS_TRUE  = 1;
  SDS_FALSE = 0;

  //  sds_command()�œ��͑҂��Ɏg���萔
  SDS_PAUSE = '\';

  //  ���Ɏg���̂��s��
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

  //  SDS�ւ̃��N�G�X�g�E�R�[�h
  SDS_RQSAVE    =   14;
  SDS_RQEND     =   15;
  SDS_RQQUIT    =   16;
  SDS_RQCFG     =   22;
  SDS_RQXLOAD   =  100;
  SDS_RQXUNLD   =  101;
  SDS_RQSUBR    =  102;
  SDS_RQHUP     =  105;
  SDS_RQXHELP   =  118;

  //  SDS�ւ̃��N�G�X�g�ɑ΂��郊�U���g�E�R�[�h
  SDS_RSRSLT    =  1;
  SDS_RSERR     =  3;

  //  ���U���g�E�o�b�t�@��restype�Ɏg���萔
  //  SDS���C�u�����֐��̕Ԃ�l���������Ă��肷��
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

  //  ���Ɏg���̂��s��
  COND_OP_CODE  = -4;

  //  ���Ɏg���̂��s��
  SDS_MODE_ENABLE   = 0;
  SDS_MODE_DISABLE  = 1;
  SDS_MODE_SETFOCUS = 2;
  SDS_MODE_SETSEL   = 3;
  SDS_MODE_FLIP     = 4;

  //  �^�C���֘A�̐����l
  SDS_MAX_TILE_STR   =  40;
  SDS_TILE_STR_LIMIT = 255;

  //  �R�[���o�b�N�E�t���O
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

  //  UNDO,REDO�̎��̒ʒm�Ɏg���萔
  SDS_ADD_NOTICE    = 1;
  SDS_MODIFY_NOTICE = 2;
  SDS_DELETE_NOTICE = 3;

  //  sds_name_nil()�Asds_name_clear()�̕ς��Ɏg���萔
  SDS_NIL_NAME = 0;

  //  SDS��API��񋟂���z�X�g�A�v���P�[�V����
  SDS_HOSTAPP = 'icad.exe';

type

  {:Note::
    �܂��́A�ȒP�ȃf�[�^�^
    Delphi�̗��V�ɏ]���ē���T�����Ă���B
    �A���_�[�X�R�A���Ȃ����āA���߂̓���啶���ɂ��Ă���̂́A
    ���V�̍D�݁i�A���_�[�X�R�A�͌���)�B
  ::Note:}

  TSdsReal = Double;
  //  ����́A���Ԃ�g��Ȃ�

  TSdsPoint = array [SDS_X..SDS_Z] of Double;
  PSdsPoint = ^TSdsPoint;
  //  2�����̓_�̎��͂ǂ����悤�H

  TSdsName = Int64;
  PSdsName = ^TSdsName;
  //  longint2���Ă��Ƃ�64bit�����Ȃ�ŁA���������g���������y���Ǝv���B

  TSdsXYZT = ( SdsMX, SdsMY, SdsMZ, SdsMT );
  TSdsMatrix = array [SDS_X..SDS_T] of array [SDS_X..SDS_T] of Double;
  PSdsMatrix = ^TSdsMatrix;
  //  ���W�ϊ��p�̃}�g���N�X�H
  //  �g�����͂悭�킩��Ȃ��B

  {:Note::
    �ꉞ�A���U���g�o�b�t�@����`���Ă������ǁA
    ��������̂܂܎g���̂́A�Ȃ񂾂��ȂƂ����C�͂���B
  ::Note:}

  TSdsBinary = record
    clen: SmallInt;
    buf:  Pointer;    //  sds.h�ł�char*�����ǁA�������̕��������ł�
  end;
  //  ���U���g�o�b�t�@�Ŏg�p����o�C�i���f�[�^

  TSdsResBufDump = array [0..23] of Byte;
  //  ResBuf�̒��g���悭������Ȃ��Ă�������悤�ɂ��邽�߂̂���
  //  sds.h�ɂ͂Ȃ�

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
    sds.h�ł́A��������sds_u_val�Ƃ������p�̂�����āA
    ������ϕ��Ɏg�p���Ă��邯�ǁA
    Delphi-Language�ł́A�����I�ȉϕ����������f�[�^�\�����g����̂ŕs�v
    DebDump�͉���p�ɕt������������
    TSdsPoint���܂܂�Ă���̂ŁA�Œ�ł�24�o�C�g�͂���͂�
    Head,Tail,SubList�́ASDSplus�p�̊g���Ȃ̂ŁA���ʂ͎g�����Ⴞ�߁B
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
    sds.h�ɂ͂Ȃ��̂����ǁAResBuf���̃f�[�^�̎�ނ����ʂ��邽�߂�
    �K�v�Ȃ̂Œǉ������B
  ::Note:}

  // ����͂悭�킩��܂���
  PSdsDObjll = ^TSdsDObjll;
  TSdsDObjll = record
    types:  Char;
    color:  Smallint;
    npts:   Smallint;
    chain:  PDouble;
    next:   PSdsDObjll;
  end;

  // Block�֘A�̍\���́@������悭�킩��܂���
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


  //  �֐�/�R�}���h��`�e�[�u���p�̍\���̂Ƃ��̓��I�z��
  TSdsUserFunc = function(var rb: PSdsResBuf): Integer;
  TSdsFuncDef = record
    funcName: String; //PChar;
    func:     TSdsUserFunc;
  end;
  TSdsFuncDefTable = array of TSdsFuncDef;
  //  TSdsUserFunc�ł́A������rb���������ꍇ�́A
  //  rb��nil�ɂ��Ă����K�v������(���̃��j�b�g��SDS_EntryPoint���g���ꍇ)
  //  �����łȂ��ꍇ�ASDS_EntryPoint���ŁArb��������悤�Ƃ���̂ŁA
  //  �܂������ƂɂȂ肻���B

  //  �R�[���o�b�N�֐��^
  TSdsCallbackFunc = function(flag: Integer;
                              arg1: Pointer;
                              arg2: Pointer;
                              arg3: Pointer): Integer; cdecl;

  TSdsDragEnts1 = function(arg: Pointer): Integer; cdecl;
  TSdsDragEnts2 = function(ptCursorLoc: PSdsPoint; mxTransform: PSdsMatrix): Integer; cdecl;

  //  ���肻���łȂ������A�n���h���Ȃǂ��w���|�C���^
  PHINST = ^HINST;
  PHWND  = ^HWND;
  PPChar = ^PChar;
  PHDC   = ^HDC;

  ESdsException = class(Exception);
  //  SDScore��SDSplus�Ŏg�p�����O�̃x�[�X

  ESdsResTypeError = class(ESdsException);
  //  restype�ƃo�b�t�@���̃f�[�^�^���s��v�������ꍇ�̗�O

  ESdsErrNotFound = class(ESdsException);
  //  ???get�n�ŁA������Ȃ��������ɔ��������O

  ESdsNoMoreLoop = class(ESdsException);
  //  ???next�n�ŁA������Ȃ��������ɔ��������O
  //  ���[�v�̏I���Ɏg�p���邽�߂̂��̂Ȃ̂ŁA
  //  �f�o�b�K�E�I�v�V�����Ŗ��������O�Ɏw�肵�Ă����������悢


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
  //  ���[�U������o�^���邽�߂̎葱���^�ƁA
  //  ��������s����^�C�~���O���w�肷�鎯�ʎq�A
  //  �ʏ�́ASdsAtLOAD�ASdsAtUNLOAD���w�肵�Ďg���Ώ\���̂͂�
  //  �������ASDS_RQSUBR�ɂ��ẮA���[�U��`�֐��̎��s��p�ɂȂ��Ă���̂ŁA
  //  ���[�U�����͎��s�ł��Ȃ��B
  //  �ڂ����́ASdsAddUserProc()���Q��

{$ENDIF}

{:Note::
  �ȉ���external�錾�́Aliki������sdslib.pas���x�[�X�ɁA
  �^�̐錾����ς��Ă���B
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
  ��API���ƁA�|�C���^�𑽗p���Ă��邽�߁A�Ăяo�����ŁA@���Z�q�̘A���ɂȂ���
  �����Ȋ����Ȃ̂ŁA���b�p�[��p�ӂ��邱�Ƃɂ����B
  �ꉞ�A�{����Lisp�֐��Ɠ��������Ŏg����悤�ɂȂ��Ă���B
  �������ALisp�ƈقȂ�Anil��Ԃ����Ƃ��ł��Ȃ��ꍇ�������̂ŁA
  ��O�ő�p���Ă���B
  Lisp�̞B�������J�o�[���邽�߁Aoverload�Əȗ��\�������g���܂���B
  �����̎g��API��������Ă��Ȃ��̂ŁA�K�v�ɉ����đ����Ă����\��B
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
//  ssget�t�@�~��

function  SdsEntNext: TSdsName;                                                 overload;
function  SdsEntNext(const known: TSdsName; first: Boolean = False): TSdsName;  overload;
//  entnext�t�@�~��

function  SdsEntSel(const msg: String; var pos: TSdsPoint):  TSdsName; overload;
function  SdsEntSel(const msg: String): TSdsName;                      overload;
function  SdsEntSel(var pos: TSdsPoint): TSdsName;                     overload;
function  SdsEntSel: TSdsName;                                         overload;
//  entsel�t�@�~��

procedure SdsRelRB(var rb: PSdsResBuf);
//  sds_relrb()�̃��b�p�[�A���������Arb��nil�ɂ��Ă����Ƃ��낪�e��

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
//  dict,table�֘A
//  raiseException��True�ɂ���ƁA���s�����ꍇ�ɗ�O�𔭐�������

function SdsAssoc(const trg: Smallint;   rb: PSdsResBuf): PSdsResBuf;
//  ������assoc
//  �������Alisp�{���̘A�z���X�g����̌����ł͂Ȃ�
//  trg��rb��restype����v������̂�T��
//  �܂��A�{����lisp�ł̓���Ƃ͈قȂ�A
//  �R�s�[���쐬���Ȃ���rb�ɘA�Ȃ郊�X�g���̂��̂�Ԃ�


function  SdsPrintf(const fmt: String; const args: array of const): Integer;  overload;
function  SdsPrintf(const str: String): Integer;                              overload;
function  SdsCommand(const cmd: String): Integer;
//  ���̑�
//  SdsPrintf�̉ψ����ł́A���͓�����Format�֐��ŕ����񉻂��Ă���̂ŁA
//  ����(fmt)�̎w��́Asds_printf�̂���ł͂Ȃ�Delphi��Format�֐��ɏ]��

function  SdsResTypeToComment(restype: Integer): String;
function  SdsResTypeToBufType(restype: Integer): TSdsResBufType;
function  SdsResTypeToBufTypeOnDXF(restype: Integer): TSdsResBufType;
//  ����́ASDS API ���̂Ƃ͑S���֌W�Ȃ��̂����ǁA
//  ResType(XDF�̃O���[�v�R�[�h�ɑ�������ƍl����)�ɑΉ�����ResBuf����
//  �f�[�^�̌^�𔻕ʂ���֐�
//  AutoCAD2002�̎����Ɋ�Â��Ă���̂�
//  IntelliCAD�ł��̂܂ܒʗp���邩�ǂ����͕s��
//  �ꕔ�̈�����DXF��ƁA���s���ňقȂ�̂ŁADXF�ł̓��e��OnDXF�Ƃ��Ă���

function  SdsMakeList(const Args: array of const): PSdsResBuf;
//  ������ASDS API �ɂ͂Ȃ��̂����ǁAsds_buildlist�̂���y��
//  restype�́A���̊֐����ŏ���ɔ��f���Ă����̂ŁA�l�������w�肷��΂���
//  SDS_RTREAL, SDS_RTLONG, SDS_RTENAME, SDS_RTSTR �������Ȃ�����
//  �܂��A���ꂾ���Ŏ�����邱�Ƃ��A�܂܂���킯�ł悵�Ƃ���

function SdsResBuf(restype: Smallint; const value): TSdsResBuf;
//  sds_buildlist�ł͂Ȃ��ADelphi�̐��E��TSdsResBuf�����֐�
//  ������Ȃ��Ă����̂ŕ֗�
//  �������Arestype��value�̐������̕ۏ؂̓��[�U���ōs���K�v������
//  ���ɁABinary(�̃|�C���^)�╶����̏ꍇ�ɂ́Avalue�Ƃ��ēn���ꂽ
//  ���̂̃|�C���^�������Ă���̂ŁAvalue�̎��̂��������I����ƁA
//  �s���ȏ�ԂɂȂ��Ă��܂��̂Œ���
//  �܂��A�^�̔��ʂ�SdsResTypeToBufType()���������Ƃ����O��ōs���Ă���̂ŁA
//  ������restype�͎w�肵�Ȃ��ق����悢


{$IFNDEF NO_SDSENTRY}

{:Note::
  ��������́A�G���g���|�C���g�p��procedure/function�Q

  ������g���ꍇ�A�G���g���|�C���g�̓��e�͌Œ肳��Ă��܂��̂ŁA
  �������ʂȂ��Ƃ��������ꍇ(���ʁA���[�U��`�֐��̓o�^�Ƃ��A
  �폜������͂�)�́ASdsAddUserProc()�ŁAprocedure��o�^���Ă���
  �Ƃ����Ă��ASDS_EntryPoint�́ASDS�A�v���P�[�V���������[�h������
  �����Ɏ��s����Ă��܂��̂ŁA
  �o�^���̂́A���j�b�g�̏�������(initialization)�ōs���K�v������
  �܂��A���ʂ�SdsAtXLOAD��callback��o�^����Ƃ����邭�炢�̂͂��B

  ���Ȃ݂ɁASdsAddUserFunc()�Ń��[�U��`�֐���o�^���Ă����΁A
  SdsAtXLOAD���ɓo�^�ASdsAtXUNLD���ɍ폜���Ă����̂ŁA
  ����ɂ��ẮA���[�U���ł��K�v�͂Ȃ�

  ���[�U�����A���[�U��`�֐��Ƃ��A���̒��Ŕ���������O��
  (Exception�̔h���ł����)SDS_EntryPoint�ŕߑ����āA
  ���b�Z�[�W��\������悤�ɂȂ��Ă���B
:::Note:}

procedure SDS_EntryPoint(hWnd: HWND); stdcall;
//  IntelliCAD��SDS�Ƃ��ĕK�v�ȃG���g���|�C���g

procedure SdsAddUserProc(proc: TSdsUserProc; at: TSdsUserProcAt);
//  ���[�U���̏����̓o�^
//  ����œo�^���Ă����ƁAat�Ŏw�肳�ꂽ�^�C�~���O��proc�����s����

procedure SdsAddUserFunc(const name: String; const func: TSdsUserFunc); overload;
procedure SdsAddUserFunc(const funcdef: TSdsFuncDef);                   overload;
procedure SdsAddUserFunc(const funcdefs: array of TSdsFuncDef);         overload;
//  ���[�U�֐���`�̒ǉ�

function SdsAppName:    String; //  �A�v���P�[�V������(�t���p�X)
function SdsHWndAcad:   HWND;   //  IntelliCAD ��WindowHandle
function SdsHInstAcad:  HINST;  //  IntelliCAD ��InstanceHandle
//  �G���g���|�C���g�Őݒ肳�ꂽ�������o���֐��Q

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
  //  IntelliCAD�̃C���X�^���X�̏���ێ�����ϐ�

  UserProcs: array [TSdsUserProcAt] of array of TSdsUserProc;
  UserFuncs: array of TSdsFuncDef;
  //  ���[�U�����ƃ��[�U��`�֐���ێ����铮�I�z��

{$ENDIF}

///////////////////////////////////////////////////////////////////////////
{ �G���g���|�C���g�֘A }

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

//  UserProc�Ƃ��ēo�^���Ďg��
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

//  UserProc�Ƃ��ēo�^���Ďg��
procedure UndefUserFuncs;
var
  i: Integer;
begin
  if Length(UserFuncs) > 0 then for i := Low(UserFuncs) to High(UserFuncs) do
  begin
    sds_undef(PChar(UserFuncs[i].funcName), i);
  end;
end;

//  ���[�U��`�֐��̎��s
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
    ����I�����́ASDS_RTNORM��Ԃ��̂����K�炵���B
    �ł��ASDS�̎d�l�ł́A�Ԃ�l�� SDS_RSRSLT�ASDS_RSERR�̂ǂ��炩�ł���炵���B
    ���������킯�ŁA�Ԃ�l��ύX����B
    �Ȃ񂩂ӂɗ����Ȃ�����
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
  // ������
  SDS_GetGlobals(@sdsw_AppName[0], @sdsw_hwndAcad, @sdsw_hInstance);
  sds_init(1, @sdsw_AppName);

  //  ���[�U��`�֐��֘A�̏����̓o�^
  SdsAddUserProc(DefUserFuncs,   SdsAtXLOAD);
  SdsAddUserProc(UndefUserFuncs, SdsAtXUNLD);

  //  ���C���E���[�v
  rslt := SDS_RSRSLT;
  while True do
  begin
    stat := sds_link(rslt);
		// ���N�G�X�g�ԍ��ɂ�镪��
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
{ SDS API ���b�p�[�֘A }

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
{ SdsSSGet �t�@�~�� }

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
{ SdsEntNext �t�@�~�� }

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
{ SdsEntSel �t�@�~�� }

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
{ dict,table �t�@�~�� }

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
{ RestType�֘A }

{:Note::
  ���̓��e�́AXDF Reference���Q�l�ɂ����B
  �ڍׂ́A
  http://usa.autodesk.com/adsk/item/0,,752569-123112,00.html
  ������Ō��J����Ă���h�L�������g���Q�Ƃ��ĂˁB
  5000�ԑ�ɂ��ẮA�h�L�������g�ɂ͋L�ڂ��Ȃ������̂ŁA
  SDS_RT????���g�p�����B
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
    SDS_RTPICKS:    Result := SdsRUnkown;   //'Pick set';  SdsRName����(?)
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
  //Note::  330..369�ɂ��ẮADXF��ł́AString representing hex object IDs
  //Note::  �Ƃ��邯�ǁA���s���ɂ�Entity name�������Ǝv��
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
  //  100,102��255�����܂ŁA����ȊO�͎��������͂Ȃ��Ƃ̂���
end;

function  SdsResTypeToComment(restype: Integer): String;
begin
  case restype of
    -5:       Result := '�p�[�V�X�e���g�ȃ��A�N�^�E�`�F�C��(�H) [APP]';       //'persistent reactor chain (APP)';
    -4:       Result := '�����t�I�y���[�^(�H) [APP]';                         //'conditional operator (APP)';
    -3:       Result := 'XDATA(�g���f�[�^)�̋�؂� *';                        //'* XDATA sentinel (APP)';
    -2:       Result := '�G���e�B�e�B���Q��(�H) * [APP]';                     //'* Entity name reference (APP)';
    -1:       Result := '�G���e�B�e�B��(64bit����) * [APP])';                 //'* Entity name (APP)';
    0:        Result := '�G���e�B�e�B�E�^�C�v *';                             //'* Entity type';
    1:        Result := '�G���e�B�e�B�̎�v�ȕ�����';                         //'Primary text value for an entity';
    2:        Result := '���O(TAG��u���b�N����)';                            //'Name (tag, block name, and so on)';
    3..4:     Result := '���̑��̖��O';                                       //'Other text or name values';
    5:        Result := '�G���e�B�e�B�E�n���h�� *';                           //'* Entity handle';
    6:        Result := '���햼 *';                                           //'Linetype name';
    7:        Result := '�e�L�X�g�E�X�^�C���� *';                             //'Text style name';
    8:        Result := '��w(���C��)�� *';                                   //'Layer name';
    9:        Result := '�ϐ��� [DXF]';                                       //'Variable name identifier (DXF)';
    10:       Result := '��v��3D���W DXF�ł�X���W';                          //'Primary point';
    11..18:   Result := '���̑���3D���W DXF�ł�X���W';                        //'Other points';
    20:       Result := '��v��Y���W [DXF]';                                  //'Y values of the primary point (DXF)';
    30:       Result := '��v��Z���W [DXF]';                                  //'Z values of the primary point (DXF)';
    21..28:   Result := '���̑���Y���W [DXF]';                                //'Y values of other points (DXF)';
    31..37:   Result := '���̑���Z���W [DXF]';                                //'Y values of other points (DXF)';
    38:       Result := '�G���e�B�e�B�̍���(0�łȂ��ꍇ)';                    //'Elevation of entity if nonzero (DXF)';
    39:       Result := '�G���e�B�e�B�̌���(0�łȂ��ꍇ) *';                  //'Thickness of Entity if nonzero';
    40..47:   Result := '�����̍�����X�P�[���t�@�N�^��';                     //'Text height, scale factors, and so on';
    48:       Result := '����̃X�P�[��(?)';                                  //'Linetype scale';
    49:       Result := 'LTYPE�e�[�u���̃_�b�V���̒����Ȃ�';                  //'Such as the dash lengths in the LTYPE table';
    50..58:   Result := '�p�x(DXF�ł͓x�AAPP�ł�rad)';                        //'Angles (degrees at DXF, radians at APP)';
    60:       Result := '�G���e�B�e�B�̉���';                               //'Entity visibility';
    62:       Result := '�J���[�ԍ� *';                                       //* Color number';
    66:       Result := '�G���e�B�e�B�ɕt������t���O(?) *';                  //'* "Entities follow" flag';
    67:       Result := '���f����Ԃ��y�[�p�[��Ԃ��̋�� *';                 //'* Space?that is, model or paper space';
    68:       Result := '�r���[�|�[�g��ON���ǂ��� [APP]';                     //'Viewport is on ? (APP)';
    69:       Result := '�r���[�|�[�gID�ԍ� [APP]';                           //'Viewport identification number (APP)';
    70..78:   Result := '�J�Ԃ��񐔂�A�t���O�E�r�b�g�A���[�h�Ȃ�';           //'Such as repeat counts, flag bits, or modes';
    90..99:   Result := '32bit�����l';                                        //'32-bit integer values';
    100:      Result := '�T�u�N���X�E�}�[�J';                                 //'Subclass data marker.';
    102:      Result := '���䕶����("{????" �� "}")';                         //'Control string, followed by "{<arbitrary name>" or "}".';
    105:      Result := 'DIMSTYLE�e�[�u���̃I�u�W�F�N�g�E�n���h��';           //'Object handle for DIMVAR symbol table entry';
    110:      Result := 'UCS�̌��_��3D���W DXF�ł�X���W';                     //'UCS origin (appears only if code 72 is set to 1)';
    111:      Result := 'UCS��X������ DXF�ł�X����';                          //X-axis (appears only if code 72 is set to 1)';
    112:      Result := 'UCS��Y������ DXF�ł�X����';                          //'UCS Y-axis (appears only if code 72 is set to 1)';
    120:      Result := 'UCS�̌��_��Y���W [DXF]';                             //'Y value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    121:      Result := 'UCS��X��������Y���� [DXF]';                          //'Y value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    122:      Result := 'UCS��Y��������Y���� [DXF]';                          //Y value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    130:      Result := 'UCS�̌��_��Y���W [DXF]';                             //'Z value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    131:      Result := 'UCS��X��������Z���� [DXF]';                          //'Z value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    132:      Result := 'UCS��Y��������Z���� [DXF]';                          //'Z value of UCS origin, UCS X-axis, and UCS Y-axis (DXF)';
    140..149: Result := '���W��A�����ADIMSTYLE�ݒ�Ȃ�';                     //'Points, elevation, and DIMSTYLE settings, for example';
    170..179: Result := '�t���O�E�r�b�g��DIMSTYLE�ݒ�Ȃ�';                   //'Such as flag bits representing DIMSTYLE settings';
    210:      Result := '���o������ DXF�ł�X���� *';                          //'* Extrusion direction';
    220:      Result := '���o������ DXF�ł�X����';                            //'Y values of the extrusion direction (DXF)';
    230:      Result := '���o������ DXF�ł�X����';                            //'Z values of the extrusion direction (DXF)';
    270..279: Result := '16bit�����l';                                        //'16-bit integer values';
    280..289: Result := '16bit�����l';                                        //'16-bit integer values';
    290..299: Result := '�_���t���O';                                         //'Boolean flag value';
    300..309: Result := '�C�ӂ̕�����';                                       //'Arbitrary text strings';
    310..319: Result := '�C�ӂ̃o�C�i��(with hexadecimal strings�H)';         //Arbitrary binary chunks with hexadecimal strings';
    320..329: Result := '�C�ӂ̃I�u�W�F�N�g�E�n���h��';                       //'Arbitrary object handles';
    330..339: Result := '�\�t�g�E�|�C���^(64bit����) DXF�ł̓n���h��';        //'Soft-pointer handle';
    340..349: Result := '�n�[�h�E�|�C���^(64bit����) DXF�ł̓n���h��';        //'Hard-pointer handle';
    350..359: Result := '�\�t�g�E�I�[�i(64bit����) DXF�ł̓n���h��';          //Soft-owner handle';
    360..369: Result := '�n�[�h�E�I�[�i(64bit����) DXF�ł̓n���h��';          //Hard-owner handle';
    370..379: Result := '���C���E�F�C�g(?)�̏����ԍ�(?)';                     //'Lineweight enum value (AcDb::LineWeight).';
    380..389: Result := '�v���b�g�X�^�C���̏����ԍ�';                         //'PlotStyleName type enum (AcDb::PlotStyleNameType).';
    390..399: Result := '�n���h���l���J��Ԃ���������';                       //'String representing handle value';
    400..409: Result := '16bit�����l';                                        //'16-bit Integers';
    410..419: Result := '������';                                             //'String';
    999:      Result := '�R�����g������ [DXF]';                               //'Comment string (DXF)';
    1000:     Result := '[XDATA] ������(255byte�܂�)';                        //'ASCII string in XDATA (up to 255 bytes long)';
    1001:     Result := '[XDATA] �A�v���P�[�V������(31byte�܂�)';             //'Application name for XDATA (up to 31 bytes long)';
    1002:     Result := '[XDATA] ���䕶����("{" �� "}")';                     //'XDATA control string ("{" or "}")';
    1003:     Result := '[XDATA] ��w(���C��)��';                             //'XDATA layer name';
    1004:     Result := '[XDATA] �o�C�i���f�[�^(127byte�܂�)';                //'Chunk of bytes in XDATA (up to 127 bytes long)';
    1005:     Result := '[XDATA] �G���e�B�e�B�E�n���h��';                     //'Entity handle in XDATA';
    1010:     Result := '[XDATA] 3D���W DXF�ł�X���W';                        //'A point in XDATA';
    1020:     Result := '[XDATA] Y���W [DXF]';                                //'Y values of a point in XDATA (DXF)';
    1030:     Result := '[XDATA] Z���W [DXF]';                                //'Z values of a point in XDATA (DXF)';
    1011:     Result := '[XDATA] ���[���h��Ԃ�3D���W DXF�ł�X���W';          //'A 3D world space position in XDATA';
    1021:     Result := '[XDATA] ���[���h��Ԃ�Y���W [DXF]';                  //'Y values of a world space position in XDATA (DXF)';
    1031:     Result := '[XDATA] ���[���h��Ԃ�Z���W [DXF]';                  //'Z values of a world space position in XDATA (DXF)';
    1012:     Result := '[XDATA] ���[���h��ԕψ�(?)��3D���W DXF�ł�X���W';   //'A 3D world space displacement in XDATA';
    1022:     Result := '[XDATA] ���[���h��ԕψ�(?)��Y���W [DXF]';           //'Y values of a world space displacement in XDATA (DXF)';
    1032:     Result := '[XDATA] ���[���h��ԕψ�(?)��Z���W [DXF]';           //'Z values of a world space displacement in XDATA (DXF)';
    1013:     Result := '[XDATA] ���[���h��Ԃ̕��� DXF�ł�X����';            //'A 3D world space direction in XDATA';
    1023:     Result := '[XDATA] ���[���h��Ԃ̕�����Y���� [DXF]';            //'Y values of a world space direction in XDATA (DXF)';
    1033:     Result := '[XDATA] ���[���h��Ԃ̕�����Z���� [DXF]';            //'Z values of a world space direction in XDATA (DXF)';
    1040:     Result := '[XDATA] �����l';                                     //'Extended data double precision floating point value';
    1041:     Result := '[XDATA] ����';                                       //'Extended data distance value';
    1042:     Result := '[XDATA] �X�P�[���E�t�@�N�^';                         //'Extended data scale factor';
    1070:     Result := '[XDATA] 16bit�����l';                                //'Extended data 16-bit signed integer';
    1071:     Result := '[XDATA] 32bit�����l';                                //'Extended data 32-bit signed long';
    SDS_RTNONE:     Result := '�f�[�^�Ȃ�(sds_buildlist()�̏I�[)';            //'No result';
    SDS_RTREAL:     Result := '����(���X�g�쐬�p)';                           //'Real number';
    SDS_RTPOINT:    Result := '2D���W(���X�g�쐬�p)';                         //'2-D point (x, y)';
    SDS_RTSHORT:    Result := '16bit�����l(���X�g�쐬�p)';                    //'Short integer';
    SDS_RTANG:      Result := '�p�x(���X�g�쐬�p)';                           //'Angle';
    SDS_RTSTR:      Result := '������(sds_buildlist()�p)';                    //'String';
    SDS_RTENAME:    Result := '�G���e�B�e�B��(64bit���� ���X�g�쐬�p)';       //'Entity name';
    SDS_RTPICKS:    Result := 'Pick set(���ĉ��H) (���X�g�쐬�p)';            //'Pick set';
    SDS_RTORINT:    Result := '����(���X�g�쐬�p)';                           //'Orientation';
    SDS_RT3DPOINT:  Result := '3D���W(���X�g�쐬�p)';                         //'3-D point (x, y, z)';
    SDS_RTLONG:     Result := '32bit�����l(���X�g�쐬�p)';                    //'Long integer';
    SDS_RTVOID:     Result := '��(?)(���X�g�쐬�p)';                        //'Blank symbol';
    SDS_RTLB:       Result := '"("�J������(���X�g�쐬�p)';                    //'Begin list';
    SDS_RTLE:       Result := '"("������(���X�g�쐬�p)';                    //'End of list';
    SDS_RTDOTE:     Result := '�h�b�g�E�y�A�̃h�b�g(���X�g�쐬�p)';           //'Dotted pair';
    SDS_RTNIL:      Result := 'nil(���X�g�쐬�p)';                            //'Nil';
    SDS_RTDXF0:     Result := '0 (sds_buildlist()�ł�0�̑���)';             //'DXF code 0 (for sds_buildlist)';
    SDS_RTT:        Result := 'T (�^�l ���X�g�쐬�p)';                        //'T (true) atom';
    SDS_RTBINARY:   Result := '�o�C�i���E�f�[�^(���X�g�쐬�p)';               //'Binary data';
    SDS_RTRESBUF:   Result := '���U���g�E�o�b�t�@(?) (���X�g�쐬�p)';         //'Result buffer';
    SDS_RTDRAGPT:   Result := '�h���b�O�E�|�C���g(?) (���X�g�쐬�p)';         //'Drag point';
  else        Result := 'unknown';
  end;
end;

//////////////////////////////////////////
{ ResBuf������� }

function SdsResBuf(restype: Smallint; const value): TSdsResBuf;
begin
  Result.restype := restype;
  Result.rbnext  := nil;
  case SdsResTypeToBufType(restype) of
    SdsRUnkown: Result.DebDump := TSdsResBufDump(value);  //  ������R�s�[
    SdsRReal:   Result.rreal   := Double(value);
    SdsRPoint:  Result.rpoint  := TSdsPoint(value);
    SdsRInt:    Result.rint    := Smallint(value);
    SdsRString: Result.rstring := PChar(value);
    SdsRName:   Result.rlname  := TSdsName(value);
    SdsRLong:   Result.rlong   := Longint(value);
    SdsRBinary: Result.rbinary := TSdsBinary(value);
  end;
  //  ������̏ꍇ��value�̎����ɂ��Ă͖ڂ��Ԃ�
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
      //  �Ȃ񂩎��s����
      sds_relrb(Result);
      Result := nil;
      Exit;
    end;
  end;
end;
{:Note::
  sds_buildlist()���ψ������󂯕t���Ă����̂ŁA
  �s�v���ȂƎv�����̂����ǁA�w�肷��^�C�v�Ǝ��ۂɓn���ϐ��̐�������
  ���[�U�܂����ŁA�|�����̂�����̂ŁA���O��ς��Ďc�����B
  # ���������[���Ƃ�������Ă���R�[�h�Ȃ̂ŁA
  # �̂Ă�̂����������Ȃ��Ƃ����̂�����
  sds_buildlist()�Ƃ͈قȂ�A���̊֐����Ō^�̖ʓ|�͌��Ă����̂ŁA
  �����̔z��ɂ͕ϐ��݂̂���ׂ�΂悢�B

  �ψ������������ɓn�����Ƃ��ł��Ȃ��̂ŁA
  �P�Â�ResBuf������āA����������łȂ��ł���
  �������č�������X�g��SdsRelRB()�ɓn�����Ƃ��ɂ�����
  �S�������[�X���Ă����̂��s�����Ȃ��ł͂Ȃ����A
  Lisp�̃Z���P�ʂŃ������̊Ǘ����Ă���Ă���̂ł���΁A
  ���v�Ȃ͂��B
  �����Asds_buildbuf()����邲�ƁA�K�v�ȕ����܂Ƃ߂�malloc()�Ƃ�
  ���Ă�̂��Ƃ����(�܂��l�����Ȃ���)�A�����Ƀ��������[�N����B
  ���Ԃ��Ƃꂽ��m�F���邱�Ƃɂ��悤�B

  �Ƃ������Ƃňȉ��̃R�����g�A�E�g����Ă���procedure�Ŋm�F�����B
    �Eresbuf�́A1�Z���ɂ�32�o�C�g���蓖�Ă���
      # p�̒l�̊Ԋu���ŒZ��32�o�C�g�������B
    �Esds_buildlist()�ŁA�܂Ƃ߂ăA���P�[�g���Ă���̂ł͂Ȃ��炵��
      # p�̃A�h���X���o���o��
    �Erstring�̓��e�́A���ꂼ��̃Z�����ɃR�s�[�����
      # �X��p.rstring�ƌ���s�̂ǂ���ʂ̃A�h���X�ɂȂ��Ă���
    �Erstring�p�Ɋm�ۂ����̈�̃T�C�Y�͕s��
      # ���Ȃ݂ɁA���̕�����7�o�C�g�̎��̍ŒZ�̊Ԋu��24�o�C�g������
  �Ƃ������ƂŁA
    �E�Z���̃������Ǘ��́A������Ƃ���Ă���̂ŁA
      sds_buildlist�̌��ʂ��������łȂ������Ă��A�܂����Ȃ��Ǝv��
    �E����ς�Arstring�͎Q�Ƃ݂̂Ɏg�p���āA�l��ς����肵�Ȃ���������
      # Sample�ɂ���ShowURL�Ȃ񂩂��ƁA
      # rstring��strcpy()�Ƃ���������Ă��肷�邯�ǁB
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
  //s := s + '�Ȃ񂾂��������Ȃ����Ⴄ���炢�����������';
  //s := s + '���Ȃ���Ȃ�Ȃ��񂾂��ǁB';
  //s := s + '����ȕ��������邱�Ǝ��̂����Ȃ����Ⴄ�킯�ŁA';
  //s := s + '�����������̂��炢����Δ�r�ΏƂƂ��ẮA�\���Ȃ񂾂낤���H';
  //s := s + '�ł�����ς�A���̎�̂��̂Ƃ��ẮA';
  //s := s + '�Œ�ł��Q�T�U�o�C�g�͒����Ă��Ȃ��ƒ����Ƃ͂����Ȃ��킯�ŁB';
  //s := s + '�ƁA���̕ӂ܂ł���΂������낤�B';

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
  //  ��x�ɁA�܂Ƃ߂�buildlist����

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
    //  �����ȏ����o��
  finally
    if Assigned(rb) then sds_relrb(rb);
  end;
end;
::CommentOut:}


end.
