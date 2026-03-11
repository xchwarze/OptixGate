object ControlFormFileManager: TControlFormFileManager
  Left = 0
  Top = 0
  BorderStyle = bsNone
  BorderWidth = 2
  Caption = 'File Manager'
  ClientHeight = 332
  ClientWidth = 454
  Color = clBlack
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 14
  object PanelMain: TFlatPanel
    Left = 0
    Top = 0
    Width = 454
    Height = 332
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    BorderTop = 0
    BorderLeft = 0
    BorderRight = 0
    BorderBottom = 0
    Color = 13554645
    BorderColor = clBlack
    object MultiPanel: TOMultiPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 366
      Height = 299
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      PanelCollection = <
        item
          Control = PanelVSTFolders
          Position = 0.350000000000000000
          Visible = False
          Index = 0
        end
        item
          Control = PanelVSTFiles
          Position = 1.000000000000000000
          Visible = True
          Index = 1
        end>
      MinPosition = 0.020000000000000000
      SplitterHoverColor = clHighlight
      Align = alClient
      ParentBackground = False
      Color = 13554645
      TabOrder = 0
      DesignSize = (
        366
        299)
      object PanelVSTFolders: TFlatPanel
        Left = 0
        Top = 0
        Width = 128
        Height = 299
        Caption = 'PanelVSTFolders'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Visible = False
        TabOrder = 0
        Anchors = []
        Padding.Left = 2
        Padding.Top = 2
        Padding.Right = 2
        Padding.Bottom = 2
        BorderTop = 2
        BorderLeft = 2
        BorderRight = 2
        BorderBottom = 2
        Color = 13554645
        BorderColor = clBlack
        object VSTFolders: TVirtualStringTree
          Left = 2
          Top = 2
          Width = 124
          Height = 295
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          BackGroundImageTransparent = True
          BorderStyle = bsNone
          Color = clWhite
          Colors.UnfocusedColor = clWindowText
          DefaultNodeHeight = 17
          Header.AutoSizeIndex = 0
          Header.DefaultHeight = 25
          Header.Height = 17
          Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoHeaderClickAutoSort]
          Header.SortColumn = 0
          Images = FormMain.ImageSystem
          PopupMenu = PopupFoldersTree
          StateImages = FormMain.VirtualImageList
          TabOrder = 0
          TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowTreeLines, toShowVertGridLines, toUseBlendedImages, toFullVertGridLines]
          TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect, toSelectNextNodeOnRemoval]
          OnCompareNodes = VSTFoldersCompareNodes
          OnDblClick = VSTFoldersDblClick
          OnFreeNode = VSTFoldersFreeNode
          OnGetText = VSTFoldersGetText
          OnGetImageIndex = VSTFoldersGetImageIndex
          OnGetNodeDataSize = VSTFoldersGetNodeDataSize
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          Columns = <
            item
              Position = 0
              Text = 'Name'
              Width = 124
            end>
        end
      end
      object PanelVSTFiles: TFlatPanel
        Left = 131
        Top = 0
        Width = 235
        Height = 299
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Anchors = []
        Padding.Left = 2
        Padding.Top = 2
        Padding.Right = 2
        Padding.Bottom = 2
        BorderTop = 2
        BorderLeft = 2
        BorderRight = 2
        BorderBottom = 2
        Color = 13554645
        BorderColor = clBlack
        object MultiPanelFiles: TOMultiPanel
          Left = 2
          Top = 2
          Width = 231
          Height = 295
          PanelType = ptVertical
          PanelCollection = <
            item
              Control = VSTFiles
              Position = 0.700000000000000000
              Visible = True
              Index = 0
            end
            item
              Control = VSTBulkActions
              Position = 1.000000000000000000
              Visible = False
              Index = 1
            end>
          MinPosition = 0.020000000000000000
          SplitterHoverColor = clHighlight
          Align = alClient
          TabOrder = 0
          object VSTFiles: TVirtualStringTree
            Left = 0
            Top = 0
            Width = 231
            Height = 206
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BackGroundImageTransparent = True
            BorderStyle = bsNone
            Color = clWhite
            Colors.UnfocusedColor = clWindowText
            DefaultNodeHeight = 17
            Header.AutoSizeIndex = -1
            Header.DefaultHeight = 25
            Header.Height = 17
            Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible, hoHeaderClickAutoSort]
            Header.SortColumn = 0
            Images = FormMain.ImageSystem
            PopupMenu = PopupMenu
            StateImages = FormMain.VirtualImageList
            TabOrder = 0
            TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowTreeLines, toShowVertGridLines, toUseBlendedImages, toFullVertGridLines]
            TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect, toSelectNextNodeOnRemoval]
            OnBeforeCellPaint = VSTFilesBeforeCellPaint
            OnChecked = VSTFilesChecked
            OnCompareNodes = VSTFilesCompareNodes
            OnDblClick = VSTFilesDblClick
            OnFreeNode = VSTFilesFreeNode
            OnGetText = VSTFilesGetText
            OnPaintText = VSTFilesPaintText
            OnGetImageIndex = VSTFilesGetImageIndex
            OnGetNodeDataSize = VSTFilesGetNodeDataSize
            Touch.InteractiveGestures = [igPan, igPressAndTap]
            Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
            Columns = <
              item
                Position = 0
                Text = 'Name'
                Width = 150
              end
              item
                Position = 1
                Text = 'Type'
                Width = 100
              end
              item
                Position = 2
                Text = 'Size'
                Width = 100
              end
              item
                Position = 3
                Text = 'Access Rights'
                Width = 100
              end
              item
                Position = 4
                Text = 'DACL (SSDL)'
                Width = 200
              end
              item
                Position = 5
                Text = 'Creation Date'
                Width = 150
              end
              item
                Position = 6
                Text = 'Last Modified'
                Width = 150
              end
              item
                Position = 7
                Text = 'Last Access'
                Width = 150
              end>
          end
          object VSTBulkActions: TVirtualStringTree
            Left = 0
            Top = 209
            Width = 231
            Height = 86
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BackGroundImageTransparent = True
            BorderStyle = bsNone
            Color = clWhite
            Colors.UnfocusedColor = clWindowText
            DefaultNodeHeight = 17
            Header.AutoSizeIndex = -1
            Header.DefaultHeight = 25
            Header.Height = 17
            Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoHeaderClickAutoSort]
            Images = FormMain.ImageSystem
            PopupMenu = PopupBulkActions
            TabOrder = 1
            TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowTreeLines, toShowVertGridLines, toUseBlendedImages, toFullVertGridLines]
            TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect, toRightClickSelect, toSelectNextNodeOnRemoval]
            Visible = False
            OnFreeNode = VSTBulkActionsFreeNode
            OnGetText = VSTBulkActionsGetText
            OnGetImageIndex = VSTBulkActionsGetImageIndex
            OnGetNodeDataSize = VSTBulkActionsGetNodeDataSize
            Touch.InteractiveGestures = [igPan, igPressAndTap]
            Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
            Columns = <
              item
                Position = 0
                Text = 'File Name'
                Width = 231
              end>
          end
        end
      end
    end
    object PanelPath: TFlatPanel
      AlignWithMargins = True
      Left = 4
      Top = 307
      Width = 446
      Height = 21
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Padding.Left = 1
      Padding.Top = 1
      Padding.Right = 1
      Padding.Bottom = 1
      BorderTop = 2
      BorderLeft = 2
      BorderRight = 2
      BorderBottom = 2
      Color = 13554645
      BorderColor = clBlack
      object EditPath: TFlatEdit
        Left = 1
        Top = 1
        Width = 444
        Height = 19
        Align = alClient
        AutoSize = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        Status = cStatusNormal
        Validators = []
        ShowBorder = True
      end
    end
    object PanelActions: TFlatPanel
      AlignWithMargins = True
      Left = 374
      Top = 4
      Width = 80
      Height = 299
      Margins.Left = 0
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -6
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Padding.Left = 6
      Padding.Top = 6
      Padding.Right = 6
      Padding.Bottom = 6
      BorderTop = 2
      BorderLeft = 2
      BorderRight = 0
      BorderBottom = 2
      Color = 13554645
      BorderColor = clBlack
      object ButtonDrives: TFlatButton
        Left = 6
        Top = 6
        Width = 68
        Height = 22
        Hint = 
          'Show available drives and connected storage devices, including e' +
          'xternal media and removable disks.'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Drives'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Align = alTop
        ShowHint = True
        ImageIndex = 17
        Value = 0
        OnClick = ButtonDrivesClick
        Busy = False
        ExplicitTop = 26
        ExplicitWidth = 69
      end
      object LabelAccess: TLabel
        Left = 6
        Top = 278
        Width = 68
        Height = 15
        Margins.Left = 8
        Margins.Top = 10
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alBottom
        Alignment = taCenter
        Caption = '___'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
        Visible = False
        ExplicitWidth = 21
      end
      object Shape1: TShape
        AlignWithMargins = True
        Left = 6
        Top = 84
        Width = 68
        Height = 1
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alTop
        ExplicitTop = 58
      end
      object ButtonRefresh: TFlatButton
        AlignWithMargins = True
        Left = 6
        Top = 32
        Width = 68
        Height = 22
        Hint = 
          'Refresh the files and folders in the current location to display' +
          ' the latest information.'
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Refresh'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Align = alTop
        ShowHint = True
        ImageIndex = 17
        Value = 0
        OnClick = ButtonRefreshClick
        Busy = False
        ExplicitTop = 26
      end
      object ButtonGoTo: TFlatButton
        AlignWithMargins = True
        Left = 6
        Top = 89
        Width = 68
        Height = 22
        Hint = 
          'Navigate to a specific folder. Supports environment variables in' +
          ' the path.'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Go To...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Align = alTop
        ShowHint = True
        ImageIndex = 17
        Value = 0
        OnClick = ButtonGoToClick
        Busy = False
        ExplicitTop = 160
      end
      object ButtonUpload: TFlatButton
        AlignWithMargins = True
        Left = 6
        Top = 115
        Width = 68
        Height = 22
        Hint = 'Upload a file to the current directory, if permissions allow.'
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Upload'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Align = alTop
        ShowHint = True
        ImageIndex = 17
        Value = 0
        OnClick = ButtonUploadClick
        Busy = False
        ExplicitLeft = 14
        ExplicitTop = 173
      end
      object ButtonOptions: TFlatButton
        AlignWithMargins = True
        Left = 6
        Top = 208
        Width = 68
        Height = 22
        Hint = 'Open the file manager options.'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Align = alTop
        ShowHint = True
        ImageIndex = 17
        Value = 0
        OnClick = ButtonOptionsClick
        Busy = False
        ExplicitTop = 241
      end
      object ButtonNewDirectory: TFlatButton
        AlignWithMargins = True
        Left = 6
        Top = 146
        Width = 68
        Height = 22
        Hint = 'Create a new directory, if permissions allow.'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'New Dir'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Align = alTop
        ShowHint = True
        ImageIndex = 17
        Value = 0
        OnClick = ButtonNewDirectoryClick
        Busy = False
        ExplicitTop = 168
      end
      object Shape2: TShape
        AlignWithMargins = True
        Left = 6
        Top = 203
        Width = 68
        Height = 1
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alTop
        ExplicitTop = 219
      end
      object Shape3: TShape
        AlignWithMargins = True
        Left = 6
        Top = 141
        Width = 68
        Height = 1
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alTop
      end
      object Shape4: TShape
        AlignWithMargins = True
        Left = 6
        Top = 172
        Width = 68
        Height = 1
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alTop
      end
      object ButtonPaste: TFlatButton
        AlignWithMargins = True
        Left = 6
        Top = 177
        Width = 68
        Height = 22
        Hint = 'Paste the clipboard contents into the current directory.'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Paste'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Align = alTop
        ShowHint = True
        ImageIndex = 17
        Value = 0
        OnClick = ButtonPasteClick
        Busy = False
      end
      object PanelDirection: TFlatPanel
        AlignWithMargins = True
        Left = 6
        Top = 58
        Width = 68
        Height = 22
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        BorderTop = 0
        BorderLeft = 0
        BorderRight = 0
        BorderBottom = 0
        Color = 13554645
        BorderColor = clBlack
        object ButtonBack: TFlatButton
          Left = 0
          Top = 0
          Width = 32
          Height = 22
          Hint = 'Go back to the previous folder.'
          Margins.Left = 6
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = '<-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Align = alLeft
          ShowHint = True
          ImageIndex = 16
          Value = 0
          OnClick = ButtonBackClick
          Busy = False
        end
        object ButtonForward: TFlatButton
          Left = 36
          Top = 0
          Width = 32
          Height = 22
          Hint = 'Go forward to the next folder.'
          Margins.Left = 6
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = '->'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Align = alRight
          ShowHint = True
          ImageIndex = 16
          Value = 0
          OnClick = ButtonForwardClick
          Busy = False
          ExplicitLeft = 38
        end
      end
    end
  end
  object PopupMenu: TFlatPopupMenu
    OwnerDraw = True
    OnPopup = PopupMenuPopup
    Left = 208
    Top = 72
    object DownloadFile1: TMenuItem
      Caption = 'Download File'
      OnClick = DownloadFile1Click
    end
    object UploadToFolder1: TMenuItem
      Caption = 'Upload To Selected Folder'
      OnClick = UploadToFolder1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object StreamFileContentOpen1: TMenuItem
      Caption = 'Stream File Content (Open)'
      OnClick = StreamFileContentOpen1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object NewDirectory1: TMenuItem
      Caption = 'New Directory'
      OnClick = NewDirectory1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Cut1: TMenuItem
      Caption = 'Cut'
      OnClick = Cut1Click
    end
    object Copy1: TMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object Paste1: TMenuItem
      Caption = 'Paste'
      OnClick = Paste1Click
    end
    object PasteToSelectedFolder1: TMenuItem
      Caption = 'Paste To Selected Folder'
      OnClick = PasteToSelectedFolder1Click
    end
    object ClearClipboard1: TMenuItem
      Caption = 'Clear Clipboard'
      OnClick = ClearClipboard1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Rename1: TMenuItem
      Caption = 'Rename'
      OnClick = Rename1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
  end
  object PopupMenuOptions: TFlatPopupMenu
    OwnerDraw = True
    Left = 296
    Top = 72
    object ColoredFoldersAccessView1: TMenuItem
      AutoCheck = True
      Caption = 'Colored Folders (Access View)'
      OnClick = ColoredFoldersAccessView1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ShowFolderTree1: TMenuItem
      AutoCheck = True
      Caption = 'Show Folder Tree'
      OnClick = ShowFolderTree1Click
    end
    object EnableBulkActions1: TMenuItem
      AutoCheck = True
      Caption = 'Enable Bulk Actions'
      OnClick = EnableBulkActions1Click
    end
  end
  object PopupFoldersTree: TFlatPopupMenu
    OwnerDraw = True
    Left = 56
    Top = 81
    object FullExpand1: TMenuItem
      Caption = 'Full Expand'
      OnClick = FullExpand1Click
    end
    object FullCollapse1: TMenuItem
      Caption = 'Full Collapse'
      OnClick = FullCollapse1Click
    end
  end
  object PopupBulkActions: TFlatPopupMenu
    OwnerDraw = True
    OnPopup = PopupBulkActionsPopup
    Left = 201
    Top = 230
    object BulkDownload1: TMenuItem
      Caption = 'Bulk Download (All Listed Files)'
      OnClick = BulkDownload1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object BrowsePath1: TMenuItem
      Caption = 'Browse Selected Item Path'
      OnClick = BrowsePath1Click
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object RemoveSelectedItems1: TMenuItem
      Caption = 'Remove Selected Item(s) From List'
      OnClick = RemoveSelectedItems1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Clear1: TMenuItem
      Caption = 'Clear List'
      OnClick = Clear1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
  end
end
