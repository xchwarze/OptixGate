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

unit OptixCore.System.FileSystem;

interface

// ---------------------------------------------------------------------------------------------------------------------
uses
  System.Classes, System.Win.ComObj, System.SysUtils,

  Winapi.Windows, Winapi.ShlObj,

  Generics.Collections,

  OptixCore.Protocol.Packet, OptixCore.Classes;
// ---------------------------------------------------------------------------------------------------------------------

type
  TDriveType = (
    dtUnknown,
    dtNoRootDir,
    dtRemovable,
    dtFixed,
    dtRemote,
    dtCDROM,
    dtRAMDisk
  );

  TFileAccess = (
    faRead,
    faWrite,
    faExecute
  );
  TFileAccessAttributes = set of TFileAccess;

  TVirtualClipboardCopyMode = (
    vccmCopy,
    vccmCut
  );

  TVirtualClipboard = class
  private
    FContent: string;
    FCopyMode: TVirtualClipboardCopyMode;

    FNotifyClipboardUpdateList: TList<TNotifyEvent>;

    {@M}
    procedure SetContent(const AValue: string);
    procedure SetCopyMode(const AValue: TVirtualClipboardCopyMode);
    procedure SignalClipboardUpdate;
  public
    {@C}
    constructor Create;
    destructor Destroy; override;

    {@M}
    procedure SubscribeToClipboardUpdateSignal(const ASignalFunc: TNotifyEvent);
    procedure UnsubscribeFromClipboardUpdateSignal(const ASignalFunc: TNotifyEvent);
    function IsEmpty: Boolean;
    procedure Clear;

    {@G/S}
    property Content: string read FContent write SetContent;
    property CopyMode: TVirtualClipboardCopyMode read FCopyMode write SetCopyMode;
  end;

  TFileOperationSink = class(TInterfacedObject, IFileOperationProgressSink)
  private
    FSourcePath: string;
    FLastOperationFinalPath: string;

    {@M}
    function PostMoveOrCopyItem(dwFlags: DWORD; const psiItem: IShellItem; const psiDestinationFolder: IShellItem;
      pszNewName: LPCWSTR; hrCopyOrMove: HResult; const psiNewlyCreated: IShellItem) : HResult;
  public
    {@C}
    constructor Create(const ASourcePath: string);

    {@M:Implemented}
    function PostCopyItem(dwFlags: DWORD; const psiItem: IShellItem; const psiDestinationFolder: IShellItem;
      pszNewName: LPCWSTR; hrCopy: HResult; const psiNewlyCreated: IShellItem): HResult; stdcall;
    function PostMoveItem(dwFlags: DWORD; const psiItem: IShellItem; const psiDestinationFolder: IShellItem;
      pszNewName: LPCWSTR; hrMove: HResult; const psiNewlyCreated: IShellItem): HResult; stdcall;

    {@M:Not Implemented}
    function StartOperations: HResult; stdcall;
    function FinishOperations(hrResult: HResult): HResult; stdcall;
    function PreRenameItem(dwFlags: DWORD; const psiItem: IShellItem; pszNewName: LPCWSTR): HResult; stdcall;
    function PostRenameItem(dwFlags: DWORD; const psiItem: IShellItem; pszNewName: LPCWSTR; hrRename: HResult;
      const psiNewlyCreated: IShellItem): HResult; stdcall;
    function PreMoveItem(dwFlags: DWORD; const psiItem: IShellItem; const psiDestinationFolder: IShellItem;
      pszNewName: LPCWSTR): HResult; stdcall;
    function PreCopyItem(dwFlags: DWORD; const psiItem: IShellItem; const psiDestinationFolder: IShellItem;
      pszNewName: LPCWSTR): HResult; stdcall;
    function PreDeleteItem(dwFlags: DWORD; const psiItem: IShellItem): HResult; stdcall;
    function PostDeleteItem(dwFlags: DWORD; const psiItem: IShellItem; hrDelete: HResult;
      const psiNewlyCreated: IShellItem): HResult; stdcall;
    function PreNewItem(dwFlags: DWORD; const psiDestinationFolder: IShellItem; pszNewName: LPCWSTR): HResult; stdcall;
    function PostNewItem(dwFlags: DWORD; const psiDestinationFolder: IShellItem; pszNewName: LPCWSTR;
      pszTemplateName: LPCWSTR; dwFileAttributes: DWORD; hrNew: HResult;
      const psiNewItem: IShellItem): HResult; stdcall;
    function UpdateProgress(iWorkTotal: UINT; iWorkSoFar: UINT): HResult; stdcall;
    function ResetTimer: HResult; stdcall;
    function PauseTimer: HResult; stdcall;
    function ResumeTimer: HResult; stdcall;

    {@G}
    property LastOperationFinalPath: string read FLastOperationFinalPath;
  end;

  TFileSystemHelper = class
  type
    TTraversedDirectoryCallback = reference to procedure(const ADirectoryName: string; const AAbsolutePath: string);
  private

  public
    class function GetDriveInformation(ADriveLetter: string; out AName: string; out AFormat: string;
      var ADriveType: TDriveType) : Boolean; static;
    class function TryGetDriveInformation(ADriveLetter: string; out AName: string; out AFormat: string;
      var ADriveType: TDriveType) : Boolean; static;
    class function GetFileACLString(const AFileName: string): string; static;
    class function TryGetFileACLString(const AFileName: string): string; static;
    class procedure GetCurrentUserFileAccess(const AFileName: string; out ARead, AWrite, AExecute: Boolean); overload; static;
    class function GetCurrentUserFileAccess(const AFileName: string): TFileAccessAttributes; overload; static;
    class procedure TryGetCurrentUserFileAccess(const AFileName: string; out ARead, AWrite, AExecute: Boolean); overload; static;
    class function TryGetCurrentUserFileAccess(const AFileName: string): TFileAccessAttributes; overload; static;
    class function GetFileSize(const AFileName: string): Int64; static;
    class function TryGetFileSize(const AFileName: string): Int64; static;
    class function GetFileTypeDescription(const AFileName: string): string; static;
    class procedure GetFileTime(const AFileName: string; out ACreate, ALastModified, ALastAccess: TDateTime); static;
    class function TryGetFileTime(const AFileName: string; out ACreate, ALastModified, ALastAccess: TDateTime): Boolean; static;
    class function UniqueFileName(const AFilePath: string): string; static;
    class function UniqueDirectoryName(const ADirectoryPath: string): string; static;
    class function UniqueFileOrDirectoryName(const APath: string): string; static;
    class function ExpandPath(const APath: string): string; static;
    class procedure TraverseDirectories(const APath: string;
      const ATraversedDirectoryFunc: TTraversedDirectoryCallback); static;
    class function GetFullPathName(const APath: string): string; static;
    class procedure PathExists(const APath: string); static;
    class function CleanFileName(const AFileName: string): string; static;
    class procedure CreateDirectory(const APath, ANewDirectoryName: string); overload; static;
    class procedure CreateDirectory(const AFullPath: string); overload; static;
    class function Copy(const ASource, ADestination: string; const ADoMove: Boolean;
      const ABlockThread: Boolean = True): string; static;
    class procedure Delete(const AFilePath: string; const ABlockThread: Boolean = True); static;
    class function GetFileVersion(const AFilePath : string; var AMajor, AMinor, ARelease,
      ABuild : Cardinal) : Boolean; overload; static;
    class function GetFileVersion(const AFilePath : string) : string; overload; static;
  end;

  TContentReader = class
  private
    FPageSize: UInt64;
    FFileHandle: THandle;
    FFileSize: UInt64;
    FFilePath: string;

    {@M}
    function GetPageCount: UInt64;
    procedure SetPageSize(AValue: UInt64);
  public
    const
      MIN_PAGE_SIZE = 128;
      MAX_PAGE_SIZE = 409600;
  public
    {@C}
    constructor Create(const AFilePath: string; const APageSize: UInt64);
    destructor Destroy; override;

    {@M}
    procedure ReadPage(APageNumber: UInt64; var pBuffer: Pointer; var ABufferSize: UInt64);

    {@G}
    property FileSize: UInt64 read FFileSize;
    property PageCount: UInt64 read GetPageCount;
    property FilePath: string read FFilePath;

    {@S}
    property PageSize: UInt64 read FPageSize write SetPageSize;
  end;

  TFileInformation = class;

  // Folder Information (Simplified) -----------------------------------------------------------------------------------
  TSimpleFolderInformation = class(TOptixSerializableObject)
  private
    [OptixSerializableAttribute]
    FName: string;

    [OptixSerializableAttribute]
    FPath: string;

    [OptixSerializableAttribute]
    FAccess: TFileAccessAttributes;
  public
    {@C}
    constructor Create(const AFileInformation : TFileInformation); overload;
    constructor Create(const AName, APath: string; const AAccess: TFileAccessAttributes); overload;

    {@M}
    procedure Assign(ASource: TPersistent); override;

    {@G}
    property Name: string read FName;
    property Path: string read FPath;
    property Access: TFileAccessAttributes read FAccess;
  end;

  // Drives ------------------------------------------------------------------------------------------------------------
  TDriveInformation = class(TOptixSerializableObject)
  private
    [OptixSerializableAttribute]
    FLetter: string;

    [OptixSerializableAttribute]
    FName: string;

    [OptixSerializableAttribute]
    FFormat: string;

    [OptixSerializableAttribute]
    FType: TDriveType;

    [OptixSerializableAttribute]
    FTotalSize: Int64;

    [OptixSerializableAttribute]
    FFreeSize: Int64;

    {@G}
    function GetUsedPercentage: Byte;
    function GetUsedSize: Int64;
  public
    {@C}
    constructor Create(const ADrive: string; const AIndex: Integer); overload;

    {@M}
    procedure Assign(ASource: TPersistent); override;

    {@G}
    property Letter: string read FLetter;
    property Name: string read FName;
    property Format: string read FFormat;
    property DriveType: TDriveType read FType;
    property TotalSize: Int64 read FTotalSize;
    property FreeSize: Int64 read FFreeSize;
    property UsedSize: Int64 read GetUsedSize;
    property UsedPercentage: Byte read GetUsedPercentage;
  end;

  TOptixEnumDrives = class
  public
    class procedure Enum(var AList: TObjectList<TDriveInformation>); static;
  end;

  // Files -------------------------------------------------------------------------------------------------------------
  TFileInformation = class(TOptixSerializableObject)
  private
    [OptixSerializableAttribute]
    FPath: string;

    [OptixSerializableAttribute]
    FName: string;

    [OptixSerializableAttribute]
    FIsDirectory: Boolean;

    [OptixSerializableAttribute]
    FACL_SSDL: string;

    [OptixSerializableAttribute]
    FAccess: TFileAccessAttributes;

    [OptixSerializableAttribute]
    FTypeDescription: string;

    [OptixSerializableAttribute]
    FSize: Int64;

    [OptixSerializableAttribute]
    FDateAreValid: Boolean;

    [OptixSerializableAttribute]
    FCreatedDate: TDateTime;

    [OptixSerializableAttribute]
    FLastModifiedDate: TDateTime;

    [OptixSerializableAttribute]
    FLastAccessDate: TDateTime;
  public
    {@C}
    constructor Create(const APath: string; const AIsDirectory: Boolean); overload;

    {@M}
    function GetFileTypeDescription: string;
    procedure Assign(ASource: TPersistent); override;

    {@G}
    property Path: string read FPath;
    property Name: string read FName;
    property IsDirectory: Boolean read FIsDirectory;
    property ACL_SSDL: string read FACL_SSDL;
    property Access: TFileAccessAttributes read FAccess;
    property TypeDescription: string read GetFileTypeDescription;
    property Size: Int64 read FSize;
    property DateAreValid: Boolean read FDateAreValid;
    property CreatedDate: TDateTime read FCreatedDate;
    property LastModifiedDate: TDateTime read FLastModifiedDate;
    property LastAccessDate: TDateTime read FLastAccessDate;
  end;

  TOptixEnumFiles = class
  public
    class procedure Enum(const APath: string; var AList: TObjectList<TFileInformation>; var AIsRoot: Boolean;
      var AAccess: TFileAccessAttributes); static;
  end;

  function DriveTypeToString(const AValue: TDriveType): string;
  function AccessSetToString(const AValue: TFileAccessAttributes): string;
  function StringToAccessSet(const AValue: string): TFileAccessAttributes;
  function AccessSetToReadableString(const AValue: TFileAccessAttributes): string;

implementation

// ---------------------------------------------------------------------------------------------------------------------
uses
  System.IOUtils, System.StrUtils, System.Math,

  Winapi.AccCtrl, Winapi.AclAPI, Winapi.ShellAPI, Winapi.ActiveX,

  OptixCore.Exceptions, OptixCore.WinApiEx, OptixCore.System.Helper;
// ---------------------------------------------------------------------------------------------------------------------

(* Local *)

function DriveTypeToString(const AValue: TDriveType): string;
begin
  Result := 'Unknown';
  ///

  case AValue of
    dtUnknown: Result := 'Unknown';
    dtNoRootDir: Result := 'No Root Dir';
    dtRemovable: Result := 'Removable';
    dtFixed: Result := 'Fixed';
    dtRemote: Result := 'Network';
    dtCDROM: Result := 'CD-ROM';
    dtRAMDisk: Result := 'RAM Disk';
  end;
end;

function AccessSetToString(const AValue: TFileAccessAttributes): string;
begin
  SetLength(Result, 3);
  ///

  Result[1] := IfThen(faRead in AValue, 'R', '_')[1];
  Result[2] := IfThen(faWrite in AValue, 'W', '_')[1];
  Result[3] := IfThen(faExecute in AValue, 'E', '_')[1];
end;

function StringToAccessSet(const AValue: string): TFileAccessAttributes;
begin
  Result := [];
  ///

  if Length(AValue) <> 3 then
    Exit;

  if Copy(AValue, 1, 1) = 'R' then
    Include(Result, faRead);

  if Copy(AValue, 2, 1) = 'W' then
    Include(Result, faWrite);

  if Copy(AValue, 3, 1) = 'E' then
    Include(Result, faExecute);
end;

function AccessSetToReadableString(const AValue: TFileAccessAttributes): string;
begin
  if AValue <> [] then
    Result := AccessSetToString(AValue)
  else
    Result := 'No Access';
end;

(* TFileSystemHelper *)

class function TFileSystemHelper.GetDriveInformation(ADriveLetter: string; out AName: string; out AFormat: string;
 var ADriveType: TDriveType) : Boolean;
begin
  var AOldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    ADriveLetter := IncludeTrailingPathDelimiter(ExtractFileDrive(ADriveLetter));
    ///

    var ADummy: DWORD;
    var ABufferName: array[0..MAX_PATH-1] of WideChar;
    var ABufferFormat: array[0..MAX_PATH-1] of WideChar;

    FillChar(ABufferName, MAX_PATH, #0);
    FillChar(ABufferFormat, MAX_PATH, #0);

    Result := GetVolumeInformation(
                                    PWideChar(ADriveLetter),
                                    ABufferName,
                                    MAX_PATH,
                                    nil,
                                    ADummy,
                                    ADummy,
                                    ABufferFormat,
                                    MAX_PATH
    );

    {
      Conv to String
    }
    AName := String(ABufferName);
    AFormat := String(ABufferFormat);

    {
      Get Drive Type
    }
    case GetDriveType(PWideChar(ADriveLetter)) of
      1: ADriveType := dtNoRootDir; // DRIVE_NO_ROOT_DIR
      2: ADriveType := dtRemovable; // DRIVE_REMOVABLE
      3: ADriveType := dtFixed;     // DRIVE_FIXED
      4: ADriveType := dtRemote;    // DRIVE_REMOTE
      5: ADriveType := dtCDROM;     // DRIVE_CDROM
      6: ADriveType := dtRAMDisk;   // DRIVE_RAMDISK
      else
        ADriveType := dtUnknown;
    end;
  finally
    SetErrorMode(AOldErrorMode);
  end;
end;

class function TFileSystemHelper.TryGetDriveInformation(ADriveLetter: string; out AName: string; out AFormat: string;
 var ADriveType: TDriveType) : Boolean;
begin
  ADriveType := dtUnknown;
  ///
  try
    Result := GetDriveInformation(ADriveLetter, AName, AFormat, ADriveType);
  except
    Result := False;
  end;
end;

class function TFileSystemHelper.GetFileACLString(const AFileName: string): string;
begin
  var ptrSecurityDescriptor: PSecurityDescriptor := nil;
  var pFileACL_SSDL: LPWSTR := nil;
  try
    var ASecurityInformation := OWNER_SECURITY_INFORMATION or
                                GROUP_SECURITY_INFORMATION or
                                DACL_SECURITY_INFORMATION;

    var AResult := GetNamedSecurityInfoW(
      PWideChar(AFileName),
      SE_FILE_OBJECT,
      ASecurityInformation,
      nil,
      nil,
      nil,
      nil,
      @ptrSecurityDescriptor
    );
    if AResult <> ERROR_SUCCESS then
      raise EWindowsException.Create('GetNamedSecurityInfoW', AResult);

    if not ConvertSecurityDescriptorToStringSecurityDescriptorW(
      ptrSecurityDescriptor,
      SDDL_REVISION_1,
      ASecurityInformation,
      pFileACL_SSDL,
      nil
    ) then
      raise EWindowsException.Create('ConvertSecurityDescriptorToStringSecurityDescriptorW');

    ///
    Result := string(pFileACL_SSDL);
  finally
    if Assigned(pFileACL_SSDL) then
      LocalFree(pFileACL_SSDL);

    if Assigned(ptrSecurityDescriptor) then
      LocalFree(ptrSecurityDescriptor);
  end;
end;

class function TFileSystemHelper.TryGetFileACLString(const AFileName: string): string;
begin
  try
    Result := GetFileACLString(AFileName);
  except
    Result := '';
  end;
end;

class procedure TFileSystemHelper.GetCurrentUserFileAccess(const AFileName: string;
 out ARead, AWrite, AExecute: Boolean);
begin
  var AImpersonated := False;

  var ptrSecurityDescriptor := PSecurityDescriptor(nil);
  var hToken := THandle(0);
  ///

  try
    AImpersonated := ImpersonateSelf(SecurityImpersonation);

    if not OpenThreadToken(GetCurrentThread, TOKEN_QUERY, False, hToken) then
      raise EWindowsException.Create('OpenProcessToken');
    ///

    var AResult := GetNamedSecurityInfoW(
      PWideChar(AFileName),
      SE_FILE_OBJECT,
      (
        OWNER_SECURITY_INFORMATION or
        GROUP_SECURITY_INFORMATION or
        DACL_SECURITY_INFORMATION
      ),
      nil,
      nil,
      nil,
      nil,
      @ptrSecurityDescriptor
    );
    if AResult <> ERROR_SUCCESS then
      raise EWindowsException.Create('GetNamedSecurityInfoW', AResult);

    ///
    if TSystemHelper.AccessCheck(FILE_ALL_ACCESS, hToken, ptrSecurityDescriptor) then begin
      ARead := True;
      AWrite := True;
      AExecute := True;
    end else begin
      ARead := TSystemHelper.AccessCheck(FILE_GENERIC_READ, hToken, ptrSecurityDescriptor);
      AWrite := TSystemHelper.AccessCheck(FILE_GENERIC_WRITE, hToken, ptrSecurityDescriptor);
      AExecute := TSystemHelper.AccessCheck(FILE_GENERIC_EXECUTE, hToken, ptrSecurityDescriptor);
    end;
  finally
    if Assigned(ptrSecurityDescriptor) then
      LocalFree(ptrSecurityDescriptor);

    if hToken <> 0 then
      CloseHandle(hToken);

    if AImpersonated then
      RevertToSelf;
  end;
end;

class function TFileSystemHelper.GetCurrentUserFileAccess(const AFileName: string): TFileAccessAttributes;
begin
  var ARead, AWrite, AExecute: Boolean;

  Result := [];

  GetCurrentUserFileAccess(AFileName, ARead, AWrite, AExecute);

  if ARead then
    Include(Result, faRead);

  if AWrite then
    Include(Result, faWrite);

  if AExecute then
    Include(Result, faExecute);
end;

class procedure TFileSystemHelper.TryGetCurrentUserFileAccess(const AFileName: string;
 out ARead, AWrite, AExecute: Boolean);
begin
  try
    GetCurrentUserFileAccess(AFileName, ARead, AWrite, AExecute);
  except
    ARead := False;
    AWrite := False;
    AExecute := False;
  end;
end;

class function TFileSystemHelper.TryGetCurrentUserFileAccess(const AFileName: string): TFileAccessAttributes;
begin
  try
    Result := GetCurrentUserFileAccess(AFileName);
  except
    Result := [];
  end;
end;

class function TFileSystemHelper.GetFileSize(const AFileName: string): Int64;
begin
  var AFileInfo: TWin32FileAttributeData;

  if NOT GetFileAttributesEx(PWideChar(AFileName), GetFileExInfoStandard, @AFileInfo) then
    raise EWindowsException.Create('GetFileAttributesEx');

  ///
  Result := Int64(AFileInfo.nFileSizeLow) or Int64(AFileInfo.nFileSizeHigh shl 32);
end;

class function TFileSystemHelper.TryGetFileSize(const AFileName: string): Int64;
begin
  try
    Result := GetFileSize(AFileName);
  except
    Result := 0;
  end;
end;

class function TFileSystemHelper.GetFileTypeDescription(const AFileName: string): string;
begin
  var AShFileInfo: TSHFileInfoW;

  ZeroMemory(@AShFileInfo, SizeOf(TSHFileInfoW));

  if SHGetFileInfoW(
    PWideChar(AFileName),
    0,
    AShFileInfo,
    SizeOf(TSHFileInfoW),
    SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES
  ) <> 0 then
    Result := AShFileInfo.szTypeName
  else
    Result := '';
end;

class procedure TFileSystemHelper.GetFileTime(const AFileName: string;
 out ACreate, ALastModified, ALastAccess: TDateTime);
begin
  var hFile := CreateFileW(
    PWideChar(AFileName),
    GENERIC_READ,
    FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE,
    nil,
    OPEN_EXISTING,
    FILE_FLAG_BACKUP_SEMANTICS,
    0
  );
  if hFile = INVALID_HANDLE_VALUE then
    raise EWindowsException.Create('GetFileTime');
  try
    var AFtCreate, AFtLastAccess, AFtLastModified: TFileTime;

    if not Winapi.Windows.GetFileTime(hFile, @AFtCreate, @AFtLastAccess, @AFtLastModified) then
      raise EWindowsException.Create('GetFileTime');

    ACreate := TSystemHelper.TryFileTimeToDateTime(AFtCreate);
    ALastModified := TSystemHelper.TryFileTimeToDateTime(AFtLastModified);
    ALastAccess := TSystemHelper.TryFileTimeToDateTime(AFtLastAccess);
  finally
    CloseHandle(hFile);
  end;
end;

class function TFileSystemHelper.TryGetFileTime(const AFileName: string;
 out ACreate, ALastModified, ALastAccess: TDateTime) : Boolean;
begin
  try
    GetFileTime(AFileName, ACreate, ALastModified, ALastAccess);

    ///
    Result := True;
  except
    Result := False;
  end;
end;

class function TFileSystemHelper.UniqueFileName(const AFilePath: string): string;
begin
  if not FileExists(AFilePath) then
    Exit(AFilePath);
  ///
  var I := 1;
  repeat
    Result := Format('%s%s(%d)%s', [
      IncludeTrailingPathDelimiter(ExtractFilePath(AFilePath)),
      TPath.GetFileNameWithoutExtension(AFilePath),
      I,
      TPath.GetExtension(AFilePath)
    ]);

    ///
    Inc(i);
  until (not FileExists(Result));
end;

class function TFileSystemHelper.UniqueDirectoryName(const ADirectoryPath: string): string;
begin
  if not DirectoryExists(ADirectoryPath) then
    Exit(ADirectoryPath);
  ///
  var I := 1;
  repeat
    Result := Format('%s(%d)', [ADirectoryPath, I]);

    ///
    Inc(I);
  until (not DirectoryExists(Result));
end;

class function TFileSystemHelper.UniqueFileOrDirectoryName(const APath: string): string;
begin
  if DirectoryExists(APath) then
    Result := UniqueDirectoryName(APath)
  else if FileExists(APath) then
    Result := UniqueFileName(APath)
  else
    Result := APath;
end;

class function TFileSystemHelper.ExpandPath(const APath: string): string;
begin
  var APathLength := ExpandEnvironmentStrings(PWideChar(APath), nil, 0);
  if APathLength = 0 then
    Exit(APath);
  ///

  SetLength(Result, APathLength - 1);

  if ExpandEnvironmentStrings(PWideChar(APath), PWideChar(Result), APathLength) = 0 then
    Result := APath;

  ///
  Result := IncludeTrailingPathDelimiter(Result);
end;

class procedure TFileSystemHelper.TraverseDirectories(const APath: string;
  const ATraversedDirectoryFunc: TTraversedDirectoryCallback);
begin
  var ADirectories := APath.Split(['\'], TStringSplitOptions.ExcludeEmpty);
  ///

  var ACurrentPath := '';
  for var ADirectory in ADirectories do begin
    ACurrentPath := TSystemHelper.IncludeTrailingPathDelimiterIfNotEmpty(ACurrentPath) + ADirectory;

    ///
    ATraversedDirectoryFunc(ADirectory, ACurrentPath);
  end;
end;

class function TFileSystemHelper.GetFullPathName(const APath: string): string;
begin
  Result := '';
  ///

  var pDummy: PWideChar;

  var ARequiredLength := Winapi.Windows.GetFullPathNameW(PWideChar(APath), 0, nil, pDummy);
  if ARequiredLength = 0 then
    raise EWindowsException.Create('GetFullPathNameW(0)');
  ///

  Inc(ARequiredLength);

  var pBuffer: PWideChar;
  GetMem(pBuffer, ARequiredLength * SizeOf(WideChar));
  try
    if Winapi.Windows.GetFullPathNameW(PWideChar(APath), ARequiredLength, pBuffer, pDummy) = 0 then
      raise EWindowsException.Create('GetFullPathNameW(1)');

    ///
    Result := String(pBuffer);
  finally
    FreeMem(pBuffer, ARequiredLength * SizeOf(WideChar));
  end;
end;

class procedure TFileSystemHelper.PathExists(const APath: string);
begin
  if GetFileAttributesW(PWideChar(APath)) = INVALID_FILE_ATTRIBUTES then
    raise EWindowsException.Create('GetFileAttributesW');
end;

class function TFileSystemHelper.CleanFileName(const AFileName: string): string;
begin
  Result := AFileName;
  ///

  // Or use a Regular Expression
  for var AChar in TPath.GetInvalidFileNameChars do
    Result := Result.Replace(AChar, '_');
end;

class procedure TFileSystemHelper.CreateDirectory(const AFullPath: string);
begin
  if not Winapi.Windows.CreateDirectoryW(PWideChar(AFullPath), nil) then
    raise EWindowsException.Create('CreateDirectoryW');
end;

class procedure TFileSystemHelper.CreateDirectory(const APath, ANewDirectoryName: string);
begin
  TFileSystemHelper.CreateDirectory(IncludeTrailingPathDelimiter(APath) + ANewDirectoryName);
end;

class function TFileSystemHelper.Copy(const ASource, ADestination: string; const ADoMove: Boolean;
  const ABlockThread: Boolean = True): string;
begin
  Result := '';
  ///

  CoInitialize(nil);
  try
    var AFileOperation := CreateComObject(CLSID_FileOperation) as IFileOperation;
    AFileOperation.SetOperationFlags(
      FOF_SILENT or
      FOF_NOCONFIRMATION or
      FOF_NOERRORUI or
      FOF_NOCONFIRMMKDIR or
      FOFX_EARLYFAILURE or
      FOF_RENAMEONCOLLISION
    );

    var ASourceShellItem, ADestinationShellItem: IShellItem;
    OleCheck(SHCreateItemFromParsingName(PWideChar(ASource), nil, IShellItem, ASourceShellItem));
    OleCheck(SHCreateItemFromParsingName(PWideChar(ADestination), nil, IShellItem, ADestinationShellItem));

    var AFileOperationSink := TFileOperationSink.Create(ASource);
    var ASinkInterface := IFileOperationProgressSink(AFileOperationSink);
    try
      if ADoMove then
        AFileOperation.MoveItem(ASourceShellItem, ADestinationShellItem, nil, ASinkInterface)
      else
        AFileOperation.CopyItem(ASourceShellItem, ADestinationShellItem, nil, ASinkInterface);

      if ABlockThread then begin
        var AResult := AFileOperation.PerformOperations;
        if Failed(AResult) then
          raise ECOMException.Create('MoveItem|CopyItem', AResult);
      end;

      ///
      Result := AFileOperationSink.LastOperationFinalPath;
    finally
      AFileOperation := nil;
      ASourceShellItem := nil;
      ADestinationShellItem := nil;
      ASinkInterface := nil;
    end;
  finally
    CoUninitialize;
  end;
end;

class procedure TFileSystemHelper.Delete(const AFilePath: string; const ABlockThread: Boolean = True);
begin
  CoInitialize(nil);
  try
    var AFileOperation := CreateComObject(CLSID_FileOperation) as IFileOperation;
    AFileOperation.SetOperationFlags(
      FOF_SILENT or
      FOF_NOCONFIRMATION or
      FOF_NOERRORUI or
      FOFX_EARLYFAILURE
    );

    var AShellItem: IShellItem;
    OleCheck(SHCreateItemFromParsingName(PWideChar(AFilePath), nil, IShellItem, AShellItem));
    try
      AFileOperation.DeleteItem(AShellItem, nil);

      if ABlockThread then begin
        var AResult := AFileOperation.PerformOperations;
        if Failed(AResult) then
          raise ECOMException.Create('DeleteItem', AResult);
      end;
    finally
      AFileOperation := nil;
    end;
  finally
    CoUninitialize;
  end;
end;

class function TFileSystemHelper.GetFileVersion(const AFilePath : string; var AMajor, AMinor, ARelease,
  ABuild : Cardinal) : Boolean;
begin
  Result := False;
  ///

  AMajor   := 0;
  AMinor   := 0;
  ARelease := 0;
  ABuild   := 0;
  ///

  var ADummyHandle : DWORD;
  var pVersionInfo : Pointer;
  var AVersionInfoSize := GetFileVersionInfoSize(PWideChar(AFilePath), ADummyHandle);
  GetMem(pVersionInfo, AVersionInfoSize);
  try
    if not GetFileVersionInfo(PWideChar(AFilePath), 0, AVersionInfoSize, pVersionInfo) then
      Exit;

    var AValueLength : UINT;
    var pQueriedValue : Pointer;
    if not VerQueryValue(pVersionInfo, '\', pQueriedValue, AValueLength) or (pQueriedValue = nil) then
      Exit;

    AMajor   := HiWord(PVSFixedFileInfo(pQueriedValue)^.dwFileVersionMS);
    AMinor   := LoWord(PVSFixedFileInfo(pQueriedValue)^.dwFileVersionMS);
    ARelease := HiWord(PVSFixedFileInfo(pQueriedValue)^.dwFileVersionLS);
    ABuild   := LoWord(PVSFixedFileInfo(pQueriedValue)^.dwFileVersionLS);

    ///
    Result := True;
  finally
    FreeMem(pVersionInfo, AVersionInfoSize);
  end;
end;

class function TFileSystemHelper.GetFileVersion(const AFilePath : string) : string;
begin
  var AMajor, AMinor, ARelease, ABuild : Cardinal;
  if not GetFileVersion(AFilePath, AMajor, AMinor, ARelease, ABuild) then
    Exit;
  ///

  Result := Format('%d.%d.%d', [
    AMajor,
    AMinor,
    ARelease
  ]);
end;

(* TContentReader *)

constructor TContentReader.Create(const AFilePath: string; const APageSize: UInt64);
begin
  inherited Create;
  ///

  FFileSize := 0;
  FFilePath := AFilePath;

  FFileHandle := CreateFileW(
    PWideChar(FFilePath),
    GENERIC_READ,
    FILE_SHARE_READ,
    nil,
    OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL,
    0
  );
  if FFileHandle = INVALID_HANDLE_VALUE then
    raise EWindowsException.Create('CreateFileW');
  ///

  FFileSize := TFileSystemHelper.GetFileSize(FFilePath);
  SetPageSize(APageSize);
end;

destructor TContentReader.Destroy;
begin
  if FFileHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FFileHandle);

  ///
  inherited Destroy;
end;

function TContentReader.GetPageCount: UInt64;
begin
  Result := 0;
  ///

  if FFileHandle = INVALID_HANDLE_VALUE then
    Exit;

  ///
  Result := ceil(FFileSize / FPageSize);
end;

procedure TContentReader.SetPageSize(AValue: UInt64);
begin
  if AValue < MIN_PAGE_SIZE then
    AValue := MIN_PAGE_SIZE
  else if AValue > MAX_PAGE_SIZE then
    AValue := MAX_PAGE_SIZE;

  if (FFileSize > 0) and (AValue > FFileSize) then
    AValue := FFileSize;

  ///
  FPageSize := AValue;
end;

procedure TContentReader.ReadPage(APageNumber: UInt64; var pBuffer: Pointer; var ABufferSize: UInt64);
begin
  pBuffer := nil;
  ABufferSize := 0;
  ///

  var APageCount := GetPageCount;
  ///

  if APageNumber > APageCount  then
    APageNumber := APageCount;

  var AOffset := UInt64(FPageSize * APageNumber);
  var AHighOffset := DWORD((AOffset shr 32) and $FFFFFFFF);

  if SetFilePointer(FFileHandle, DWORD(AOffset and $FFFFFFFF), @AHighOffset, FILE_BEGIN) = INVALID_SET_FILE_POINTER then
    raise EWindowsException.Create('SetFilePointer');

  GetMem(pBuffer, FPageSize);

  var ABytesRead: DWORD;
  if not ReadFile(FFileHandle, PByte(pBuffer)^, FPageSize, ABytesRead, nil) then
    raise EWindowsException.Create('ReadFile');

  ABufferSize := ABytesRead;
  if ABufferSize < FPageSize then
    ReallocMem(pBuffer, ABufferSize);
end;

(* TSimpleFolderInformation *)

constructor TSimpleFolderInformation.Create(const AName, APath: string; const AAccess: TFileAccessAttributes);
begin
  inherited Create;
  ///

  FName := AName;
  FPath := IncludeTrailingPathDelimiter(APath);
  FAccess := AAccess;
end;

constructor TSimpleFolderInformation.Create(const AFileInformation : TFileInformation);
begin
  inherited Create;
  ///

  if not Assigned(AFileInformation) then
    raise EOptixSystemException.Create('{73267E78-D356-460A-BCCE-3704E312335C}');

  FName := AFileInformation.Name;
  FPath := AFileInformation.Path;
  FAccess := AFileInformation.Access;
end;

procedure TSimpleFolderInformation.Assign(ASource: TPersistent);
begin
  if ASource is TSimpleFolderInformation then begin
    FName := TSimpleFolderInformation(ASource).FName;
    FPath := TSimpleFolderInformation(ASource).FPath;
    FAccess := TSimpleFolderInformation(ASource).FAccess;
  end else
    inherited;
end;

(* TDriveInformation *)

procedure TDriveInformation.Assign(ASource: TPersistent);
begin
  if ASource is TDriveInformation then begin
    FLetter := TDriveInformation(ASource).FLetter;
    FName := TDriveInformation(ASource).FName;
    FFormat := TDriveInformation(ASource).FFormat;
    FType := TDriveInformation(ASource).FType;
    FTotalSize := TDriveInformation(ASource).FTotalSize;
    FFreeSize := TDriveInformation(ASource).FFreeSize;
  end else
    inherited;
end;

constructor TDriveInformation.Create(const ADrive: string; const AIndex: Integer);
begin
  FLetter := ADrive;

  TFileSystemHelper.TryGetDriveInformation(FLetter, FName, FFormat, FType);

  try
    FTotalSize := DiskSize(AIndex);
    FFreeSize := DiskFree(AIndex);
  except
    FTotalSize := 0;
    FFreeSize := 0;
  end;
end;

function TDriveInformation.GetUsedPercentage: Byte;
begin
  if (FTotalSize <= 0) or (FFreeSize <= 0) then
    Exit(0);
  ///

  Result := (GetUsedSize * 100) div FTotalSize;
end;

function TDriveInformation.GetUsedSize: Int64;
begin
  if FTotalSize <= 0 then
    Exit(0);
  ///

  Result := FTotalSize - FFreeSize;
end;

(* TOptixEnumDrives *)

class procedure TOptixEnumDrives.Enum(var AList: TObjectList<TDriveInformation>);
begin
  if not Assigned(AList) then
    AList := TObjectList<TDriveInformation>.Create(True)
  else
    AList.Clear;
  ///

  {$I-}
  var ALogicalDrives := GetLogicalDrives;

  var AIndex := 0;
  for var ALetter: Char in ['a'..'z'] do begin
    if (ALogicalDrives and (1 shl AIndex)) = 0 then begin
      Inc(AIndex);

      continue;
    end;
    ///

    ///
    Inc(AIndex);

    var ADrive := Format('%s:', [UpperCase(ALetter)]);

    AList.Add(TDriveInformation.Create(ADrive, AIndex));
  end;
  {$I+}
end;

(* TFileInformation *)

function TFileInformation.GetFileTypeDescription: string;
begin
  if FIsDirectory then
    Result := 'Directory'
  else
    Result := FTypeDescription;
end;

procedure TFileInformation.Assign(ASource: TPersistent);
begin
  if ASource is TFileInformation then begin
    FPath := TFileInformation(ASource).FPath;
    FName := TFileInformation(ASource).FName;
    FIsDirectory := TFileInformation(ASource).FIsDirectory;
    FACL_SSDL := TFileInformation(ASource).FACL_SSDL;
    FAccess := TFileInformation(ASource).FAccess;
    FTypeDescription := TFileInformation(ASource).FTypeDescription;
    FSize := TFileInformation(ASource).FSize;
    FDateAreValid := TFileInformation(ASource).FDateAreValid;
    FCreatedDate := TFileInformation(ASource).FCreatedDate;
    FLastModifiedDate := TFileInformation(ASource).FLastModifiedDate;
    FLastAccessDate := TFileInformation(ASource).FLastAccessDate;
  end else
    inherited;
end;

constructor TFileInformation.Create(const APath: string; const AIsDirectory: Boolean);
begin
  FPath := APath;
  FName := ExtractFileName(APath);
  FIsDirectory := AIsDirectory;
  FACL_SSDL := TFileSystemHelper.TryGetFileACLString(APath);
  FAccess := TFileSystemHelper.TryGetCurrentUserFileAccess(APath);
  FDateAreValid := TFileSystemHelper.TryGetFileTime(APath, FCreatedDate, FLastModifiedDate, FLastAccessDate);

  if not FIsDirectory then begin
    FTypeDescription := TFileSystemHelper.GetFileTypeDescription(APath);
    FSize := TFileSystemHelper.TryGetFileSize(APath);
  end else begin
    FTypeDescription := '';
    FSize := 0;
  end;
end;

(* TOptixEnumFiles *)

class procedure TOptixEnumFiles.Enum(const APath: string; var AList: TObjectList<TFileInformation>;
  var AIsRoot: Boolean; var AAccess: TFileAccessAttributes);
begin
  if not Assigned(AList) then
    AList := TObjectList<TFileInformation>.Create(True)
  else
    AList.Clear;
  ///

  if String.IsNullOrEmpty(APath) then
    Exit;

  var ASearchParameter := Format('%s*.*', [APath]);

  var AWin32FindData: TWin32FindDataW;

  var hSearch := FindFirstFileW(PWideChar(ASearchParameter), AWin32FindData);
  if hSearch = INVALID_HANDLE_VALUE then
    raise EWindowsException.Create('FindFirstFileW')
  else if hSearch = ERROR_FILE_NOT_FOUND then
    raise Exception.Create(Format('No files found so far in the directory: `%s`', [APath]));
  try
    AIsRoot := True;
    AAccess := TFileSystemHelper.TryGetCurrentUserFileAccess(APath);

    var AFileName: string;
    repeat
      AFileName := String(AWin32FindData.cFileName);
      if AFileName = '.' then
        continue;
      ///

      if AFileName = '..' then
        AIsRoot := False;

      AList.Add(
        TFileInformation.Create(
          APath + AFileName,
          (AWin32FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = FILE_ATTRIBUTE_DIRECTORY)
        )
      );
    until FindNextFileW(hSearch, AWin32FindData) = False;
  finally
    FindClose(hSearch);
  end;
end;

(* TVirtualClipboard *)

constructor TVirtualClipboard.Create;
begin
  inherited;
  ///

  FNotifyClipboardUpdateList := TList<TNotifyEvent>.Create;

  Clear;
end;

destructor TVirtualClipboard.Destroy;
begin
  if Assigned(FNotifyClipboardUpdateList) then
    FNotifyClipboardUpdateList.Free;

  ///
  inherited;
end;

function TVirtualClipboard.IsEmpty: Boolean;
begin
  Result := string.IsNullOrWhiteSpace(Content);
end;

procedure TVirtualClipboard.SubscribeToClipboardUpdateSignal(const ASignalFunc: TNotifyEvent);
begin
  if Assigned(FNotifyClipboardUpdateList) then
    FNotifyClipboardUpdateList.Add(ASignalFunc);
end;

procedure TVirtualClipboard.UnsubscribeFromClipboardUpdateSignal(const ASignalFunc: TNotifyEvent);
begin
  if Assigned(FNotifyClipboardUpdateList) then
    FNotifyClipboardUpdateList.Remove(ASignalFunc);
end;

procedure TVirtualClipboard.SignalClipboardUpdate;
begin
  if not Assigned(FNotifyClipboardUpdateList) then
    Exit;
  ///

  for var ASubscriber in FNotifyClipboardUpdateList do
    ASubscriber(self);
end;

procedure TVirtualClipboard.Clear;
begin
  FContent := '';
  FCopyMode := vccmCopy;

  ///
  SignalClipboardUpdate;
end;

procedure TVirtualClipboard.SetContent(const AValue: string);
begin
  if AValue = FContent then
    Exit;
  ///

  FContent := AValue;

  ///
  SignalClipboardUpdate;
end;

procedure TVirtualClipboard.SetCopyMode(const AValue: TVirtualClipboardCopyMode);
begin
  if AValue = FCopyMode then
    Exit;
  ///

  FCopyMode := AValue;

  ///
  SignalClipboardUpdate;
end;

(* TFileOperationSink *)

constructor TFileOperationSink.Create(const ASourcePath: string);
begin
  inherited Create;
  ///

  FSourcePath := ASourcePath;
  FLastOperationFinalPath := '';
end;

function TFileOperationSink.PostMoveOrCopyItem(dwFlags: DWORD; const psiItem: IShellItem; const psiDestinationFolder: IShellItem;
  pszNewName: LPCWSTR; hrCopyOrMove: HResult; const psiNewlyCreated: IShellItem): HResult;
begin
  if Assigned(psiItem) and Assigned(psiNewlyCreated) then begin
    var ASource: PWideChar;
    var ACurrent: PWideChar;
    if Succeeded(psiItem.GetDisplayName(SIGDN_FILESYSPATH, ASource)) then begin
      try
        if Succeeded(psiNewlyCreated.GetDisplayName(SIGDN_FILESYSPATH, ACurrent)) and
          (string.Compare(string(ASource), FSourcePath, True) = 0)
        then begin
          try
            FLastOperationFinalPath := string(ACurrent);
          finally
            CoTaskMemFree(ACurrent);
          end;
        end;
      finally
        CoTaskMemFree(ASource);
      end;
    end;
  end;

  ///
  Result := S_OK;
end;

function TFileOperationSink.PostCopyItem(dwFlags: DWORD; const psiItem: IShellItem;
  const psiDestinationFolder: IShellItem; pszNewName: LPCWSTR; hrCopy: HResult;
  const psiNewlyCreated: IShellItem): HResult; stdcall;
begin
  Result := PostMoveOrCopyItem(dwFlags, psiItem, psiDestinationFolder, pszNewName, hrCopy, psiNewlyCreated);
end;

function TFileOperationSink.PostMoveItem(dwFlags: DWORD; const psiItem: IShellItem;
  const psiDestinationFolder: IShellItem; pszNewName: LPCWSTR; hrMove: HResult;
  const psiNewlyCreated: IShellItem): HResult; stdcall;
begin
  Result := PostMoveOrCopyItem(dwFlags, psiItem, psiDestinationFolder, pszNewName, hrMove, psiNewlyCreated);
end;

function TFileOperationSink.StartOperations: HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.FinishOperations(hrResult: HResult): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.PreRenameItem(dwFlags: DWORD; const psiItem: IShellItem;
  pszNewName: LPCWSTR): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.PostRenameItem(dwFlags: DWORD; const psiItem: IShellItem; pszNewName: LPCWSTR;
  hrRename: HResult; const psiNewlyCreated: IShellItem): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.PreMoveItem(dwFlags: DWORD; const psiItem: IShellItem;
  const psiDestinationFolder: IShellItem; pszNewName: LPCWSTR): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.PreCopyItem(dwFlags: DWORD; const psiItem: IShellItem;
  const psiDestinationFolder: IShellItem; pszNewName: LPCWSTR): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.PreDeleteItem(dwFlags: DWORD; const psiItem: IShellItem): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.PostDeleteItem(dwFlags: DWORD; const psiItem: IShellItem; hrDelete: HResult;
  const psiNewlyCreated: IShellItem): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.PreNewItem(dwFlags: DWORD; const psiDestinationFolder: IShellItem;
  pszNewName: LPCWSTR): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.PostNewItem(dwFlags: DWORD; const psiDestinationFolder: IShellItem; pszNewName: LPCWSTR;
  pszTemplateName: LPCWSTR; dwFileAttributes: DWORD; hrNew: HResult; const psiNewItem: IShellItem): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.UpdateProgress(iWorkTotal: UINT; iWorkSoFar: UINT): HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.ResetTimer: HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.PauseTimer: HResult; stdcall;
begin
  Result := S_OK;
end;

function TFileOperationSink.ResumeTimer: HResult; stdcall;
begin
  Result := S_OK;
end;

end.
