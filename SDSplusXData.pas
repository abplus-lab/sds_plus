unit SDSplusXData;
//  Copyright (C) 2003 ABplus Inc. kazHIDA
//  All rights reserved.
//  $Id: SDSplusXData.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $

interface

uses
  Classes, SDScore, SDSplusList;

{:Note::
  XDATA で使えるデータはこれだけ

  String            1000  Strings in extended data can be up to 255 bytes long
                          (with the 256th byte reserved for the null character)
  Application name  1001  also a string value Application names can be up to
                          31 bytes long (the 32nd byte is reserved for the null
                          character).
                          NOTE Do not add a 1001 group into your extended data
                          because AutoCAD assumes it is the beginning of a new
                          application extended data group
  Control string    1002  An extended data control string can be either
                          "｛"or "｝".
                          These braces enable applications to organize their
                          data by subdividing the data into lists.
                          The left brace begins a list, and the right brace
                          terminates the most recent list. Lists can be nested.
                          When AutoCAD reads the extended data for a particular
                          application, it checks to ensure that braces are
                          balanced
  Layer name        1003  Name of the layer associated with the extended data
  Binary data       1004  Binary data is organized into variable-length chunks.
                          The maximum length of each chunk is 127 bytes.
                          In ASCII DXF files, binary data is represented as
                          a string of hexadecimal digits, two per binary byte
  Database handle   1005  Handles of entities in the drawing database
                          NOTE When a drawing with handles and extended data
                          handles is imported into another drawing using
                          INSERT, INSERT *, XREF Bind, XBIND, or partial OPEN,
                          the extended data handles are translated in the same
                          manner as their corresponding entity handles,
                          thus maintaining their binding. This is also done
                          in the EXPLODE block operation or for any other
                          AutoCAD operation. When AUDIT detects an extended
                          data handle that doesn't match the handle of an
                          entity in the drawing file, it is considered an error.
                          If AUDIT is fixing entities, it sets the handle to 0
  3 reals           1010  Three real values, in the order X, Y, Z.
                    1020  They can be used as a point or vector record.
                    1030  AutoCAD never alters their value
  World space       1011  Unlike a simple 3D point, the world space coordinates
                    1021  are moved, scaled, rotated, and mirrored along with
                    1031  the parent entity to which the extended data belongs.
                          The world space position is also stretched when the
                          STRETCH command is applied to the parent entity and
                          this point lies within the select window
  World space       1012  Also a 3D point that is scaled, rotated, and mirrored
  displacement      1022  along with the parent (but is not moved or stretched)
                    1032
  World direction   1013  Also a 3D point that is rotated and mirrored along
                    1023  with the parent (but is not moved, scaled, or
                    1033  stretched)
  Real              1040  A real value
  Distance          1041  A real value that is scaled along with the parent
                          entity
  Scale factor      1042  Also a real value that is scaled along with the
                          parent. The difference between a distance and a scale
                          factor is application-defined
  Integer           1070  A 16-bit integer (signed or unsigned)
  Long              1071  A 32-bit signed (long) integer
::Note:}

type

  ESdsInvalidXData = class(ESdsException);

  TSdsXData = class(TStringList)
  private
    FHead:    PSdsResBuf;
    FParent:  TSdsList;
    procedure AddXDataBuf(const app: String;  rb: PSdsResBuf);
    procedure InsertXDataBuf(const app: String;
                                   idx: Integer; rb: PSdsResBuf);
    function  GetAttached: Boolean;
    function  GetAppName(i: Integer): String;
    function  GetListByIndex(i: Integer): TSdsList;
    function  GetListByName(app: String): TSdsList;
    procedure CheckResType(Sender: TObject; rb: PSdsResBuf; var relrb: Boolean);
    function  CopyResBuf(const rb: PSdsResBuf): PSdsResBuf;
  protected
    procedure InsertItem(idx: Integer; const s: string; obj: TObject); override;
    //  InsertItemが受け付けるのは、XDATAとして認められているrestype
    //  だけで構成されていてかつ、空でないTSdsListのみ。
    //  それ以外ではESdsInvalidXDataを発生させる。
    //  そのため、Add(),Insert()は使えないし、
    //  AddObject(),InsertObjectも同様の制限を受ける
    //  また、渡されたTSdsList自体はSnachされる
  public
    constructor Create;
    constructor CreateByBuf(rb: PSdsResBuf);
    procedure Clear; override;
    //  Attach済みの場合は、ResBufを解放しないようになっている
    procedure Delete(idx: Integer); override;
    //  ぶら下がっているオブジェクトもFreeするようになっている
    //  管理下にあるResBufを解放する
    procedure Attach(parent: TSdsList);
    //  新規にXDATAの所有者を割り当てるメソッド
    //  複数の所有者にAttachできないので、Attach済みの場合は、
    //  例外を発生させる
    procedure AddString(const app: String; const val: String);
    procedure AddLayer( const app: String; const val: String);
    procedure AddBinary(const app: String; const val: String);  //????
    procedure AddDBHand(const app: String; const val: String);  //????
    procedure AddPoint( const app: String; const val: TSdsPoint);
    procedure AddWsPos( const app: String; const val: TSdsPoint);
    procedure AddWsDisp(const app: String; const val: TSdsPoint);
    procedure AddWDir(  const app: String; const val: TSdsPoint);
    procedure AddReal(  const app: String; const val: Double);
    procedure AddDist(  const app: String; const val: Double);
    procedure AddScale( const app: String; const val: Double);
    procedure AddShort( const app: String; const val: Smallint);
    procedure AddWord(  const app: String; const val: Word);
    procedure AddLong(  const app: String; const val: Longint);
    procedure InsertString(const app: String; idx: Integer; const val: String);
    procedure InsertLayer( const app: String; idx: Integer; const val: String);
    procedure InsertBinary(const app: String; idx: Integer; const val: String);   //????
    procedure InsertDBHand(const app: String; idx: Integer; const val: String);   //????
    procedure InsertPoint( const app: String; idx: Integer; const val: TSdsPoint);
    procedure InsertWsPos( const app: String; idx: Integer; const val: TSdsPoint);
    procedure InsertWsDisp(const app: String; idx: Integer; const val: TSdsPoint);
    procedure InsertWDir(  const app: String; idx: Integer; const val: TSdsPoint);
    procedure InsertReal(  const app: String; idx: Integer; const val: Double);
    procedure InsertDist(  const app: String; idx: Integer; const val: Double);
    procedure InsertScale( const app: String; idx: Integer; const val: Double);
    procedure InsertShort( const app: String; idx: Integer; const val: Smallint);
    procedure InsertWord(  const app: String; idx: Integer; const val: Word);
    procedure InsertLong(  const app: String; idx: Integer; const val: Longint);
    //  データを追加挿入するメソッド
    procedure InsertXData(const app: String; idx: Integer; rb: PSdsResBuf);
    procedure AddXData(   const app: String;               rb: PSdsResBuf);
    //  自分で作ったResBufを追加挿入するメソッド、
    //  InsertItem()と同様の制約あり
    function  Clone: TSdsXData;
    //  自分と同じ内容で、AttachされていないXDATAをコピーして返す。
    //  中身のResBufは、それようにsds_buildlistされたものなので、
    //  いわゆる深いコピーになっている。
    property  Head: PSdsResBuf              read FHead;
    property  Attached: Boolean             read GetAttached;
    property  AppNames[i: Integer]: String  read GetAppName;
    property  Lists[app: String]: TSdsList  read GetListByName;
    property  Items[i: Integer]:  TSdsList  read GetListByIndex;
  end;
  {:Note::
    削除や変更するためのメソッドはないので、Lists[]かItems[]で、
    ぶら下がっているリストを引っ張り出して、操作する。
    それをいったら、挿入・追加もできてしまうわけであるが、
    そこまでは面倒見切れないので、自粛してもらうことにする

    また、Application名やLayer名などは、TABLESの内容と整合していなければ
    ならないのだけど、ここではそれを考慮せず、単に文字列として扱っている。
    XDATAにのApplication名は、APPIDに、Layer名はLAYERに含まれていなければ、
    ならないのだけど(なければ、それを登録する必要がある)、それは使う側が
    面倒をみる必要があるのでよろしく。
  ::Note:}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
implementation

////////////////////////////////////////////////////////
{ TSdsXData }

constructor TSdsXData.Create;
begin
  inherited Create;
  FHead   := nil;
  FParent := nil;
end;

constructor TSdsXData.CreateByBuf(rb: PSdsResBuf);
var
  idx: Integer;
begin
  SdsPrintf(#10'Create XDATA');
  inherited Create;
  FHead   := rb;
  FParent := nil;

  idx := -1;
  while Assigned(rb) do
  begin
    SdsPrintf(#10'restype = %d', [rb.restype]);
    if rb.restype = 1001 then
    begin
      SdsPrintf(' new-app %s ', [rb.rstring]);
      idx := AddObject(rb.rstring, TSdsList.Create);
      SdsPrintf('idx = %d', [idx]);
    end;
    if idx >= 0 then
    begin
      Items[idx].AddList(CopyResBuf(rb));
    end;
    SdsPrintf(' copied.');
    rb := rb.rbnext;
  end;
end;

procedure TSdsXData.Clear;
var
  i: Integer;
begin
  if Count > 0 then for i := 0 to Count - 1 do
  begin
    if Assigned(FParent) and Assigned(Items[i])
    then Items[i].Snach;
    Objects[i].Free;
    Objects[i] := nil;
  end;
  inherited Clear;
end;

procedure TSdsXData.Delete(idx: Integer);
begin
  if idx = 0 then
  begin
    if Assigned(Items[idx+1])
    then FHead := Items[idx].HeadOfHead
    else FHead := nil;
  end
  else Items[idx-1].TailOfTail.rbnext := Items[idx].TailOfTail.rbnext;
  Items[idx].TailOfTail.rbnext := nil;
  sds_relrb(Items[idx].HeadOfHead);
  inherited Delete(idx);
end;

function  TSdsXData.GetAppName(i: Integer): String;
begin
  Result := Strings[i];
end;

function  TSdsXData.GetListByIndex(i: Integer): TSdsList;
begin
  Result := Objects[i] as TSdsList;
end;

function  TSdsXData.GetListByName(app: String): TSdsList;
var
  idx: Integer;
begin
  idx := IndexOf(app);
  if idx < 0
  then Result := nil
  else Result := GetListByIndex(idx);
end;

function  TSdsXData.GetAttached: Boolean;
begin
  Result := Assigned(FParent);
end;

procedure TSdsXData.Attach(parent: TSdsList);
begin
  if Assigned(FParent)
  then raise ESdsException.Create('Already Attached.');

  FParent := parent;
  if Assigned(FParent) then FParent.TailOfTail.rbnext := FHead;
end;

procedure TSdsXData.CheckResType(Sender: TObject;
                                  rb: PSdsResBuf;
                                  var relrb: Boolean);
begin
  case rb.restype of
    1000,
    1001,
    1002,
    1003,
    1004,
    1005,
    1010,
    1011,
    1012,
    1013,
    1040,
    1041,
    1042,
    1070,
    1071: ; //ok
  else
    raise ESdsInvalidXData.Create('XDataでは使用できないデータが含まれていた');
  end;
end;

function  TSdsXData.CopyResBuf(const rb: PSdsResBuf): PSdsResBuf;
begin
  case rb.restype of
    1000,
    1001,
    1002,
    1003,
    1004,
    1005: Result := sds_buildlist(rb.restype, rb.rstring, SDS_RTNONE);
    1010,
    1011,
    1012,
    1013: Result := sds_buildlist(rb.restype, @(rb.rpoint), SDS_RTNONE);
    1040,
    1041,
    1042: Result := sds_buildlist(rb.restype, rb.rreal, SDS_RTNONE);
    1070: Result := sds_buildlist(rb.restype, rb.rint,  SDS_RTNONE);
    1071: Result := sds_buildlist(rb.restype, rb.rlong, SDS_RTNONE);
  else
    raise ESdsInvalidXData.Create('XDataでは使用できないデータが含まれていた');
  end;
end;

procedure TSdsXData.InsertItem(idx: Integer; const s: string; obj: TObject);
var
  rb: PSdsResBuf;
  lt: TSdsList;
begin
  SdsPrintf(#10'InsertItem [%d] %s', [idx, s]);
  if obj is TSdsList then with obj as TSdsList do
  begin
    SdsPrintf(#10'Check Types ');
    ForEach(CheckResType);
    SdsPrintf(' ok');
    rb := Snach;
    SdsPrintf(' got resbuf=%p ', [rb]);
    lt := TSdsList.CreateByBuf(Snach);
    SdsPrintf(' created-list ', [rb]);
    inherited  InsertItem(idx, s, lt);
    SdsPrintf(' inserted.');
  end
  else raise ESdsInvalidXData.Create('XDataでないものを挿入追加しようとした。');
end;

procedure TSdsXData.InsertXDataBuf(const app: String;
                                         idx: Integer; rb: PSdsResBuf);
var
  lt: TSdsList;
begin
  //  ここに来る前にrestypeのチェックは終わっているはず
  lt := Lists[app];
  if Assigned(lt)
  then lt.InsertList(idx, rb)
  else AddObject(app, TSdsList.CreateByBuf(rb));
end;

procedure TSdsXData.AddXDataBuf(const app: String;  rb: PSdsResBuf);
var
  lt: TSdsList;
begin
  //  ここに来る前にrestypeのチェックは終わっているはず
  lt := Lists[app];
  if Assigned(lt)
  then lt.AddList(rb)
  else AddObject(app, TSdsList.CreateByBuf(rb));
end;

procedure TSdsXData.AddString(const app: String; const val: String);
begin
  AddXDataBuf(app, sds_buildlist(1000, PChar(val), SDS_RTNONE));
end;

procedure TSdsXData.AddLayer( const app: String; const val: String);
begin
  AddXDataBuf(app, sds_buildlist(1003, PChar(val), SDS_RTNONE));
end;

procedure TSdsXData.AddBinary(const app: String; const val: String);
begin
  AddXDataBuf(app, sds_buildlist(1004, PChar(val), SDS_RTNONE));
end;

procedure TSdsXData.AddDBHand(const app: String; const val: String);
begin
  AddXDataBuf(app, sds_buildlist(1005, PChar(val), SDS_RTNONE));
end;

procedure TSdsXData.AddPoint( const app: String; const val: TSdsPoint);
begin
  AddXDataBuf(app, sds_buildlist(1010, @val, SDS_RTNONE));
end;

procedure TSdsXData.AddWsPos( const app: String; const val: TSdsPoint);
begin
  AddXDataBuf(app, sds_buildlist(1011, @val, SDS_RTNONE));
end;

procedure TSdsXData.AddWsDisp(const app: String; const val: TSdsPoint);
begin
  AddXDataBuf(app, sds_buildlist(1012, @val, SDS_RTNONE));
end;

procedure TSdsXData.AddWDir(  const app: String; const val: TSdsPoint);
begin
  AddXDataBuf(app, sds_buildlist(1013, @val, SDS_RTNONE));
end;

procedure TSdsXData.AddReal(  const app: String; const val: Double);
begin
  AddXDataBuf(app, sds_buildlist(1040, @val, SDS_RTNONE));
end;

procedure TSdsXData.AddDist(  const app: String; const val: Double);
begin
  AddXDataBuf(app, sds_buildlist(1041, @val, SDS_RTNONE));
end;

procedure TSdsXData.AddScale( const app: String; const val: Double);
begin
  AddXDataBuf(app, sds_buildlist(1042, @val, SDS_RTNONE));
end;

procedure TSdsXData.AddShort( const app: String; const val: Smallint);
begin
  AddXDataBuf(app, sds_buildlist(1070, @val, SDS_RTNONE));
end;

procedure TSdsXData.AddWord(  const app: String; const val: Word);
begin
  AddXDataBuf(app, sds_buildlist(1070, @val, SDS_RTNONE));
end;

procedure TSdsXData.AddLong(  const app: String; const val: Longint);
begin
  AddShort(app, Smallint(val));
end;

procedure TSdsXData.InsertString(const app: String; idx: Integer; const val: String);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1000, PChar(val), SDS_RTNONE));
end;

procedure TSdsXData.InsertLayer( const app: String; idx: Integer; const val: String);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1003, PChar(val), SDS_RTNONE));
end;

procedure TSdsXData.InsertBinary(const app: String; idx: Integer; const val: String);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1004, PChar(val), SDS_RTNONE));
end;

procedure TSdsXData.InsertDBHand(const app: String; idx: Integer; const val: String);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1005, PChar(val), SDS_RTNONE));
end;

procedure TSdsXData.InsertPoint( const app: String; idx: Integer; const val: TSdsPoint);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1010, @val, SDS_RTNONE));
end;

procedure TSdsXData.InsertWsPos( const app: String; idx: Integer; const val: TSdsPoint);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1011, @val, SDS_RTNONE));
end;

procedure TSdsXData.InsertWsDisp(const app: String; idx: Integer; const val: TSdsPoint);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1012, @val, SDS_RTNONE));
end;

procedure TSdsXData.InsertWDir(  const app: String; idx: Integer; const val: TSdsPoint);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1013, @val, SDS_RTNONE));
end;

procedure TSdsXData.InsertReal(  const app: String; idx: Integer; const val: Double);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1040, @val, SDS_RTNONE));
end;

procedure TSdsXData.InsertDist(  const app: String; idx: Integer; const val: Double);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1041, @val, SDS_RTNONE));
end;

procedure TSdsXData.InsertScale( const app: String; idx: Integer; const val: Double);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1042, @val, SDS_RTNONE));
end;

procedure TSdsXData.InsertShort( const app: String; idx: Integer; const val: Smallint);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1070, @val, SDS_RTNONE));
end;

procedure TSdsXData.InsertWord(  const app: String; idx: Integer; const val: Word);
begin
  InsertShort(app, idx, Smallint(val));
end;

procedure TSdsXData.InsertLong(  const app: String; idx: Integer; const val: Longint);
begin
  InsertXDataBuf(app, idx, sds_buildlist(1071, @val, SDS_RTNONE));
end;

procedure TSdsXData.InsertXData(const app: String; idx: Integer; rb: PSdsResBuf);
var
  relrb: Boolean;
begin
  relrb := False;
  CheckResType(Self, rb, relrb);
  InsertXDataBuf(app, idx, rb);
end;


procedure TSdsXData.AddXData(const app: String; rb: PSdsResBuf);
var
  relrb: Boolean;
begin
  relrb := False;
  CheckResType(Self, rb, relrb);
  AddXDataBuf(app, rb);
end;

function  TSdsXData.Clone: TSdsXData;
var
  rb:   PSdsResBuf;
  idx:  Integer;
begin
  Result := TSdsXData.Create;
  rb  := FHead;
  idx := -1;
  while Assigned(rb) do
  begin
    if rb.restype = 1001
    then idx := Result.AddObject(rb.rstring, TSdsList.Create);
    if idx >= 0 then
    begin
      Result.Items[idx].AddList(CopyResBuf(rb));
    end;
    rb := rb.rbnext;
  end;
end;

end.
