unit Welcome;
//  Copyright (C) 2003 ABplus Inc. kazHIDA
//  All rights reserved.
//  $Id: Welcome.pas 266 2003-03-09 05:41:19Z kazhida $
//  $Author: kazhida $

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TWelcomeForm = class(TForm)
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
  end;

var
  WelcomeForm: TWelcomeForm;

implementation

{$R *.dfm}

procedure TWelcomeForm.FormShow(Sender: TObject);
begin
  Repaint;
end;

end.
