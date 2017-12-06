{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to get CPU identifier
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooOS.CPUID;

interface

uses
  Windows, SysUtils, Math;

type
{$REGION 'documentation'}
// Type for each register of ID
{$ENDREGION}
  TCPUValue = {$IFDEF CPUX64}LongInt {$ELSE}Dword {$ENDIF};

{$REGION 'documentation'}
// Return struct for CPU ID
{$ENDREGION}

  TCPURegister = record
    EAX, EBX, ECX, EDX: TCPUValue;
  end;

{$REGION 'documentation'}
{
  @abstract(Object to get CPU identifier)
  Object to get CPU identifier
  @member(
    ID Return the CPU identifier
    @return(Record with the ID info)
  )
  @member(
    HasCPUID Checks if the system can access to cpu id
    @return(@true if has ID, @false if not)
  )
}
{$ENDREGION}

  IOSCPUID = interface
    ['{94600C0D-7394-402E-AFF3-8FEA2E0A1F0C}']
    function ID: TCPURegister;
    function HasCPUID: Boolean;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSCPUID))
  @member(ID @seealso(IOSCPUID.ID))
  @member(Create Object contructor)
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TOSCPUID = class sealed(TInterfacedObject, IOSCPUID)
  strict private
    _ID: TCPURegister;
  private
    function CPUID: TCPURegister;
    function EmptyID: TCPURegister;
  public
    function HasCPUID: Boolean;
    function ID: TCPURegister;
    constructor Create;
    class function New: IOSCPUID;
  end;

implementation

function TOSCPUID.ID: TCPURegister;
begin
  Result := _ID;
end;

function TOSCPUID.HasCPUID: Boolean; assembler; register;
asm
  {$IFDEF WIN64}
  MOV EAX, True
  {$ELSE}
  PUSHFD                 // save EFLAGS to stack
  POP     EAX            // store EFLAGS in EAX
  MOV     EDX, EAX       // save in EDX for later testing
  XOR     EAX, $200000;  // flip ID bit in EFLAGS
  PUSH    EAX            // save new EFLAGS value on stack
  POPFD                  // replace current EFLAGS value
  PUSHFD                 // get new EFLAGS
  POP     EAX            // store new EFLAGS in EAX
  XOR     EAX, EDX       // check if ID bit changed
  JZ      @exit          // no, CPUID not available
  MOV     EAX, True      // yes, CPUID is available
  {$ENDIF}
@exit:
end;

function TOSCPUID.CPUID: TCPURegister; assembler; register;
asm
  {$IFDEF WIN64}
  push  rbx
  push  rdi
  mov   rdi, result
  mov   eax, 1
  cpuid
  mov   [rdi].TCPURegister.&EAX, eax
  mov   [rdi].TCPURegister.&EBX, ebx
  mov   [rdi].TCPURegister.&ECX, ecx
  mov   [rdi].TCPURegister.&EDX, edx
  pop   rdi
  pop   rbx
  {$ELSE}
  PUSH    EBX
  PUSH    EDI
  MOV     EDI, Result
  MOV     EAX, 1
  CPUID   // DW $A20F
  MOV     [EDI].TCPURegister.&EAX, EAX
  MOV     [EDI].TCPURegister.&EBX, EBX
  MOV     [EDI].TCPURegister.&ECX, ECX
  MOV     [EDI].TCPURegister.&EDX, EDX
  POP     EDI
  POP     EBX
  {$ENDIF}
end;

function TOSCPUID.EmptyID: TCPURegister;
begin
  Result.EAX := 0;
  Result.EBX := 0;
  Result.ECX := 0;
  Result.EDX := 0;
end;

constructor TOSCPUID.Create;
begin
  if HasCPUID then
    _ID := CPUID
  else
    _ID := EmptyID;
end;

class function TOSCPUID.New: IOSCPUID;
begin
  Result := TOSCPUID.Create;
end;

end.
