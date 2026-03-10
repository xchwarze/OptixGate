{******************************************************************************}
{                                                                              }
{         ____             _     ____          _           ____                }
{        |  _ \  __ _ _ __| | __/ ___|___   __| | ___ _ __/ ___|  ___          }
{        | | | |/ _` | '__| |/ / |   / _ \ / _` |/ _ \ '__\___ \ / __|         }
{        | |_| | (_| | |  |   <| |__| (_) | (_| |  __/ |   ___) | (__          }
{        |____/ \__,_|_|  |_|\_\\____\___/ \__,_|\___|_|  |____/ \___|         }
{                             Project: Optix Gate                              }
{                                                                              }
{                                                                              }
{                   Author: DarkCoderSc (Jean-Pierre LESUEUR)                  }
{                   https://www.twitter.com/darkcodersc                        }
{                   https://bsky.app/profile/darkcodersc.bsky.social           }
{                   https://github.com/darkcodersc                             }
{                   License: GPLv3                                             }
{                                                                              }
{                                                                              }
{                                                                              }
{  Disclaimer:                                                                 }
{  -----------                                                                 }
{    We are doing our best to prepare the content of this app and/or code.     }
{    However, The author cannot warranty the expressions and suggestions       }
{    of the contents, as well as its accuracy. In addition, to the extent      }
{    permitted by the law, author shall not be responsible for any losses      }
{    and/or damages due to the usage of the information on our app and/or      }
{    code.                                                                     }
{                                                                              }
{    By using our app and/or code, you hereby consent to our disclaimer        }
{    and agree to its terms.                                                   }
{                                                                              }
{    Any links contained in our app may lead to external sites are provided    }
{    for convenience only.                                                     }
{    Any information or statements that appeared in these sites or app or      }
{    files are not sponsored, endorsed, or otherwise approved by the author.   }
{    For these external sites, the author cannot be held liable for the        }
{    availability of, or the content located on or through it.                 }
{    Plus, any losses or damages occurred from using these contents or the     }
{    internet generally.                                                       }
{                                                                              }
{******************************************************************************}

unit NeoFlat.Validators;

interface

// ---------------------------------------------------------------------------------------------------------------------
uses
  System.Classes,

  VCL.Controls,

  NeoFlat.Types, NeoFlat.Panel;
// ---------------------------------------------------------------------------------------------------------------------

function IsValidIpAddress(const AIP: string): Boolean;
function IsValidHost(const AHost: string): Boolean;
function IsValidNetworkAddress(const AValue: string): Boolean;

function IsValidPort(const APort: Integer): Boolean; overload;
function IsValidPort(const APort: string): Boolean; overload;

function Validate(const AInput: string; const AValidators: TValidators): Boolean;

implementation

// ---------------------------------------------------------------------------------------------------------------------
uses
  System.RegularExpressions, System.SysUtils,

  Winapi.Windows,

  NeoFlat.Edit, NeoFlat.ComboBox;
// ---------------------------------------------------------------------------------------------------------------------

function Validate(const AInput: string; const AValidators: TValidators): Boolean;
begin
  Result := False;
  ///

  { Filled }
  if reqFilled in AValidators then
    if Length(Trim(AInput)) = 0 then
      Exit;

  { Ip Address }
  if reqIpAddress in AValidators then
    if not IsValidIpAddress(AInput) then
      Exit;

  { Host }
  if reqHost in AValidators then
    if not IsValidHost(AInput) then
      Exit;

  { TCP / UDP Port }
  if reqNetPort in AValidators then
    if not IsValidPort(AInput) then
      Exit;

  ///
  Result := True;
end;

function IsValidIpAddress(const AIP: string): Boolean;
begin
  Result := TRegEx.IsMatch(AIP,
    '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
  );
end;

function IsValidHost(const AHost: string): Boolean;
begin
  Result := TRegEx.IsMatch(AHost,
    '^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$'
  );
end;

function IsValidNetworkAddress(const AValue: string): Boolean;
begin
  Result := IsValidIpAddress(AValue) or
            IsValidHost(AValue);
end;

function IsValidPort(const APort: Integer): Boolean;
begin
  Result := (APort >= Low(word)) and (APort <= High(word));
end;

function IsValidPort(const APort: string): Boolean;
var AValue: Integer;
begin
  Result := False;
  if not TryStrToInt(APort, AValue) then
    Exit;
  ///

  Result := IsValidPort(AValue);
end;

end.
