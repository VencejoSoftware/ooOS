{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to get CPU speed
  @created(22/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit OSCPUSpeed;

{$IFDEF FPC}
{$IFDEF UNIX}
{$DEFINE USE_LINUX}
{$ENDIF}
{$asmmode intel}
{$endif}

interface

uses
{$IFDEF USE_LINUX}
  baseunix,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils;

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
    function Frequency: Extended;
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
    function Frequency: Extended;
    class function New: IOSCPUSpeed;
  end;

implementation

function TOSCPUSpeed.CPUClockCycleCount: TCycleCount; assembler; register;
asm
  rdtsc  // dw 310Fh
  {$IFDEF CPUX64}
  shl rdx, 32
  or rax, rdx
  {$ELSE}
  mov Result, eax
  {$ENDIF}
end;

function TOSCPUSpeed.Frequency: Extended;
const
  DelayTime = 500; // measure time in ms
var
  TimerLo, TimerLo2: TCycleCount;
  PriorityClass, Priority: Integer;
begin
{$IFDEF USE_LINUX}
  Priority := fpGetPriority(PRIO_PROCESS, FpGetpid);
{$ELSE}
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetthreadPriority(GetCurrentthread);
{$ENDIF}
  try
{$IFDEF USE_LINUX}
    fpSetPriority(PRIO_PROCESS, FpGetpid, 20);
{$ELSE}
    SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
    SetthreadPriority(GetCurrentthread, THREAD_PRIORITY_TIME_CRITICAL);
{$ENDIF}
    Sleep(10);
    TimerLo := CPUClockCycleCount;
    Sleep(DelayTime);
    TimerLo2 := CPUClockCycleCount;
    try
      if TimerLo2 > TimerLo then
        Result := (TimerLo2 - TimerLo)
      else
        Result := (TimerLo - TimerLo2);
      Result := Result / (1000 * DelayTime);
    except
      Result := 0;
    end;
  finally
{$IFDEF USE_LINUX}
    fpSetPriority(PRIO_PROCESS, FpGetpid, Priority);
{$ELSE}
    SetthreadPriority(GetCurrentthread, Priority);
    SetPriorityClass(GetCurrentProcess, PriorityClass);
{$ENDIF}
  end;
end;

class function TOSCPUSpeed.New: IOSCPUSpeed;
begin
  Result := TOSCPUSpeed.Create;
end;

end.
