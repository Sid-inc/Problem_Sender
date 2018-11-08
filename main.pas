unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ComObj, Vcl.Grids, DateUtils;

type
  TMainForm = class(TForm)
    BtnConf: TButton;
    BtnSend: TButton;
    procedure BtnSendClick(Sender: TObject);
    function FormatingDateTime(s: string): TDateTime;
    procedure BtnConfClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses config;

procedure TMainForm.BtnConfClick(Sender: TObject);
begin
   if (not Assigned(ConfigForm)) then   // �������� ������������� ����� (���� ���, ��
       ConfigForm:=TConfigForm.Create(Self);    // �������� �����)
   ConfigForm.Show;
end;

procedure TMainForm.BtnSendClick(Sender: TObject);
const
  xlCellTypeLastCell = $0000000B;
var
  ExcelApp, ExcelSheet: OLEVariant;
  ChannelsSrc: Variant;
  ChannelsResult: array of array of string;
  x, y: Integer;
  a, i, j, N: Integer;
  s: string;
begin
  N:=1;
  a:=1;
  s:='';
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
  // ���� ����������� ������ � ���� ����� ���������� ������ N ���� ����� � �������������� ������
  SetLength(ChannelsResult,x,3);
  j:=0;
  for i := 2 to x do
    begin
      if ChannelsSrc[i,4] = 'OFF' then
        if DaysBetween(Now, FormatingDateTime(ChannelsSrc[i,6])) >= N then
          begin
            ChannelsResult[j,0]:=ChannelsSrc[i,1];
            if ChannelsSrc[i,3] = 'M' then ChannelsResult[j,1]:='�������� �����';
            if ChannelsSrc[i,3] = 'B' then ChannelsResult[j,1]:='��������� �����';
            ChannelsResult[j,2]:=inttostr(DaysBetween(Now, FormatingDateTime(ChannelsSrc[i,6])));
            j:=j+1;
          end;

    end;


    for a := 0 to j-1 do s:=s+ChannelsResult[a,0]+' | '+ChannelsResult[a,1]+' | '+ChannelsResult[a,2]+sLineBreak;

    ShowMessage(s);


    ChannelsResult:=NIL;
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
