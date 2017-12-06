{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to get drive serial from system
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooOS.DriveSerial;

interface

uses
  Windows,
  ooOS.Info.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Object to get drive serial from system)
  Object to get drive serial from system
  @member(
    Serial Return the drive serial number as hexadecimal
    @return(String with the serial number formatted)
  )
}
{$ENDREGION}
  IOSDriveSerial = interface
    ['{A6E8779F-0E72-4F68-A204-FCC05052B9F8}']
    function Serial: DWord;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSDriveSerial))
  @member(
    HDDSerial Call OS to get drive serial
    @return(Integer with the serial if success, 0 if fail)
  )
  @member(Serial @seealso(IOSDriveSerial.Serial))
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

  TOSDriveSerial = class sealed(TInterfacedObject, IOSDriveSerial)
  strict private
    _Serial: DWord;
  private
    function HDDSerial(const Drive: Char): DWord;
  public
    function Serial: DWord;
    constructor Create(const Drive: Char);
    class function New(const Drive: Char): IOSDriveSerial;
  end;

implementation

function TOSDriveSerial.Serial: DWord;
begin
  Result := _Serial;
end;

function TOSDriveSerial.HDDSerial(const Drive: Char): DWord;
var
  lHDTemp: PDWORD;
  lMC, lFL: DWord;
begin
  System.New(lHDTemp);
  if GetVolumeInformation(PChar(Drive + ':\'), nil, 0, lHDTemp, lMC, lFL, nil, 0) then
    Result := lHDTemp^
  else
    Result := 0;
  Dispose(lHDTemp);
end;

constructor TOSDriveSerial.Create(const Drive: Char);
begin
  _Serial := HDDSerial(Drive);
end;

class function TOSDriveSerial.New(const Drive: Char): IOSDriveSerial;
begin
  Result := TOSDriveSerial.Create(Drive);
end;

end.
