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
    { Private 宣言 }
    function  AddEntity(ent: TSdsName): TSdsName;
    procedure ShowEntity(ent: TSdsName; cap: String);
    function  ShowExistForm(ent: TSdsName): Boolean;
  public
    { Public 宣言 }
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
      //  既にあったら、それを出すだけ
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
      //  エンティティ名とフォームつけるキャプションをつくる
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
    子フォームを解放する
    子フォームもApplication管理下にあるみたいで、明示的に解放しないと
    使えない(Showしても現れない)のに、存在することになってしまう
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
    //  ループ終了
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
    else SdsPrintf(#10'Entityがない at ' + tbl);
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
  ソートしたり、検索したりできると便利そうではあるけど、
  サンプルでそこまでするのは面倒なので、やってない
::Note:}

end.
