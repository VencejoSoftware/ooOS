{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Operation system information
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooOS.Info.Intf;

interface

type
{$REGION 'documentation'}
{
  @abstract(Operation system information)
  @member(Value Information value)
}
{$ENDREGION}
  IOSInfo = interface
    ['{04BDF10E-5E1F-409C-AEB0-B18F4314F138}']
    function Value: String;
  end;

implementation

end.
