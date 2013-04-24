unit SDSplusDict;
//  Copyright (C) 2003 ABplus Inc. kazHIDA
//  All rights reserved.
//  $Id: SDSplusDict.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $

interface

{:Note::
  DICTIONARY用のTSdsList
::Note:}

{:Note::
    0     Object name (DICTIONARY)
    5     Handle
  102     Start of persistent reactors group; always "｛ACAD_REACTORS"
  330     Soft-pointer ID/handle to owner dictionary
  102     End of persistent reactors group, always "｝"
  330     Soft-pointer ID/handle to owner object
  100     Subclass marker (AcDbDictionary)
  280     Hard owner flag. If set to 1, indicates that elements of the dictionary are to be treated as hard owned
  281     Duplicate record cloning flag (determines how to merge duplicate entries):
          0 = Not applicable
          1 = Keep existing
          2 = Use clone
          3 = <xref>$0$<name>
          4 = $0$<name>
          5 = Unmangle name
    3     Entry name (one for each entry) (optional)
  350     Soft-owner ID/handle to entry object (one for each entry) (optional)
::Note:}

uses
  Classes, SDScore, SDSplusEnt;

const
  SDSDD_NotApply  = 0;  // Not applicable
  SDSDD_KeepExist = 1;  // Keep existing
  SDSDD_UseClone  = 2;  // Use clone        これは何？
  SDSDD_XrefNum   = 3;  // <xref>$0$<name>  これは何？
  SDSDD_Numbered  = 4;  // $0$<name>        これは何？
  SDSDD_Unmangle  = 5;  // Unmangle name    これは何？
  {:Note::
    Duplicate record cloning flag については、
    はっきりいってよく分からないので、
    当面、
    SDSDD_UseCloneはSDSDD_KeepExistと同じ
    SDSDD_XrefNum、SDSDD_Numbered、SDSDD_UnmangleはSDSDD_NotApplyと同じ
    として扱う
  ::Note:}


type

  ESdsDictDuplicate = class(ESdsException);
  //  重複が許されない辞書で、重複した要素を与えた

  TSdsDictonary = class (TSdsEntList)
  private
    FOwnerDict:       TSdsName;
    FOwnerObject:     TSdsName;
    FHardOwner:       Smallint;
    FDupFlag:         Smallint;
    FEntryList:       TStringList;
    function  GetEntCount: Integer;
    function  GetEntry(i: Integer):  TSdsEntHolder;
    function  GetStrings(i: Integer): String;
    procedure SetDupFlag(flg: Smallint);
  public
    constructor Create;
    constructor CreateByBuf(rb: PSdsResBuf); override;
    constructor CreateNamedObjDict;
    destructor  Destroy;    override;
    procedure SetComments;  override;
    procedure AddEnt(name: String; ent: TSdsName);
    procedure DeleteEnt(idx: Integer);    overload;
    procedure DeleteEnt(ent: TSdsName);   overload;
    procedure DeleteEnt(name: String);    overload;
    function  GetEntityList(idx: Integer): TSdsEntList;  overload;
    function  GetEntityList(name: String): TSdsEntList;  overload;
    function  Search(name: String): TSdsName;
    property  Filters;    //  implemeted in TSdsEntList
    property  OwnerDict: TSdsName    read FOwnerDict;
    property  OwnerObject: TSdsName  read FOwnerObject;
    property  HardOwner: Smallint    read FHardOwner;
    property  DupFlag: Smallint      read FDupFlag write SetDupFlag;
    property  Count: Integer         read GetEntCount;    //  意味が変わっている
    property  Entries[i: Integer]: TSdsEntHolder  read GetEntry;
    property  EntryNames[i: Integer]: String      read GetStrings;
  end;
  {:Note::
    引数なしのCreateは、新規の辞書を作る。
    この場合、ハンドルやオーナー関係は、リストに含まない(たぶんICADが
    つけてくれると思う)。
    また、DupFlagsは、デフォルトでは重複を認めないので、まずい場合は、
    Createの後に変更する(ただし、エントリが空の場合のみ変更可能)。
    それ以外のコンストラクタは、既存の辞書を読み込む。

    辞書のエントリに関する操作は、直ちに、ResBufのリストに反映される。
    元のTSdsListのInsert,Add,Delete系の操作は、そのまま残っているが、
    うかつに使うと辞書の構造を崩すおそれがあるので注意!
  ::Note:}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
implementation

uses
  SysUtils;

///////////////////////////////////////////////////////////////////////////
{ TSdsDictonary }

constructor TSdsDictonary.Create;
var
  rb: TSdsResBuf;
begin
  inherited Create;
  SetComments;

  FEntType        := 'DICTIONARY';
  FHandle         := '';
  FOwnerDict      := 0;
  FOwnerObject    := 0;
  FSubClassMarker := 'AcDbDictionary';
  FHardOwner      := 0;
  FDupFlag        := 0; //Duplicate record Not applicable
  FEntryList      := TStringList.Create;

  rb.rbnext := nil;

  rb.restype := 0;
  rb.rstring := PChar(FEntType);
  AddByCopy(rb);

  rb.restype := 100;
  rb.rstring := PChar(FSubClassMarker);
  AddByCopy(rb);

  rb.restype := 281;
  rb.rint    := FDupFlag;
  AddByCopy(rb);
end;

constructor TSdsDictonary.CreateNamedObjDict;
begin
  CreateByEnt(SdsNamedObjDict);
end;

constructor TSdsDictonary.CreateByBuf(rb: PSdsResBuf);
var
  p: PSdsResBuf;
  s: String;
begin
  inherited CreateByBuf(rb);

  FEntryList := TStringList.Create;
  ListStructure(True);

  SearchFromSubList(FOwnerDict, 330, 102, '{ACAD_REACTORS');
  Find(330, FOwnerObject);
  Find(280, FHardOwner);
  Find(281, FDupFlag);

  p := Assoc(3);
  if Assigned(p) then
  begin
    s := p.rstring;
    p := p.rbnext;
  end;
  while Assigned(p) do
  begin
    if p.restype = 350
    then FEntryList.AddObject(s, TSdsEntHolder.Create(p));
    p := SdsAssoc(3, p);
    if Assigned(p) then
    begin
      s := p.rstring;
      p := p.rbnext;
    end;
  end;
end;

procedure TSdsDictonary.SetComments;
begin
  inherited SetComments;
  CustomizeResType(  0, 'オブジェクト名 *');
  CustomizeResType(330, 'オーナ・オブジェクト(または辞書)');
  CustomizeResType(280, 'ハード・オーナ・フラグ');
  CustomizeResType(281, '重複エントリ発生時の処理方法');
  CustomizeResType(  3, 'エントリ名');
  CustomizeResType(350, 'エントリの実体のエンティティ名');
end;

destructor  TSdsDictonary.Destroy;
var
  i: Integer;
begin
  if Assigned(FEntryList) then with FEntryList do
  begin
    if Count > 0 then for i := 0 to Count - 1 do Objects[i].Free;
    FEntryList.Clear;
  end;
  inherited Destroy;
end;


{ プロパティ関連 }

procedure TSdsDictonary.SetDupFlag(flg: Smallint);
var
  rb: PSdsResBuf;
begin
  if FEntryList.Count > 0
  then raise ESdsException.Create('Cannot set DupFlags');

  if FDupFlag <> flg then
  begin
    FDupFlag := flg;
    rb := Assoc(281);
    if Assigned(rb) then rb.rint := flg;
  end;
end;

function  TSdsDictonary.GetEntCount: Integer;
begin
  Result := FEntryList.Count;
end;

function  TSdsDictonary.GetEntry(i: Integer):  TSdsEntHolder;
begin
  Result := FEntryList.Objects[i] as TSdsEntHolder;
end;

function  TSdsDictonary.GetStrings(i: Integer): String;
begin
  Result := FEntryList.Strings[i];
end;

{
procedure TSdsDictonary.SetFilter(const filter: array of String);
var
  i: Integer;
  p: PSdsResBuf;
begin
  ClearFilter;
  if Length(filter) > 0 then for i := High(filter) downto Low(filter) do
  begin
    p := FFilter;
    FFilter := sds_buildlist(SDS_RTSTR, PChar(filter[i]), SDS_RTNONE);
    if Assigned(FFilter) then FFilter.rbnext := p
    else
    begin
      if Assigned(p) then sds_relrb(p);
      raise ESdsException.Create('Failed sds_buildlist');
    end;
  end;
end;

procedure TSdsDictonary.ClearFilter;
begin
  SdsRelRB(FFilter);
end;
}
{ データ利用系 }

function  TSdsDictonary.GetEntityList(idx: Integer): TSdsEntList;
begin
  Result := TSdsEntList.CreateByEnt(GetEntry(idx).EntName, EntGetFilter);
end;

function  TSdsDictonary.GetEntityList(name: String): TSdsEntList;
begin
  Result := GetEntityList(FEntryList.IndexOf(name));
end;

function  TSdsDictonary.Search(name: String): TSdsName;
var
  idx: Integer;
begin
  idx := FEntryList.IndexOf(name);
  if idx < 0
  then raise ESdsException.Create('Not found [' + name + '] entry');
  Result := GetEntry(idx).EntName;
end;

{ 追加・削除系 }

procedure TSdsDictonary.AddEnt(name: String; ent: TSdsName);
var
  rb: PSdsResBuf;
  idx: Integer;

  procedure raiseException(const msg: String);
  begin
    raise ESdsDictDuplicate.Create(msg);
  end;

begin
  rb := sds_buildlist(3, PChar(name), 350, @ent, SDS_RTNONE);
  if Assigned(rb) then
  begin
    try
      //  重複を探す
      idx := FEntryList.IndexOf(name);
      if idx >= 0 then
      begin
        case FDupFlag of
          SDSDD_NotApply:   raiseException(name + ' (NotApply)');
          SDSDD_KeepExist:  ; //OK?
          SDSDD_UseClone:   ; //OK?
          SDSDD_XrefNum:    raiseException(name + ' (XrefNum)');
          SDSDD_Numbered:   raiseException(name + ' (Numbered)');
          SDSDD_Unmangle:   raiseException(name + ' (Unmangle)');
        end;
      end;
      idx := FEntryList.AddObject(name, TSdsEntHolder.Create(rb.rbnext));
      try
        AddList(rb);
      except
        DeleteEnt(idx);
        raise;
      end;
    except
      sds_relrb(rb);
      raise;
    end;
  end
  else raise ESdsException.Create('Failed sds_buildlist');
end;

procedure TSdsDictonary.DeleteEnt(name: String);
var
  i: Integer;
begin
  i := 0;
  while i < FEntryList.Count do
  begin
    if FEntryList.Strings[i] = name
    then DeleteEnt(i)
    else Inc(i);
  end;
end;

procedure TSdsDictonary.DeleteEnt(ent: TSdsName);
var
  i: Integer;
begin
  i := 0;
  while i < FEntryList.Count do
  begin
    if GetEntry(i).EntName = ent
    then DeleteEnt(i)
    else Inc(i);
  end;
end;

procedure TSdsDictonary.DeleteEnt(idx: Integer);
var
  h: TSdsEntHolder;
  i: Integer;
begin
  h := GetEntry(idx);
  if Assigned(h) then
  begin
    if Assigned(h.ResBuf) then
    begin
      i := IndexOf(h.ResBuf);
      if i > 0 then
      begin
        Delete(i-1);  //  EntryName
        Delete(i);    //  EntityID
      end;
    end;
    h.Free;
    FEntryList.Delete(idx);
  end;
end;

end.
