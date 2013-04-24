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
    { Private 宣言 }
    function GetText: String;
  public
    { Public 宣言 }
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
