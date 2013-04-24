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
//  以下は、日本語版
//
//  ソースあるいはバイナリー形式での再配布/使用は、改変を加える場合も、
//  加えない場合も、下記の条件を満たした場合に許諾される。
//
//  1.  ソースコードでの再配布物には、必ず上記の著作権表示、この条件リスト、
//      および以下の免責事項を、改変せずにこのファイルの最初の数行に入れな
//      ければならない。
//  2.  バイナリー形式での再配布は、必ず上記の著作権表示、この条件リスト、
//      以下の免責事項の複製をドキュメンテーション内、あるいは配布物と共に
//      提供されるものに含めなければならない。
//
//  このソフトウェアは、著作者により、「現状のまま」で提供され、
//  著作者は直接的、非直接的、偶発的、特殊な、典型的、あるいは必然の
//  いかなる場合においても、いかなる損害に一切責任は負わない。
//  その損害は以下の内容も含み、しかもそれに限定されない。
//  代用となる物やサービスの調達、効果・データ・利益の低下、商取引の障害、
//  また、どのような責務の論理においても、それが契約に関するものであろうと、
//  厳格な責務であろうと、不正行為（不注意やその他の場合も含む）であろうと、
//  このソフトウェアを使用することによって生じるそれらの損害の、
//  一切の責任から著作者は免れている。
//  たとえ事前にそれらすべての損害への可能性が示唆されていた場合においても
//  同様である。
//
library DelphiSDSdemo;
//  $Id: DelphiSDSdemo.dpr 270 2003-03-11 02:52:54Z kazhida $
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
  //  渡されたリストの中身を表示する関数
  //SdsPrintf(#10'Create SdsList.');
  f := TForm1.Create(nil);
  //SdsPrintf(' done.');
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
    //  これをやってフォームを表示して閉じると、ApplicationがTerminatedになって、
    //  それ以降、Runが処理をしなくなってしまう。
    //  つまり、２度目からは、すぐに次の処理に入ってしまう
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
  SdsPrintf(#10'Delphi-SDS demo  loaded.');
end;

procedure AppDone;
begin
  SdsPrintf(#10'Delphi-SDS demo  unloaded.');
  Application.Handle := 0;
end;

begin
  //  プロジェクトの初期化部でも登録できる
  SdsAddUserProc(AppInit, SdsAtXLOAD);
  SdsAddUserProc(AppDone, SdsAtXUNLD);
  SdsAddUserFunc('resview',     ResView);
  SdsAddUserFunc('c:selview',   SelView);
  SdsAddUserFunc('c:dictview',  DictView);
  SdsAddUserFunc('c:entview',   EntView);
  SdsAddUserFunc('c:tblview',   TblView);
//SdsAddUserFunc('c:minipad',   PadShow);
end.
