{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooOS.ComputerName;

interface

uses
  Windows,
  SysUtils,
  ooOS.Info.Intf;

type
  TOSComputerName = class sealed(TInterfacedObject, IOSInfo)
  public
    function Value: string;
    class function New: IOSInfo;
  end;

implementation

function TOSComputerName.Value: string;
var
  Len: Cardinal;
begin
  Len := Succ(MAX_COMPUTERNAME_LENGTH);
  Result := StringOfChar(#0, Len);
  Windows.GetComputerName(PChar(Result), Len);
  SetLength(Result, Len);
  Result := Trim(Result);
end;

class function TOSComputerName.New: IOSInfo;
begin
  Result := TOSComputerName.Create;
end;

end.
