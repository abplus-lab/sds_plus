library ResultView;
//  Copyright (C) 2001 ABplus kazhida.
//  All rights reserved.
//  $Id: ResultView.dpr 268 2003-03-09 08:40:49Z kazhida $
//  $Author: kazhida $


{:Note::
  SDScore、SDSplusListのテスト用SDSアプリケーション
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
  EntForm in 'EntForm.pas' {Form4};

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
  //  渡されたリストの中身を表示する関数
  SdsPrintf(#10'Create SdsList.');
  f := TForm1.Create(nil);
  SdsPrintf(' done.');
  try
    f.DispArgs(TSdsList.CreateByBuf(rb));
    rb := nil;  //rbはTSdsListが解放する
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
  //選択された図形(複数だった場合は最初の図形)の中身を表示するコマンド
  try
    e := SdsEntSel;
  except
    Result := SDS_RSERR;
    SdsPrintf(#10'entselできませんでした');
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
  //namedobjdictの中身を表示するコマンド
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
  //  こういう作り方もある
  //  ていうか、MDIフォームは、Applicationのメインフォームでなければ
  //  ならないので、こういう風にしないと子フォームをつくれない
  Application.CreateForm(TForm3, f);
  try
    f.LoadEntities;
    f.ShowModal;
    //f.Show;
    //Application.Run;
    //  これをやってフォームを閉じると、ApplicationがTerminatedになって、
    //  Runが処理をしなくなってしまう。
    //  つまり、すぐに次の処理に入ってしまう
  finally
          if Application.MainForm <> nil
          then SdsPrintf(#10'1 MainForm %s]', [Application.MainForm.Caption])
          else SdsPrintf(#10'1 MainForm (nil)');
    f.Release;
          if Application.MainForm <> nil
          then SdsPrintf(#10'2 MainForm %s]', [Application.MainForm.Caption])
          else SdsPrintf(#10'2 MainForm (nil)');
    f.Free;
          if Application.MainForm <> nil
          then SdsPrintf(#10'3 MainForm %s]', [Application.MainForm.Caption])
          else SdsPrintf(#10'3 MainForm (nil)');
    //  Freeしないと、Application.MainFormがnilにならない
    //  Releaseはいらないかも
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
end;

procedure AppDone;
begin
  SdsPrintf(#10'ResultView unloaded.');
  Application.Handle := 0;
end;

begin
  SdsAddUserProc(loadmsg,       AppInit);
  SdsAddUserProc(unloadmsg,     AppDone);
  SdsAddUserFunc('resview',     ResView);
  SdsAddUserFunc('c:selview',   SelView);
  SdsAddUserFunc('c:dictview',  DictView);
  SdsAddUserFunc('c:entview',   EntView);
  SdsAddUserFunc('c:tblview',   TblView);
//SdsAddUserFunc('c:minipad',   PadShow);
end.
