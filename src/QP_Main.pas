unit QP_Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Platform, FMX.Clipboard, System.Rtti, FMX.Grid.Style,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Controls,
  FMX.Layouts, Fmx.Bind.Navigator, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, FMX.ScrollBox, FMX.Grid, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.TabControl,
  FMX.ListView, FMX.Memo.Types, FMX.Colors, FMX.Memo, FMX.Edit, FMX.ListBox,
  FMX.Objects;

type
  TForm9 = class(TForm)
    dbConnection: TFDConnection;
    qryClips: TFDQuery;
    qryClipsidx: TFDAutoIncField;
    qryClipsName: TWideStringField;
    qryClipsBody: TWideMemoField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    qryClipsCategory: TWideStringField;
    itemsList: TListView;
    LinkListControlToField1: TLinkListControlToField;
    tabNav: TTabControl;
    tabMain: TTabItem;
    tabEdit: TTabItem;
    Layout1: TLayout;
    Edit1: TEdit;
    Memo1: TMemo;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    Layout2: TLayout;
    ComboColorBox1: TComboColorBox;
    ComboColorBox2: TComboColorBox;
    qryClipsForeground: TLargeintField;
    qryClipsBackground: TLargeintField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Edit2: TEdit;
    LinkControlToField5: TLinkControlToField;
    SpeedButton3: TSpeedButton;
    qryClipsColorCheat: TWideStringField;
    SpeedButton4: TSpeedButton;
    ckAccumulate: TCheckBox;
    splitAccumulate: TSplitter;
    txtAccumulate: TMemo;
    layAccumulate: TLayout;
    Layout4: TLayout;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Line1: TLine;
    procedure FormCreate(Sender: TObject);
    procedure itemsListItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure SpeedButton1Click(Sender: TObject);
    procedure qryClipsAfterInsert(DataSet: TDataSet);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure itemsListPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure qryClipsCalcFields(DataSet: TDataSet);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ckAccumulateChange(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.fmx}

uses IOUtils;

procedure TForm9.ckAccumulateChange(Sender: TObject);
begin
  layAccumulate.Visible := ckAccumulate.IsChecked;
  splitAccumulate.Visible := ckAccumulate.IsChecked;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
  tabNav.ActiveTab := tabMain;
  if not fileExists(dbConnection.Params.Values['Database']) then
    dbConnection.Params.Values['Database'] := TPath.Combine(
      ExtractFilePath(ParamStr(0)),
      ExtractFileName(dbConnection.Params.Values['Database'])
      );
  qryClips.Open;
end;

procedure TForm9.itemsListItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject is TListItemAccessory then
  begin
    tabNav.ActiveTab := tabEdit;
  end
  else
  begin
    if ckAccumulate.IsChecked then
    begin
      txtAccumulate.Lines.Add(qryClipsBody.Value);
    end
    else
    begin
      var Svc: IFMXClipboardService;
      if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Svc) then
        Svc.SetClipboard(qryClipsBody.Value);
    end;
  end;

end;

procedure TForm9.itemsListPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  for var i := 0 to pred(itemsList.Items.Count) do
  begin
    var itemRect := itemsList.GetItemRect(i);
    if ARect.IntersectsWith(itemRect) then
    begin
      var cheat := itemsList.Items[i].Detail;
      if cheat <> '' then
      begin
        var fgc := cheat.Split([','])[0].ToInt64;
        var bgc := cheat.Split([','])[1].ToInt64;
        Canvas.Fill.Color := bgc;
        itemRect.Right := itemRect.Right - 45;
        Canvas.FillRect(itemRect, 1);
        Canvas.Fill.Color := fgc;
        itemRect.Left := itemRect.Left + 20;
        Canvas.FillText(itemRect, itemsList.Items[i].Text, false, 1,
          [], TTextAlign.Leading);

      end;
    end;
  end;
end;

procedure TForm9.qryClipsAfterInsert(DataSet: TDataSet);
begin
  qryClipsForeground.Value := TAlphaColorRec.Black;
  qryClipsBackground.Value := TAlphaColorRec.White;
  qryClipsCategory.Value := 'Main';
end;

procedure TForm9.qryClipsCalcFields(DataSet: TDataSet);
begin
  qryClipsColorCheat.Value := format('%d,%d',
    [qryClipsForeground.Value, qryClipsBackground.Value]);
end;

procedure TForm9.SpeedButton1Click(Sender: TObject);
begin
  qryClips.Insert;
  tabNav.ActiveTab := tabEdit;
end;

procedure TForm9.SpeedButton2Click(Sender: TObject);
begin
  qryClips.Post;
  tabNav.ActiveTab := tabMain;
end;

procedure TForm9.SpeedButton3Click(Sender: TObject);
begin
  qryClips.Cancel;
  tabNav.ActiveTab := tabMain;
end;

procedure TForm9.SpeedButton4Click(Sender: TObject);
begin
  if MessageDlg('Delete this record?',TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
  begin
    qryClips.Delete;
    tabNav.ActiveTab := tabMain;
  end;

end;

procedure TForm9.SpeedButton5Click(Sender: TObject);
begin
  txtAccumulate.Lines.Clear;
end;

procedure TForm9.SpeedButton6Click(Sender: TObject);
begin
  var Svc: IFMXClipboardService;
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Svc) then
    Svc.SetClipboard(txtAccumulate.Lines.Text);

end;

end.
