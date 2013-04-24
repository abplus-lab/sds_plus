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
    { Private 宣言 }
  public
    { Public 宣言 }
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
