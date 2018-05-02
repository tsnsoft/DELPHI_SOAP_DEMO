unit Unit_CWS;
// лндскэ ябъгх я яепбепнл (реумнкнцхъ SOAP)

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type
  CommunicationWithClient = interface(IInvokable)
    ['{0C4BE492-F776-A77E-1D30-438A940BED01}']
    function  controlCommunication: Integer; stdcall;
  end;

function GetCommunicationWithClient(UseWSDL: Boolean = System.False;
  Addr: string = ''; HTTPRIO: THTTPRIO = nil): CommunicationWithClient;

implementation

uses SysUtils, Unit_Main;

function GetCommunicationWithClient(UseWSDL: Boolean; Addr: string;
  HTTPRIO: THTTPRIO): CommunicationWithClient;
const
  defSvc: string = 'CommunicationWithClientService';
  defPrt: string = 'CommunicationWithClientPort';
var
  defWSDL: string;
  defURL: string;
  RIO: THTTPRIO;
begin
  try
    defWSDL := ServerPath + '/disp/cwc?wsdl'; defURL := ServerPath + '/disp/cwc';
    Result := nil;
    if (Addr = '') then begin
      if UseWSDL then
        Addr := defWSDL
      else
        Addr := defURL;
    end;
    if HTTPRIO = nil then
      RIO := THTTPRIO.Create(nil)
    else
      RIO := HTTPRIO;
    try
      Result := (RIO as CommunicationWithClient);
      if UseWSDL then begin
        RIO.WSDLLocation := Addr;
        RIO.Service := defSvc;
        RIO.Port := defPrt;
      end
      else
        RIO.URL := Addr;
    finally
      if (Result = nil) and (HTTPRIO = nil) then
        RIO.Free;
    end;
  except
  end;
end;

initialization

InvRegistry.RegisterInterface(TypeInfo(CommunicationWithClient),
  'http://communication.disp.pnhz.kz/', 'UTF-8');
InvRegistry.RegisterDefaultSOAPAction(TypeInfo(CommunicationWithClient), '');

end.
