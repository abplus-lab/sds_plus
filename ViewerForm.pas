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
unit ViewerForm;
//  $Id: ViewerForm.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Clipbrd, Menus, SDScore, SDSplusList;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    procedure Copy1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
    procedure DispArgs(lt: TSdsList);
    procedure DispList(lt: TSdsList);
    procedure DispTree(lt: TSdsList);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DispList(lt: TSdsList);
var
  i:  Integer;
  it: TListItem;
  rt: Smallint;
begin
  ListView1.Clear;

  if lt.Structured
  then lt.ListFlatten;

  //SdsPrintf(#10'items %d.', [lt.Count]);
  if lt.Count > 0 then for i := 0 to lt.Count - 1 do
  begin
    //SdsPrintf(#10'item[%d] %s.', [i, lt.Contents[i]]);
    it := ListView1.Items.Add;
    rt := lt.ResTypes[i];
    it.Caption := lt.Contents[i];
    it.SubItems.Add(IntToStr(rt));
    it.SubItems.Add(lt.BufTypeStr[i]);
    it.SubItems.Add(lt.Comments[i]);
  end;
  //SdsPrintf(#10'done.');
end;

procedure TForm1.DispTree(lt: TSdsList);

  procedure addNode(node: TTreeNode; list: TSdsList);
  var
    i:  Integer;
    sl: TSdsList;
  begin
    if list.Count > 0 then for i := 0 to list.Count - 1 do
    begin
      sl := list.SubLists[i];
      if Assigned(sl)
      then addNode(TreeView1.Items.AddChild(node, sl.Text), sl)
      else TreeView1.Items.AddChild(node, list.Contents[i]);
    end;
  end;

begin
  TreeView1.Items.Clear;
  lt.ListStructure;
  addNode(TreeView1.Items.Add(nil, lt.Text), lt);
end;

procedure TForm1.DispArgs(lt: TSdsList);
begin
  try
    DispTree(lt);
    DispList(lt);
  finally
    lt.Free;
  end;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Copy1Click(Sender: TObject);
var
  s: String;
  i: Integer;
begin
  s := '';
  with ListView1.Items do if Count > 0 then for i := 0 to Count - 1 do
  begin
    s := s + Item[i].Caption + #9;
    s := s + Item[i].SubItems.Strings[0] + #9;
    s := s + Item[i].SubItems.Strings[1] + #9;
    s := s + Item[i].SubItems.Strings[2] + #13#10;
  end;
  Clipboard.SetTextBuf(PChar(s));
end;

end.
