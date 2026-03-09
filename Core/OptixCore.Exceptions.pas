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

unit OptixCore.Exceptions;

interface

// ---------------------------------------------------------------------------------------------------------------------
uses
  System.SysUtils;
// ---------------------------------------------------------------------------------------------------------------------

type
  EWindowsException = class(Exception)
  private
    FErrorCode: Cardinal;
  public
    {@C}
    constructor Create(const WindowsAPIName: string; const AErrorCode: Cardinal = 0); overload;

    {@G}
    property ErrorCode: Cardinal read FErrorCode;
  end;

  EOptixSystemException = class(Exception)
  public
    {@C}
    constructor Create(const ASystemmErrorIdentifier: TGUID); overload;
  end;

  TOptixConfigError = (
    oceMissingField,
    oceInvalidDataFormat
  );

  EOptixConfigException = class(Exception)
  private
    FError: TOptixConfigError;
  public
    {@C}
    constructor Create(const AError: TOptixConfigError); reintroduce;

    {@G}
    property Error: TOptixConfigError read FError;
  end;

  ECOMException = class(Exception)
  private
    FErrorCode : HRESULT;
  public
    {@C}
    constructor Create(const AMethodName : string; const AErrorCode : HRESULT); overload;

    {@G}
    property ErrorCode : HRESULT read FErrorCode;
  end;

implementation

// ---------------------------------------------------------------------------------------------------------------------
uses
  OptixCore.WinApiEx;
// ---------------------------------------------------------------------------------------------------------------------

(* EWindowsException *)

constructor EWindowsException.Create(const WindowsAPIName: string; const AErrorCode: Cardinal = 0);
begin
  if AErrorCode = 0 then
    FErrorCode := GetLastError
  else
    FErrorCode := AErrorCode;
  ///

  var AFormatedMessage := Format('___%s: last_err=%d, last_err_msg="%s".', [
      WindowsAPIName,
      FErrorCode,
      SysErrorMessage(FErrorCode)
  ]);

  ///
  inherited Create(AFormatedMessage);
end;

(* EOptixSystemException *)

constructor EOptixSystemException.Create(const ASystemmErrorIdentifier: TGUID);
begin
  inherited Create(Format('Optix System Error: "%s"', [ASystemmErrorIdentifier.ToString]));
end;

(* EOptixConfigException *)

constructor EOptixConfigException.Create(const AError: TOptixConfigError);
begin
  var AMessage := '';
  case AError of
    oceMissingField: AMessage := 'Missing Field';
    oceInvalidDataFormat: AMessage := 'Invalid Data Format';
  end;

  inherited Create(AMessage);
  ///

  FError := AError;
end;

(* ECOMException *)

constructor ECOMException.Create(const AMethodName : string; const AErrorCode : HRESULT);
begin
  FErrorCode := AErrorCode;

  var AReason := '';

  case Cardinal(FErrorCode) of
    COPYENGINE_E_USER_CANCELLED: AReason := 'The user cancelled the operation';
    COPYENGINE_E_CANCELLED: AReason := 'The operation was cancelled';
    COPYENGINE_E_REQUIRES_ELEVATION: AReason := 'The operation requires Administrator elevation';
    COPYENGINE_E_SAME_FILE: AReason := 'The source and destination are the exact same file';
    COPYENGINE_E_DIFF_DIR: AReason := 'The source and destination are in different directories';
    COPYENGINE_E_MANY_SRC_1_DEST: AReason := 'Multiple sources were specified for a single destination';
    COPYENGINE_E_DEST_SUBTREE: AReason := 'The destination is a subtree of the source';
    COPYENGINE_E_DEST_SAME_TREE: AReason := 'The destination is in the same tree as the source';
    COPYENGINE_E_FLD_IS_FILE_DEST: AReason := 'The destination is a file, but the source is a folder';
    COPYENGINE_E_FILE_IS_FLD_DEST: AReason := 'The destination is a folder, but the source is a file';
    COPYENGINE_E_FILE_TOO_LARGE: AReason := 'The file is too large for the destination file system (e.g., > 4GB on FAT32)';
    COPYENGINE_E_REMOVABLE_FULL: AReason := 'The destination removable media is full';
    COPYENGINE_E_DEST_IS_RO_CD: AReason := 'The destination is a read-only CD';
    COPYENGINE_E_DEST_IS_RW_CD: AReason := 'The destination is a read/write CD';
    COPYENGINE_E_DEST_IS_R_CD: AReason := 'The destination is a recordable CD';
    COPYENGINE_E_DEST_IS_RO_DVD: AReason := 'The destination is a read-only DVD';
    COPYENGINE_E_DEST_IS_RW_DVD: AReason := 'The destination is a read/write DVD';
    COPYENGINE_E_DEST_IS_R_DVD: AReason := 'The destination is a recordable DVD';
    COPYENGINE_E_SRC_IS_RO_CD: AReason := 'The source is a read-only CD';
    COPYENGINE_E_SRC_IS_RW_CD: AReason := 'The source is a read/write CD';
    COPYENGINE_E_SRC_IS_R_CD: AReason := 'The source is a recordable CD';
    COPYENGINE_E_SRC_IS_RO_DVD: AReason := 'The source is a read-only DVD';
    COPYENGINE_E_SRC_IS_RW_DVD: AReason := 'The source is a read/write DVD';
    COPYENGINE_E_SRC_IS_R_DVD: AReason := 'The source is a recordable DVD';
    COPYENGINE_E_INVALID_FILES_SRC: AReason := 'The source file or files are invalid';
    COPYENGINE_E_INVALID_FILES_DEST: AReason := 'The destination file or files are invalid';
    COPYENGINE_E_PATH_TOO_DEEP_SRC: AReason := 'The source path exceeds the maximum character length';
    COPYENGINE_E_PATH_TOO_DEEP_DEST: AReason := 'The destination path exceeds the maximum character length';
    COPYENGINE_E_ROOT_DIR_SRC: AReason := 'The source is a root directory';
    COPYENGINE_E_ROOT_DIR_DEST: AReason := 'The destination is a root directory';
    COPYENGINE_E_ACCESS_DENIED_SRC: AReason := 'Access denied to the source location';
    COPYENGINE_E_ACCESS_DENIED_DEST: AReason := 'Access denied to the destination location';
    COPYENGINE_E_PATH_NOT_FOUND_SRC: AReason := 'The source path could not be found';
    COPYENGINE_E_PATH_NOT_FOUND_DEST: AReason := 'The destination path could not be found';
    COPYENGINE_E_NET_DISCONNECT_SRC: AReason := 'The network disconnected from the source';
    COPYENGINE_E_NET_DISCONNECT_DEST: AReason := 'The network disconnected from the destination';
    COPYENGINE_E_SHARING_VIOLATION_SRC: AReason := 'A sharing violation occurred on the source';
    COPYENGINE_E_SHARING_VIOLATION_DEST: AReason := 'A sharing violation occurred on the destination';
    COPYENGINE_E_ALREADY_EXISTS_NORMAL: AReason := 'A file with that name already exists';
    COPYENGINE_E_ALREADY_EXISTS_READONLY: AReason := 'A read-only file with that name already exists';
    COPYENGINE_E_ALREADY_EXISTS_SYSTEM: AReason := 'A system file with that name already exists';
    COPYENGINE_E_ALREADY_EXISTS_FOLDER: AReason := 'A folder with that name already exists';
    COPYENGINE_E_STREAM_LOSS: AReason := 'Secondary stream information would be lost';
    COPYENGINE_E_EA_LOSS: AReason := 'Extended attributes would be lost';
    COPYENGINE_E_PROPERTY_LOSS: AReason := 'A property would be lost';
    COPYENGINE_E_PROPERTIES_LOSS: AReason := 'Properties would be lost';
    COPYENGINE_E_ENCRYPTION_LOSS: AReason := 'Encryption would be lost during the copy';
    COPYENGINE_E_DISK_FULL: AReason := 'The destination disk is completely full';
    COPYENGINE_E_DISK_FULL_CLEAN: AReason := 'The destination disk is full (can be freed using Disk Cleanup)';
    COPYENGINE_E_EA_NOT_SUPPORTED: AReason := 'Extended attributes are not supported on the destination';
    COPYENGINE_E_CANT_REACH_SOURCE: AReason := 'Cannot reach the source / Unknown Recycle Bin error';
    COPYENGINE_E_RECYCLE_FORCE_NUKE: AReason := 'The file is too large for the Recycle Bin; permanent deletion is required';
    COPYENGINE_E_RECYCLE_SIZE_TOO_BIG: AReason := 'The file size exceeds the current Recycle Bin capacity';
    COPYENGINE_E_RECYCLE_PATH_TOO_LONG: AReason := 'The file path is too long for the Recycle Bin';
    COPYENGINE_E_RECYCLE_BIN_NOT_FOUND: AReason := 'The Recycle Bin could not be found';
    COPYENGINE_E_NEWFILE_NAME_TOO_LONG: AReason := 'The new file name is too long';
    COPYENGINE_E_NEWFOLDER_NAME_TOO_LONG: AReason := 'The new folder name is too long';
    COPYENGINE_E_DIR_NOT_EMPTY: AReason := 'The directory cannot be deleted because it is not empty';
    COPYENGINE_E_FAT_MAX_IN_ROOT: AReason := 'The maximum number of files has been reached in the FAT root directory';
    COPYENGINE_E_ACCESSDENIED_READONLY: AReason := 'Access denied because the item is read-only';
    COPYENGINE_E_REDIRECTED_TO_WEBPAGE: AReason := 'The operation was redirected to a webpage';
    COPYENGINE_E_SERVER_BAD_FILE_TYPE: AReason := 'The server rejected the file type';
    else
      AReason := 'Unknown';
  end;

  ///
  inherited Create(Format('COM___%s: last_err=%x, reason="%s".', [AMethodName, AErrorCode, AReason]));
end;

end.
