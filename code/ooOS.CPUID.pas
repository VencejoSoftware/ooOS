{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to get CPU identifier
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooOS.CPUID;

{$IFDEF FPC}
{$asmmode intel}
{$endif}

interface

type
{$REGION 'documentation'}
// Type for each register of ID
{$ENDREGION}
  TCPUValue = {$IFDEF CPUX64} UInt64{$ELSE} UInt32{$ENDIF};

{$REGION 'documentation'}
// Return struct for CPU ID
{$ENDREGION}

  TCPURegister = record
    AX, BX, CX, DX: TCPUValue;
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
{$IFDEF CPUX64}
    function CPUID64: TCPURegister;
{$ELSE}
    function CPUID: TCPURegister;
{$ENDIF}
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
  {$IFDEF CPUX64}
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

{$IFDEF CPUX64}

function TOSCPUID.CPUID64: TCPURegister; assembler; register;
asm
  PUSH  RBX
  PUSH  RDI
  MOV   RDI, result
  // MOV   RAX, 1
  XOR   RAX, RAX                    // Clear register
  XOR   RBX, RBX
  XOR   RCX, RCX
  XOR   RDX, RDX
  CPUID   // DW $A20F
  {$IFDEF FPC}
  MOV   [RDI + TCPURegister.AX], RAX
  MOV   [RDI + TCPURegister.BX], RBX
  MOV   [RDI + TCPURegister.CX], RCX
  MOV   [RDI + TCPURegister.DX], RDX
  {$ELSE}
  MOV   [RDI].TCPURegister.&AX, RAX
  MOV   [RDI].TCPURegister.&BX, RBX
  MOV   [RDI].TCPURegister.&CX, RCX
  MOV   [RDI].TCPURegister.&DX, RDX
  {$ENDIF}
  POP   RDI
  POP   RBX
end;
{$ELSE}

function TOSCPUID.CPUID: TCPURegister; assembler; register;
asm
  PUSH  EBX
  PUSH  EDI
  MOV   EDI, Result
  // MOV   EAX, 1
  XOR   EAX, EAX
  XOR   EBX, EBX
  XOR   ECX, ECX
  XOR   EDX, EDX
  CPUID   // DW $A20F
  {$IFDEF FPC}
  MOV   [EDI + TCPURegister.AX], EAX
  MOV   [EDI + TCPURegister.BX], EBX
  MOV   [EDI + TCPURegister.CX], ECX
  MOV   [EDI + TCPURegister.DX], EDX
  {$ELSE}
  MOV   [EDI].TCPURegister.&AX, EAX
  MOV   [EDI].TCPURegister.&BX, EBX
  MOV   [EDI].TCPURegister.&CX, ECX
  MOV   [EDI].TCPURegister.&DX, EDX
  {$ENDIF}
  POP   EDI
  POP   EBX
end;
{$ENDIF}

function TOSCPUID.EmptyID: TCPURegister;
begin
  Result.AX := 0;
  Result.BX := 0;
  Result.CX := 0;
  Result.DX := 0;
end;

constructor TOSCPUID.Create;
begin
  if HasCPUID then
    _ID := {$IFDEF CPUX64}CPUID64{$ELSE}CPUID{$ENDIF}
  else
    _ID := EmptyID;
end;

class function TOSCPUID.New: IOSCPUID;
begin
  Result := TOSCPUID.Create;
end;

end.
