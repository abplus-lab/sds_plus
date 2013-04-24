unit SDSplusList;
//  Copyright (C) 2003 ABplus Inc. kazHIDA
//  All rights reserved.
//  $Id: SDSplusList.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $

interface

{:Note::
  SDSで、一番厄介でありながら避けて通れないリザルト・バッファを
  TListでラップしたクラスを提供するユニット
  リザルト・バッファの返却(sds_relrb)もやってくれるので、
  原則としてSDS絡みであることを意識しないでも使えるようになっている
  assocもどきとentmodも用意されているので、
  簡単な変更なら、Create->assoc->変更->entmod->freeで完了。
::Note*}

uses
  Classes, SysUtils, SDScore;

type

  ESdsInvalidList = class(Exception);
  //  リストを構造化しようとしたときに、
  //  ()の組の数が合わなかったら発生する例外

  TSdsIteraterProc   = procedure (Sender: TObject;
                                  rb: PSdsResBuf;
                                  var relrb: Boolean);
  TSdsIteraterMethod = procedure (Sender: TObject;
                                  rb: PSdsResBuf;
                                  var relrb: Boolean) of object;
  //  TSdsLits.ForEachで使用するハンドラの型
  //  Senderには、呼び出したリストそのもの、
  //  rbは、リスト内の要素
  //  その要素を削除したい場合は、relrbをTrueにする

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
    //  ResBufs[]のタイプ・セーフ版
    //  指定したタイプでない場合は、例外が発生する
    function  CopyResBuf(const src: TSdsResBuf): PSdsResBuf;    virtual;
    //  ResBuf(1個)をコピーして返すメソッド
    function  ContentsOf(const rb: PSdsResBuf;
                          verb: Boolean = True): String;        virtual;
    //
    function  BufType(restype: Integer): TSdsResBufType;        virtual;
    //  restypeに対応するのデータ型を返すメソッド
    function  BufComment(restype: Integer): String;             virtual;
    //  restypeに対応するの説明文を返すメソッド
    function  GetText: String;                                  virtual;
    //  リスト全体を表す文字列(Lisp式風にするのが標準)
    procedure Reconnect;
    //  ResBufのリンクが切れてしまった場合につなぎ直すメソッド(デバッグ用)
    procedure CheckLink(postmsg: String);
    //  ResBufのリンクが切れているかどうかを調べるメソッド
    //  切れていたら例外を発生させる
    function  CreateSubListBuf(const head, tail: PSdsResBuf;
                               sublist: TSdsList = nil): PSdsResBuf;
    //  サブリスト用の似非ResBufを作るメソッド
    function  GetBufCount: Integer;
    //  本来のTListのCount
  public
    constructor Create;
    constructor CreateByBuf(rb: PSdsResBuf);                          virtual;
    constructor CreateByEnt(en: TSdsName; Filter: PSdsResBuf = nil);  virtual;
    procedure Clear;              override;
    function  Snach: PSdsResBuf;  virtual;
    //  元になっているPSdsBufのリストを取り出し、このList自体は空にするメソッド
    function  EntMod: Boolean;
    //  いわゆるendmod
    function  EntMake: Boolean;
    //  いわゆるentmake
    function  Assoc(restype: Smallint): PSdsResBuf;
    function  AssocIndex(restype: Smallint): Integer;
    //  いわゆるassoc(?)
    //  本来の(lispの)意味でのassocではなく、指定されたrestypeの
    //  ResBufを指すポインタを返すだけだけど、まぁ十分かと思う
    //  AssocIndex()は、Assocで見つけた要素のリスト上の位置を返す
    //  見つからなかった場合、AssocIndex()はBufCount以上の値を返す
    function  Find(restype: Smallint; var ret: Double): Boolean;      overload;
    function  Find(restype: Smallint; var ret: TSdsPoint): Boolean;   overload;
    function  Find(restype: Smallint; var ret: Smallint): Boolean;    overload;
    function  Find(restype: Smallint; var ret: String): Boolean;      overload;
    function  Find(restype: Smallint; var ret: TSdsName): Boolean;    overload;
    function  Find(restype: Smallint; var ret: Longint): Boolean;     overload;
    function  Find(restype: Smallint; var ret: TSdsBinary): Boolean;  overload;
    function  Find(restype: Smallint; var ret: Boolean): Boolean;     overload;
    //  Assocして、中身を取り出すだけのメソッド
    //  見つけたらTrue見つからなければ、retの値を変更せずにFalseを返す
    //  データ型の整合性は見ていないので使用時には注意
    procedure InsertByCopy(idx: Integer; const src: TSdsResBuf); overload;
    procedure InsertByCopy(idx: Integer; const src: PSdsResBuf); overload;
    procedure AddByCopy(const src: TSdsResBuf);                  overload;
    procedure AddByCopy(const src: PSdsResBuf);                  overload;
    //  引数で渡した内容のバッファをコピーして追加する
    //  prot自体は、内部に影響を与えないので、sds_buildlistしたもので
    //  無くてもかまわない
    //  PSdsResBufで渡しても、先頭の要素しか追加されないので注意
    function InsertList(idx: Integer; var list: TSdsList): Integer; overload;
    function InsertList(idx: Integer; rb: PSdsResBuf): Integer;     overload;
    function InsertList(idx: Integer;
                        const Args: array of const): Integer;       overload;
    function AddList(var list: TSdsList): Integer;                  overload;
    function AddList(rb: PSdsResBuf): Integer;                      overload;
    function AddList(const Args: array of const): Integer;          overload;
    //  他のリストを挿入(追加)する。
    //  TSdsListが渡された場合、それ自体はFreeAndNilされる。
    //  PSdsResBufは、どこかからとってきたものをそのまま連結するためのもので、
    //  TSdsListは、なんかしらの加工を加えた後に連結するためのもの
    //  わたされたResBufは、このリストの管理下に置かれるので、
    //  sds_relebしてはいけない。
    //  いずれも、実際に挿入(追加)した要素数を返す。
    procedure InsertSubList(idx: Integer; list: TSdsList);
    procedure AddSubList(idx: Integer; list: TSdsList);
    //  サブリストとして、挿入/追加するメソッド
    //  もとの状態が構造化されているかどうかはお構いなしに
    //  追加/挿入してしまうので、中途半端な状態になる可能性がある
    //  気になるときは、挿入/追加した後、Structureメソッドで、
    //  全体を構造化した方がよい
    procedure CustomizeResType(rt: Smallint;
                               bt: TSdsResBufType; const cm: String); overload;
    procedure CustomizeResType(rt: Smallint; bt: TSdsResBufType);     overload;
    procedure CustomizeResType(rt: Smallint; const cm: String);       overload;
    //  ResTypeの解釈を変更するメソッド
    //  btをSdsRUnkown、contを空文字列にすると
    //  その解釈を無効にして、本来の解釈をするようになる
    procedure ListStructure(withCtrl: Boolean = False);
    procedure ListFlatten;
    //  リスト構造化したり、平準化したりするメソッド
    //  ここでいう構造化とは、括弧のネストがある場合に、
    //  その中身をサブリストということで、別のTSdsListにして、
    //  元の位置には、括弧とサブリストを保持するノードだけにする
    //  ただし、中身のResBufのリンクは全体を通して繋がったまま
    //  保持されている。
    //  withCtrlをTrueにすると、restype:102,1002の{}も
    //  括弧として扱うようにする。
    procedure ForEach(proc:   TSdsIteraterProc);    overload;
    procedure ForEach(method: TSdsIteraterMethod);  overload;
    procedure RevEach(proc:   TSdsIteraterProc);    overload;
    procedure RevEach(method: TSdsIteraterMethod);  overload;
    //  リストの各要素になにかしたいときに使用するメソッド
    //  構造化されたリストの場合、'('と')'を除いて、サブリストもたどる
    //  RevEach()は、逆にたどるバージョン
    function  IsSubList(rb: PSdsResBuf): Boolean; overload;
    function  IsSubList(idx: Integer):   Boolean; overload;
    //  サブリストかどうかの判別
    function  HeadOfHead: PSdsResBuf;
    function  TailOfTail: PSdsResBuf;
    //  先端や末尾の要素がサブリスト用の似非ResBufの場合、
    //  その、HeadやTailを返すメソッド。
    //  内部的に、切った張ったする場合に使用するメソッド
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
    ResBufをラップするクラス
    AddやInsertをすると、きちんとResBufのポインタも繋いでくれるし、
    DeleteとかClearとかをするとsds_relrb()してくれるので、
    こいつに任せれば、普通のDelphiのリストと同じように扱える
    ただし、生のItems[],Insert,Addなどは、overrideしてない(できない)ので、
    ICADからとって来ていないPSdsResBufとかPSdsResBufでないものを
    Add,Insertしたり、Items[]で代入したりすると、大変なことになる
    Move,Sortについても、元のままなので、これをやってしまうと
    ICADが期待している順番と異なってしまうのでやはりまずい。
  ::Note:}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
implementation

{:Note::
  サブリストを保持するために、SdsListの中に似非バッファを紛れ込ませる。
  Head: PSdsResBuf;   リストの開きカッコ(SDS_RTLB)を保持するフィールド
  Tail: PSdsResBuf;   リストの閉じカッコ(SDS_RTLE)を保持するフィールド
  SubList: TObject;   サブリスト(TSdsList)を保持するフィールド
  ちなみに、
  rbnext:  PSdsResBuf;  常にnil
  restype: SmallInt;    常にSDS_RTDXF0
  SDS_RTDXF0は、sds_buildlistで、restypeが0のバッファを作るときに
  指定する値なので、この値のrestypeは無いはずということで、
  判別に使用している。

  似非バッファは、ICADの管理外にあるものなので、
  こちら側で、GetMem,FreeMemして使用する。
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
  //  ResBufの中で一番大きいのはrpoint
  rb.rpoint[SDS_X] := 0;
  rb.rpoint[SDS_Y] := 0;
  rb.rpoint[SDS_Z] := 0;
end;

////////////////////////////////////////////////////////
{ TSdsList }

{ Create, Destroy, Clear関係は重要なので、とっとと実装する }

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

{ property絡みはウザいので、手早くすませる }

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
  then ESdsResTypeError.Create('型が違います');
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
    //  新しいバッファを作って、差し替える
    Items[i] := sds_buildlist(p.restype, PChar(AValue), SDS_RTNONE);
    //  古いのの破棄とか連結とかは、Notifyメソッドがやってくれる
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
      raise ESdsResTypeError.Create('型が違います');
    end;
  end
  else raise ESdsResTypeError.Create('型が違います');
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
      raise ESdsResTypeError.Create('型が違います');
    end;
  end
  else raise ESdsResTypeError.Create('型が違います');
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


{ ResTypeの解釈関連 }

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
    //  無効になっているかどうかのチェック
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

{ 挿入・追加関係と削除時の処理 }

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
  //  0の時はすり替え
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
  Result.rbnext := nil;   //念のため
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
    //  直前の次が自分
    if idx > 0 then tailOf(ResBufs[idx-1]).rbnext := headOf(rb);
    //  追加
    while Assigned(rb) do
    begin
      Insert(idx, rb);
      rb := rb.rbnext;
      Inc(idx);
      Inc(Result);
    end;
    //  切れてたリンクをつなぎ直す
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
    //  追加も削除も末尾で行われることが多いので、
    //  末尾から探す関数を用意した。
    Result := BufCount - 1;
    while (Result > 0) and (Items[Result] <> Ptr) do Dec(Result);
  end;

  procedure atAdd(p: PSdsResBuf);
  var
    i: Integer;
  begin
    i := reverseSearch(Ptr);
    if BufCount = 1 then                   //  最初の要素
    begin
      if Assigned(FParentHead) then FParentHead.rbnext := headOf(p);
      if Assigned(FParentTail) then tailOf(p).rbnext := FParentTail;
    end
    else if i = BufCount - 1 then          //  末尾
    begin
      tailOf(p).rbnext := FParentTail;
    end
    else if i > 0 then                  //  中間
    begin
      tailOf(ResBufs[i-1]).rbnext := headOf(p);
      tailOf(p).rbnext := headOf(ResBufs[i+1]);
    end
    else if Assigned(FParentHead) then  //  先頭
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
    //  つなぎ直し処理
    if not Assigned(t)
    then Tail.rbnext := nil     //  末尾
    else
    begin                       //  それ以外
      i := reverseSearch(t);
      while i > 0 do
      begin
        Dec(i);
        if tailOf(ResBufs[i]).rbnext = h then
        begin   //  直前のデータを見つけた
          tailOf(ResBufs[i]).rbnext := t;
          i := 0;
        end;
      end;
    end;
    if IsSubList(p) then
    begin
      //  もしサブリストだったら、その中身のResBufを強奪してから、解放
      s := subListOf(p);
      s.Snach;
      FreeAndNil(s);
      FreeMem(p);
    end;
    //  ResBufを解放
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

{ どっちかというとデバッグ用 }

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
      //  再帰的に調べる
      lt.CheckLink(postmsg);
      //  サブリストの場合、内部の括弧との連続も調べる
      if Assigned(lt.FParentHead) and Assigned(lt.FParentTail) then
      begin
        if lt.BufCount > 0 then
        begin
          checkJoint(lt.FParentHead, lt.Head, 'SubList内の先頭が不連続');
          checkJoint(lt.Tail, lt.FParentTail, 'SubList内の末尾が不連続');
        end
        else
        begin
          checkJoint(lt.FParentHead,
                     lt.FParentTail, 'SubList内の先頭と末尾が不連続');
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
                  ResBufs[i], Format('[(%d)%d:%s]と[(%d)%d:%s]が不連続',
                  [i-1, ResTypes[i-1], Contents[i-1],
                   i,   ResTypes[i],   Contents[i]]));
    end;
    Inc(i);
  end;
end;

{ リストの構造化関連 }

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
  //  いったん平準化する
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
          else raise ESdsInvalidList.Create('")"が足りない');
        end;
        //  差し替える
        Items[i] := CreateSubListBuf(ResBufs[i], ResBufs[j]);
        if i + 1 < j then
        begin
          ResBufs[j - 1].rbnext := nil;               //  いったん切る
          SubLists[i].AddList(ResBufs[i+1]);
          SubLists[i].ListStructure;                  //  構造化する
          SubLists[i].Tail.rbnext := ResBufs[i].Tail; //  繋げ直す
        end;
        //  サブリストに取り込まれたものを削除
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
          raise Exception.CreateFmt('(%d) %d:%s(%p) -> %d:%s(%p) がつながってない',
                    [i-1,
                    ResTypes[i-1], Contents[i-1], tailOf(ResBufs[i-1]).rbnext,
                    ResTypes[i],   Contents[i],   headOf(ResBufs[i]) ]);
         end;
         Inc(i);
      end;
      if tailOf(ResBufs[i-1]).rbnext <> nil
      then raise Exception.Create('末尾がnilじゃない');
    end;
  end;

begin
  //  一応チェック
  CheckLink('before Flatten/Structure');

  Inc(FDoNotify);
  try
    i := 0;
    while i < BufCount do
    begin
      if IsSubList(i) then
      begin
        //  展開
        p  := ResBufs[i];
        lt := SubListOf(p);
        Items[i] := p.Head;
        Inc(i);
        Insert(i, p.Tail);
        p.Head.rbnext := p.Tail;
        if lt.BufCount > 0 then
        begin
          tailOf(lt.Tail).rbnext := nil;  //  いったん切ってから
          //debugOfList(lt);
          InsertList(i, lt.Snach);        //  ResBufを奪い取る
        end;
        //debugOfList(Self);
      end;
      Inc(i);
    end;
  finally
    Dec(FDoNotify);
  end;
end;

{ イテレータ }

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


{ 実際にリストを使って操作する関係 }

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
//  これだとサブリストもたどってしまう
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
