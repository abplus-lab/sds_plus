unit SDSplusGroup;
//  Copyright (C) 2003 ABplus Inc. kazHIDA
//  All rights reserved.
//  $Id: SDSplusGroup.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $

interface

{:Note::
  DICTIONARY用のTSdsList
::Note:}


{:Note::
    0 Object name (GROUP)
    5 Handle
  102 Start of persistent reactors group; always
      "｛ACAD_REACTORS" (persistent reactors group appears
      in all dictionaries except the main dictionary)
  330 Soft-pointer ID/handle to owner dictionary.
      For GROUP objects this is always the ACAD_GROUP
      entry of the named object dictionary
  102 End of persistent reactors group, always "｝"
  330 Soft-pointer ID/handle to owner object
  100 Subclass marker (AcDbGroup)
  300 Group description
   70 "Unnamed" flag: 1 = Unnamed; 0 = Named
   71 Selectability flag: 1 = Selectable; 0 = Not selectable
  340 Hard-pointer handle to entity in group (one entry per object)
::Note:}

uses
  SDScore, SDSplusEnt;

type

  TSdsGroup = class (TSdsEntList)
  private
    FOwnerDict:       TSdsName;
    FOwnerObject:     TSdsName;
    FDescription:     String;
    FUnnamed:         Boolean;
    FSelectable:      Boolean;
    function  GetEntCount: Integer;
    function  GetEntity(idx: Integer): TSdsName;
  public
    constructor Create;
    constructor CreateByBuf(rb: PSdsResBuf); override;
    procedure SetComments;                override;
    procedure AddEnt(ent: TSdsName);
    procedure DeleteEnt(idx: Integer);    overload;
    procedure DeleteEnt(ent: TSdsName);   overload;
    function  GetEntityList(idx: Integer): TSdsEntity;
    property  Filters;    //  implemeted in TSdsEntList
    property  OwnerDict: TSdsName     read FOwnerDict;
    property  OwnerObject: TSdsName   read FOwnerObject;
    property  Description: String     read FDescription;
    property  Unnamed: Boolean        read FUnnamed;
    property  Selectable: Boolean     read fSelectable;
    property  Count: Integer          read GetEntCount;    //  意味が変わっている
    property  BufCount: Integer       read GetBufCount;    //  これが元のCount
    property  Entities[i: Integer]: TSdsName read GetEntity;
  end;
  {:Note::
    引数なしのCreateは、新規にGROUPを作る。
    この場合、ハンドルやオーナー関係は、リストに含まない(たぶんICADが
    つけてくれると思う)。
    それ以外のコンストラクタは、既存のグループを読み込む。
  ::Note:}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
implementation

///////////////////////////////////////////////////////////////////////////
{ TSdsGroup }

constructor TSdsGroup.Create;
var
  rb: TSdsResBuf;

  function BoolVal(b: Boolean): Smallint;
  begin
    if b then Result := 1 else Result := 0;
  end;

begin
  inherited Create;
  SetComments;

  FHandle         := '';
  FEntType        := 'GROUP';
  FOwnerDict      := 0;
  FOwnerObject    := 0;
  FSubClassMarker := 'AcDbGroup';
  FDescription    := '';
  FUnnamed        := True;
  FSelectable     := True;

  rb.rbnext := nil;

  rb.restype := 0;
  rb.rstring := PChar(FEntType);
  AddByCopy(rb);

  rb.restype := 100;
  rb.rstring := PChar(FSubClassMarker);
  AddByCopy(rb);

  rb.restype := 300;
  rb.rstring := PChar(FDescription);
  AddByCopy(rb);

  rb.restype := 70;
  rb.rint    := BoolVal(FUnnamed);
  AddByCopy(rb);

  rb.restype := 71;
  rb.rint    := BoolVal(FSelectable);
  AddByCopy(rb);
end;

constructor TSdsGroup.CreateByBuf(rb: PSdsResBuf);
begin
  inherited CreateByBuf(rb);

  ListStructure(True);

  SearchFromSubList(FOwnerDict, 330, 102, '{ACAD_REACTORS');
  Find(330, FOwnerObject);
  Find(300, FDescription);
  Find( 70, FUnnamed);
  Find( 71, FSelectable);
end;

procedure TSdsGroup.SetComments;
begin
  inherited SetComments;
  CustomizeResType(  0, 'オブジェクト名 *');
  CustomizeResType(330, 'オーナ・オブジェクト(または辞書)');
  CustomizeResType(280, 'ハード・オーナ・フラグ');
  CustomizeResType(300, 'グループの説明');
  CustomizeResType( 70, '名前なしフラグ(1:名前なし,0:名前あり)');
  CustomizeResType(340, 'グループに所属するエンティティ名');
end;

function  TSdsGroup.GetEntCount:    Integer;
var
  rb: PSdsResBuf;
begin
  Result := 0;
  rb := Assoc(340);
  while Assigned(rb) do
  begin
    if rb.restype = 340 then Inc(Result);
    rb := rb.rbnext;
  end;
end;

function  TSdsGroup.GetEntity(idx: Integer): TSdsName;
var
  i: Integer;
begin
  i := 0;
  while (i < BufCount) and (idx >= 0) do
  begin
    if ResTypes[i] = 340 then
    begin
      if idx > 0 then Dec(idx)
      else
      begin
        Result := Names[i];
        Exit;
      end;
    end;
    Inc(i);
  end;
  raise ESdsErrNotFound.CreateFmt('%dは、範囲外です', [i]);
end;

function  TSdsGroup.GetEntityList(idx: Integer): TSdsEntity;
begin
  Result := TSdsEntity.CreateByEnt(GetEntity(idx), EntGetFilter);
end;

procedure TSdsGroup.AddEnt(ent: TSdsName);
var
  rb: TSdsResBuf;
begin
  rb.restype := 340;
  rb.rbnext  := nil;
  rb.rlname  := ent;
  AddByCopy(rb);
end;

procedure TSdsGroup.DeleteEnt(idx: Integer);
var
  i: Integer;
begin
  i := 0;
  while (i < BufCount) and (idx >= 0) do
  begin
    if ResTypes[i] = 340 then
    begin
      if idx > 0 then Dec(idx)
      else
      begin
        Delete(i);
        i := BufCount;
      end;
    end;
    Inc(i);
  end;
end;

procedure TSdsGroup.DeleteEnt(ent: TSdsName);
var
  i: Integer;
begin
  i := 0;
  while i < BufCount do
  begin
    if (ResTypes[i] = 340) and (Names[i] = ent) then
    begin
      Delete(i);
      i := BufCount;
    end;
    Inc(i);
  end;
end;



end.
