{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to get CPU vendor from system
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooOS.CPUVendor;

{$IFDEF FPC}
{$asmmode intel}
{$endif}

interface

uses
  ooOS.Info.Intf,
  ooOS.CPUID;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSInfo))
  Object to get CPU vendor from system
  @member(
    HDDSerial Call OS to get drive serial
    @return(Integer with the serial if success, 0 if fail)
  )
  @member(
    CPUVendor Call OS to get CPU vendor
    @return(String with the CPU vendor)
  )
  @member(CPUValueToStr Use register VALUE as bit to retunr string)
  @member(
    Value Return the CPU vendor
    @return(String with CPU vendor)
  )
  @member(Create Object constructor)
  @member(New Create a new @classname as interface)
}
{$ENDREGION}
  TOSCPUVendor = class sealed(TInterfacedObject, IOSInfo)
  strict private
    _Value: String;
  private
    function CPUVendor: String;
    function VendorRegister: TCPURegister;
    function CPUValueToStr(const Value: TCPUValue): String;
  public
    function Value: string;
    constructor Create;
    class function New: IOSInfo;
  end;

implementation

function TOSCPUVendor.Value: string;
begin
  Result := _Value;
end;

function TOSCPUVendor.VendorRegister: TCPURegister;
begin
  Result := TOSCPUID.New.ID;
end;

function TOSCPUVendor.CPUValueToStr(const Value: TCPUValue): String;
var
  i: 0 .. 3;
begin
  Result := '';
  for i := 0 to 3 do
    Result := Result + Chr((Value and ($000000FF shl (i * 8))) shr (i * 8));
end;

function TOSCPUVendor.CPUVendor: String;
var
  CPURegister: TCPURegister;
begin
  CPURegister := VendorRegister;
  Result := CPUValueToStr(CPURegister.BX) + CPUValueToStr(CPURegister.DX) + CPUValueToStr(CPURegister.CX);
end;

constructor TOSCPUVendor.Create;
begin
  _Value := CPUVendor;
end;

class function TOSCPUVendor.New: IOSInfo;
begin
  Result := TOSCPUVendor.Create;
end;

end.
