unit SDSplusList;
//  Copyright (C) 2003 ABplus Inc. kazHIDA
//  All rights reserved.
//  $Id: SDSplusList.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $

interface

{:Note::
  SDS�ŁA��Ԗ��ł���Ȃ�������Ēʂ�Ȃ����U���g�E�o�b�t�@��
  TList�Ń��b�v�����N���X��񋟂��郆�j�b�g
  ���U���g�E�o�b�t�@�̕ԋp(sds_relrb)������Ă����̂ŁA
  �����Ƃ���SDS���݂ł��邱�Ƃ��ӎ����Ȃ��ł��g����悤�ɂȂ��Ă���
  assoc���ǂ���entmod���p�ӂ���Ă���̂ŁA
  �ȒP�ȕύX�Ȃ�ACreate->assoc->�ύX->entmod->free�Ŋ����B
::Note*}

uses
  Classes, SysUtils, SDScore;

type

  ESdsInvalidList = class(Exception);
  //  ���X�g���\�������悤�Ƃ����Ƃ��ɁA
  //  ()�̑g�̐�������Ȃ������甭�������O

  TSdsIteraterProc   = procedure (Sender: TObject;
                                  rb: PSdsResBuf;
                                  var relrb: Boolean);
  TSdsIteraterMethod = procedure (Sender: TObject;
                                  rb: PSdsResBuf;
                                  var relrb: Boolean) of object;
  //  TSdsLits.ForEach�Ŏg�p����n���h���̌^
  //  Sender�ɂ́A�Ăяo�������X�g���̂��́A
  //  rb�́A���X�g���̗v�f
  //  ���̗v�f���폜�������ꍇ�́Arelrb��True�ɂ���

  TSdsList = class(TList)
  private
    FDoNotify:  Cardinal;
    FTypeSafe:  Boolean;
    FMyResTypes:  array of SmallInt;
    FMyBufTypes:  array of TSdsResBufType;
    FMyComments:  array of String;
    FParentHead:  PSdsResBuf;
    FParentTail:  PSdsResBuf;
    function  GetHead: PSdsResBuf;
    function  GetTail: PSdsResBuf;
    function  GetResType( i: Integer): Integer;
    function  GetReal(    i: Integer): Double;
    function  GetPoint(   i: Integer): TSdsPoint;
    function  GetShort(   i: Integer): SmallInt;
    function  GetString(  i: Integer): String;
    function  GetName(    i: Integer): TSdsName;
    function  GetLong(    i: Integer): LongInt;
    function  GetInteger( i: Integer): Integer;
    function  GetBinary(  i: Integer): TSdsBinary;
    function  GetResBuf(  i: Integer): PSdsResBuf;
    function  GetSubList( i: Integer): TSdsList;
    function  GetStructured: Boolean;
    procedure SetResType( i:Integer;  AValue: Integer);
    procedure SetReal(    i: Integer; AValue: Double);
    procedure SetPoint(   i: Integer; AValue: TSdsPoint);
    procedure SetShort(   i: Integer; AValue: SmallInt);
    procedure SetName(    i: Integer; AValue: TSdsName);
    procedure SetLong(    i: Integer; AValue: LongInt);
    procedure SetInteger( i: Integer; AValue: Integer);
    procedure SetString(  i: Integer; AValue: String);
    procedure SetBinary(  i: Integer; AValue: TSdsBinary);
    function  GetBufType(i: Integer): TSdsResBufType;
    function  GetStrType(i: Integer): String;
    function  GetComment(i: Integer): String;
    function  GetContent(i: Integer): String;
    function  GetCustomResTypeIndex(rt: Smallint): Integer;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification);  override;
    function  CheckedResBuf(i: Integer;
                            t: TSdsResBufType): PSdsResBuf;     virtual;
    //  ResBufs[]�̃^�C�v�E�Z�[�t��
    //  �w�肵���^�C�v�łȂ��ꍇ�́A��O����������
    function  CopyResBuf(const src: TSdsResBuf): PSdsResBuf;    virtual;
    //  ResBuf(1��)���R�s�[���ĕԂ����\�b�h
    function  ContentsOf(const rb: PSdsResBuf;
                          verb: Boolean = True): String;        virtual;
    //
    function  BufType(restype: Integer): TSdsResBufType;        virtual;
    //  restype�ɑΉ�����̃f�[�^�^��Ԃ����\�b�h
    function  BufComment(restype: Integer): String;             virtual;
    //  restype�ɑΉ�����̐�������Ԃ����\�b�h
    function  GetText: String;                                  virtual;
    //  ���X�g�S�̂�\��������(Lisp�����ɂ���̂��W��)
    procedure Reconnect;
    //  ResBuf�̃����N���؂�Ă��܂����ꍇ�ɂȂ��������\�b�h(�f�o�b�O�p)
    procedure CheckLink(postmsg: String);
    //  ResBuf�̃����N���؂�Ă��邩�ǂ����𒲂ׂ郁�\�b�h
    //  �؂�Ă������O�𔭐�������
    function  CreateSubListBuf(const head, tail: PSdsResBuf;
                               sublist: TSdsList = nil): PSdsResBuf;
    //  �T�u���X�g�p�̎���ResBuf����郁�\�b�h
    function  GetBufCount: Integer;
    //  �{����TList��Count
  public
    constructor Create;
    constructor CreateByBuf(rb: PSdsResBuf);                          virtual;
    constructor CreateByEnt(en: TSdsName; Filter: PSdsResBuf = nil);  virtual;
    procedure Clear;              override;
    function  Snach: PSdsResBuf;  virtual;
    //  ���ɂȂ��Ă���PSdsBuf�̃��X�g�����o���A����List���̂͋�ɂ��郁�\�b�h
    function  EntMod: Boolean;
    //  ������endmod
    function  EntMake: Boolean;
    //  ������entmake
    function  Assoc(restype: Smallint): PSdsResBuf;
    function  AssocIndex(restype: Smallint): Integer;
    //  ������assoc(?)
    //  �{����(lisp��)�Ӗ��ł�assoc�ł͂Ȃ��A�w�肳�ꂽrestype��
    //  ResBuf���w���|�C���^��Ԃ����������ǁA�܂��\�����Ǝv��
    //  AssocIndex()�́AAssoc�Ō������v�f�̃��X�g��̈ʒu��Ԃ�
    //  ������Ȃ������ꍇ�AAssocIndex()��BufCount�ȏ�̒l��Ԃ�
    function  Find(restype: Smallint; var ret: Double): Boolean;      overload;
    function  Find(restype: Smallint; var ret: TSdsPoint): Boolean;   overload;
    function  Find(restype: Smallint; var ret: Smallint): Boolean;    overload;
    function  Find(restype: Smallint; var ret: String): Boolean;      overload;
    function  Find(restype: Smallint; var ret: TSdsName): Boolean;    overload;
    function  Find(restype: Smallint; var ret: Longint): Boolean;     overload;
    function  Find(restype: Smallint; var ret: TSdsBinary): Boolean;  overload;
    function  Find(restype: Smallint; var ret: Boolean): Boolean;     overload;
    //  Assoc���āA���g�����o�������̃��\�b�h
    //  ��������True������Ȃ���΁Aret�̒l��ύX������False��Ԃ�
    //  �f�[�^�^�̐������͌��Ă��Ȃ��̂Ŏg�p���ɂ͒���
    procedure InsertByCopy(idx: Integer; const src: TSdsResBuf); overload;
    procedure InsertByCopy(idx: Integer; const src: PSdsResBuf); overload;
    procedure AddByCopy(const src: TSdsResBuf);                  overload;
    procedure AddByCopy(const src: PSdsResBuf);                  overload;
    //  �����œn�������e�̃o�b�t�@���R�s�[���Ēǉ�����
    //  prot���̂́A�����ɉe����^���Ȃ��̂ŁAsds_buildlist�������̂�
    //  �����Ă����܂�Ȃ�
    //  PSdsResBuf�œn���Ă��A�擪�̗v�f�����ǉ�����Ȃ��̂Œ���
    function InsertList(idx: Integer; var list: TSdsList): Integer; overload;
    function InsertList(idx: Integer; rb: PSdsResBuf): Integer;     overload;
    function InsertList(idx: Integer;
                        const Args: array of const): Integer;       overload;
    function AddList(var list: TSdsList): Integer;                  overload;
    function AddList(rb: PSdsResBuf): Integer;                      overload;
    function AddList(const Args: array of const): Integer;          overload;
    //  ���̃��X�g��}��(�ǉ�)����B
    //  TSdsList���n���ꂽ�ꍇ�A���ꎩ�̂�FreeAndNil�����B
    //  PSdsResBuf�́A�ǂ�������Ƃ��Ă������̂����̂܂ܘA�����邽�߂̂��̂ŁA
    //  TSdsList�́A�Ȃ񂩂���̉��H����������ɘA�����邽�߂̂���
    //  �킽���ꂽResBuf�́A���̃��X�g�̊Ǘ����ɒu�����̂ŁA
    //  sds_releb���Ă͂����Ȃ��B
    //  ��������A���ۂɑ}��(�ǉ�)�����v�f����Ԃ��B
    procedure InsertSubList(idx: Integer; list: TSdsList);
    procedure AddSubList(idx: Integer; list: TSdsList);
    //  �T�u���X�g�Ƃ��āA�}��/�ǉ����郁�\�b�h
    //  ���Ƃ̏�Ԃ��\��������Ă��邩�ǂ����͂��\���Ȃ���
    //  �ǉ�/�}�����Ă��܂��̂ŁA���r���[�ȏ�ԂɂȂ�\��������
    //  �C�ɂȂ�Ƃ��́A�}��/�ǉ�������AStructure���\�b�h�ŁA
    //  �S�̂��\�������������悢
    procedure CustomizeResType(rt: Smallint;
                               bt: TSdsResBufType; const cm: String); overload;
    procedure CustomizeResType(rt: Smallint; bt: TSdsResBufType);     overload;
    procedure CustomizeResType(rt: Smallint; const cm: String);       overload;
    //  ResType�̉��߂�ύX���郁�\�b�h
    //  bt��SdsRUnkown�Acont���󕶎���ɂ����
    //  ���̉��߂𖳌��ɂ��āA�{���̉��߂�����悤�ɂȂ�
    procedure ListStructure(withCtrl: Boolean = False);
    procedure ListFlatten;
    //  ���X�g�\����������A�����������肷�郁�\�b�h
    //  �����ł����\�����Ƃ́A���ʂ̃l�X�g������ꍇ�ɁA
    //  ���̒��g���T�u���X�g�Ƃ������ƂŁA�ʂ�TSdsList�ɂ��āA
    //  ���̈ʒu�ɂ́A���ʂƃT�u���X�g��ێ�����m�[�h�����ɂ���
    //  �������A���g��ResBuf�̃����N�͑S�̂�ʂ��Čq�������܂�
    //  �ێ�����Ă���B
    //  withCtrl��True�ɂ���ƁArestype:102,1002��{}��
    //  ���ʂƂ��Ĉ����悤�ɂ���B
    procedure ForEach(proc:   TSdsIteraterProc);    overload;
    procedure ForEach(method: TSdsIteraterMethod);  overload;
    procedure RevEach(proc:   TSdsIteraterProc);    overload;
    procedure RevEach(method: TSdsIteraterMethod);  overload;
    //  ���X�g�̊e�v�f�ɂȂɂ��������Ƃ��Ɏg�p���郁�\�b�h
    //  �\�������ꂽ���X�g�̏ꍇ�A'('��')'�������āA�T�u���X�g�����ǂ�
    //  RevEach()�́A�t�ɂ��ǂ�o�[�W����
    function  IsSubList(rb: PSdsResBuf): Boolean; overload;
    function  IsSubList(idx: Integer):   Boolean; overload;
    //  �T�u���X�g���ǂ����̔���
    function  HeadOfHead: PSdsResBuf;
    function  TailOfTail: PSdsResBuf;
    //  ��[�▖���̗v�f���T�u���X�g�p�̎���ResBuf�̏ꍇ�A
    //  ���́AHead��Tail��Ԃ����\�b�h�B
    //  �����I�ɁA�؂�������������ꍇ�Ɏg�p���郁�\�b�h
    property  ResTypes[i: Integer]: Integer    read GetResType write SetResType;
    property  Reals[   i: Integer]: Double     read GetReal    write SetReal;
    property  Points[  i: Integer]: TSdsPoint  read GetPoint   write SetPoint;
    property  Shorts[  i: Integer]: SmallInt   read GetShort   write SetShort;
    property  Strings[ i: Integer]: String     read GetString  write SetString;
    property  Names[   i: Integer]: TSdsName   read GetName    write SetName;
    property  Longs[   i: Integer]: LongInt    read GetLong    write SetLong;
    property  Binaries[i: Integer]: TSdsBinary read GetBinary  write SetBinary;
    property  ResBufs[ i: Integer]: PSdsResBuf read GetResBuf;
    property  SubLists[i: Integer]: TSdsList   read GetSubList;
    property  Integers[i: Integer]: Integer    read GetInteger write SetInteger;
    property  BufTypes[i: Integer]: TSdsResBufType  read GetBufType;
    property  BufTypeStr[i: Integer]: String        read GetStrType;
    property  Comments[i: Integer]: String          read GetComment;
    property  Contents[i: Integer]: String          read GetContent;
    property  BufCount: Integer   read GetBufCount;
    property  Structured: Boolean read GetStructured;
    property  Head: PSdsResBuf    read GetHead;
    property  Tail: PSdsResBuf    read GetTail;
    property  TypeSafe: Boolean   read FTypeSafe  write FTypeSafe;
    property  Text: String        read GetText;
  end;
  {:Note::
    ResBuf�����b�v����N���X
    Add��Insert������ƁA�������ResBuf�̃|�C���^���q���ł���邵�A
    Delete�Ƃ�Clear�Ƃ��������sds_relrb()���Ă����̂ŁA
    �����ɔC����΁A���ʂ�Delphi�̃��X�g�Ɠ����悤�Ɉ�����
    �������A����Items[],Insert,Add�Ȃǂ́Aoverride���ĂȂ�(�ł��Ȃ�)�̂ŁA
    ICAD����Ƃ��ė��Ă��Ȃ�PSdsResBuf�Ƃ�PSdsResBuf�łȂ����̂�
    Add,Insert������AItems[]�ő�������肷��ƁA��ςȂ��ƂɂȂ�
    Move,Sort�ɂ��Ă��A���̂܂܂Ȃ̂ŁA���������Ă��܂���
    ICAD�����҂��Ă��鏇�ԂƈقȂ��Ă��܂��̂ł�͂�܂����B
  ::Note:}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
implementation

{:Note::
  �T�u���X�g��ێ����邽�߂ɁASdsList�̒��Ɏ���o�b�t�@�𕴂ꍞ�܂���B
  Head: PSdsResBuf;   ���X�g�̊J���J�b�R(SDS_RTLB)��ێ�����t�B�[���h
  Tail: PSdsResBuf;   ���X�g�̕��J�b�R(SDS_RTLE)��ێ�����t�B�[���h
  SubList: TObject;   �T�u���X�g(TSdsList)��ێ�����t�B�[���h
  ���Ȃ݂ɁA
  rbnext:  PSdsResBuf;  ���nil
  restype: SmallInt;    ���SDS_RTDXF0
  SDS_RTDXF0�́Asds_buildlist�ŁArestype��0�̃o�b�t�@�����Ƃ���
  �w�肷��l�Ȃ̂ŁA���̒l��restype�͖����͂��Ƃ������ƂŁA
  ���ʂɎg�p���Ă���B

  ����o�b�t�@�́AICAD�̊Ǘ��O�ɂ�����̂Ȃ̂ŁA
  �����瑤�ŁAGetMem,FreeMem���Ďg�p����B
::Note:}

////////////////////////////////////////////////////////
{ Utilities }

function isSubListBuf(const rb: PSdsResBuf): Boolean;
begin
  Result := rb.restype = SDS_RTDXF0;
end;

function subListOf(const rb: PSdsResBuf): TSdsList;
begin
  Result := rb.List as TSdsList;
end;

function headOf(const rb: PSdsResBuf): PSdsResBuf;
begin
  if Assigned(rb) then
  begin
    if isSubListBuf(rb)
    then Result := rb.Head
    else Result := rb;
  end
  else Result := nil;
end;

function tailOf(const rb: PSdsResBuf): PSdsResBuf;
begin
  if Assigned(rb) then
  begin
    if isSubListBuf(rb)
    then Result := rb.Tail
    else Result := rb;
  end
  else Result := nil;
end;

procedure clearBuf(rb: PSdsResBuf);
begin
  //  ResBuf�̒��ň�ԑ傫���̂�rpoint
  rb.rpoint[SDS_X] := 0;
  rb.rpoint[SDS_Y] := 0;
  rb.rpoint[SDS_Z] := 0;
end;

////////////////////////////////////////////////////////
{ TSdsList }

{ Create, Destroy, Clear�֌W�͏d�v�Ȃ̂ŁA�Ƃ��ƂƎ������� }

constructor TSdsList.Create;
begin
  inherited Create;
  FTypeSafe := True;
  FDoNotify := 0;
  SetLength(FMyResTypes, 0);
  SetLength(FMyBufTypes, 0);
  SetLength(FMyComments, 0);
end;

constructor TSdsList.CreateByBuf(rb: PSdsResBuf);
begin
  inherited Create;
  FTypeSafe := True;
  SetLength(FMyResTypes, 0);
  SetLength(FMyBufTypes, 0);
  SetLength(FMyComments, 0);
  FDoNotify := 1;
  try
    while Assigned(rb) do
    begin
      Add(rb);
      rb := rb.rbnext;
    end;
  finally
    FDoNotify := 0;
  end;
end;

constructor TSdsList.CreateByEnt(en: TSdsName; Filter: PSdsResBuf = nil);
var
  rb: PSdsResBuf;
begin
  if Filter = nil
  then rb := sds_entget(@en)
  else rb := sds_entgetx(@en, Filter);
  CreateByBuf(rb);
end;

procedure TSdsList.Clear;
begin
  ListFlatten;
  Inc(FDoNotify);
  try
    if Assigned(Tail) then tailOf(Tail).rbnext := nil;
    if Assigned(Head) then sds_relrb(headOf(Head));
    inherited Clear;
  finally
    Dec(FDoNotify);
  end;
end;

function  TSdsList.Snach: PSdsResBuf;
begin
  Inc(FDoNotify);
  try
    //ListFlatten;
    Result := headOf(Head);
    inherited Clear;
  finally
    Dec(FDoNotify);
  end;
end;

{ property���݂̓E�U���̂ŁA�葁�����܂��� }

function  TSdsList.IsSubList(rb: PSdsResBuf): Boolean;
begin
  Result := isSubListBuf(rb);
end;

function  TSdsList.IsSubList(idx: Integer):   Boolean;
begin
  Result := IsSubList(ResBufs[idx]);
end;

function  TSdsList.GetHead: PSdsResBuf;
begin
  if BufCount = 0
  then Result := nil
  else if IsSubList(PSdsResBuf(First))
  then Result := PSdsResBuf(First).Head
  else Result := PSdsResBuf(First)
end;

function  TSdsList.GetTail: PSdsResBuf;
begin
  if BufCount = 0
  then Result := nil
  else if IsSubList(PSdsResBuf(Last))
  then Result := PSdsResBuf(Last).Tail
  else Result := PSdsResBuf(Last)
end;


function  TSdsList.GetResType( i: Integer): Integer;
begin
  Result := ResBufs[i].restype;
end;

procedure TSdsList.SetResType( i:Integer;  AValue: Integer);
begin
  ResBufs[i].restype := AValue;
end;

function  TSdsList.CheckedResBuf(i: Integer; t: TSdsResBufType): PSdsResBuf;
begin
  Result := ResBufs[i];
  if FTypeSafe and (BufType(Result.restype) <> t)
  then ESdsResTypeError.Create('�^���Ⴂ�܂�');
end;

function  TSdsList.GetReal(i: Integer): Double;
begin
  Result := CheckedResBuf(i, SdsRReal).rreal;
end;

function  TSdsList.GetPoint(i: Integer): TSdsPoint;
begin
  Result := CheckedResBuf(i, SdsRPoint).rpoint;
end;

function  TSdsList.GetShort(i: Integer): SmallInt;
begin
  Result := CheckedResBuf(i, SdsRInt).rint;
end;

function  TSdsList.GetString(i: Integer): String;
begin
  Result := CheckedResBuf(i, SdsRString).rstring;
end;

function  TSdsList.GetName(i: Integer): TSdsName;
begin
  Result := CheckedResBuf(i, SdsRName).rlname;
end;

function  TSdsList.GetLong(i: Integer): LongInt;
begin
  Result := CheckedResBuf(i, SdsRLong).rlong;
end;

function  TSdsList.GetBinary(i: Integer): TSdsBinary;
begin
  Result := CheckedResBuf(i, SdsRBinary).rbinary;
end;

function  TSdsList.GetResBuf(i: Integer): PSdsResBuf;
begin
  Result := PSdsResBuf(Items[i]);
end;

function  TSdsList.GetSubList(i: Integer): TSdsList;
begin
  if IsSubList(i)
  then Result := subListOf(ResBufs[i])
  else Result := nil;
end;

procedure TSdsList.SetReal(i: Integer; AValue: Double);
begin
  CheckedResBuf(i, SdsRReal).rreal := AValue;
end;

procedure TSdsList.SetPoint(i: Integer; AValue: TSdsPoint);
begin
  CheckedResBuf(i, SdsRPoint).rpoint := AValue;
end;

procedure TSdsList.SetShort(i: Integer; AValue: SmallInt);
begin
  CheckedResBuf(i, SdsRInt).rint := AValue;
end;

procedure TSdsList.SetName(i: Integer; AValue: TSdsName);
begin
  CheckedResBuf(i, SdsRName).rlname := AValue;
end;

procedure TSdsList.SetLong(i: Integer; AValue: LongInt);
begin
  CheckedResBuf(i, SdsRLong).rlong := AValue;
end;

procedure TSdsList.SetString(i: Integer; AValue: String);
var
  p: PSdsResBuf;
begin
  p := CheckedResBuf(i, SdsRString);

  if StrLen(p.rstring) >= Cardinal(Length(AValue))
  then StrCopy(p.rstring, PChar(AValue))
  else
  begin
    //  �V�����o�b�t�@������āA�����ւ���
    Items[i] := sds_buildlist(p.restype, PChar(AValue), SDS_RTNONE);
    //  �Â��̂̔j���Ƃ��A���Ƃ��́ANotify���\�b�h������Ă����
  end
end;

procedure TSdsList.SetBinary(  i: Integer; AValue: TSdsBinary);
begin
  CheckedResBuf(i, SdsRBinary).rbinary := AValue;
end;

procedure TSdsList.SetInteger( i: Integer; AValue: Integer);
begin
  if not IsSubList(i) then with ResBufs[i]^ do
  begin
    case BufType(restype) of
      SdsRInt:  rint  := AValue;
      SdsRLong: rlong := AValue;
      SdsRReal: rreal := AVAlue;
    else
      raise ESdsResTypeError.Create('�^���Ⴂ�܂�');
    end;
  end
  else raise ESdsResTypeError.Create('�^���Ⴂ�܂�');
end;

function  TSdsList.GetInteger( i: Integer): Integer;
begin
  if not IsSubList(i) then with ResBufs[i]^ do
  begin
    case BufType(restype) of
      SdsRInt:  Result := rint;
      SdsRLong: Result := rlong;
      SdsRReal: Result := Round(rreal);
    else
      raise ESdsResTypeError.Create('�^���Ⴂ�܂�');
    end;
  end
  else raise ESdsResTypeError.Create('�^���Ⴂ�܂�');
end;

function TSdsList.GetStructured: Boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (i < BufCount) and (not Result) do
  begin
    Result := IsSubList(i);
    Inc(i);
  end;
end;

function  TSdsList.BufType(restype: Integer): TSdsResBufType;
var
  i: Integer;
begin
  i := GetCustomResTypeIndex(restype);
  if i < 0
  then Result := SdsResTypeToBufType(restype)
  else Result := FMyBufTypes[i];
end;

function  TSdsList.BufComment(restype: Integer): String;
var
  i: Integer;
begin
  i := GetCustomResTypeIndex(restype);
  if i < 0
  then Result := SdsResTypeToComment(restype)
  else Result := FMyComments[i];
end;

function  TSdsList.GetBufType(i: Integer): TSdsResBufType;
begin
  Result := BufType(ResBufs[i].restype);
end;

function  TSdsList.GetComment(i: Integer): String;
begin
  Result := BufComment(ResBufs[i].restype);
end;

function  TSdsList.GetStrType(i: Integer): String;
begin
  case GetBufType(i) of
    SdsRUnkown: Result := '(unknown)';
    SdsRReal:   Result := 'Real';
    SdsRPoint:  Result := 'Point';
    SdsRInt:    Result := 'ShortInt';
    SdsRString: Result := 'String';
    SdsRName:   Result := 'Entity Name';
    SdsRLong:   Result := 'LongInt';
    SdsRBinary: Result := 'Binary';
  end;
end;

function  TSdsList.GetContent(i: Integer): String;
begin
  Result := ContentsOf(ResBufs[i]);
end;

function  TSdsList.ContentsOf(const rb: PSdsResBuf; verb: Boolean): String;

  function dump(pref: String; const rb: PSdsResBuf): String;
  var
    j: Integer;
  begin
    Result := pref;
    if verb then
    begin
      Result := Result + ' : ';
      for j := Low(rb.DebDump) to High(rb.DebDump) do
      begin
       Result := Result + ' ' + IntToHex(rb.DebDump[j], 2);
      end;
    end;
  end;

  function intstr(v: Integer; digit: Integer): String;
  begin
    Result := IntToStr(v);
    if verb then Result := Result + ' (' + IntToHex(v, digit) + 'h)';
  end;

  function pointstr(p: TSdsPoint): String;
  begin
    Result := '(';
    Result := Result + FloatToStr(p[SDS_X]) + ', ';
    Result := Result + FloatToStr(p[SDS_Y]) + ', ';
    Result := Result + FloatToStr(p[SDS_Z]) + ')';
  end;

begin
  Result := '';
  if Result <> '' then Exit;

  case BufType(rb.restype) of
    SdsRReal:   Result := FloatToStr(rb.rreal);
    SdsRPoint:  Result := pointstr(rb.rpoint);
    SdsRInt:    Result := intstr(rb.rint, 4);
    SdsRString: Result := rb.rstring;
    SdsRName:   Result := IntToHex(rb.rlname, 16);
    SdsRLong:   Result := intstr(rb.rlong, 8);
    SdsRBinary: Result := Format('%p+%d', [rb.rbinary.buf, rb.rbinary.clen]);
  else
    case rb.restype of
      SDS_RTVOID:     Result := dump('void',  rb);
      SDS_RTLB:       Result := dump('(',     rb);
      SDS_RTLE:       Result := dump(')',     rb);
      SDS_RTDOTE:     Result := dump('.',     rb);
      SDS_RTNIL:      Result := dump('nil',   rb);
      SDS_RTDXF0:     Result := dump('DXF0',  rb);
      SDS_RTT:        Result := dump('T',     rb);
    else              Result := dump('???',   rb);
    end;
  end;
end;

function  TSdsList.GetText: String;
var
  i: Integer;
begin
  Result := '';
  if BufCount > 0 then for i := 0 to BufCount - 1 do
  begin
    if IsSubList(i) then
    begin
      //Result := Result + ContentsOf(ResBufs[i].Head, False);
      Result := Result + SubLists[i].Text;
      //Result := Result + ContentsOf(ResBufs[i].Tail, False);
    end
    else Result := Result + ContentsOf(ResBufs[i], False);
    if i < BufCount - 1 then Result := Result + ' ';
  end;
  if Assigned(FParentHead)
  then Result := ContentsOf(FParentHead, False) + ' ' + Result;
  if Assigned(FParentTail)
  then Result := Result + ' ' + ContentsOf(FParentTail, False);
end;

function  TSdsList.GetBufCount: Integer;
begin
  Result := inherited Count;
end;

function  TSdsList.HeadOfHead;
begin
  Result := headOf(GetHead);
end;

function  TSdsList.TailOfTail;
begin
  Result := tailOf(GetTail);
end;


{ ResType�̉��ߊ֘A }

function  TSdsList.GetCustomResTypeIndex(rt: Smallint): Integer;
var
  i: Integer;
begin
  Result := -1;
  i := Low(FMyResTypes);
  while (i <= High(FMyResTypes)) and (Result < 0) do
  begin
    if FMyResTypes[i] = rt then Result := i;
    Inc(i);
  end;
  if Result >= 0 then
  begin
    //  �����ɂȂ��Ă��邩�ǂ����̃`�F�b�N
    if (FMyBufTypes[Result] = SdsRUnkown) and (FMyComments[Result] = '')
    then Result := -1;
  end;
end;

procedure TSdsList.CustomizeResType(rt: Smallint; bt: TSdsResBufType);
var
  i: Integer;
begin
  i := GetCustomResTypeIndex(rt);
  if i < 0 then
  begin
    i := Length(FMyResTypes);
    SetLength(FMyResTypes, i + 1);
    SetLength(FMyBufTypes, i + 1);
    SetLength(FMyComments, i + 1);
    FMyResTypes[i] := rt;
    FMyBufTypes[i] := SdsResTypeToBufType(rt);
    FMyComments[i] := SdsResTypeToComment(rt);
  end;
  FMyBufTypes[i] := bt;
end;

procedure TSdsList.CustomizeResType(rt: Smallint; const cm: String);
var
  i: Integer;
begin
  i := GetCustomResTypeIndex(rt);
  if i < 0 then
  begin
    i := Length(FMyResTypes);
    SetLength(FMyResTypes, i + 1);
    SetLength(FMyBufTypes, i + 1);
    SetLength(FMyComments, i + 1);
    FMyResTypes[i] := rt;
    FMyBufTypes[i] := SdsResTypeToBufType(rt);
    FMyComments[i] := SdsResTypeToComment(rt);
  end;
  FMyComments[i] := cm;
end;

procedure TSdsList.CustomizeResType(rt: Smallint;
                                    bt: TSdsResBufType; const cm: String);
var
  i: Integer;
begin
  i := GetCustomResTypeIndex(rt);
  if i < 0 then
  begin
    i := Length(FMyResTypes);
    SetLength(FMyResTypes, i + 1);
    SetLength(FMyBufTypes, i + 1);
    SetLength(FMyComments, i + 1);
    FMyResTypes[i] := rt;
  end;
  FMyBufTypes[i] := bt;
  FMyComments[i] := cm;
end;

{ �}���E�ǉ��֌W�ƍ폜���̏��� }

function  TSdsList.CreateSubListBuf(const head, tail: PSdsResBuf;
                                    sublist: TSdsList): PSdsResBuf;

  function createIfNil(restype: Smallint; const rb: PSdsResBuf): PSdsResBuf;
  begin
    if Assigned(rb)
    then Result := rb
    else Result := sds_buildlist(restype, 0, SDS_RTNONE);
  end;

begin
  GetMem(Result, SizeOf(TSdsResBuf));

  if not Assigned(sublist) then sublist := TSdsList.Create;
  sublist.FParentHead := createIfNil(SDS_RTLB, head);
  sublist.FParentTail := createIfNil(SDS_RTLE, tail);

  Result.rbnext   := nil;
  Result.restype  := SDS_RTDXF0;
  Result.Head     := head;
  Result.Tail     := tail;
  Result.List     := sublist;
end;

function TSdsList.CopyResBuf(const src: TSdsResBuf): PSdsResBuf;
var
  rt: Smallint;
begin
  //  0�̎��͂���ւ�
  if src.restype = 0
  then rt := SDS_RTDXF0
  else rt := src.restype;
  
  case BufType(src.restype) of
    SdsRReal:   Result := sds_buildlist(rt, src.rreal,   SDS_RTNONE);
    SdsRInt:    Result := sds_buildlist(rt, src.rint,    SDS_RTNONE);
    SdsRName:   Result := sds_buildlist(rt, src.rlname,  SDS_RTNONE);
    SdsRLong:   Result := sds_buildlist(rt, src.rlong,   SDS_RTNONE);
    SdsRPoint:  Result := sds_buildlist(rt, src.rpoint,  SDS_RTNONE);
    SdsRBinary: Result := sds_buildlist(rt, src.rbinary, SDS_RTNONE);
    SdsRString: Result := sds_buildlist(rt, src.rstring, SDS_RTNONE);
  else          Result := nil;
  end;
  Result.rbnext := nil;   //�O�̂���
end;

function TSdsList.InsertList(idx: Integer; var list: TSdsList): Integer;
begin
  Result := InsertList(idx, list.Snach);
  FreeAndNil(list);
end;

function TSdsList.AddList(var list: TSdsList): Integer;
begin
  Result := AddList(list.Snach);
  FreeAndNil(list);
end;

function TSdsList.InsertList(idx: Integer; const Args: array of const): Integer;
begin
  Result := InsertList(idx, SdsMakeList(Args));
end;

function TSdsList.AddList(const Args: array of const): Integer;
begin
  Result := AddList(SdsMakeList(Args));
end;

function TSdsList.InsertList(idx: Integer; rb: PSdsResBuf): Integer;
begin
  Result := 0;
  if rb = nil       then Exit;
  if idx < 0        then Exit;
  if idx > BufCount then idx := BufCount;

  Inc(FDoNotify);
  try
    //  ���O�̎�������
    if idx > 0 then tailOf(ResBufs[idx-1]).rbnext := headOf(rb);
    //  �ǉ�
    while Assigned(rb) do
    begin
      Insert(idx, rb);
      rb := rb.rbnext;
      Inc(idx);
      Inc(Result);
    end;
    //  �؂�Ă������N���Ȃ�����
    if idx < BufCount
    then tailOf(ResBufs[idx - 1]).rbnext := headOf(ResBufs[idx]);
  finally
    Dec(FDoNotify);
  end;
end;

function TSdsList.AddList(rb: PSdsResBuf): Integer;
begin
  Result := InsertList(BufCount, rb);
end;

procedure TSdsList.InsertSubList(idx: Integer; list: TSdsList);
begin
  InsertList(idx, CreateSubListBuf(nil, nil, list));
end;

procedure TSdsList.AddSubList(idx: Integer; list: TSdsList);
begin
  AddList(CreateSubListBuf(nil, nil, list));
end;

procedure TSdsList.InsertByCopy(idx: Integer; const src: TSdsResBuf);
begin
  InsertList(idx, CopyResBuf(src));
end;

procedure TSdsList.AddByCopy(const src: TSdsResBuf);
begin
  AddList(CopyResBuf(src));
end;

procedure TSdsList.InsertByCopy(idx: Integer; const src: PSdsResBuf);
begin
  if Assigned(src) then InsertByCopy(idx, src^);
end;

procedure TSdsList.AddByCopy(const src: PSdsResBuf);
begin
  if Assigned(src) then AddByCopy(src^);
end;

procedure TSdsList.Notify(Ptr: Pointer; Action: TListNotification);

  function reverseSearch(Ptr: Pointer): Integer;
  begin
    //  �ǉ����폜�������ōs���邱�Ƃ������̂ŁA
    //  ��������T���֐���p�ӂ����B
    Result := BufCount - 1;
    while (Result > 0) and (Items[Result] <> Ptr) do Dec(Result);
  end;

  procedure atAdd(p: PSdsResBuf);
  var
    i: Integer;
  begin
    i := reverseSearch(Ptr);
    if BufCount = 1 then                   //  �ŏ��̗v�f
    begin
      if Assigned(FParentHead) then FParentHead.rbnext := headOf(p);
      if Assigned(FParentTail) then tailOf(p).rbnext := FParentTail;
    end
    else if i = BufCount - 1 then          //  ����
    begin
      tailOf(p).rbnext := FParentTail;
    end
    else if i > 0 then                  //  ����
    begin
      tailOf(ResBufs[i-1]).rbnext := headOf(p);
      tailOf(p).rbnext := headOf(ResBufs[i+1]);
    end
    else if Assigned(FParentHead) then  //  �擪
    begin
      FParentHead.rbnext := headOf(p);
    end;
  end;

  procedure atDel(p: PSdsResBuf);
  var
    t: PSdsResBuf;
    h: PSdsResBuf;
    s: TSdsList;
    i: Integer;
  begin
    h := headOf(p);
    t := tailOf(p).rbnext;
    tailOf(p).rbnext := nil;
    //  �Ȃ���������
    if not Assigned(t)
    then Tail.rbnext := nil     //  ����
    else
    begin                       //  ����ȊO
      i := reverseSearch(t);
      while i > 0 do
      begin
        Dec(i);
        if tailOf(ResBufs[i]).rbnext = h then
        begin   //  ���O�̃f�[�^��������
          tailOf(ResBufs[i]).rbnext := t;
          i := 0;
        end;
      end;
    end;
    if IsSubList(p) then
    begin
      //  �����T�u���X�g��������A���̒��g��ResBuf�����D���Ă���A���
      s := subListOf(p);
      s.Snach;
      FreeAndNil(s);
      FreeMem(p);
    end;
    //  ResBuf�����
    sds_relrb(h);
  end;

begin

  if (FDoNotify = 0) and Assigned(Ptr) then
  begin
    case Action of
      lnAdded:      atAdd(Ptr);
      lnDeleted:    atDel(Ptr);
      lnExtracted:  atDel(Ptr);
    end;
  end;
end;

{ �ǂ������Ƃ����ƃf�o�b�O�p }

procedure TSdsList.Reconnect;
var
  i: Integer;

  function nextheadOf(idx: Integer): PSdsResBuf;
  begin
    Inc(idx);
    if (idx < BufCount) and Assigned(ResBufs[idx])
    then Result := headOf(ResBufs[idx])
    else Result := nil;
  end;

begin
  i := 0;
  while i < BufCount do
  begin
    if Assigned(Items[i]) then
    begin
      tailOf(Items[i]).rbnext := nextheadOf(i);
      Inc(i);
    end
    else Delete(i);
  end;
end;

procedure TSdsList.CheckLink(postmsg: String);
var
  i:  Integer;

  procedure checkJoint(const rb1, rb2: PSdsResBuf; const msg: String);
  begin
    if tailOf(rb1).rbnext <> headOf(rb2) then
    begin
      raise ESdsInvalidList.Create(msg
              + Format(' (%p -> %p) ', [tailOf(rb1).rbnext, headOf(rb2)])
              + postmsg);
    end;
  end;

  procedure checkWithNode(rb: PSdsResBuf);
  var
    lt: TSdsList;
  begin
    if IsSubList(rb) then
    begin
      lt := subListOf(rb);
      //  �ċA�I�ɒ��ׂ�
      lt.CheckLink(postmsg);
      //  �T�u���X�g�̏ꍇ�A�����̊��ʂƂ̘A�������ׂ�
      if Assigned(lt.FParentHead) and Assigned(lt.FParentTail) then
      begin
        if lt.BufCount > 0 then
        begin
          checkJoint(lt.FParentHead, lt.Head, 'SubList���̐擪���s�A��');
          checkJoint(lt.Tail, lt.FParentTail, 'SubList���̖������s�A��');
        end
        else
        begin
          checkJoint(lt.FParentHead,
                     lt.FParentTail, 'SubList���̐擪�Ɩ������s�A��');
        end;
      end;
    end;
  end;

begin
  i := 0;
  while i < BufCount do
  begin
    checkWithNode(ResBufs[i]);
    if i > 0 then
    begin
      checkJoint( ResBufs[i-1],
                  ResBufs[i], Format('[(%d)%d:%s]��[(%d)%d:%s]���s�A��',
                  [i-1, ResTypes[i-1], Contents[i-1],
                   i,   ResTypes[i],   Contents[i]]));
    end;
    Inc(i);
  end;
end;

{ ���X�g�̍\�����֘A }

procedure TSdsList.ListStructure(withCtrl: Boolean = False);
var
  i: Integer;
  j: Integer;
  n: Integer;

  function BeginSubList(const rb: PSdsResBuf): Boolean;
  begin
    Result := (rb.restype = SDS_RTLB) or
              (withCtrl and
              ((rb.restype = 102) or
               (rb.restype = 1002)) and
               (rb.rstring[0] = '{'));
  end;

  function EndOfSubList(const rb: PSdsResBuf): Boolean;
  begin
    Result := (rb.restype = SDS_RTLE) or
              (withCtrl and
              ((rb.restype = 102) or
               (rb.restype = 1002)) and
               (rb.rstring[0] = '}'));
  end;

begin
  //  �������񕽏�������
  ListFlatten;
  Inc(FDoNotify);
  try
    i := 0;
    while i < BufCount do
    begin
      if BeginSubList(ResBufs[i]) then
      begin
        j := i;
        n := 1;
        while n > 0 do
        begin
          Inc(j);
          if j < BufCount then
          begin
            if BeginSubList(ResBufs[j]) then Inc(n);
            if EndOfSubList(ResBufs[j]) then Dec(n);
          end
          else raise ESdsInvalidList.Create('")"������Ȃ�');
        end;
        //  �����ւ���
        Items[i] := CreateSubListBuf(ResBufs[i], ResBufs[j]);
        if i + 1 < j then
        begin
          ResBufs[j - 1].rbnext := nil;               //  ��������؂�
          SubLists[i].AddList(ResBufs[i+1]);
          SubLists[i].ListStructure;                  //  �\��������
          SubLists[i].Tail.rbnext := ResBufs[i].Tail; //  �q������
        end;
        //  �T�u���X�g�Ɏ�荞�܂ꂽ���̂��폜
        while j > i do
        begin
          Delete(j);
          Dec(j);
        end;
      end;
      Inc(i);
    end;
  finally
    Dec(FDoNotify);
  end;
  CheckLink('at Structuring');
end;

procedure TSdsList.ListFlatten;
var
  i:  Integer;
  lt: TSdsList;
  p:  PSdsResBuf;

  procedure debugOfList(lt: TSdsList);
  var
    i: Integer;
  begin
    with lt do
    begin
      i := 1;
      while (i < BufCount) do
      begin
        if tailOf(ResBufs[i-1]).rbnext <> headOf(ResBufs[i]) then
        begin
          raise Exception.CreateFmt('(%d) %d:%s(%p) -> %d:%s(%p) ���Ȃ����ĂȂ�',
                    [i-1,
                    ResTypes[i-1], Contents[i-1], tailOf(ResBufs[i-1]).rbnext,
                    ResTypes[i],   Contents[i],   headOf(ResBufs[i]) ]);
         end;
         Inc(i);
      end;
      if tailOf(ResBufs[i-1]).rbnext <> nil
      then raise Exception.Create('������nil����Ȃ�');
    end;
  end;

begin
  //  �ꉞ�`�F�b�N
  CheckLink('before Flatten/Structure');

  Inc(FDoNotify);
  try
    i := 0;
    while i < BufCount do
    begin
      if IsSubList(i) then
      begin
        //  �W�J
        p  := ResBufs[i];
        lt := SubListOf(p);
        Items[i] := p.Head;
        Inc(i);
        Insert(i, p.Tail);
        p.Head.rbnext := p.Tail;
        if lt.BufCount > 0 then
        begin
          tailOf(lt.Tail).rbnext := nil;  //  ��������؂��Ă���
          //debugOfList(lt);
          InsertList(i, lt.Snach);        //  ResBuf��D�����
        end;
        //debugOfList(Self);
      end;
      Inc(i);
    end;
  finally
    Dec(FDoNotify);
  end;
end;

{ �C�e���[�^ }

procedure TSdsList.ForEach(proc: TSdsIteraterProc);
var
  i: Integer;
  relrb: Boolean;
begin
  i := 0;
  while i < BufCount do
  begin
    relrb := False;
    if IsSubList(i)
    then SubLists[i].ForEach(proc)
    else proc(Self, ResBufs[i], relrb);
    if relrb
    then Delete(i)
    else Inc(i);
  end;
end;

procedure TSdsList.ForEach(method: TSdsIteraterMethod);
var
  i: Integer;
  relrb: Boolean;
begin
  i := 0;
  while i < BufCount do
  begin
    relrb := False;
    if IsSubList(i)
    then SubLists[i].ForEach(method)
    else method(Self, ResBufs[i], relrb);
    if relrb
    then Delete(i)
    else Inc(i);
  end;
end;

procedure TSdsList.RevEach(proc:   TSdsIteraterProc);
var
  i: Integer;
  relrb: Boolean;
begin
  i := BufCount;
  while i > 0 do
  begin
    Dec(i);
    relrb := False;
    if IsSubList(i)
    then SubLists[i].RevEach(proc)
    else proc(Self, ResBufs[i], relrb);
    if relrb then Delete(i)
  end;
end;

procedure TSdsList.RevEach(method: TSdsIteraterMethod);
var
  i: Integer;
  relrb: Boolean;
begin
  i := BufCount;
  while i > 0 do
  begin
    Dec(i);
    relrb := False;
    if IsSubList(i)
    then SubLists[i].RevEach(method)
    else method(Self, ResBufs[i], relrb);
    if relrb then Delete(i)
  end;
end;


{ ���ۂɃ��X�g���g���đ��삷��֌W }

function  TSdsList.EntMod: Boolean;
begin
  if BufCount > 0 then
  begin
    if Structured then
    begin
      ListFlatten;
      Result := (sds_entmod(Head) = SDS_RTNORM);
      ListStructure;
    end
    else
    begin
      Result := (sds_entmod(Head) = SDS_RTNORM);
    end;
  end
  else Result := False;
end;

function  TSdsList.EntMake: Boolean;
begin
  if BufCount > 0 then
  begin
    if Structured then
    begin
      ListFlatten;
      Result := (sds_entmake(Head) = SDS_RTNORM);
      ListStructure;
    end
    else
    begin
      Result := (sds_entmake(Head) = SDS_RTNORM);
    end;
  end
  else Result := False;
end;

function  TSdsList.AssocIndex(restype: Smallint): Integer;
begin
  Result := 0;
  while (Result < BufCount) and (ResTypes[Result] = restype) do Inc(Result);
end;

function  TSdsList.Assoc(restype: Smallint): PSdsResBuf;
var
  i:  Integer;
begin
  Result := nil;
  i := 0;
  while (i < BufCount) and (not Assigned(Result)) do
  begin
    if ResTypes[i] = restype
    then Result := ResBufs[i]
    else Inc(i);
  end;
end;
{:CommentOut::
//  ���ꂾ�ƃT�u���X�g�����ǂ��Ă��܂�
var
  p: PSdsResBuf;
begin
  Result := nil;
  p := Head;
  while Assigned(p) and (not Assigned(Result)) do
  begin
    if p.restype = restype
    then Result := p
    else p := p.rbnext;
  end;
end;
::CommentOut:}

function  TSdsList.Find(restype: Smallint; var ret: Double): Boolean;
var
  rb: PSdsResBuf;
begin
  rb := Assoc(restype);
  Result := Assigned(rb);
  if Result then ret := rb.rreal;
end;

function  TSdsList.Find(restype: Smallint; var ret: TSdsPoint): Boolean;
var
  rb: PSdsResBuf;
begin
  rb := Assoc(restype);
  Result := Assigned(rb);
  if Result then ret := rb.rpoint;
end;

function  TSdsList.Find(restype: Smallint; var ret: Smallint): Boolean;
var
  rb: PSdsResBuf;
begin
  rb := Assoc(restype);
  Result := Assigned(rb);
  if Result then ret := rb.rint;
end;

function  TSdsList.Find(restype: Smallint; var ret: String): Boolean;
var
  rb: PSdsResBuf;
begin
  rb := Assoc(restype);
  Result := Assigned(rb);
  if Result then ret := rb.rstring;
end;

function  TSdsList.Find(restype: Smallint; var ret: TSdsName): Boolean;
var
  rb: PSdsResBuf;
begin
  rb := Assoc(restype);
  Result := Assigned(rb);
  if Result then ret := rb.rlname;
end;

function  TSdsList.Find(restype: Smallint; var ret: Longint): Boolean;
var
  rb: PSdsResBuf;
begin
  rb := Assoc(restype);
  Result := Assigned(rb);
  if Result then ret := rb.rlong;
end;

function  TSdsList.Find(restype: Smallint; var ret: TSdsBinary): Boolean;
var
  rb: PSdsResBuf;
begin
  rb := Assoc(restype);
  Result := Assigned(rb);
  if Result then ret := rb.rbinary;
end;

function  TSdsList.Find(restype: Smallint; var ret: Boolean): Boolean;
var
  flg: Smallint;
begin
  Result := Find(restype, flg);
  ret := (flg <> 0);
end;

end.
