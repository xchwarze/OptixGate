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
{                   License: GPL v3                                            }
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
{                                                                              }
{  Authorship (No AI):                                                         }
{  -------------------                                                         }
{   All code contained in this unit was written and developed by the author    }
{   without the assistance of artificial intelligence systems, large language  }
{   models (LLMs), or automated code generation tools. Any external libraries  }
{   or frameworks used comply with their respective licenses.	                 }
{                                                                              }
{******************************************************************************}

unit OptixCore.Task.CopyFileOrDirectory;

interface

// ---------------------------------------------------------------------------------------------------------------------
uses
  OptixCore.Classes, OptixCore.Commands.Base, OptixCore.System.FileSystem, OptixCore.Commands.FileSystem;
// ---------------------------------------------------------------------------------------------------------------------

type
  TOptixCopyFileOrDirectoryTask = class(TOptixTask)
  protected
    {@M}
    function TaskCode() : TOptixTaskResult; override;
  end;

  TOptixTaskGetCopyFileOrDirectoryResult = class(TOptixTaskResult)
  private
    [OptixSerializableAttribute]
    FFileInformation : TFileInformation;

    [OptixSerializableAttribute]
    FSource : String;

    [OptixSerializableAttribute]
    FDestination : String;

    [OptixSerializableAttribute]
    FMoved : Boolean;
  protected
    {@M}
    function GetExtendedDescription() : String; override;
  public
    {@C}
    constructor Create(const ASource, ADestination : string; const AMoved : Boolean); overload;
    destructor Destroy(); override;

    {@M}
    procedure AfterCreate(); override;

    {@G}
    property FileInformation : TFileInformation read FFileInformation;
    property Source          : String           read FSource;
    property Destination     : String           read FDestination;
    property Moved           : Boolean          read FMoved;
  end;

implementation

// ---------------------------------------------------------------------------------------------------------------------
uses
  System.SysUtils, System.IOUtils,

  Winapi.Windows;
// ---------------------------------------------------------------------------------------------------------------------

(* TOptixCopyFileOrDirectoryTask *)

function TOptixCopyFileOrDirectoryTask.TaskCode() : TOptixTaskResult;
begin
  if not Assigned(FCommand) or not (FCommand is TOptixCommandCopyFileOrDirectory) then
    Exit(nil);
  ///

  var ACastedCommand := TOptixCommandCopyFileOrDirectory(FCommand);

  var ACopiedOrMovedFileDestination := TFileSystemHelper.Copy(
    ACastedCommand.Source,
    ACastedCommand.Destination,
    ACastedCommand.CopyMode = vccmCut
  );

  ///
  result := TOptixTaskGetCopyFileOrDirectoryResult.Create(
    ACastedCommand.Source,
    ACopiedOrMovedFileDestination,
    ACastedCommand.CopyMode = vccmCut
  );
end;

(* TOptixTaskGetCopyFileOrDirectoryResult *)

constructor TOptixTaskGetCopyFileOrDirectoryResult.Create(const ASource, ADestination : string; const AMoved : Boolean);
begin
  FSource      := ASource;
  FDestination := ADestination;
  FMoved       := AMoved;
  ///

  FFileInformation := TFileInformation.Create(FDestination, DirectoryExists(FDestination));

  ///
  inherited Create();
end;

destructor TOptixTaskGetCopyFileOrDirectoryResult.Destroy();
begin
  if Assigned(FFileInformation) then
    FFileInformation.Free;

  ///
  inherited Destroy();
end;

procedure TOptixTaskGetCopyFileOrDirectoryResult.AfterCreate();
begin
  inherited;
  ///

  if not Assigned(FFileInformation) then
    FFileInformation := TFileInformation.Create();
end;

function TOptixTaskGetCopyFileOrDirectoryResult.GetExtendedDescription() : String;
begin
  // TODO: Ternary (Delphi CE 13+)
  var AMode := '';
  if FMoved then
    AMode := 'moved'
  else
    AMode := 'pasted';
  // END TODO

  result := Format('"%s" was successfully %s to "%s"', [FSource, AMode, FDestination]);
end;

end.
