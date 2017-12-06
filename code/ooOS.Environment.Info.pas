{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.Environment.Info;

interface

uses
  Windows, SysUtils,
  Generics.Collections;

type
  TEnvironmentValueList = class sealed(TDictionary<string, string>)
  public
    procedure AddFromText(const Text: String);
  end;

  IOSEnvironmentInfo = interface
    ['{A4840FF5-82A2-46F7-8537-90438D696AF9}']
    function Variables: TEnvironmentValueList;
    function VariableByKey(const Key: String): String;
  end;

  TWinEnvironmentInfo = class sealed(TInterfacedObject, IOSEnvironmentInfo)
  strict private
    _Variables: TEnvironmentValueList;
  private
    procedure FillEnvironmentList(const List: TEnvironmentValueList);
  public
    function Variables: TEnvironmentValueList;
    function VariableByKey(const Key: String): String;
    constructor Create;
    destructor Destroy; override;
    class function New: IOSEnvironmentInfo;
  end;

implementation

{ TEnvironmentValueList }

procedure TEnvironmentValueList.AddFromText(const Text: String);
var
  Key, Value: String;
  PosAsig: Integer;
begin
  PosAsig := Pos('=', Text);
  if PosAsig > 1 then
  begin
    Key := UpperCase(Copy(Text, 1, Pred(PosAsig)));
    Value := Copy(Text, Succ(PosAsig));
    Add(Key, Value);
  end;
end;

{ TWinEnvironmentInfo }

function TWinEnvironmentInfo.Variables: TEnvironmentValueList;
begin
  if _Variables.Count < 1 then
    FillEnvironmentList(_Variables);
  Result := _Variables;
end;

procedure TWinEnvironmentInfo.FillEnvironmentList(const List: TEnvironmentValueList);
var
  PEnvironmentStrs: PChar;
begin
  List.Clear;
  PEnvironmentStrs := Windows.GetEnvironmentStrings;
  try
    if Assigned(PEnvironmentStrs) then
      while PEnvironmentStrs^ <> #0 do
      begin
        List.AddFromText(PEnvironmentStrs);
        Inc(PEnvironmentStrs, Succ(Length(PEnvironmentStrs)));
      end;
  finally
    Windows.FreeEnvironmentStrings(PEnvironmentStrs);
  end;
end;

function TWinEnvironmentInfo.VariableByKey(const Key: String): String;
begin
  if not Variables.TryGetValue(UpperCase(Key), Result) then
    Result := EmptyStr;
end;

constructor TWinEnvironmentInfo.Create;
begin
  _Variables := TEnvironmentValueList.Create;
end;

destructor TWinEnvironmentInfo.Destroy;
begin
  _Variables.Free;
  inherited;
end;

class function TWinEnvironmentInfo.New: IOSEnvironmentInfo;
begin
  Result := TWinEnvironmentInfo.Create;
end;

end.
