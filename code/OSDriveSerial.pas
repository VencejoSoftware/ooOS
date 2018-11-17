{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Obtains the drive serial number from operating system
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit OSDriveSerial;

interface

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$ENDIF}

uses
  Classes,
{$IFDEF USE_LINUX}
  regexpr, LazFileUtils, FileUtil,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils,
  OSInfo;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSInfo))
  Obtains the drive serial number from operating system
  @member(Value @seealso(IOSInfo.Value))
  @member(
    HDDSerial Call OS to get drive serial
    @return(Integer with the serial if success, 0 if fail)
  )
  @member(
    Create Object constructor
    @param(Drive Drive letter to access)
  )
  @member(
    New Create a new @classname as interface
    @param(Drive Drive letter to access)
  )
}
{$ENDREGION}
  TOSDriveSerial = class sealed(TInterfacedObject, IOSInfo)
  strict private
    _Value: String;
  private
    function HDDSerial(const Drive: String): String;
  public
    function Value: String;
    constructor Create(const Drive: String);
    class function New(const Drive: String): IOSInfo;
  end;

implementation

function TOSDriveSerial.Value: String;
begin
  Result := _Value;
end;

function TOSDriveSerial.HDDSerial(const Drive: string): string;
{$IFDEF USE_LINUX}
var
  DriveList: TStringList;
  RegexObj: TRegExpr;
  symlnk, RegexpInput: string;
  i: integer;
begin
  DriveList := TStringList.Create;
  try
    DriveList := FindAllFiles('/dev/disk/by-id');
    RegexpInput := EmptyStr;
    for i := 0 to Pred(DriveList.Count) do
    begin
      symlnk := ReadAllLinks(DriveList[i], False);
      if (symlnk = Drive) then
        RegexpInput := RegexpInput + DriveList[i] + LineEnding;
    end;
    RegexObj := TRegExpr.Create;
    try
      RegexObj.Expression := 'ata.*_([^ ]*)\n';
      if RegexObj.Exec(RegexpInput) then
        Result := RegexObj.Match[1]
      else
        Result := EmptyStr;
    finally
      RegexObj.Free;
    end;
  finally
    DriveList.Free;
  end;
{$ELSE}

var
  MC, FL, SN: DWORD;
begin
  if GetVolumeInformation(PChar(Drive + ':\'), nil, SizeOf(Drive), @SN, MC, FL, nil, 0) then
    Result := IntToHex(SN, 10)
  else
    Result := EmptyStr;
{$ENDIF}
end;

constructor TOSDriveSerial.Create(const Drive: String);
begin
  _Value := HDDSerial(Drive);
end;

class function TOSDriveSerial.New(const Drive: String): IOSInfo;
begin
  Result := TOSDriveSerial.Create(Drive);
end;

end.
