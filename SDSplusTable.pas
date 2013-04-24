unit SDSplusTable;
//  Copyright (C) 2003 ABplus Inc. kazHIDA
//  All rights reserved.
//  $Id: SDSplusTable.pas 266 2003-03-09 05:41:19Z kazhida $
//  $Author: kazhida $

interface

{:Note::
  TABLE�p��TSdsList
::Note:}


{:Note::
   -1     APP: entity name (changes each time a drawing is opened) 
    0     Entity type (table name) 
    5     Handle (all except DIMSTYLE) 
  105     Handle (DIMSTYLE table only) 
  102     Start of application-defined group "�oapplication_name". For example,
          "�oACAD_REACTORS" indicates the start of the AutoCAD persistent
          reactors group (optional)
  ???     application-defined codes  Codes and values within the 102 groups
          are application defined (optional)
  102     End of group, "�p" (optional)
  102     "�oACAD_REACTORS" indicates the start of the AutoCAD persistent
          reactors group. This group exists only if persistent reactors have
          been attached to this object (optional)
  330     Soft pointer ID/handle to owner dictionary (optional)
  102     End of group, "�p" (optional)
  102     "�oACAD_XDICTIONARY" indicates the start of an extension dictionary
          group. This group exists only if persistent reactors have been
          attached to this object (optional)
  360     Hard owner ID/handle to owner dictionary (optional)
  102     End of group, "�p" (optional)
  330     Soft-pointer ID/handle to owner object
  100     Subclass marker (AcDbSymbolTableRecord)
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
    property  Count: Integer          read GetEntCount;    //  �Ӗ����ς���Ă���
    property  BufCount: Integer       read GetBufCount;    //  ���ꂪ����Count
    property  Entities[i: Integer]: TSdsName read GetEntity;
  end;
  {:Note::
    �����Ȃ���Create�́AGROUP�����B
    ���̏ꍇ�A�n���h����I�[�i�[�֌W�́A���X�g�Ɋ܂܂Ȃ�(���Ԃ�ICAD��
    ���Ă����Ǝv��)�B
    ����ȊO�̃R���X�g���N�^�́A�����̃O���[�v��ǂݍ��ށB
  ::Note:}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
implementation

end.
