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
library DelphiSDSdemo;
//  $Id: DelphiSDSdemo.dpr 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $


{:Note::
  SDScore�ASDSplusList�̃e�X�g�pSDS�A�v���P�[�V����
::Note:}

uses
  SysUtils,
  Classes,
  Forms,
  SDScore in 'SDScore.pas',
  ViewerForm in 'ViewerForm.pas' {Form1},
  MiniPad in 'MiniPad.pas' {Form2},
  SDSplusList in 'SDSplusList.pas',
  ListForm in 'ListForm.pas' {Form3},
  EntForm in 'EntForm.pas' {Form4},
  DemoUtils in 'DemoUtils.pas';

{$R *.res}

function PadShow(var rb: PSdsResBuf): Integer;
var
  f: TForm2;
begin
  f := TForm2.Create(nil);
  try
    f.ShowModal;
  finally
    f.Release;
    Result := SDS_RTNORM;
  end;
end;

function ResView(var rb: PSdsResBuf): Integer;
var
  f: TForm1;
begin
  //  �n���ꂽ���X�g�̒��g��\������֐�
  //SdsPrintf(#10'Create SdsList.');
  f := TForm1.Create(nil);
  //SdsPrintf(' done.');
  try
    f.DispArgs(TSdsList.CreateByBuf(rb));
    rb := nil;  //rb��TSdsList���������
    f.ShowModal;
  finally
    f.Release;
    Result := SDS_RTNORM;
    sds_retnil;
  end;
end;

function SelView(var rb: PSdsResBuf): Integer;
var
  f: TForm1;
  e: TSdsName;
begin
  //�I�����ꂽ�}�`(�����������ꍇ�͍ŏ��̐}�`)�̒��g��\������R�}���h
  try
    e := SdsEntSel;
  except
    Result := SDS_RSERR;
    SdsPrintf(#10'entsel�ł��܂���ł���');
    Exit;
  end;

  f := TForm1.Create(nil);
  try
    f.DispArgs(TSdsList.CreateByEnt(e));
    f.ShowModal;
  finally
    f.Release;
    Result := SDS_RTNORM;
    sds_retvoid;
  end;
end;

function DictView(var rb: PSdsResBuf): Integer;
var
  f: TForm1;
  lt: TSdsList;
begin
  //namedobjdict�̒��g��\������R�}���h
  f  := TForm1.Create(nil);
  lt := TSdsList.CreateByEnt(SdsNamedObjDict);
  try
    f.DispArgs(lt);
    f.ShowModal;
  finally
    f.Release;
    Result := SDS_RTNORM;
    sds_retvoid;
  end;
end;

function EntView(var rb: PSdsResBuf): Integer;
var
  f: TForm3;
begin
  //  ������������������
  //  �Ă������AMDI�t�H�[���́AApplication�̃��C���t�H�[���łȂ����
  //  �Ȃ�Ȃ��̂ŁA�����������ɂ��Ȃ��Ǝq�t�H�[��������Ȃ�
  Application.CreateForm(TForm3, f);
  try
    f.LoadEntities;
    f.ShowModal;
    //f.Show;
    //Application.Run;
    //  ���������ăt�H�[����\�����ĕ���ƁAApplication��Terminated�ɂȂ��āA
    //  ����ȍ~�ARun�����������Ȃ��Ȃ��Ă��܂��B
    //  �܂�A�Q�x�ڂ���́A�����Ɏ��̏����ɓ����Ă��܂�
  finally
          //if Application.MainForm <> nil
          //then SdsPrintf(#10'1 MainForm %s]', [Application.MainForm.Caption])
          //else SdsPrintf(#10'1 MainForm (nil)');
    f.Release;
          //if Application.MainForm <> nil
          //then SdsPrintf(#10'2 MainForm %s]', [Application.MainForm.Caption])
          //else SdsPrintf(#10'2 MainForm (nil)');
    f.Free;
          //if Application.MainForm <> nil
          //then SdsPrintf(#10'3 MainForm %s]', [Application.MainForm.Caption])
          //else SdsPrintf(#10'3 MainForm (nil)');
    //  Free���Ȃ��ƁAApplication.MainForm��nil�ɂȂ�Ȃ�
    //  Release�͂���Ȃ�����
    Result := SDS_RTNORM;
    sds_retvoid;
  end;
end;

function TblView(var rb: PSdsResBuf): Integer;
var
  f: TForm3;
begin
  Application.CreateForm(TForm3, f);
  try
    f.LoadTables;
    f.ShowModal;
  finally
    f.Release;
    f.Free;
    Result := SDS_RTNORM;
    sds_retvoid;
  end;
end;

procedure AppInit;
begin
  Application.Handle := SdsHWndAcad;
  Application.Initialize;
  SdsPrintf(#10'Delphi-SDS demo  loaded.');
end;

procedure AppDone;
begin
  SdsPrintf(#10'Delphi-SDS demo  unloaded.');
  Application.Handle := 0;
end;

begin
  //  �v���W�F�N�g�̏��������ł��o�^�ł���
  SdsAddUserProc(AppInit, SdsAtXLOAD);
  SdsAddUserProc(AppDone, SdsAtXUNLD);
  SdsAddUserFunc('resview',     ResView);
  SdsAddUserFunc('c:selview',   SelView);
  SdsAddUserFunc('c:dictview',  DictView);
  SdsAddUserFunc('c:entview',   EntView);
  SdsAddUserFunc('c:tblview',   TblView);
//SdsAddUserFunc('c:minipad',   PadShow);
end.
