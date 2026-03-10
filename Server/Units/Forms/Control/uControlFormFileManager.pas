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

{
  TODO:
    - Lock GUI during refresh (Folders), Unlock if: Refresh Success / Refresh Error
}

unit uControlFormFileManager;

interface

// ---------------------------------------------------------------------------------------------------------------------
uses
  System.SysUtils, System.Variants, System.Classes,

  Generics.Collections,

  Winapi.Windows, Winapi.Messages,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Buttons, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ExtCtrls,

  VirtualTrees, VirtualTrees.BaseAncestorVCL, VirtualTrees.BaseTree, VirtualTrees.AncestorVCL,
  OMultiPanel, VirtualTrees.Types,

  __uBaseFormControl__,

  OptixCore.System.FileSystem, OptixCore.Commands.FileSystem, OptixCore.Protocol.Packet,

  NeoFlat.Panel, NeoFlat.Edit, NeoFlat.ImageButton, NeoFlat.Button, NeoFlat.PopupMenu;

// ---------------------------------------------------------------------------------------------------------------------

type
  TFileTreeData = record
  private
    {@M}
    function GetName: string;
    function GetAccess: TFileAccessAttributes;
  public
    DriveInformation: TDriveInformation;
    FileInformation: TFileInformation;
    ImageIndex: Integer;

    {@M}
    function Path(const IncludeTrailingPathDelimiterIfDirectory: Boolean = False): string;

    {@G}
    property Name: string read GetName;
    property Access: TFileAccessAttributes read GetAccess;
  end;
  PFileTreeData = ^TFileTreeData;

  TFolderTreeData = record
  private
    {@M}
    function GetIsRoot: Boolean;
  public
    Information: TSimpleFolderInformation;
    ImageIndex: Integer;

    {@G}
    property IsRoot: Boolean read GetIsRoot;
  end;
  PFolderTreeData = ^TFolderTreeData;

  TDisplayMode = (
    dmDrives,
    dmFiles
  );

  TControlFormFileManager = class(TBaseFormControl)
    PopupMenu: TFlatPopupMenu;
    DownloadFile1: TMenuItem;
    UploadToFolder1: TMenuItem;
    PopupMenuOptions: TFlatPopupMenu;
    ColoredFoldersAccessView1: TMenuItem;
    N1: TMenuItem;
    ShowFolderTree1: TMenuItem;
    PopupFoldersTree: TFlatPopupMenu;
    FullExpand1: TMenuItem;
    FullCollapse1: TMenuItem;
    N2: TMenuItem;
    StreamFileContentOpen1: TMenuItem;
    PanelMain: TFlatPanel;
    MultiPanel: TOMultiPanel;
    PanelVSTFolders: TFlatPanel;
    VSTFolders: TVirtualStringTree;
    PanelVSTFiles: TFlatPanel;
    VSTFiles: TVirtualStringTree;
    PanelPath: TFlatPanel;
    EditPath: TFlatEdit;
    PanelActions: TFlatPanel;
    ButtonDrives: TFlatButton;
    LabelAccess: TLabel;
    PanelDirection: TFlatPanel;
    ButtonBack: TFlatButton;
    ButtonForward: TFlatButton;
    Shape1: TShape;
    ButtonRefresh: TFlatButton;
    ButtonGoTo: TFlatButton;
    ButtonUpload: TFlatButton;
    ButtonOptions: TFlatButton;
    ButtonNewDirectory: TFlatButton;
    Shape2: TShape;
    Shape3: TShape;
    N3: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    PasteToSelectedFolder1: TMenuItem;
    Shape4: TShape;
    ButtonPaste: TFlatButton;
    Paste1: TMenuItem;
    ClearClipboard1: TMenuItem;
    N4: TMenuItem;
    Delete1: TMenuItem;
    Rename1: TMenuItem;
    procedure VSTFilesGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: TImageIndex);
    procedure VSTFilesFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTFilesGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VSTFilesDblClick(Sender: TObject);
    procedure VSTFilesCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VSTFilesBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ColoredFoldersAccessView1Click(Sender: TObject);
    procedure DownloadFile1Click(Sender: TObject);
    procedure ButtonDrivesClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure UploadToFolder1Click(Sender: TObject);
    procedure ButtonOptionsClick(Sender: TObject);
    procedure ButtonUploadClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonForwardClick(Sender: TObject);
    procedure ButtonGoToClick(Sender: TObject);
    procedure ShowFolderTree1Click(Sender: TObject);
    procedure VSTFoldersGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure VSTFoldersGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure VSTFoldersGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
      Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure FullExpand1Click(Sender: TObject);
    procedure FullCollapse1Click(Sender: TObject);
    procedure VSTFoldersDblClick(Sender: TObject);
    procedure VSTFoldersCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex;
      var Result: Integer);
    procedure VSTFoldersFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure StreamFileContentOpen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonNewDirectoryClick(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure VSTFilesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure ButtonPasteClick(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure PasteToSelectedFolder1Click(Sender: TObject);
    procedure ClearClipboard1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
  private
    FHistoryCursor: Integer;
    FPathHistory: TList<string>;
    FCurrentPathACL: TFileAccessAttributes;

    {@M}
    procedure InsertPathToHistory(APath: string);
    procedure BrowseFromCurrentHistoryLocation;
    function GetFolderFromTreeByFolderPath(AFolderPath: string) : PVirtualNode;
    procedure DeleteFolderFromTree(const AFolderPath: string);
    procedure RegisterNewFolderOnTree(const AFolderInformation: TFileInformation);
    function CanNodeFileBeRead(var pData: PFileTreeData): Boolean;
    function CanFileBeUploadedToNodeDirectory(var pData: PFileTreeData): Boolean;
    procedure RegisterFoldersInTree(const AParentFolders: TObjectList<TSimpleFolderInformation>;
      const AFolders: TObjectList<TSimpleFolderInformation>);
    procedure DisplayDrives(const AList: TOptixCommandEnumDrives);
    procedure DisplayFiles(const AList: TOptixCommandEnumDirectoryFiles);
    procedure SetDisplayMode(const AMode: TDisplayMode);
    procedure BrowsePath(const APath: string; const APushToHistory: Boolean = True);
    procedure RefreshActionsButtons;
    procedure RefreshDrives(const APushToHistory: Boolean = True);
    procedure RefreshFiles;
    function GetFolderImageIndex(const AFolderAccess: TFileAccessAttributes): Integer;
    function GetNodeByFileName(const AFileName: string): PVirtualNode;
    procedure CopyOrCutSelectedNode(const ACopyMode: TVirtualClipboardCopyMode);
    procedure PasteFileOrDirectory(const pNode: PVirtualNode = nil);
    procedure OnVirtualClipboardUpdate(Sender: TObject);
  protected
    {@M}
    function GetContextDescription: string; override;
    procedure OnFirstShow; override;

    function RequestFileDownload(const ARemoteFilePath: string = ''; ALocalFilePath: string = ''): TGUID; reintroduce;
    function RequestFileUpload(ALocalFilePath: string; const ARemoteFilePath: string = ''; const AContext: string = ''): TGUID; reintroduce;
  public
    {@M}
    procedure ReceivePacket(const AOptixPacket: TOptixPacket; var AHandleMemory: Boolean); override;
    procedure RegisterNewFile(const APath: string; const AFileInformation: TFileInformation);
    procedure DeleteFile(const AFilePath: string; const AIsDirectory: Boolean);
  end;

var
  ControlFormFileManager: TControlFormFileManager;

implementation

// ---------------------------------------------------------------------------------------------------------------------
uses
  Winapi.ShLwApi,

  System.Types, System.DateUtils, System.Math, System.IOUtils, System.StrUtils,

  uFormMain,

  OptixCore.Commands, Optix.Constants, Optix.Helper;
// ---------------------------------------------------------------------------------------------------------------------

{$R *.dfm}

(* TFolderTreeData *)

function TFolderTreeData.GetIsRoot: Boolean;
begin
  if Assigned(Information) then
    result := PathIsRootW(PWideChar(Information.Path))
  else
    result := True;
end;

(* TFileTreeData *)

function TFileTreeData.GetName: string;
begin
  Result := '';
  ///

  if Assigned(DriveInformation) then
    Result := DriveInformation.Letter
  else if Assigned(FileInformation) then
    Result := FileInformation.Name;
end;

function TFileTreeData.GetAccess: TFileAccessAttributes;
begin
  if Assigned(FileInformation) then
    Result := FileInformation.Access
  else
    Result := [];
end;

function TFileTreeData.Path(const IncludeTrailingPathDelimiterIfDirectory: Boolean = False): string;
begin
  Result := '';
  ///

  if Assigned(FileInformation) then begin
    Result := FileInformation.Path;
    if IncludeTrailingPathDelimiterIfDirectory and FileInformation.IsDirectory then
      Result := IncludeTrailingPathDelimiter(Result);
  end;
end;

(* TControlFormFileManager *)

function TControlFormFileManager.GetNodeByFileName(const AFileName: string): PVirtualNode;
begin
  Result := nil;
  ///

  for var pNode in VSTFiles.Nodes do begin
    var pData := PFileTreeData(pNode.GetData);
    ///

    if string.Compare(pData^.Name, AFileName, True) = 0 then begin
      Result := pNode;

      break;
    end;
  end;
end;

procedure TControlFormFileManager.RegisterNewFile(const APath: string; const AFileInformation: TFileInformation);
begin
  if not Assigned(AFileInformation) then
    Exit;
  ///

  if string.Compare(
    IncludeTrailingPathDelimiter(APath),
    IncludeTrailingPathDelimiter(EditPath.Text),
    True
  ) <> 0 then
    Exit;

  VSTFiles.BeginUpdate;
  try
    var pNode := GetNodeByFileName(AFileInformation.Name);
    if not Assigned(pNode) then
      pNode := VSTFiles.AddChild(nil);

    var pData := PFileTreeData(pNode.GetData);

    if Assigned(pData^.FileInformation) then
      FreeAndNil(pData^.FileInformation);

    pData^.FileInformation := TFileInformation.Create;
    pData^.FileInformation.Assign(AFileInformation);

    if AFileInformation.IsDirectory then
      pData^.ImageIndex := TOptixHelper.SystemFolderIcon
    else
      pData^.ImageIndex := TOptixHelper.SystemFileIcon(pData^.Name, True);

    ///
    if AFileInformation.IsDirectory then
      RegisterNewFolderOnTree(pData^.FileInformation);
  finally
    VSTFiles.EndUpdate;
  end;
end;

procedure TControlFormFileManager.Delete1Click(Sender: TObject);
begin
  if VSTFiles.FocusedNode = nil then
    Exit;
  ///

  var pData := PFileTreeData(VSTFiles.FocusedNode.GetData);
  if not Assigned(pData) or not (faWrite in pData^.Access) or not Assigned(pData^.FileInformation) then
    Exit;
  ///

  var ADisplayType := '';
  if pData^.FileInformation.IsDirectory then
    ADisplayType := Format('directory ("%s"), including all subdirectories and files', [pData^.Name])
  else
    ADisplayType := Format('file ("%s")', [pData^.Name]);


  if Application.MessageBox(
    PWideChar(Format('You are about to delete this %s. Are you sure you want to proceed?', [ADisplayType])),
    'Delete',
    MB_ICONQUESTION + MB_YESNO) = ID_NO
  then
    Exit;
  ///

 SendCommand(TOptixCommandDeleteFileOrDirectory.Create(pData^.Path));
end;

procedure TControlFormFileManager.DeleteFile(const AFilePath: string; const AIsDirectory: Boolean);
begin
  if string.Compare(
    IncludeTrailingPathDelimiter(ExtractFilePath(AFilePath)),
    IncludeTrailingPathDelimiter(EditPath.Text),
    True
  ) <> 0 then
    Exit;
  ///

  VSTFiles.BeginUpdate;
  try
    var pNode := GetNodeByFileName(ExtractFileName(AFilePath));
    if Assigned(pNode) then
      VSTFiles.DeleteNode(pNode);
  finally
    VSTFiles.EndUpdate;
  end;

  ///
  if AIsDirectory then
    DeleteFolderFromTree(AFilePath);
end;

function TControlFormFileManager.GetFolderImageIndex(const AFolderAccess: TFileAccessAttributes): Integer;
begin
  Result := -1;
  ///

  if not ColoredFoldersAccessView1.Checked then
    Exit;
  ///

  if (faRead in AFolderAccess) and (faWrite in AFolderAccess) and (faExecute in AFolderAccess) then
    Result := IMAGE_FOLDER_FULLACCESS
  else if AFolderAccess = [faRead] then
    Result := IMAGE_FOLDER_READONLY
  else if AFolderAccess = [faWrite] then
    Result := IMAGE_FOLDER_WRITEONLY
  else if AFolderAccess = [faExecute] then
    Result := IMAGE_FOLDER_EXECONLY
  else if AFolderAccess = [] then
    Result := IMAGE_FOLDER_DENIED
  else
    Result := IMAGE_FOLDER_NORMAL;
end;

procedure TControlFormFileManager.RegisterFoldersInTree(const AParentFolders: TObjectList<TSimpleFolderInformation>;
  const AFolders: TObjectList<TSimpleFolderInformation>);
begin
  TOptixVirtualTreesFolderTreeHelper.UpdateTree<TSimpleFolderInformation>(
    VSTFolders,
    AParentFolders,
    AFolders,
    (
      function (const pData: Pointer): string
      begin
        Result := PFolderTreeData(pData)^.Information.Name
      end
    ),
    (
      function (const AItem: TSimpleFolderInformation): string
      begin
        Result := AItem.Name
      end
    ),
    (
      procedure (var pNode, pParentNode: PVirtualNode; const AItem: TSimpleFolderInformation)
      begin
        var pData: PFolderTreeData;
        ///

        if not Assigned(pNode) then begin
          pNode := VSTFolders.AddChild(pParentNode);

          pData := PFolderTreeData(pNode.GetData);

          pData^.Information := TSimpleFolderInformation.Create
        end else
          pData := PFolderTreeData(pNode.GetData);

        pData^.Information.Assign(AItem);

        if pData^.IsRoot then
          pData^.ImageIndex := TOptixHelper.SystemFileIcon(AItem.Path)
        else
          pData^.ImageIndex := TOptixHelper.SystemFolderIcon;
      end
    )
  );
end;

function TControlFormFileManager.GetFolderFromTreeByFolderPath(AFolderPath: string) : PVirtualNode;
begin
  result := nil;
  ///

  AFolderPath := IncludeTrailingPathDelimiter(AFolderPath);
  ///

  for var pNode in VSTFolders.Nodes do begin
    var pData := PFolderTreeData(pNode.GetData);
    if not Assigned(pData) then
      Exit;
    ///

    if string.Compare(pData^.Information.Path, AFolderPath, True) = 0 then begin
      result := pNode;

      Break;
    end;
  end;
end;

procedure TControlFormFileManager.DeleteFolderFromTree(const AFolderPath: string);
begin
  var pNodeToDelete := GetFolderFromTreeByFolderPath(AFolderPath);
  if Assigned(pNodeToDelete) then
    VSTFolders.DeleteNode(pNodeToDelete);
end;

procedure TControlFormFileManager.RegisterNewFolderOnTree(const AFolderInformation: TFileInformation);
begin
  if not Assigned(AFolderInformation) then
    Exit;
  ///

  var pParentNode := GetFolderFromTreeByFolderPath(ExtractFilePath(AFolderInformation.Path));
  if not Assigned(pParentNode) then
    Exit;
  ///

  VSTFolders.BeginUpdate;
  try
    var pNode := VSTFolders.AddChild(pParentNode);
    var pData := PFolderTreeData(pNode.GetData);
    if not Assigned(pData) then
      Exit;
    ///

    pData^.Information := TSimpleFolderInformation.Create(AFolderInformation);
    pData^.ImageIndex := TOptixHelper.SystemFolderIcon;
  finally
    if Assigned(pParentNode) then
      VSTFolders.Expanded[pParentNode] := True;

    VSTFolders.SortTree(0, TSortDirection.sdAscending);

    VSTFolders.EndUpdate;
  end;
end;

procedure TControlFormFileManager.Rename1Click(Sender: TObject);
begin
  if VSTFiles.FocusedNode = nil then
    Exit;
  ///

end;

procedure TControlFormFileManager.BrowseFromCurrentHistoryLocation;
begin
  if (FPathHistory.Count > 0) and (FHistoryCursor >= 0) then begin
    var APath := FPathHistory.Items[FHistoryCursor];

    if string.Compare(APath, '\\:DRIVES:\\') = 0 then
      RefreshDrives(False)
    else
      BrowsePath(APath, False);
  end;
end;

procedure TControlFormFileManager.RefreshActionsButtons;
begin
  ButtonBack.Enabled := (FPathHistory.Count > 0) and (FHistoryCursor > 0);
  ButtonForward.Enabled := (FPathHistory.Count > 0) and (FHistoryCursor < FPathHistory.Count -1);
  ButtonRefresh.Enabled := PanelPath.Visible;
  ButtonUpload.Enabled := ButtonRefresh.Enabled and (faWrite in FCurrentPathACL);
  ButtonNewDirectory.Enabled := ButtonUpload.Enabled;
  ButtonPaste.Enabled := ButtonUpload.Enabled and not FSharedClass.FileClipboard.IsEmpty;
end;

procedure TControlFormFileManager.InsertPathToHistory(APath: string);
begin
  if not Assigned(FPathHistory) then
    Exit;
  ///

  APath := IncludeTrailingPathDelimiter(APath);

  if (FPathHistory.Count = 0) or
     (string.Compare(FPathHistory.Items[FPathHistory.Count-1], APath, True) <> 0) then begin

     if FHistoryCursor < FPathHistory.Count -1 then
      FPathHistory.DeleteRange(FHistoryCursor +1, (FPathHistory.Count -1) - FHistoryCursor);

     FPathHistory.Add(APath);

     ///
     FHistoryCursor := FPathHistory.Count -1;
  end;

  ///
  RefreshActionsButtons;
end;

procedure TControlFormFileManager.OnFirstShow;
begin
  inherited;
  ///

  RefreshDrives;
end;

function TControlFormFileManager.RequestFileDownload(const ARemoteFilePath: string = ''; ALocalFilePath: string = ''): TGUID;
begin
  inherited RequestFileDownload(ARemoteFilePath, ALocalFilePath, Format('File Manager (%s)', [EditPath.Text]));
end;

function TControlFormFileManager.RequestFileUpload(ALocalFilePath: string; const ARemoteFilePath: string = ''; const AContext: string = ''): TGUID;
begin
  inherited RequestFileUpload(ALocalFilePath, ARemoteFilePath, Format('File Manager (%s)', [EditPath.Text]));
end;

procedure TControlFormFileManager.RefreshDrives(const APushToHistory: Boolean = True);
begin
  if APushToHistory then
    InsertPathToHistory('\\:DRIVES:\\');
  ///

  SendCommand(TOptixCommandEnumDrives.Create);
end;

procedure TControlFormFileManager.RefreshFiles;
begin
  BrowsePath(EditPath.Text);
end;

procedure TControlFormFileManager.ColoredFoldersAccessView1Click(Sender: TObject);
begin
  VSTFiles.Refresh;
  VSTFolders.Refresh;
end;

procedure TControlFormFileManager.Copy1Click(Sender: TObject);
begin
  CopyOrCutSelectedNode(vccmCopy);
end;

procedure TControlFormFileManager.CopyOrCutSelectedNode(const ACopyMode: TVirtualClipboardCopyMode);
begin
  if not Assigned(VSTFiles.FocusedNode) then
    Exit;
  ///

  var pData := PFileTreeData(VSTFiles.FocusedNode.GetData);
  if (faRead in pData^.Access) and (((ACopyMode = vccmCut) and (faWrite in pData^.Access)) or (ACopyMode = vccmCopy))
  then begin
    FSharedClass.FileClipboard.CopyMode := ACopyMode;
    FSharedClass.FileClipboard.Content := pData^.FileInformation.Path;
  end;

  ///
  RefreshActionsButtons;
  VSTFiles.Refresh;
end;

procedure TControlFormFileManager.Paste1Click(Sender: TObject);
begin
  ButtonPasteClick(ButtonPaste);
end;

procedure TControlFormFileManager.PasteFileOrDirectory(const pNode: PVirtualNode = nil);
begin
  if FSharedClass.FileClipboard.IsEmpty then
    Exit;
  ///

  var ADestination := '';
  ///

  if Assigned(pNode) then begin
    var pData := PFileTreeData(pNode.GetData);
    if Assigned(pData) and (faWrite in pData^.Access) then
      ADestination := pData^.Path(True);
  end else if faWrite in FCurrentPathACL then
    ADestination := EditPath.Text;

  ///
  if not string.IsNullOrWhiteSpace(ADestination) then
    SendCommand(TOptixCommandCopyFileOrDirectory.Create(
      FSharedClass.FileClipboard.Content,
      ADestination,
      FSharedClass.FileClipboard.CopyMode
    ));
end;

procedure TControlFormFileManager.PasteToSelectedFolder1Click(Sender: TObject);
begin
  if Assigned(VSTFiles.FocusedNode) then
    PasteFileOrDirectory(VSTFiles.FocusedNode);
end;

procedure TControlFormFileManager.Cut1Click(Sender: TObject);
begin
  CopyOrCutSelectedNode(vccmCut);
end;

procedure TControlFormFileManager.SetDisplayMode(const AMode: TDisplayMode);
begin
  VSTFiles.Clear;
  ///

  EditPath.Visible := AMode = dmFiles;
  EditPath.Clear;

  LabelAccess.Visible := AMode = dmFiles;

  TOptixVirtualTreesHelper.UpdateColumnVisibility(VSTFiles, 'DACL (SSDL)', AMode = dmFiles);
  TOptixVirtualTreesHelper.UpdateColumnVisibility(VSTFiles, 'Access Rights', AMode = dmFiles);
  TOptixVirtualTreesHelper.UpdateColumnVisibility(VSTFiles, 'Creation Date', AMode = dmFiles);
  TOptixVirtualTreesHelper.UpdateColumnVisibility(VSTFiles, 'Last Modified', AMode = dmFiles);
  TOptixVirtualTreesHelper.UpdateColumnVisibility(VSTFiles, 'Last Access', AMode = dmFiles);

  ///
  RefreshActionsButtons;
end;

procedure TControlFormFileManager.ButtonBackClick(Sender: TObject);
begin
  Dec(FHistoryCursor);
  if FHistoryCursor < 0 then
    FHistoryCursor := 0;

  BrowseFromCurrentHistoryLocation;

  RefreshActionsButtons;
end;

procedure TControlFormFileManager.ButtonForwardClick(Sender: TObject);
begin
  Inc(FHistoryCursor);
  if FHistoryCursor > FPathHistory.Count -1 then
    FHistoryCursor := FPathHistory.Count -1;

  BrowseFromCurrentHistoryLocation;

  RefreshActionsButtons;
end;

procedure TControlFormFileManager.ButtonGoToClick(Sender: TObject);
begin
  var APath := '';

  if not InputQuery('Go To', 'Path:', APath) then
    Exit;

  ///
  BrowsePath(APath);
end;

procedure TControlFormFileManager.ButtonDrivesClick(Sender: TObject);
begin
  RefreshDrives;
end;

procedure TControlFormFileManager.ButtonNewDirectoryClick(Sender: TObject);
begin
  var AFolderName := '';

  if not InputQuery('Create New Directory', 'Directory Name', AFolderName) then
    Exit;

  AFolderName := TFileSystemHelper.CleanFileName(AFolderName);
  if string.IsNullOrWhiteSpace(AFolderName) then
    Exit;

  ///
  SendCommand(TOptixCommandCreateDirectory.Create(EditPath.Text, AFolderName));
end;

procedure TControlFormFileManager.ButtonOptionsClick(Sender: TObject);
begin
  var APoint := PanelActions.ClientToScreen(
    Point(
      TFlatButton(Sender).Left,
      TFlatButton(Sender).Top + TFlatButton(Sender).Height
    )
  );

  PopupMenuOptions.Popup(APoint.X, APoint.Y);
end;

procedure TControlFormFileManager.ButtonPasteClick(Sender: TObject);
begin
  PasteFileOrDirectory;
end;

procedure TControlFormFileManager.ButtonRefreshClick(Sender: TObject);
begin
  if EditPath.Visible then
    RefreshFiles
  else
    RefreshDrives;
end;

procedure TControlFormFileManager.ButtonUploadClick(Sender: TObject);
begin
  if EditPath.Visible then
    RequestFileUpload('', IncludeTrailingPathDelimiter(EditPath.Text));
end;

procedure TControlFormFileManager.UploadToFolder1Click(Sender: TObject);
begin
  var pNode := VSTFiles.FocusedNode;
  if not Assigned(pNode) then
    Exit;

  var pData := PFileTreeData(pNode.GetData);
  if not CanFileBeUploadedToNodeDirectory(pData) then
    Exit;

  RequestFileUpload('', IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(EditPath.Text) + pData^.FileInformation.Name));
end;

function TControlFormFileManager.GetContextDescription: string;
begin
  var ANodeCount := VSTFiles.RootNodeCount;
  ///

  if not EditPath.Visible and (ANodeCount > 0) then
    Result := Format('%d drives enumerated.', [ANodeCount])
  else if ANodeCount > 0 then
    Result := Format('%s', [EditPath.Text]);
end;

function TControlFormFileManager.CanNodeFileBeRead(var pData: PFileTreeData): Boolean;
begin
  Result := False;
  ///

  if not Assigned(pData) and Assigned(pData^.FileInformation) and (pData^.FileInformation.IsDirectory) then
    Exit;

  // ?? File is not empty
  // ?? Client has read access
  Result := (pData^.FileInformation.Size > 0) and (faRead in pData^.FileInformation.Access);
end;

procedure TControlFormFileManager.ClearClipboard1Click(Sender: TObject);
begin
  FSharedClass.FileClipboard.Clear;
  RefreshActionsButtons;
  VSTFiles.Refresh;
end;

function TControlFormFileManager.CanFileBeUploadedToNodeDirectory(var pData: PFileTreeData): Boolean;
begin
  Result := False;
  ///

  if not Assigned(pData) and Assigned(pData^.FileInformation) then
    Exit;

  // ?? A folder
  // ?? Client has write access
  Result := (pData^.FileInformation.IsDirectory) and (faWrite in pData^.FileInformation.Access);
end;

procedure TControlFormFileManager.PopupMenuPopup(Sender: TObject);
begin
  TOptixHelper.HideAllPopupMenuRootItems(TPopupMenu(Sender));
  ///

  if EditPath.Visible then begin
    var pNode := VSTFiles.FocusedNode;
    if Assigned(pNode) then begin
      var pData := PFileTreeData(pNode.GetData);
      ///

      Copy1.Visible := True;
      Cut1.Visible := True;
      Delete1.Visible := True;
      Rename1.Visible := True;

      if Assigned(pData^.FileInformation) then begin
        if pData^.FileInformation.IsDirectory then begin
          UploadToFolder1.Visible := True;
          UploadToFolder1.Enabled := CanFileBeUploadedToNodeDirectory(pData);
          PasteToSelectedFolder1.Visible := True;
          PasteToSelectedFolder1.Enabled := (faWrite in pData^.Access) and not FSharedClass.FileClipboard.IsEmpty;
        end else begin
          DownloadFile1.Visible := True;
          DownloadFile1.Enabled := CanNodeFileBeRead(pData);
          StreamFileContentOpen1.Visible := DownloadFile1.Visible;
          StreamFileContentOpen1.Enabled := DownloadFile1.Enabled;
        end;

        ///
        Copy1.Enabled := faRead in pData^.Access;
        Cut1.Enabled := (faRead in pData^.Access) and (faWrite in pData^.Access);
        Delete1.Enabled := (faWrite in pData^.Access);
        Rename1.Enabled := pData^.Access <> [];
      end;
    end;

    ///
    ClearClipboard1.Visible := not FSharedClass.FileClipboard.IsEmpty;
    Paste1.Visible := True;
    Paste1.Enabled := not FSharedClass.FileClipboard.IsEmpty and (faWrite in FCurrentPathACL);
  end;
end;

procedure TControlFormFileManager.VSTFilesBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  if Column <> 3 then
    Exit;
  ///

  var pData := PFileTreeData(Node.GetData);
  var AColor := clNone;

  if Assigned(pData) and Assigned(pData^.FileInformation) then begin
    var AFolderAccess := pData^.FileInformation.Access;
    ///

    if (faRead in AFolderAccess) and (faWrite in AFolderAccess) and (faExecute in AFolderAccess) then
      AColor := COLOR_FILE_ALL_ACCESS
    else if (AFolderAccess = [faRead]) then
      AColor := COLOR_FILE_READ_ONLY
    else if (AFolderAccess = [faWrite]) then
      AColor := COLOR_FILE_WRITE_ONLY
    else if (AFolderAccess = [faExecute]) then
      AColor := COLOR_FILE_EXECUTE_ONLY
    else if (AFolderAccess = []) then
      AColor := COLOR_FILE_NO_ACCESS;

    if AColor <> clNone then begin
      TargetCanvas.Brush.Color := AColor;

      CellRect.Width := ScaleValue(4);

      TargetCanvas.FillRect(CellRect);
    end;
  end;
end;

procedure TControlFormFileManager.VSTFilesCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
begin
  var pData1 := PFileTreeData(Node1.GetData);
  var pData2 := PFileTreeData(Node2.GetData);
  ///

  if not Assigned(pData1) or not Assigned(pData2) then begin
    Result := 0;

    ///
    Exit; // Avoid too many nested blocks of code in this specific case.
  end;

  // File Mode Sorting -------------------------------------------------------------------------------------------------
  if Assigned(pData1^.FileInformation) and Assigned(pData2^.FileInformation) then begin
    case Column of
      0: begin
        // Always put '..' at the top
        if (pData1^.FileInformation.Name = '..') and
           (pData2^.FileInformation.Name <> '..') then
          Result := -1
        else if (pData2^.FileInformation.Name = '..') and
                (pData1^.FileInformation.Name <> '..') then
          Result := 1
        else if (pData1^.FileInformation.Name = '..') and
                (pData2^.FileInformation.Name = '..') then
          Result := 0
        else begin
          // Separate folders from files
          if pData1^.FileInformation.IsDirectory and
             not pData2^.FileInformation.IsDirectory then
            Result := -1
          else if not pData1^.FileInformation.IsDirectory and
                      pData2^.FileInformation.IsDirectory then
            Result := 1
          else
            Result := CompareText(
              pData1^.FileInformation.Name,
              pData2^.FileInformation.Name
            );
        end;
      end;

      1: Result := CompareText(pData1^.FileInformation.TypeDescription, pData2^.FileInformation.TypeDescription);
      2: Result := CompareValue(pData1^.FileInformation.Size, pData2^.FileInformation.Size);

      3: Result := CompareText(
                      AccessSetToReadableString(pData1^.FileInformation.Access),
                      AccessSetToReadableString(pData2^.FileInformation.Access)
                    );

      4: Result := CompareText(pData1^.FileInformation.ACL_SSDL, pData2^.FileInformation.ACL_SSDL);
      5: Result := CompareDateTime(pData1^.FileInformation.CreatedDate, pData2^.FileInformation.CreatedDate);
      6: Result := CompareDateTime(pData1^.FileInformation.LastModifiedDate, pData2^.FileInformation.LastModifiedDate);
      7: Result := CompareDateTime(pData1^.FileInformation.LastAccessDate, pData2^.FileInformation.LastAccessDate);
    end;
  end else if Assigned(pData1^.DriveInformation) and Assigned(pData2^.DriveInformation) then begin
    case Column of
      0: Result := CompareText(pData1^.DriveInformation.Letter, pData1^.DriveInformation.Letter);
      1: Result := CompareText(pData1^.DriveInformation.Format, pData2^.DriveInformation.Format);
      2: Result := CompareValue(pData1^.DriveInformation.TotalSize, pData2^.DriveInformation.TotalSize);
    end;
  end;
  // -------------------------------------------------------------------------------------------------------------------
end;

procedure TControlFormFileManager.BrowsePath(const APath: string; const APushToHistory: Boolean = True);
begin
  if APushToHistory then
    InsertPathToHistory(APath);
  ///

  SendCommand(TOptixCommandEnumDirectoryFiles.Create(APath));
end;

procedure TControlFormFileManager.VSTFilesDblClick(Sender: TObject);
begin
  if VSTFiles.FocusedNode = nil then
    Exit;

  var pData := PFileTreeData(VSTFiles.FocusedNode.GetData);

  if Assigned(pData^.DriveInformation) then
    BrowsePath(pData^.DriveInformation.Letter)
  else if Assigned(pData^.FileInformation) then begin
    var APath := EditPath.Text;

    if pData^.FileInformation.Name = '..' then
      APath := IncludeTrailingPathDelimiter(
        TDirectory.GetParent(ExcludeTrailingPathDelimiter(APath))
      )
    else
      APath := IncludeTrailingPathDelimiter(APath) + pData^.FileInformation.Name;

    ///
    BrowsePath(APath);
  end;
end;

procedure TControlFormFileManager.VSTFilesFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  var pData := PFileTreeData(Node.GetData);
  if not Assigned(pData) then
    Exit;
  ///

  if Assigned(pData^.DriveInformation) then
    FreeAndNil(pData^.DriveInformation);

  if Assigned(pData^.FileInformation) then
    FreeAndNil(pData^.FileInformation);

  ///
  // Finalize(pData^);
end;

procedure TControlFormFileManager.VSTFilesGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
begin
  var pData := PFileTreeData(Node.GetData);
  if not Assigned(pData) or (Column <> 0) then
    Exit;
  ///

//  if Assigned(pData^.DriveInformation) and (Kind = TVTImageKind.ikState) then begin
//    case pData^.DriveInformation.DriveType of
//      dtUnknown: ImageIndex := IMAGE_DRIVE_UNKNOWN;
//      dtNoRootDir: ImageIndex := IMAGE_DRIVE_NO_ROOT;
//      dtRemovable: ImageIndex := IMAGE_DRIVE_USB;
//      dtFixed: ImageIndex := IMAGE_DRIVE;
//      dtRemote: ImageIndex := IMAGE_DRIVE_NETWORK;
//      dtCDROM: ImageIndex := IMAGE_DRIVE_CD;
//      dtRAMDisk: ImageIndex := IMAGE_DRIVE_HARDWARE;
//    end;
  if Assigned(pData^.DriveInformation) and ((Kind = ikNormal) or (Kind = ikSelected)) then
    ImageIndex := pData^.ImageIndex
  else if Assigned(pData^.FileInformation) then begin
    case Kind of
      ikNormal, ikSelected: begin
        if (pData^.FileInformation.IsDirectory and not ColoredFoldersAccessView1.Checked) or
            not (pData^.FileInformation.IsDirectory) then
          ImageIndex := pData^.ImageIndex;
      end;

      ikState: begin
        if not FSharedClass.FileClipboard.IsEmpty and
          (string.Compare(FSharedClass.FileClipboard.Content, pData^.Path, True) = 0)
        then begin
          if FSharedClass.FileClipboard.CopyMode = vccmCopy then
            ImageIndex := IMAGE_COPY
          else
            ImageIndex := IMAGE_CUT;
        end else begin
          if pData^.FileInformation.IsDirectory and ColoredFoldersAccessView1.Checked then begin
            if (pData^.FileInformation.Name = '..') then
              ImageIndex := IMAGE_FOLDER_PREV
            else
              ImageIndex := GetFolderImageIndex(pData^.FileInformation.Access);
          end;
        end;
      end;
    end;
  end;
end;

procedure TControlFormFileManager.VSTFilesGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TFileTreeData);
end;

procedure TControlFormFileManager.VSTFilesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  var pData := PFileTreeData(Node.GetData);

  CellText := '';

  if Assigned(pData) and Assigned(pData^.DriveInformation) then begin
    // Drives ----------------------------------------------------------------------------------------------------------
    case Column of
      0: begin
        if String.IsNullOrEmpty(pData^.DriveInformation.Name) then
          CellText := pData^.DriveInformation.Letter
        else
          CellText := Format('%s (%s)', [
            pData^.DriveInformation.Letter,
            pData^.DriveInformation.Name
          ]);
      end;

      1: begin
        var ADriveType := DriveTypeToString(pData^.DriveInformation.DriveType);
        if String.IsNullOrEmpty(pData^.DriveInformation.Format) then
          CellText := ADriveType
        else
          CellText := Format('%s (%s)', [
            ADriveType,
            pData^.DriveInformation.Format
          ]);
      end;

      2: begin
        if pData^.DriveInformation.TotalSize > 0 then
          CellText := Format('%s(%d%%) / %s', [
            TOptixHelper.FormatFileSize(pData^.DriveInformation.UsedSize),
            pData^.DriveInformation.UsedPercentage,
            TOptixHelper.FormatFileSize(pData^.DriveInformation.TotalSize)
          ]);
      end;
    end;
  // -------------------------------------------------------------------------------------------------------------------
  end else if Assigned(pData) and Assigned(pData^.FileInformation) then begin
    // Files -----------------------------------------------------------------------------------------------------------
    if (pData^.FileInformation.Name = '..') then begin
      if Column = 0 then
        CellText := '< .. >';
    end else begin
      case Column of
        0: CellText := pData^.FileInformation.Name;
        1: CellText := pData^.FileInformation.TypeDescription;

        2: begin
          if not pData^.FileInformation.IsDirectory then
            CellText := TOptixHelper.FormatFileSize(pData^.FileInformation.Size);
        end;

        3: CellText := AccessSetToReadableString(pData^.FileInformation.Access);
        4: CellText := pData^.FileInformation.ACL_SSDL;
      end;

      if pData^.FileInformation.DateAreValid then begin
        case column of
          5: CellText := DateTimeToStr(pData^.FileInformation.CreatedDate);
          6: CellText := DateTimeToStr(pData^.FileInformation.LastModifiedDate);
          7: CellText := DateTimeToStr(pData^.FileInformation.LastAccessDate);
        End;
      end;
    end;
  end;
  // -------------------------------------------------------------------------------------------------------------------

  ///
  CellText := TOptixHelper.DefaultIfEmpty(CellText);
end;

procedure TControlFormFileManager.VSTFilesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  var pData := PFileTreeData(Node.GetData);
  if not Assigned(pData) then
    Exit;

  if not FSharedClass.FileClipboard.IsEmpty and
    (string.Compare(pData^.Path, FSharedClass.FileClipboard.Content, True) = 0)
  then begin
    case FSharedClass.FileClipboard.CopyMode of
      vccmCopy: TargetCanvas.Font.Color := clBlue;
      vccmCut: TargetCanvas.Font.Color := clRed;
    end;

  end;
end;

procedure TControlFormFileManager.VSTFoldersCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
begin
  var pData1 := PFolderTreeData(Node1.GetData);
  var pData2 := PFolderTreeData(Node2.GetData);
  ///

  if not Assigned(pData1) or not Assigned(pData2) then
    Result := 0
  else
    Result := CompareText(pData1^.Information.Name, pData2^.Information.Name);
end;

procedure TControlFormFileManager.VSTFoldersDblClick(Sender: TObject);
begin
  var pNode := VSTFolders.FocusedNode;
  if not Assigned(pNode) then
    Exit;
  ///

  var pData := PFolderTreeData(pNode.GetData);

  ///
  BrowsePath(pData^.Information.Path);
end;

procedure TControlFormFileManager.VSTFoldersFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  var pData := PFolderTreeData(Node.GetData);
  if not Assigned(pData) then
    Exit;
  ///

  if Assigned(pData^.Information) then
    FreeAndNil(pData^.Information);

  ///
  // Finalize(pData^);
end;

procedure TControlFormFileManager.VSTFoldersGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
begin
  var pData := PFolderTreeData(Node.GetData);
  if not Assigned(pData) or (Column <> 0) or ((Kind <> ikNormal) and (Kind <> ikSelected)) then
    Exit;
  ///

  ImageIndex := pData^.ImageIndex;
end;

procedure TControlFormFileManager.VSTFoldersGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TFolderTreeData);
end;

procedure TControlFormFileManager.VSTFoldersGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
begin
  var pData := PFolderTreeData(Node.GetData);

  CellText := '';

  if Assigned(pData) then begin
    case Column of
      0: CellText := pData^.Information.Name;
    end;
  end;

  CellText := TOptixHelper.DefaultIfEmpty(CellText);
end;

procedure TControlFormFileManager.ReceivePacket(const AOptixPacket: TOptixPacket; var AHandleMemory: Boolean);
begin
  inherited;
  ///

  // -------------------------------------------------------------------------------------------------------------------
  if AOptixPacket is TOptixCommandEnumDrives then
    DisplayDrives(TOptixCommandEnumDrives(AOptixPacket))
  // -------------------------------------------------------------------------------------------------------------------
  else if AOptixPacket is TOptixCommandEnumDirectoryFiles then
    DisplayFiles(TOptixCommandEnumDirectoryFiles(AOptixPacket))
  // -------------------------------------------------------------------------------------------------------------------
  else if AOptixPacket is TOptixCommandFileInformation then begin
    var ACastedPacket := TOptixCommandFileInformation(AOptixPacket);
    ///

    // Propagate signal to other File Manager Windows
    RegisterNewFileOnFileManagers(ExtractFilePath(ACastedPacket.FileName), ACastedPacket.FileInformation);
  end;
  // -------------------------------------------------------------------------------------------------------------------
end;

procedure TControlFormFileManager.DisplayDrives(const AList: TOptixCommandEnumDrives);
begin
  SetDisplayMode(dmDrives);
  ///

  FCurrentPathACL := [];

  if not Assigned(AList) then
    Exit;
  ///

  var AFolders := TObjectList<TSimpleFolderInformation>.Create(True);

  VSTFiles.BeginUpdate;
  try
    for var ADrive in AList.Drives do begin
      var pNode := VSTFiles.AddChild(nil);
      var pData := PFileTreeData(pNode.GetData);
      ///

      pData^.DriveInformation := TDriveInformation.Create;
      pData^.DriveInformation.Assign(ADrive);
      pData^.FileInformation := nil;
      pData^.ImageIndex := TOptixHelper.SystemFileIcon(IncludeTrailingPathDelimiter(ADrive.Letter));

      ///
      AFolders.Add(TSimpleFolderInformation.Create(ADrive.Letter, ADrive.Letter, []));
    end;
  finally
    RegisterFoldersInTree(nil, AFolders);

    VSTFiles.EndUpdate;

    AFolders.Free;
  end;
end;

procedure TControlFormFileManager.DisplayFiles(const AList: TOptixCommandEnumDirectoryFiles);
begin
  SetDisplayMode(dmFiles);
  ///

  if not Assigned(AList) then
    Exit;
  ///

  EditPath.Text := AList.Path;

  LabelAccess.Caption := AccessSetToString(AList.Access);
  FCurrentPathACL := AList.Access;

  var AFolders := TObjectList<TSimpleFolderInformation>.Create(True);

  VSTFiles.BeginUpdate;
  try
    for var AFile in AList.Files do begin
      var pNode := VSTFiles.AddChild(nil);
      var pData := PFileTreeData(pNode.GetData);
      ///

      pData^.DriveInformation := nil;
      pData^.FileInformation := TFileInformation.Create;
      pData^.FileInformation.Assign(AFile);

      if AFile.IsDirectory then begin
        pData^.ImageIndex := TOptixHelper.SystemFolderIcon;

        ///
        if not MatchStr(pData^.FileInformation.Name, ['.', '..']) then
          AFolders.Add(
            TSimpleFolderInformation.Create(
              pData^.FileInformation.Name,
              pData^.FileInformation.Path,
              pData^.FileInformation.Access
            )
          );
      end else
        pData^.ImageIndex := TOptixHelper.SystemFileIcon(AFile.Name, True);
    end;
  finally
    RegisterFoldersInTree(AList.ParentFolders, AFolders);

    VSTFiles.EndUpdate;

    RefreshActionsButtons;

    ///
    AFolders.Free;
  end;
end;

procedure TControlFormFileManager.DownloadFile1Click(Sender: TObject);
begin
  var pNode := VSTFiles.FocusedNode;
  if not Assigned(pNode) then
    Exit;

  var pData := PFileTreeData(pNode.GetData);
  if not CanNodeFileBeRead(pData) then
    Exit;

  ///
  RequestFileDownload(IncludeTrailingPathDelimiter(EditPath.Text) + pData^.FileInformation.Name);
end;

procedure TControlFormFileManager.ShowFolderTree1Click(Sender: TObject);
begin
  MultiPanel.PanelCollection.Items[0].Visible := TMenuItem(Sender).Checked;
end;

procedure TControlFormFileManager.StreamFileContentOpen1Click(Sender: TObject);
begin
  if VSTFiles.FocusedNode = nil then
    Exit;
  ///

  var pData := PFileTreeData(VSTFiles.FocusedNode.GetData);
  if CanNodeFileBeRead(pData) then
    StreamFileContent(pData^.FileInformation.Path);
end;

procedure TControlFormFileManager.FormCreate(Sender: TObject);
begin
  FHistoryCursor := 0;
  FPathHistory := TList<string>.Create;

  SetDisplayMode(dmDrives);

  FCurrentPathACL := [];

  // Setup Constraints
  Constraints.MinWidth := ScaleValue(250);

  var APoint := ButtonOptions.ClientToScreen(Point(0, 0));

  Constraints.MinHeight := (APoint.Y - Top) + ButtonOptions.Height + LabelAccess.Height + PanelPath.Height +
    ScaleValue(20);

  FSharedClass.FileClipboard.SubscribeToClipboardUpdateSignal(OnVirtualClipboardUpdate);
end;

procedure TControlFormFileManager.FormDestroy(Sender: TObject);
begin
  VSTFiles.Clear;
  ///

  if Assigned(FPathHistory) then
    FreeAndNil(FPathHistory);
end;

procedure TControlFormFileManager.FullCollapse1Click(Sender: TObject);
begin
  VSTFolders.FullCollapse(nil);
end;

procedure TControlFormFileManager.FullExpand1Click(Sender: TObject);
begin
  VSTFolders.FullExpand(nil);
end;

procedure TControlFormFileManager.OnVirtualClipboardUpdate(Sender: TObject);
begin
  RefreshActionsButtons;
  VSTFolders.Refresh;
  VSTFiles.Refresh;
end;

end.
