unit ColorDialog;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ListBox, FMX.Colors,
  FMX.StdCtrls;

type
  TfrmColorDialog = class(TForm)
    ColorPanel1: TColorPanel;
    lbColors: TColorListBox;
    Panel1: TPanel;
    Layout1: TLayout;
    edtColorHex: TEdit;
    edtColorName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtRed: TEdit;
    edtGreen: TEdit;
    edtBlue: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure ColorPanel1Change(Sender: TObject);
    procedure ColorListBox1Change(Sender: TObject);
    procedure edtColorNameChangeTracking(Sender: TObject);
    procedure edtColorNameKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure edtRedChangeTracking(Sender: TObject);
    procedure edtAlphaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure edtColorHexExit(Sender: TObject);
  private
    { Private declarations }
    procedure FindNextColorName;
    function GetColor: TAlphaColor;
    procedure SetColor(const Value: TAlphaColor);
    var inUpdate: Boolean;
  public
    { Public declarations }
    property Color: TAlphaColor read GetColor write SetColor;
  end;

var
  frmColorDialog: TfrmColorDialog;

implementation

{$R *.fmx}

procedure TfrmColorDialog.ColorListBox1Change(Sender: TObject);
begin
  if edtColorName.IsFocused then exit;

  if (lbColors.ItemIndex > -1) then
  begin
    edtColorName.Text := lbColors.Items[lbColors.ItemIndex];
    ColorPanel1.Color := lbColors.Color;
  end
  else
    edtColorName.Text := '';
end;

procedure TfrmColorDialog.ColorPanel1Change(Sender: TObject);
begin
  var c: TAlphaColorRec;
  c.Color := ColorPanel1.Color;
  var colorString := Format('%.6x',[ColorPanel1.Color]);
  if colorString.Length > 6 then
    Delete(colorString, 1, 2);
  edtColorHex.Text := colorString;
  if not edtRed.IsFocused then edtRed.Text := c.R.ToHexString;
  if not edtGreen.IsFocused then edtGreen.Text := c.G.ToHexString;
  if not edtBlue.IsFocused then edtBlue.Text := c.B.ToHexString;
  lbColors.Color := ColorPanel1.Color;
  if (lbColors.Color <> ColorPanel1.Color) then
  begin
    lbColors.ItemIndex := -1;
  end;

end;

procedure TfrmColorDialog.edtAlphaKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  KeyChar := UpCase(KeyChar);
end;

procedure TfrmColorDialog.edtColorHexExit(Sender: TObject);
begin
  if length(edtColorHex.Text)>0  then
    ColorPanel1.Color := StrToInt64('$' + edtColorHex.Text.TrimLeft(['#',' ']))
  else
    ColorPanel1.Color := 0;
end;

procedure TfrmColorDialog.edtColorNameChangeTracking(Sender: TObject);
begin
  if (lbColors.ItemIndex = -1) or (edtColorName.Text <> lbColors.Items[lbColors.ItemIndex]) then
    FindNextColorName;
end;

procedure TfrmColorDialog.edtColorNameKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case key of
    vkDown: FindNextColorName;
  end;

end;

procedure TfrmColorDialog.edtRedChangeTracking(Sender: TObject);
begin
  if (edtRed.Text = '') or (edtGreen.Text = '') or
     (edtBlue.Text = '') then
  exit;

  var c: TAlphaColorRec;
  c.R := StrToInt('$'+edtRed.Text);
  c.G := StrToInt('$'+edtGreen.Text);
  c.B := StrToInt('$'+edtBlue.Text);

  ColorPanel1.Color := c.Color;
end;

procedure TfrmColorDialog.FindNextColorName;
begin
  if edtColorName.Text = '' then exit;

  var Offset := lbColors.ItemIndex + 1;
  var max := Pred(lbColors.Items.Count);
  for var i := 0 to max do
  begin
    if i + Offset > max then
      offset := 0 - i;

    if (I + Offset < 0) or (I + Offset > Pred(lbColors.Items.Count)) then
      raise ERangeError.Create('oops');


    if lbColors.Items[I + Offset].Contains(edtColorName.Text) then
    begin
      lbColors.ItemIndex := I + Offset;
      Break;
    end;
  end;
end;

procedure TfrmColorDialog.FormCreate(Sender: TObject);
begin
  inUpdate := False;
  SetColor(TAlphaColorRec.Powderblue);
end;

procedure TfrmColorDialog.FormResize(Sender: TObject);
begin
  if Width < 450 then Width := 450;
  if Height < 250 then Height := 250;
end;

function TfrmColorDialog.GetColor: TAlphaColor;
begin
  Result := ColorPanel1.Color;
end;

procedure TfrmColorDialog.SetColor(const Value: TAlphaColor);
begin
  ColorPanel1.Color := Value;
end;

end.
