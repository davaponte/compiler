unit MainLesson01;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnGo : TButton;
    edExpression : TLabeledEdit;
    mOutput : TMemo;
    procedure btnGoClick(Sender : TObject);
  private

  public

  end;

var
  MainForm : TMainForm;

implementation

uses
  ulesson01;

{$R *.lfm}

{ TMainForm }

procedure TMainForm.btnGoClick(Sender : TObject);
begin
  mOutput.Text := Analize(edExpression.Text);
end;

end.

