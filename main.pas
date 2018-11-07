unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ComObj, Vcl.Grids, DateUtils;

type
  TMainForm = class(TForm)
    BtnConf: TButton;
    BtnSend: TButton;
    StringGridChannels: TStringGrid;
    procedure BtnSendClick(Sender: TObject);
    function FormatingDateTime(s: string): TDateTime;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.BtnSendClick(Sender: TObject);
const
  xlCellTypeLastCell = $0000000B;
var
  ExcelApp, ExcelSheet: OLEVariant;
  ChannelsSrc: Variant;
  x, y: Integer;
  d: TDateTime;
begin
  // �������� OLE-������� Excel
  ExcelApp := CreateOleObject('Excel.Application');

  // �������� ����� Excel
  ExcelApp.Workbooks.Open('E:\Develop\Delphi\onlineoo_export_OMG_smolensk-3.XLS');

  // �������� ����� �����
  ExcelSheet := ExcelApp.Workbooks[1].WorkSheets[1];

  // ��������� ��������� ��������������� ������ �� �����
  ExcelSheet.Cells.SpecialCells(xlCellTypeLastCell).Activate;

  // ��������� �������� ������� ���������� ���������
  x := ExcelApp.ActiveCell.Row;
  y := ExcelApp.ActiveCell.Column;

  // ���������� ������� ��������� ����� �� �����
  ChannelsSrc := ExcelApp.Range['A1', ExcelApp.Cells.Item[X, Y]].Value;

  // �������� ����� � ������� ����������
  ExcelApp.Quit;
  ExcelApp := Unassigned;
  ExcelSheet := Unassigned;

  // ���������� ������� StringGrid �� ������� ����������� ��������� �����
  StringGridChannels.RowCount := x;
  StringGridChannels.ColCount := y;

  // ���������� ������� StringGrid ���������� �������
  for x := 1 to StringGridChannels.ColCount do
    for y := 1 to StringGridChannels.RowCount do
      StringGridChannels.Cells[x-1, y-1] := ChannelsSrc[y, x];

  ShowMessage(intToStr(DaysBetween(Now, FormatingDateTime(StringGridChannels.Cells[5,3]))));


end;


function TMainForm.FormatingDateTime(s: string): TDateTime;
var s2: string;
x: integer;
begin
  s2:='';
  s2:=s2+s[9];
  s2:=s2+s[10];
  s2:=s2+'.';
  s2:=s2+s[6];
  s2:=s2+s[7];
  s2:=s2+'.';
  s2:=s2+s[1];
  s2:=s2+s[2];
  s2:=s2+s[3];
  s2:=s2+s[4];
  s2:=s2+' ';
  for x := 12 to 19 do s2:=s2+s[x];
  result:=StrToDateTime(s2);
end;


end.
