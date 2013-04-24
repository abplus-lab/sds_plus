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
unit ListForm;
//  $Id: ListForm.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Menus, SDScore, SDSplusList, StdActns,
  ActnList, EntForm;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    Exit1: TMenuItem;
    StatusBar1: TStatusBar;
    ListView1: TListView;
    Splitter1: TSplitter;
    Window1: TMenuItem;
    Cascade1: TMenuItem;
    ileHorizontal1: TMenuItem;
    ileVertical1: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    Exit2: TMenuItem;
    procedure N1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Cascade1Click(Sender: TObject);
    procedure ileHorizontal1Click(Sender: TObject);
    procedure ileVertical1Click(Sender: TObject);
  private
    { Private �錾 }
    function  AddEntity(ent: TSdsName): TSdsName;
    procedure ShowEntity(ent: TSdsName; cap: String);
    function  ShowExistForm(ent: TSdsName): Boolean;
  public
    { Public �錾 }
    procedure LoadEntities;
    procedure LoadTables(tbl: String; ClearFlag: Boolean = True); overload;
    procedure LoadTables;                                         overload;
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

function TForm3.AddEntity(ent: TSdsName): TSdsName;
var
  lt: TSdsList;
  it: TListItem;
  c:  String;
  h:  String;
begin
  Result := ent;
  lt := TSdsList.CreateByEnt(ent);
  try
    lt.Find(0, c);
    lt.Find(5, h);
    it := ListView1.Items.Add;
    it.Caption := c;
    it.SubItems.Add(Format('%X', [ent]));
    it.SubItems.Add(h);
  finally
    lt.Free;
  end;
end;

procedure TForm3.ShowEntity(ent: TSdsName; cap: String);
var
  f: TForm4;

  procedure EnableAction(a: TWindowAction);
  begin
    a.Form    := Self;
    a.Enabled := True;
  end;

begin
  if not ShowExistForm(ent) then
  begin
    f := TForm4.Create(Application);
    f.Caption := cap;
    f.EntName := ent;
    f.Show;
  end;
end;

function  TForm3.ShowExistForm(ent: TSdsName): Boolean;
var
  i: Integer;
begin
  Result := True;
  i := 0;
  while i < MDIChildCount do
  begin
    if (MDIChildren[i] as TForm4).EntName = ent then
    begin
      //  ���ɂ�������A������o������
      MDIChildren[i].Show;
      SdsPrintf(#10'found.');
      Exit;
    end;
    Inc(i);
  end;
  Result := False;
end;

procedure TForm3.N1Click(Sender: TObject);
var
  i: Integer;
  ent: TSdsName;
  cap: String;
begin
  if ListView1.Items.Count > 0 then for i := 0 to ListView1.Items.Count - 1 do
  begin
    with ListView1.Items.Item[i] do
    if Selected then
    begin
      //  �G���e�B�e�B���ƃt�H�[������L���v�V����������
      ent := StrToInt64('$' + SubItems[0]);
      cap := Caption + '<' + SubItems[0] + ' . ' + SubItems[1] + '>';
      ShowEntity(ent, cap);
    end;
  end;
end;

procedure TForm3.Exit2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  i := MDIChildCount;
  while i > 0 do
  begin
    //SdsPrintf(#10'[%d/%d] ', [i, MDIChildCount]);
    Dec(i);
    //SdsPrintf(MDIChildren[i].Caption);
    //MDIChildren[i].Close;
    //MDIChildren[i].Release;
    MDIChildren[i].Free;
    //SdsPrintf(' closed.');
  end;
  {:Note::
    �q�t�H�[�����������
    �q�t�H�[����Application�Ǘ����ɂ���݂����ŁA�����I�ɉ�����Ȃ���
    �g���Ȃ�(Show���Ă�����Ȃ�)�̂ɁA���݂��邱�ƂɂȂ��Ă��܂�
  ::Note:}
end;

procedure TForm3.Cascade1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TForm3.ileHorizontal1Click(Sender: TObject);
begin
  TileMode := tbHorizontal;
  Tile;
end;

procedure TForm3.ileVertical1Click(Sender: TObject);
begin
  TileMode := tbVertical;
  Tile;
end;

procedure TForm3.LoadEntities;
var
  ent: TSdsName;
begin
  ListView1.Clear;
  try
    ent := AddEntity(SdsEntNext);
    while True do
    begin
      ent := AddEntity(SdsEntNext(ent));
    end
  except
    //  ���[�v�I��
  end;
end;

procedure TForm3.LoadTables(tbl: String; ClearFlag: Boolean);
var
  rb: PSdsResBuf;
begin
  if ClearFlag then ListView1.Clear;

  rb := SdsTblNext(tbl, True);
  while Assigned(rb) do
  begin
    rb := SdsAssoc(-1, rb);
    if Assigned(rb)
    then AddEntity(rb.rlname)
    else SdsPrintf(#10'Entity���Ȃ� at ' + tbl);
    rb := SdsTblNext(tbl);
  end;
end;

procedure TForm3.LoadTables;
begin
  LoadTables('APPID');
  LoadTables('BLOCK', False);
  LoadTables('DIMSTYLE', False);
  LoadTables('LAYER', False);
  LoadTables('LTYPE', False);
  LoadTables('STYLE', False);
  LoadTables('UCS', False);
  LoadTables('VIEW', False);
  LoadTables('VPORT', False);
end;

{:Note::
  �\�[�g������A����������ł���ƕ֗������ł͂��邯�ǁA
  �T���v���ł����܂ł���͖̂ʓ|�Ȃ̂ŁA����ĂȂ�
::Note:}

end.
