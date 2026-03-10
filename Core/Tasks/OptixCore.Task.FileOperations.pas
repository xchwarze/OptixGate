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

unit OptixCore.Task.FileOperations;

interface

// ---------------------------------------------------------------------------------------------------------------------
uses
  OptixCore.Classes, OptixCore.Commands.Base, OptixCore.System.FileSystem, OptixCore.Commands.FileSystem;
// ---------------------------------------------------------------------------------------------------------------------

type
  TOptixCopyFileOrDirectoryTask = class(TOptixTask)
  protected
    {@M}
    function TaskCode: TOptixTaskResult; override;
  end;

  TOptixTaskGetCopyFileOrDirectoryResult = class(TOptixTaskResult)
  private
    [OptixSerializableAttribute]
    FFileInformation: TFileInformation;

    [OptixSerializableAttribute]
    FSource: string;

    [OptixSerializableAttribute]
    FDestination: string;

    [OptixSerializableAttribute]
    FMoved: Boolean;
  protected
    {@M}
    function GetExtendedDescription: string; override;
  public
    {@C}
    constructor Create(const ASource, ADestination: string; const AMoved: Boolean); overload;
    destructor Destroy; override;

    {@M}
    procedure AfterCreate; override;

    {@G}
    property FileInformation: TFileInformation read FFileInformation;
    property Source: string read FSource;
    property Destination: string read FDestination;
    property Moved: Boolean read FMoved;
  end;

  TOptixDeleteFileOrDirectoryTask = class(TOptixTask)
  protected
    {@M}
    function TaskCode: TOptixTaskResult; override;
  end;

  TOptixTaskGetDeleteFileOrDirectoryResult = class(TOptixTaskResult)
  private
    [OptixSerializableAttribute]
    FFilePath: string;

    [OptixSerializableAttribute]
    FIsDirectory: Boolean;
  protected
    {@M}
    function GetExtendedDescription: string; override;
  public
    {@C}
    constructor Create(const AFilePath: string; const AIsDirectory: Boolean); overload;

    {@G}
    property FilePath: string read FFilePath;
    property IsDirectory: Boolean read FIsDirectory;
  end;

implementation

// ---------------------------------------------------------------------------------------------------------------------
uses
  System.SysUtils, System.IOUtils,

  Winapi.Windows;
// ---------------------------------------------------------------------------------------------------------------------

(* TOptixCopyFileOrDirectoryTask *)

function TOptixCopyFileOrDirectoryTask.TaskCode: TOptixTaskResult;
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
  Result := TOptixTaskGetCopyFileOrDirectoryResult.Create(
    ACastedCommand.Source,
    ACopiedOrMovedFileDestination,
    ACastedCommand.CopyMode = vccmCut
  );
end;

(* TOptixTaskGetCopyFileOrDirectoryResult *)

constructor TOptixTaskGetCopyFileOrDirectoryResult.Create(const ASource, ADestination: string; const AMoved: Boolean);
begin
  FSource := ASource;
  FDestination := ADestination;
  FMoved := AMoved;
  ///

  FFileInformation := TFileInformation.Create(FDestination, DirectoryExists(FDestination));

  ///
  inherited Create;
end;

destructor TOptixTaskGetCopyFileOrDirectoryResult.Destroy;
begin
  if Assigned(FFileInformation) then
    FFileInformation.Free;

  ///
  inherited Destroy;
end;

procedure TOptixTaskGetCopyFileOrDirectoryResult.AfterCreate;
begin
  inherited;
  ///

  if not Assigned(FFileInformation) then
    FFileInformation := TFileInformation.Create;
end;

function TOptixTaskGetCopyFileOrDirectoryResult.GetExtendedDescription: string;
begin
  // TODO: Ternary (Delphi CE 13+)
  var AMode := '';
  if FMoved then
    AMode := 'moved'
  else
    AMode := 'pasted';
  // END TODO

  Result := Format('"%s" was successfully %s to "%s"', [FSource, AMode, FDestination]);
end;

(* TOptixDeleteFileOrDirectoryTask *)

function TOptixDeleteFileOrDirectoryTask.TaskCode: TOptixTaskResult;
begin
  if not Assigned(FCommand) or not (FCommand is TOptixCommandDeleteFileOrDirectory) then
    Exit(nil);
  ///

  var ACastedCommand := TOptixCommandDeleteFileOrDirectory(FCommand);

  var AIsDirectory := DirectoryExists(ACastedCommand.FilePath);

  TFileSystemHelper.Delete(ACastedCommand.FilePath);

  ///
  Result := TOptixTaskGetDeleteFileOrDirectoryResult.Create(ACastedCommand.FilePath, AIsDirectory);
end;

(* TOptixTaskGetDeleteFileOrDirectoryResult *)

constructor TOptixTaskGetDeleteFileOrDirectoryResult.Create(const AFilePath: string; const AIsDirectory: Boolean);
begin
  FFilePath := AFilePath;
  FIsDirectory := AIsDirectory;

  ///
  inherited Create;
end;

function TOptixTaskGetDeleteFileOrDirectoryResult.GetExtendedDescription: string;
begin
  Result := Format('"%s" was successfully deleted.', [FFilePath]);
end;

end.
