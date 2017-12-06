{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to get CPU speed
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooOS.CPUSpeed;

interface

uses
  Windows;

type
{$REGION 'documentation'}
{
  @abstract(Object to get CPU speed)
  Object to get CPU speed
  @member(
    Frequency Call ASM to get CPU frequency
    @return(Double with the frequency)
  )
}
{$ENDREGION}
  IOSCPUSpeed = interface
    ['{95E14E01-382A-4E16-A867-14E3E287BDE8}']
    function Frequency: Double;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IOSCPUSpeed))
  Object to calculate the CPU speed
  @member(
    CPUClockCycleCount Call ASM to get CPU cycle count
    @return(DWord cycle count)
  )
  @member(
    Frequency Call ASM to get CPU frequency
    @return(Double with the frequency)
  )
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TOSCPUSpeed = class sealed(TInterfacedObject, IOSCPUSpeed)
  type
    TCycleCount = {$IFDEF CPUX64}Int64 {$ELSE}DWord {$ENDIF};
  private
    function CPUClockCycleCount: TCycleCount;
  public
    function Frequency: Double;
    class function New: IOSCPUSpeed;
  end;

implementation

function TOSCPUSpeed.CPUClockCycleCount: TCycleCount; assembler; register;
asm
  {$IFDEF CPUX64}
  rdtsc  // dw 310Fh
  shl rdx, 32
  or rax, rdx
  {$ELSE}
  rdtsc  // dw 310Fh
  mov Result, eax
  {$ENDIF}
end;

function TOSCPUSpeed.Frequency: Double;
const
  DelayTime = 500; // measure time in ms
var
  TimerLo, TimerLo2: TCycleCount;
  PriorityClass, Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetthreadPriority(GetCurrentthread);
  try
    SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
    SetthreadPriority(GetCurrentthread, THREAD_PRIORITY_TIME_CRITICAL);
    Sleep(10);
    TimerLo := CPUClockCycleCount;
    Sleep(DelayTime);
    TimerLo2 := CPUClockCycleCount;
    try
      Result := (TimerLo2 - TimerLo) / (1000 * DelayTime);
    except
      Result := 0;
    end;
  finally
    SetthreadPriority(GetCurrentthread, Priority);
    SetPriorityClass(GetCurrentProcess, PriorityClass);
  end;
end;

class function TOSCPUSpeed.New: IOSCPUSpeed;
begin
  Result := TOSCPUSpeed.Create;
end;

end.
