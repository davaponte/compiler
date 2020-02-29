unit ulesson01;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

function Analize(St : string): string;

implementation

var
  Look: char;
  InputStr: string;
  Index: integer = 1;
  OutputStr: string;
  ErrorStr: string;

procedure GetChar;
begin
  if (Index > Length(InputStr)) then
    Look := #0
  else begin
    Look := InputStr[Index];
    Inc(Index);
  end;
end;

procedure Error(s: string);
begin
   ErrorStr := 'Error: ' + s + '.';
end;

procedure Abort(s: string);
begin
   Error(s);
//   Halt;
end;

procedure Expected(s: string);
begin
   Abort(s + ' Expected');
end;

procedure Match(x: char);
begin
  if (ErrorStr <> '') then Exit;
  if (Look = x) then
    GetChar
  else
    Expected('''' + x + '''');
end;

function IsAlpha(c: char): boolean;
begin
  IsAlpha := UpCase(c) in ['A'..'Z'];
end;

function IsDigit(c: char): boolean;
begin
  IsDigit := c in ['0'..'9'];
end;

function GetName: char;
begin
  if Not IsAlpha(Look) then
    Expected('Name');
  GetName := UpCase(Look);
  GetChar;
end;

function GetNum: char;
begin
  if Not IsDigit(Look) then
    Expected('Integer');
  GetNum := Look;
  GetChar;
end;

procedure Emit(s: string);
begin
  OutputStr := OutputStr + #13#10 + s;
end;

procedure EmitLn(s: string);
begin
  Emit(s);
end;

procedure Expression; forward;

procedure Factor;
begin
  if (Look = '(') then begin
    Match('(');
    Expression;
    Match(')');
  end else
    EmitLn('MOVE #' + GetNum + ',D0')
end;

procedure Multiply;
begin
  Match('*');
  Factor;
  EmitLn('MULS (SP)+,D0');
end;

procedure Divide;
begin
  Match('/');
  Factor;
  EmitLn('MOVE (SP)+,D1');
  EmitLn('DIVS D1,D0');
end;

procedure Term;
begin
  Factor;
  while Look in ['*', '/'] do begin
    EmitLn('MOVE D0,-(SP)');
    case Look of
      '*': Multiply;
      '/': Divide;
      else Expected('Mulop');
    end;
  end;
end;

procedure Add;
begin
  Match('+');
  Term;
  EmitLn('ADD (SP)+,D0');
end;

procedure Subtract;
begin
  Match('-');
  Term;
  EmitLn('SUB (SP)+,D0');
  EmitLn('NEG D0');
end;

function IsAddop(c: char): boolean;
begin
  Result := c in ['+', '-'];
end;

procedure Expression;
begin
  if IsAddop(Look) then
    EmitLn('CLR D0')
  else
    Term;
  while IsAddop(Look) do begin
    EmitLn('MOVE D0,-(SP)');
    case Look of
      '+': Add;
      '-': Subtract;
      else Expected('Addop');
    end;
  end;
end;

function Analize(St : string): string;
begin
  ErrorStr := '';
  OutputStr := '';
  InputStr := St;
  Index := 1;
  GetChar;
  Expression;
  if (ErrorStr <> '') then
    Result := ErrorStr
  else
    Result := OutputStr;
end;

end.




