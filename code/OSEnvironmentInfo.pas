{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Environment variable list information
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit OSEnvironmentInfo;

interface

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$ENDIF}

uses
{$IFDEF USE_LINUX}
  unix,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils,
  Generics.Collections;

type
{$REGION 'documentation'}
{
  @abstract(Object list to store environment variables)
  @member(
    LoadItemFromText Load list parsing a text
    @param(Text Text to parse)
  )
}
{$ENDREGION}
  TEnvironmentValueList = class sealed(TDictionary<string, string>)
  public
    procedure LoadItemFromText(const Text: String);
  end;

{$REGION 'documentation'}
{
  @abstract(Object to get environment variable list)
  Obtain environment variable list information
  @member(
    Variables List of environment variables
    @return(List object)
  )
  @member(
    ValueByKey Get variable from his key
    @param(Key Variable identifier)
    @return(Variable text value)
  )
}
{$ENDREGION}

  IOSEnvironmentInfo = interface
    ['{A4840FF5-82A2-46F7-8537-90438D696AF9}']
    function Variables: TEnvironmentValueList;
    function ValueByKey(const Key: String): String;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSEnvironmentInfo))
  @member(Variables @seealso(IOSEnvironmentInfo.Variables))
  @member(ValueByKey @seealso(IOSEnvironmentInfo.ValueByKey))
  @member(
    FillList Using OS information fill list parsing text
    @param(List List object of variables)
  )
  @member(
    Create Object constructor
  )
  @member(
    Destroy Object destructor
  )
  @member(
    New Create a new @classname as interface
  )
}
{$ENDREGION}

  TOSEnvironmentInfo = class sealed(TInterfacedObject, IOSEnvironmentInfo)
  strict private
    _Variables: TEnvironmentValueList;
  private
    procedure FillList(const List: TEnvironmentValueList);
  public
    function Variables: TEnvironmentValueList;
    function ValueByKey(const Key: String): String;
    constructor Create;
    destructor Destroy; override;
    class function New: IOSEnvironmentInfo;
  end;

implementation

{ TEnvironmentValueList }

procedure TEnvironmentValueList.LoadItemFromText(const Text: String);
var
  Key, Value: String;
  PosAsig: Integer;
begin
  PosAsig := Pos('=', Text);
  if PosAsig > 1 then
  begin
    Key := UpperCase(Copy(Text, 1, Pred(PosAsig)));
    Value := Copy(Text, Succ(PosAsig));
    if not ContainsKey(Key) then
      Add(Key, Value);
  end;
end;

{ TOSEnvironmentInfo }

function TOSEnvironmentInfo.Variables: TEnvironmentValueList;
begin
  if _Variables.Count < 1 then
    FillList(_Variables);
  Result := _Variables;
end;

procedure TOSEnvironmentInfo.FillList(const List: TEnvironmentValueList);
{$IFDEF USE_LINUX}
var
  Count: Integer;
begin
  for Count := 0 to GetEnvironmentVariableCount do
    List.LoadItemFromText(GetEnvironmentString(Count));
{$ELSE}
var
  PEnvironmentStrs: PChar;
begin
  List.Clear;
  PEnvironmentStrs := Windows.GetEnvironmentStrings;
  try
    if Assigned(PEnvironmentStrs) then
      while PEnvironmentStrs^ <> #0 do
      begin
        List.LoadItemFromText(PEnvironmentStrs);
        Inc(PEnvironmentStrs, Succ(Length(PEnvironmentStrs)));
      end;
  finally
    Windows.FreeEnvironmentStrings(PEnvironmentStrs);
  end;
{$ENDIF}
end;

function TOSEnvironmentInfo.ValueByKey(const Key: String): String;
begin
  if not Variables.TryGetValue(UpperCase(Key), Result) then
    Result := EmptyStr;
end;

constructor TOSEnvironmentInfo.Create;
begin
  _Variables := TEnvironmentValueList.Create;
end;

destructor TOSEnvironmentInfo.Destroy;
begin
  _Variables.Free;
  inherited;
end;

class function TOSEnvironmentInfo.New: IOSEnvironmentInfo;
begin
  Result := TOSEnvironmentInfo.Create;
end;

end.
