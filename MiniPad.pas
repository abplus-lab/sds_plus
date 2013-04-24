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
unit MiniPad;
//  $Id: MiniPad.pas 266 2003-03-09 05:41:19Z kazhida $
//  $Author: kazhida $

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Clipbrd, SDScore, SDSplusList;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private �錾 }
    function GetText: String;
  public
    { Public �錾 }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

function TForm2.GetText: String;
var
  i: Integer;
begin
  Result := '';
  with Memo1.Lines do if Count > 0 then for i := 0 to Count - 1 do
  begin
    Result := Result + ' ' + Strings[i];
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  SdsCommand(GetText);
  Close;
  sds_retnil;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  s: String;
begin
  s := GetText;
  Clipboard.SetTextBuf(PChar(s));
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  lt: TSdsList;
  rb: PSdsResBuf;
begin
  Memo1.Clear;
  rb := nil;
  lt := TSdsList.CreateByBuf(sds_buildlist(SDS_RTLB, SDS_RTLE, SDS_RTNONE));

  try
    lt.InsertList(1, ['nemedobjdict']);
    if lt.Count > 0
    then Memo1.Lines.Add(lt.Text)
    else Memo1.Lines.Add('(empty)');
    Memo1.Lines.Add(IntToStr(lt.Count) + ' entries');
    rb := lt.Snach;
  finally
    if Assigned(rb)
    then sds_retval(rb) 
    else sds_retvoid;
    lt.Free;
    Close;
  end;
end;

end.
