unit SDSplusEnt;
//  Copyright (C) 2003 ABplus Inc. kazHIDA
//  All rights reserved.
//  $Id: SDSplusEnt.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $

interface

{:Note::
  ������Entity�̃x�[�X�E�N���XTSdsEntiry��񋟂���N���X�Ȃ̂ł��邪�A
  �܂��A�����܂Ŏ肪�܂��Ȃ��̂ŁADictonary��Group�ŕK�v�ɂȂ�
  �T�u�Z�b�g�̃N���XTSdsEntList���������Ă���
::Note*}

uses
  Classes, SDScore, SDSplusList, SDSplusXData;

const
  SDSC_BYLAYER = 256;
  SDSC_BYBLOCK =   0;

  SDS_RTXDATA_SENTINEL = -3;

type

  TSdsEntList = class(TSdsList)
  private
    FFilterStr: String;
    FFilter:    PSdsResBuf;
    procedure SearchFields;
  protected
    FHandle:          String;
    FEntType:         String;
    FSubClassMarker:  String;
    FEntityID:        TSdsName;
    function  GetCaption: String; virtual;
    procedure SetComments;        virtual;
    procedure SetFilters(s: String);
    property  EntGetFilter: PSdsResBuf read FFilter;
    property  Filters: String read FFilterStr write SetFilters;
  public
    constructor Create;
    constructor CreateByBuf(rb: PSdsResBuf);                          override;
    constructor CreateByEnt(en: TSdsName; Filter: PSdsResBuf = nil);  override;
    constructor CreateFromList(list: TSdsEntList);                    virtual;
    destructor  Destroy;  override;
    function  SearchFromSubList(var ent: TSdsName; restype: Smallint;
                              lbtype: Smallint = SDS_RTLB;
                              lbstr: String = ''): Boolean;           virtual;
    property  Handle: String          read FHandle;
    property  EntityType: String      read FEntType;
    property  ObjectName: String      read FEntType;    //  Entity type�̕ʖ�
    property  SubClassMarker: String  read FSubClassMarker;
    property  EntityID: TSdsName      read FEntityID;
    property  Caption: String         read GetCaption;
  end;
  {:Note::
    Handle��Entity type�́A�قƂ�ǂ̗v�f�������Ă�����̂Ȃ̂ŁA
    ���炩���߃v���p�e�B�Ƃ��ďo����悤�ɂ��Ă���
    TSdsName���g����Create�����ꍇ�́A�����ێ�����
  ::Note:}

  TSdsBufHolder = class(TObject)
  private
    FResBuf: PSdsResBuf;
  public
    constructor Create(rb: PSdsResBuf);
    property  ResBuf: PSdsResBuf read FResBuf;
  end;

  TSdsEntHolder = class(TSdsBufHolder)
  private
    FCode:   Smallint;
    FName:   TSdsName;
  public
    constructor Create(rb: PSdsResBuf);                 overload;
    property  GroupCode: Smallint     read FCode;
    property  EntName: TSdsName       read FName;
  end;
  {:Note::
    �����Ƃ��O���[�v�Ƃ����Ƒ��̃G���e�B�e�B��ێ����Ă���ꍇ������̂ŁA
    ���̎��̂����o���܂ŁAEntityName�������Ă������߂̃I�u�W�F�N�g
  ::Note:}


{:Note::
  �܂��A�����܂ł́A�ǂ��炩�Ƃ�����Entity���Ǘ����邽�߂�
  �I�u�W�F�N�g�ɕK�v�Ȃ��̒��S�ɂ���Ă����킯�����ǁA
  ���������́AEntity���̂��̂ɂ��čl���Ă����킯��

   -1     APP: entity name (changes each time a drawing is opened)  not omitted
    0     Entity type                                               not omitted
    5     Handle                                                    not omitted
  102     Start of application defined group
          "�oapplication_name" (optional)                           no default
  ???     application-defined codes  Codes and values
          within the 102 groups are application-defined (optional)  no default
  102     End of group, "�p" (optional)                             no default
  102     "�oACAD_REACTORS" indicates the start of the AutoCAD
          persistent reactors group. This group exists
          only if�@persistent reactors have been attached to
          this object (optional)                                    no default
  330     Soft pointer ID/handle to owner dictionary (optional)     no default
  102     End of group, "�p" (optional)                             no default
  102     "�oACAD_XDICTIONARY" indicates the start of an extension
          dictionary group. This group exists only if persistent
          reactors have been attached to this object (optional)     no default
  360     Hard owner ID/handle to owner dictionary (optional)       no default
  102     End of group, "�p" (optional)                             no default
  330     Soft-pointer ID/handle to owner BLOCK_RECORD object       not omitted
  100     Subclass marker (AcDbEntity)                              not omitted
   67     Absent or zero indicates entity is in model space.
          1 indicates entity is in paper space (optional)           0
  410     APP: layout tab name                                      not omitted
    8     Layer name                                                not omitted
    6     Linetype name (present if not BYLAYER).
          The special name BYBLOCK indicates a floating
          linetype (optional)                                       BYLAYER
   62     Color number (present if not BYLAYER);
          zero indicates the BYBLOCK (floating) color;
          256 indicates BYLAYER;
          a negative value indicates that the layer is
          turned off (optional)                                     BYLAYER
  370     Lineweight enum value. Stored and moved around as
          a 16-bit integer.                                         not omitted
   48     Linetype scale (optional)                                 1.0
   60     Object visibility (optional):
          0 = Visible, 1 = Invisible 0
   92     The number of bytes in the image (and subsequent
          binary chunk records) (optional)                          no default
  310     Preview image data (multiple lines; 256 charaters
          max. per line) (optional)                                 no default

  Entity�ɋ��ʂ̃f�[�^�Ƃ��������ł��炢�������񂠂�B
  �Ƃ����Ă��Aoptional�������肷��̂������̂����ǁB

    0     Entity type                                               not omitted
    5     Handle                                                    not omitted
  330     Soft pointer ID/handle to owner dictionary (optional)     no default
  330     Soft-pointer ID/handle to owner BLOCK_RECORD object       not omitted
  100     Subclass marker (AcDbEntity)                              not omitted
   67     Absent or zero indicates entity is in model space.
          1 indicates entity is in paper space (optional)           0
  410     APP: layout tab name                                      not omitted
    8     Layer name                                                not omitted
    6     Linetype name (present if not BYLAYER).
          The special name BYBLOCK indicates a floating
          linetype (optional)                                       BYLAYER
   62     Color number (present if not BYLAYER);
          zero indicates the BYBLOCK (floating) color;
          256 indicates BYLAYER;
          a negative value indicates that the layer is
          turned off (optional)                                     BYLAYER
  370     Lineweight enum value. Stored and moved around as
          a 16-bit integer.                                         not omitted
   48     Linetype scale (optional)                                 1.0
   60     Object visibility (optional):
          0 = Visible, 1 = Invisible 0

  �Ƃ肠�����A���̂������p�ӂ��Ă����΂悳����
  ���ƁA�O���Ȃ��̂́AXDATA�܂��̈����B
::Note:}

  TSdsEntity = class(TSdsEntList)
  private
    function  GetDataCount: Integer;
    procedure CopyXData(x: TSdsXData; freeExist: Boolean);
    procedure SetXData(x: TSdsXData);
  protected
    FOwnerDict:   TSdsName;
    FOwnerBlock:  TSdsName;
    FPaperSpace:  Boolean;
    FLayoutTab:   String;
    FLayer:       String;
    FLineType:    String;
    FColor:       Smallint;
    FLineWeight:  Smallint;
    FLineScale:   Double;
    FHidden:      Boolean;
    FXData:       TSdsXData;
    procedure SetComments;  override;
  public
    constructor Create;
    constructor CreateByBuf(rb: PSdsResBuf); override;
    destructor  Destroy; override;
    procedure CopyXDataFrom(const src: TSdsEntity; freeExist: Boolean = True);
    //  ���̃G���e�B�e�B����XDATA���R�s�[����
    //  freeExist��True�Ȃ������XDATA�͔j������
    property  OwnerDict: TSdsName read FOwnerDict;
    property  OwnerBlock: TSdsName read FOwnerBlock;
    property  PaperSpace: Boolean read FPaperSpace;
    property  LayoutTab: String read FLayoutTab;
    property  Layer: String read FLayer;
    property  LineType: String read FLineType;
    property  Color: Smallint read FColor;
    property  LineWeight: Smallint read FLineWeight;
    property  LineScale: Double read FLineScale;
    property  Hidden: Boolean read FHidden;
    //  ������Entity�Ƃ��Ẵv���p�e�B
    property  XData: TSdsXData    read FXData write SetXData;
    property  XDataCount: Integer read GetDataCount;
    //  XData�֘A�̃v���p�e�B
  end;




///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
implementation

uses
  SysUtils;

////////////////////////////////////////////////////////
{ TSdsBufHolder }

constructor TSdsBufHolder.Create(rb: PSdsResBuf);
begin
  inherited Create;
  FResBuf := rb;
end;

  ////////////////////////////////////////////////////////
{ TSdsEntHolder }

constructor TSdsEntHolder.Create(rb: PSdsResBuf);
begin
  inherited Create(rb);
  FCode   := rb.restype;
  FName   := rb.rlname;
end;

////////////////////////////////////////////////////////
{ TSdsEntList }

constructor TSdsEntList.Create;
begin
  inherited Create;
  SetComments;
  FEntType        := '';
  FHandle         := '';
  FSubClassMarker := '';
  FEntityID       := 0;
  FFilter         := nil;
  FFilterStr      := '';
  //  ���ꎩ�̂��g���Đ��������C���X�^���X��
  //  �͂����肢���ĕs���ȏ�ԁB
  //  �h���N���X��override����邱�Ƃ����҂��Ă���
end;

constructor TSdsEntList.CreateByBuf(rb: PSdsResBuf);
begin
  FFilter   := nil;
  FFilterStr:= '';
  inherited CreateByBuf(rb);
  SetComments;
  SearchFields;
  FEntityID := 0;
end;

constructor TSdsEntList.CreateByEnt(en: TSdsName; Filter: PSdsResBuf);
begin
  FFilter   := nil;
  FFilterStr:= '';
  inherited CreateByEnt(en, Filter);
  SetComments;
  SearchFields;
  FEntityID := en;
end;

constructor TSdsEntList.CreateFromList(list: TSdsEntList);
begin
  FFilter   := nil;
  FFilterStr:= '';
  CreateByBuf(list.Snach);
  FEntityID := list.EntityID;
  list.Free;
end;

destructor  TSdsEntList.Destroy;
begin
  if Assigned(FFilter) then SdsRelRB(FFilter);
  inherited Destroy;
end;

procedure TSdsEntList.SetComments;
begin
  //�������Ȃ�
end;

procedure TSdsEntList.SearchFields;
begin
  Find(  0, FEntType);
  Find(  5, FHandle);
  Find(100, FSubClassMarker);
end;

function TSdsEntList.GetCaption: String;
begin
  Result := FEntType + ' <' + Format('%X', [FEntityID]) + ' . ' + FHandle + '>';
end;

function TSdsEntList.SearchFromSubList(var ent: TSdsName; restype: Smallint;
                              lbtype: Smallint; lbstr: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (i < BufCount) and (not Result) do
  begin
    if IsSubList(i) and (ResBufs[i].Head.restype = lbtype) then
    begin
      if (lbstr = '')
      or (StrComp(ResBufs[i].Head.rstring, PChar(lbstr)) = 0) then
      begin
        Result := SubLists[i].Find(restype, ent);
      end;
    end;
    Inc(i);
  end;
end;

procedure TSdsEntList.SetFilters(s: String);
var
  i: Integer;
  n: Integer;
  p: PSdsResBuf;
  f: array of String;
begin
  if FFilterStr = s then Exit;
  FFilterStr := s;

  //  ��������N���A
  SdsRelRB(FFilter);
  if s = '' then Exit;

  //  �Ԃ؂�ɂ���
  SetLength(f, 0);
  repeat
    n := Length(f);
    SetLength(f, n + 1);
    i := Pos(#9, s);
    if i > 0 then
    begin
      f[n] := Copy(s, 1, i - 1);
      System.Delete(s, 1, i);
    end
    else
    begin
      f[n] := s;
      s := ''
    end
  until s = '';

  //  �t�B���^�[�����
  if Length(f) > 0 then for i := High(f) downto Low(f) do
  begin
    p := FFilter;
    FFilter := sds_buildlist(SDS_RTSTR, PChar(f[i]), SDS_RTNONE);
    if Assigned(FFilter) then FFilter.rbnext := p
    else
    begin
      if Assigned(p) then sds_relrb(p);
      raise ESdsException.Create('Failed sds_buildlist');
    end;
  end;
end;


////////////////////////////////////////////////////////
{ TSdsEntity }

constructor TSdsEntity.Create;
begin
  inherited Create;
  FOwnerDict  := 0;
  FOwnerBlock := 0;
  FPaperSpace := False;
  FLayoutTab  := '';
  FLayer      := '0';
  FLineType   := 'BYLAYER';
  FColor      := SDSC_BYLAYER;
  FLineWeight := 0;
  FLineScale  := 1.0;
  FHidden     := False;
  FXData      := nil;
  //  ���ꎩ�̂��g���Đ��������C���X�^���X��
  //  �͂����肢���ĕs���ȏ�ԁB
  //  �h���N���X��override����邱�Ƃ����҂��Ă���
end;

constructor TSdsEntity.CreateByBuf(rb: PSdsResBuf);
begin
  inherited CreateByBuf(rb);
  ListStructure(True);

  SearchFromSubList(FOwnerDict, 330, 102, '{ACAD_REACTORS');
  Find(330, FOwnerBlock);
  Find( 67, FPaperSpace);
  Find(410, FLayoutTab);
  Find(  8, FLayer);
  Find(  6, FLineType);
  Find( 62, FColor);
  Find(370, FLineWeight);
  Find( 48, FLineScale);
  Find( 60, FHidden);

  rb := Assoc(SDS_RTXDATA_SENTINEL);
  if Assigned(rb) then
  begin
    //SdsPrintf(#10'Create XDATA');
    FXData := TSdsXdata.CreateByBuf(rb.rbnext);
    SdsPrintf(#10'Attach Self');
    FXData.Attach(Self);
    SdsPrintf(#10'Attached XDATA');
  end
  else FXData := nil;
end;

destructor  TSdsEntity.Destroy;
var
  i: Integer;
begin
  if Assigned(FXData) then with FXData
  do if Count > 0 then for i := 0 to Count - 1 do Objects[i].Free;
  FXData.Free;
  inherited Destroy;
end;

procedure TSdsEntity.SetComments;
begin
  inherited SetComments;
  CustomizeResType(  0, '�I�u�W�F�N�g�� *');
  CustomizeResType(330, '�I�[�i�E�u���b�N(�܂��͎���)');
  CustomizeResType(410, '���C�A�E�g�E�^�u��(?)');
end;

function TSdsEntity.GetDataCount: Integer;
begin
  if Assigned(FXData)
  then Result := FXData.Count
  else Result := 0;
end;

procedure TSdsEntity.SetXData(x: TSdsXData);
begin
  CopyXData(x, True);
end;

procedure TSdsEntity.CopyXData(x: TSdsXData; freeExist: Boolean);
var
  idx: Integer;
  i:   Integer;
  lt:  TSdsList;
  nm:  String;
begin
  if freeExist and Assigned(FXData) then
  begin
    //  ���������ɂ���
    while FXData.Count > 0 do FXData.Delete(0);   //  ResBuf�����
    FreeAndNil(FXData);
    idx := AssocIndex(SDS_RTXDATA_SENTINEL);
    if idx < BufCount then Delete(idx);
  end;

  if Assigned(x) and (x.Count > 0) then
  begin
    if Assigned(FXData) then
    begin
      //  ���Ƃ��Ƃ�XDATA���c���Ă���ꍇ�͂߂�ǂ�����
      //  �������ăo���o���ɂ���
      x := x.Clone;
      try
        for i := 0 to x.Count - 1 do x.Items[i].TailOfTail.rbnext := nil;
        for i := 0 to x.Count - 1 do
        begin
          nm := x.AppNames[i];                    //  appname�𒲂ׂ�
          lt := FXData.Lists[nm];
          if Assigned(lt)
          then lt.AddList(x.Items[i].Snach)       //  ���ɂ���΂���ɒǉ�
          else FXData.AddObject(nm, x.Items[i]);  //  �Ȃ���΁A���ꎩ�̂�ǉ�
        end;
      finally
        x.Free;
      end;
    end
    else
    begin
      //  Clone�����蓖�Ă�
      FXData := x.Clone;
      FXData.Attach(Self);
      //  �����𗧂ĂČq����
      AddList(sds_buildlist(SDS_RTXDATA_SENTINEL, 0, SDS_RTNONE));
      AddList(x.Head);
    end;
  end;
end;

procedure TSdsEntity.CopyXDataFrom(const src: TSdsEntity; freeExist: Boolean);
begin
  if Assigned(src)
  then CopyXData(src.XData, freeExist)
  else CopyXData(nil, freeExist)
end;


end.
