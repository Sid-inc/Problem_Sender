unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ComObj, Vcl.Grids, DateUtils, inifiles,
  IdAntiFreezeBase, Vcl.IdAntiFreeze, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdMessage, IdIOHandler, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdCustomTransparentProxy, IdSocks,
  IdHTTP, idAttachment, IdAttachmentFile, IdIOHandlerSocket;

type
  TMainForm = class(TForm)
    BtnConf: TButton;
    BtnSend: TButton;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdHTTP1: TIdHTTP;
    procedure BtnSendClick(Sender: TObject);
    function FormatingDateTime(s: string): TDateTime;
    procedure BtnConfClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function Send_Email(Theme, Recipient, Email_Message: string): Boolean;
    function Check_Filial(s: string): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function Cryptor(s, c: string):string;

var
  MainForm: TMainForm;
  // ������ + �����
  ChanelsEnabled: string; // ��������\��������� ��������� ����� �������
  ChanelsFile: string; // ��� ����� �������� �������
  Mail_server: string; // ��� ��������� �������
  Mail_port: string; // ���� ��������� �������
  User_name: string; // ��� ������������
  Password: string; // ������
  Theme: string; // ���� ������
  Senders_address: string; // ����� �����������
  Senders_name: string; // ��� �����������
  Recipient_address: string; // ����� ����������
  ChanelsDays: string; // ���������� ���� ��������� �����������

  //Skynet
  SkynetEnabled: string;
  SkynetFile: string;
  SkynetTheme: string;
  SkynetRecipient: string;
  SkynetFilials: array of string;
  FilialsCount: integer;

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
  ChannelsSrc, SkynetSrc: Variant;
  ChannelsResult, SkynetResult, Repeated: array of array of string;
  a, i, j, x, y, sr1, sr2, repeat_count: Integer;
  tmparr: array [1..3] of string;
  s, mp, mp0, mp1, mp2, mp3, mp4, mp5, mp6, mp7, mp8, check_msg: String;
  mp0_flag, mp1_flag, mp2_flag, mp3_flag, mp4_flag, mp5_flag, mp6_flag, mp7_flag, mp8_flag, repeat_flag1, repeat_flag2 :boolean;
begin
  mp0_flag:=false;
  mp1_flag:=false;
  mp2_flag:=false;
  mp3_flag:=false;
  mp4_flag:=false;
  mp5_flag:=false;
  mp6_flag:=false;
  mp7_flag:=false;
  mp8_flag:=false;
  repeat_flag1:=false;
  repeat_flag2:=false;
  mp:='';
  repeat_count:=0;
  check_msg:='������ �� ����������';

  if FileExists('config.ini') = false then
    begin
      ShowMessage('�� ������ ���� ������������. ����� ���������.');
      exit;
    end;
  if Mail_server='' then
    begin
      ShowMessage('�� ����� �������� ������.');
      exit;
    end;

  if Mail_port='' then
    begin
      ShowMessage('�� ����� ���� ��������� �������.');
      exit;
    end;

  if User_name='' then
    begin
      ShowMessage('�� ������ ��� ������������.');
      exit;
    end;

  if Password='' then
    begin
      ShowMessage('�� ����� ������.');
      exit;
    end;

  if Senders_address='' then
    begin
      ShowMessage('�� ����� ����� �����������.');
      exit;
    end;

  if Senders_name='' then
    begin
      ShowMessage('�� ������ ��� �����������.');
      exit;
    end;


if ChanelsEnabled = 'true' then
begin
  if ((ChanelsFile='') or (FileExists(ChanelsFile) = false)) then
    begin
      ShowMessage('�� ����� ���� � ����� ���� ���� �����������.');
      exit;
    end;

  if Theme='' then
    begin
      ShowMessage('�� ������ ���� ������ � ������� �����.');
      exit;
    end;

  if Recipient_address='' then
    begin
      ShowMessage('�� ����� ����� ���������� ��� ������ � ������� �����.');
      exit;
    end;

  if ChanelsDays='' then
    begin
      ShowMessage('�� ������ ���������� ���� ��� ��������� � �����.');
      exit;
    end;

  // �������� OLE-������� Excel
  ExcelApp := CreateOleObject('Excel.Application');

  // �������� ����� Excel
  ExcelApp.Workbooks.Open(ChanelsFile);

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
        if DaysBetween(Now, FormatingDateTime(ChannelsSrc[i,6])) >= strtoint(ChanelsDays) then
          begin
            ChannelsResult[j,0]:=ChannelsSrc[i,1];
            if ChannelsSrc[i,3] = 'M' then ChannelsResult[j,1]:='�������� �����';
            if ChannelsSrc[i,3] = 'B' then ChannelsResult[j,1]:='��������� �����';
            ChannelsResult[j,2]:=inttostr(DaysBetween(Now, FormatingDateTime(ChannelsSrc[i,6])));
            j:=j+1;
          end;

    end;
   if j<>0 then
    begin
      // ���������� ������� �� �������� �� ���������� ���� �� � ����
      if j>0 then
       for sr1 := 0 to j do
        for sr2 := 0 to j-sr1 do
          if ChannelsResult[sr2,2] < ChannelsResult[sr2+1, 2] then
            begin
              tmparr[1]:=ChannelsResult[sr2,0];
              tmparr[2]:=ChannelsResult[sr2,1];
              tmparr[3]:=ChannelsResult[sr2,2];
              ChannelsResult[sr2,0]:=ChannelsResult[sr2+1,0];
              ChannelsResult[sr2,1]:=ChannelsResult[sr2+1,1];
              ChannelsResult[sr2,2]:=ChannelsResult[sr2+1,2];
              ChannelsResult[sr2+1, 0]:=tmparr[1];
              ChannelsResult[sr2+1, 1]:=tmparr[2];
              ChannelsResult[sr2+1, 2]:=tmparr[3];
            end;
      // �������� ������
      // ��������� ������
      s:='<style>'+sLineBreak;
      s:=s+'.alert-table {background-color: #fff; color: black; display: flex; justify-content: left;}'+sLineBreak;
      s:=s+'table {font-family: arial, sans-serif;}'+sLineBreak;
      s:=s+'td, th {border: 1px solid black; text-align: left; padding: 8px;}'+sLineBreak;
      s:=s+'th {width: 30%;}'+sLineBreak;
      s:=s+'th:nth-child(1), th:nth-child(2) {background-color: bisque;}'+sLineBreak;
      s:=s+'th:nth-child(3) {background-color: tomato; color: white;}'+sLineBreak;
      s:=s+'tr td:nth-child(3) {background-color: lightgrey; color: white;}'+sLineBreak;
      s:=s+'tr:hover td {background-color: darkgrey;}'+sLineBreak;
      s:=s+'</style>'+sLineBreak;
      s:=s+'<div class="alert-table"><table><tr><th><b>�������� ��</b></th><th><b>��� ������</b></th><th><b>���������� ���� �� � ����</b></th></tr>';
      for a := 0 to j-1 do
        begin
          s:=s+'<tr>';
          s:=s+'<td>'+ChannelsResult[a,0]+'</td><td>'+ChannelsResult[a,1]+'</td><td>'+ChannelsResult[a,2]+'</td>';
          s:=s+'</tr>'+sLineBreak;
        end;
      s:=s+'</table></div>';
      ChannelsResult:=NIL;
      if (Send_Email(Theme, Recipient_address, s)) then check_msg:='������ �� ������� - ��'+sLineBreak
        else check_msg:='������ �� ������� - ERROR'+sLineBreak;

    end
    else ShowMessage('���������� ������, ��� ������� ��� ������� ������� ������');
end;
    // Skynet
if SkynetEnabled = 'true' then
    begin
      if ((SkynetFile='') or (FileExists(SkynetFile) = false)) then
      begin
        ShowMessage('�� ����� ���� � ����� Skynet ���� ���� �����������.');
        exit;
      end;

      if SkynetTheme='' then
      begin
        ShowMessage('�� ������ ���� ������ Skynet.');
        exit;
      end;

      if SkynetRecipient='' then
      begin
        ShowMessage('�� ����� ����� ���������� ��� ������ � Skynet.');
        exit;
      end;

      if FilialsCount=0 then
      begin
        ShowMessage('�� ������ ������� ��� �������� Skynet.');
        exit;
      end;
  // �������� OLE-������� Excel
    ExcelApp := CreateOleObject('Excel.Application');

    // �������� ����� Excel
    ExcelApp.Workbooks.Open(SkynetFile);

    // �������� ����� �����
    ExcelSheet := ExcelApp.Workbooks[1].WorkSheets[1];

    // ��������� ��������� ��������������� ������ �� �����
    ExcelSheet.Cells.SpecialCells(xlCellTypeLastCell).Activate;

    // ��������� �������� ������� ���������� ���������
    x := ExcelApp.ActiveCell.Row;
    y := ExcelApp.ActiveCell.Column;

    // ���������� ������� ��������� ����� �� �����
    SkynetSrc := ExcelApp.Range['A2', ExcelApp.Cells.Item[X, Y]].Value;

    // �������� ����� � ������� ����������
    ExcelApp.Quit;
    ExcelApp := Unassigned;
    ExcelSheet := Unassigned;
    SetLength(SkynetResult,x,17);//������������� ���������� ��������
    sr2:=0;
    for sr1 := 1 to x-1 do // ��������� �� ������ ������ �� ������ ������� ����� ������������ � ����������
     if (Check_Filial(SkynetSrc[sr1,5])) and ((SkynetSrc[sr1,3]='�����')or(SkynetSrc[sr1,3]='������')) then
       begin
        SkynetResult[sr2,0]:=SkynetSrc[sr1,6];
        SkynetResult[sr2,1]:=SkynetSrc[sr1,5];
        SkynetResult[sr2,2]:=SkynetSrc[sr1,4];
        SkynetResult[sr2,3]:=SkynetSrc[sr1,1];
        SkynetResult[sr2,4]:=SkynetSrc[sr1,2];
        SkynetResult[sr2,5]:=SkynetSrc[sr1,3];
        SkynetResult[sr2,6]:=SkynetSrc[sr1,7];
        SkynetResult[sr2,7]:=SkynetSrc[sr1,8];
        SkynetResult[sr2,8]:=SkynetSrc[sr1,9];
        SkynetResult[sr2,9]:=SkynetSrc[sr1,10];
        SkynetResult[sr2,10]:=SkynetSrc[sr1,11];
        SkynetResult[sr2,11]:=SkynetSrc[sr1,13];
        SkynetResult[sr2,12]:=SkynetSrc[sr1,12];
        SkynetResult[sr2,13]:=SkynetSrc[sr1,14];
        SkynetResult[sr2,14]:=SkynetSrc[sr1,15];
        SkynetResult[sr2,15]:=SkynetSrc[sr1,16];
        SkynetResult[sr2,16]:=SkynetSrc[sr1,17];
        sr2:=sr2+1;
       end;

    // ��������� ������ Skynet
    //������������ ��������
    mp0:='<style>';
    mp0:=mp0+'tr:hover td {background-color: darkgrey;} </style>';
    mp0:=mp0+'<p style="font-family: arial, sans-serif"><b>���� �������� ��� ������, � ������ "�����"</b></p>'+sLineBreak+'<p style="font-family: arial, sans-serif">����� �������� ������ ��� ���� ��������<p>'+sLineBreak;
    mp0:=mp0+'<table style="font-family: arial, sans-serif; background-color: #fff; color: black; display: flex; justify-content: left">'+sLineBreak;
    mp0:=mp0+'<tr><th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp0:=mp0+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��� ��</b></th>'+sLineBreak;
    mp0:=mp0+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���</b></th>'+sLineBreak;
    mp0:=mp0+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��������</b></th>'+sLineBreak;
    mp0:=mp0+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 10%; background-color: tomato; color: white"><b>������</b></th>'+sLineBreak;
    mp0:=mp0+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���� ��������</b></th></tr>'+sLineBreak;

    for sr1 := 0 to x-1 do
     if SkynetResult[sr1,6] <> '' then
      if (FormatingDateTime(SkynetResult[sr1,6]) <= Now) and (SkynetResult[sr1,5] = '�����') then
        begin
          mp0:=mp0+'<tr><td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,1]+'</td>'+sLineBreak; // �������� �������
          mp0:=mp0+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,2]+'</td>'+sLineBreak; // ��� ��
          mp0:=mp0+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,3]+'</td>'+sLineBreak; // ���
          mp0:=mp0+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,4]+'</td>'+sLineBreak; // ��������
          mp0:=mp0+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,5]+'</td>'+sLineBreak; // ������
          mp0:=mp0+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,6]+'</td></tr>'+sLineBreak; // ���� ��������
          mp0_flag:=true;
        end;
    mp0:=mp0+'</table>';

    // �������� ��������
    mp1:='<style>';
    mp1:=mp1+'tr:hover td {background-color: darkgrey;} </style>';
    mp1:=mp1+'<p style="font-family: arial, sans-serif"><b>�������� ��������</b></p>'+sLineBreak+'<p style="font-family: arial, sans-serif">����� ������������ �������� ������ ��� ���� ��������<p>'+sLineBreak;
    mp1:=mp1+'<table style="font-family: arial, sans-serif; background-color: #fff; color: black; display: flex; justify-content: left">'+sLineBreak;
    mp1:=mp1+'<tr><th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp1:=mp1+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��� ��</b></th>'+sLineBreak;
    mp1:=mp1+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���</b></th>'+sLineBreak;
    mp1:=mp1+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��������</b></th>'+sLineBreak;
    mp1:=mp1+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 10%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp1:=mp1+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���� ��������</b></th></tr>'+sLineBreak;

    for sr1 := 0 to x-1 do
     if SkynetResult[sr1,6] <> '' then
      if (FormatingDateTime(SkynetResult[sr1,6]) > Now) and (FormatingDateTime(SkynetResult[sr1,6]) <= Now+7) and (SkynetResult[sr1,5] = '�����') then // ���� ���� �������� ������ ������� � ������ �������+7 ���� � ������ "�����"
        begin
          mp1:=mp1+'<tr><td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,1]+'</td>'+sLineBreak; // �������� �������
          mp1:=mp1+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,2]+'</td>'+sLineBreak; // ��� ��
          mp1:=mp1+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,3]+'</td>'+sLineBreak; // ���
          mp1:=mp1+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,4]+'</td>'+sLineBreak; // ��������
          mp1:=mp1+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,5]+'</td>'+sLineBreak; // ������
          mp1:=mp1+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,6]+'</td></tr>'+sLineBreak; // ���� ��������
          mp1_flag:=true;
        end;
    mp1:=mp1+'</table>';

    // �� �������� Email
    mp2:='<style>';
    mp2:=mp2+'tr:hover td {background-color: darkgrey;} </style>';
    mp2:=mp2+'<p style="font-family: arial, sans-serif"><b>�� �������� Email</b></p>'+sLineBreak;
    mp2:=mp2+'<table style="font-family: arial, sans-serif; background-color: #fff; color: black; display: flex; justify-content: left">'+sLineBreak;
    mp2:=mp2+'<tr><th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp2:=mp2+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��� ��</b></th>'+sLineBreak;
    mp2:=mp2+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���</b></th>'+sLineBreak;
    mp2:=mp2+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��������</b></th>'+sLineBreak;
    mp2:=mp2+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 10%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp2:=mp2+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: tomato; color: white"><b>Email</b></th></tr>'+sLineBreak;

    for sr1 := 0 to x-1 do
     if SkynetResult[sr1,6] <> '' then
      if (SkynetResult[sr1,8] = '') and (SkynetResult[sr1,5] = '������') then
        begin
          mp2:=mp2+'<tr><td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,1]+'</td>'+sLineBreak; // �������� �������
          mp2:=mp2+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,2]+'</td>'+sLineBreak; // ��� ��
          mp2:=mp2+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,3]+'</td>'+sLineBreak; // ���
          mp2:=mp2+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,4]+'</td>'+sLineBreak; // ��������
          mp2:=mp2+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,5]+'</td>'+sLineBreak; // ������
          mp2:=mp2+'<td style="border: 1px black solid; text-align: left; color: white">'+SkynetResult[sr1,8]+'_</td></tr>'+sLineBreak; // Email
          mp2_flag:=true;
        end;
    mp2:=mp2+'</table>';

    // �� �������� ����� �������� ��
    mp3:='<style>';
    mp3:=mp3+'tr:hover td {background-color: darkgrey;} </style>';
    mp3:=mp3+'<p style="font-family: arial, sans-serif"><b>�� �������� ����� �������� ��</b></p>'+sLineBreak;
    mp3:=mp3+'<table style="font-family: arial, sans-serif; background-color: #fff; color: black; display: flex; justify-content: left">'+sLineBreak;
    mp3:=mp3+'<tr><th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp3:=mp3+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��� ��</b></th>'+sLineBreak;
    mp3:=mp3+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���</b></th>'+sLineBreak;
    mp3:=mp3+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��������</b></th>'+sLineBreak;
    mp3:=mp3+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 10%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp3:=mp3+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: tomato; color: white"><b>����� �������� ��</b></th></tr>'+sLineBreak;

    for sr1 := 0 to x-1 do
     if SkynetResult[sr1,6] <> '' then
      if (SkynetResult[sr1,9] = '') and (SkynetResult[sr1,5] = '������') then
        begin
          mp3:=mp3+'<tr><td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,1]+'</td>'+sLineBreak; // �������� �������
          mp3:=mp3+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,2]+'</td>'+sLineBreak; // ��� ��
          mp3:=mp3+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,3]+'</td>'+sLineBreak; // ���
          mp3:=mp3+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,4]+'</td>'+sLineBreak; // ��������
          mp3:=mp3+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,5]+'</td>'+sLineBreak; // ������
          mp3:=mp3+'<td style="border: 1px black solid; text-align: left; color: white">'+SkynetResult[sr1,9]+'_</td></tr>'+sLineBreak; // ����� �������� ��
          mp3_flag:=true;
        end;
    mp3:=mp3+'</table>';

    // ������������� ������ �������� ��
    SetLength(Repeated,x,6);  // ��������� � ����
    for sr1 := 0 to x-1 do
      begin
        if SkynetResult[sr1,5] = '������' then
          begin
            repeat_flag1:=false;
            for sr2 := 0 to x-1 do
                if SkynetResult[sr1,9] = Repeated[sr2, 5] then repeat_flag1:=true;
            if repeat_flag1 = false then
              begin
                repeat_flag2:=false;
                for sr2 := sr1 to x-2 do
                  if SkynetResult[sr1,9] = SkynetResult[sr2+1,9] then
                    begin
                      repeat_flag2:=true;
                      Repeated[repeat_count,0]:=SkynetResult[sr2+1,1];
                      Repeated[repeat_count,1]:=SkynetResult[sr2+1,2];
                      Repeated[repeat_count,2]:=SkynetResult[sr2+1,3];
                      Repeated[repeat_count,3]:=SkynetResult[sr2+1,4];
                      Repeated[repeat_count,4]:=SkynetResult[sr2+1,5];
                      Repeated[repeat_count,5]:=SkynetResult[sr2+1,9];
                      repeat_count:=repeat_count+1;
                    end;
                if repeat_flag2 then
                  begin
                      Repeated[repeat_count,0]:=SkynetResult[sr1,1];
                      Repeated[repeat_count,1]:=SkynetResult[sr1,2];
                      Repeated[repeat_count,2]:=SkynetResult[sr1,3];
                      Repeated[repeat_count,3]:=SkynetResult[sr1,4];
                      Repeated[repeat_count,4]:=SkynetResult[sr1,5];
                      Repeated[repeat_count,5]:=SkynetResult[sr1,9];
                      repeat_count:=repeat_count+1;
                  end;
              end;
          end;
      end;
    mp4:='<style>';
    mp4:=mp4+'tr:hover td {background-color: darkgrey;} </style>';
    mp4:=mp4+'<p style="font-family: arial, sans-serif"><b>������������� ������ ��������� ��</b></p>'+sLineBreak;
    mp4:=mp4+'<table style="font-family: arial, sans-serif; background-color: #fff; color: black; display: flex; justify-content: left">'+sLineBreak;
    mp4:=mp4+'<tr><th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp4:=mp4+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��� ��</b></th>'+sLineBreak;
    mp4:=mp4+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���</b></th>'+sLineBreak;
    mp4:=mp4+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��������</b></th>'+sLineBreak;
    mp4:=mp4+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 10%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp4:=mp4+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: tomato; color: white"><b>����� �������� ��</b></th></tr>'+sLineBreak;

    for sr1 := 0 to repeat_count-1 do
      begin
        mp4:=mp4+'<tr><td style="border: 1px black solid; text-align: left">'+Repeated[sr1,0]+'</td>'+sLineBreak; // �������� �������
        mp4:=mp4+'<td style="border: 1px black solid; text-align: left">'+Repeated[sr1,1]+'</td>'+sLineBreak; // ��� ��
        mp4:=mp4+'<td style="border: 1px black solid; text-align: left">'+Repeated[sr1,2]+'</td>'+sLineBreak; // ���
        mp4:=mp4+'<td style="border: 1px black solid; text-align: left">'+Repeated[sr1,3]+'</td>'+sLineBreak; // ��������
        mp4:=mp4+'<td style="border: 1px black solid; text-align: left">'+Repeated[sr1,4]+'</td>'+sLineBreak; // ������
        mp4:=mp4+'<td style="border: 1px black solid; text-align: left">'+Repeated[sr1,5]+'</td></tr>'+sLineBreak; // ����� �������� ��
        mp4_flag:=true;
      end;
    mp4:=mp4+'</table>';
//    ShowMessage(mp4);

    // �� ��������� ���������� �� ��
    mp5:='<style>';
    mp5:=mp5+'tr:hover td {background-color: darkgrey;} </style>';
    mp5:=mp5+'<p style="font-family: arial, sans-serif"><b>�� ��������� ���������� �� ��</b></p>'+sLineBreak;
    mp5:=mp5+'<table style="font-family: arial, sans-serif; background-color: #fff; color: black; display: flex; justify-content: left">'+sLineBreak;
    mp5:=mp5+'<tr><th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp5:=mp5+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��� ��</b></th>'+sLineBreak;
    mp5:=mp5+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���</b></th>'+sLineBreak;
    mp5:=mp5+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��������</b></th>'+sLineBreak;
    mp5:=mp5+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 10%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp5:=mp5+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: tomato; color: white"><b>���������� �� ��</b></th></tr>'+sLineBreak;

    for sr1 := 0 to x-1 do
     if SkynetResult[sr1,6] <> '' then
      if (SkynetResult[sr1,10] = '') and (SkynetResult[sr1,5] = '������') then
        begin
          mp5:=mp5+'<tr><td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,1]+'</td>'+sLineBreak; // �������� �������
          mp5:=mp5+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,2]+'</td>'+sLineBreak; // ��� ��
          mp5:=mp5+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,3]+'</td>'+sLineBreak; // ���
          mp5:=mp5+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,4]+'</td>'+sLineBreak; // ��������
          mp5:=mp5+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,5]+'</td>'+sLineBreak; // ������
          mp5:=mp5+'<td style="border: 1px black solid; text-align: left; color: white">'+SkynetResult[sr1,10]+'_</td></tr>'+sLineBreak; // ���������� �� ��
          mp5_flag:=true;
        end;
    mp5:=mp5+'</table>';

    // �� �������� ��
    mp6:='<style>';
    mp6:=mp6+'tr:hover td {background-color: darkgrey;} </style>';
    mp6:=mp6+'<p style="font-family: arial, sans-serif"><b>�� �������� ����� ���������</b></p>'+sLineBreak;
    mp6:=mp6+'<table style="font-family: arial, sans-serif; background-color: #fff; color: black; display: flex; justify-content: left">'+sLineBreak;
    mp6:=mp6+'<tr><th style="border: 1px solid black; text-align: left; padding: 8px; width: 14%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp6:=mp6+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 14%; background-color: bisque"><b>��� ��</b></th>'+sLineBreak;
    mp6:=mp6+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 14%; background-color: bisque"><b>���</b></th>'+sLineBreak;
    mp6:=mp6+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 14%; background-color: bisque"><b>��������</b></th>'+sLineBreak;
    mp6:=mp6+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 10%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp6:=mp6+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 14%; background-color: tomato; color: white"><b>��� ��</b></th>'+sLineBreak;
    mp6:=mp6+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 14%; background-color: tomato; color: white"><b>�������� ��</b></th></tr>'+sLineBreak;

    for sr1 := 0 to x-1 do
     if SkynetResult[sr1,6] <> '' then
      if (SkynetResult[sr1,12] = '') and (SkynetResult[sr1,5] = '������') then
        begin
          mp6:=mp6+'<tr><td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,1]+'</td>'+sLineBreak; // �������� �������
          mp6:=mp6+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,2]+'</td>'+sLineBreak; // ��� ��
          mp6:=mp6+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,3]+'</td>'+sLineBreak; // ���
          mp6:=mp6+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,4]+'</td>'+sLineBreak; // ��������
          mp6:=mp6+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,5]+'</td>'+sLineBreak; // ������
          mp6:=mp6+'<td style="border: 1px black solid; text-align: left; color: white">'+SkynetResult[sr1,11]+'_</td>'+sLineBreak; // ��� ��
          mp6:=mp6+'<td style="border: 1px black solid; text-align: left; color: white">'+SkynetResult[sr1,12]+'_</td></tr>'+sLineBreak; // �������� ��
          mp6_flag:=true;
        end;
    mp6:=mp6+'</table>';

    // �� ��������� ��� ��������������
    mp7:='<style>';
    mp7:=mp7+'tr:hover td {background-color: darkgrey;} </style>';
    mp7:=mp7+'<p style="font-family: arial, sans-serif"><b>�� ��������� ��� ��������������</b></p>'+sLineBreak;
    mp7:=mp7+'<table style="font-family: arial, sans-serif; background-color: #fff; color: black; display: flex; justify-content: left">'+sLineBreak;
    mp7:=mp7+'<tr><th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp7:=mp7+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��� ��</b></th>'+sLineBreak;
    mp7:=mp7+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���</b></th>'+sLineBreak;
    mp7:=mp7+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��������</b></th>'+sLineBreak;
    mp7:=mp7+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 10%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp7:=mp7+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: tomato; color: white"><b>��� ��������������</b></th></tr>'+sLineBreak;

    for sr1 := 0 to x-1 do
     if SkynetResult[sr1,6] <> '' then
      if (SkynetResult[sr1,13] = '') and (SkynetResult[sr1,5] = '������') then
        begin
          mp7:=mp7+'<tr><td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,1]+'</td>'+sLineBreak; // �������� �������
          mp7:=mp7+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,2]+'</td>'+sLineBreak; // ��� ��
          mp7:=mp7+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,3]+'</td>'+sLineBreak; // ���
          mp7:=mp7+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,4]+'</td>'+sLineBreak; // ��������
          mp7:=mp7+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,5]+'</td>'+sLineBreak; // ������
          mp7:=mp7+'<td style="border: 1px black solid; text-align: left; color: white">'+SkynetResult[sr1,13]+'_</td></tr>'+sLineBreak; // ��� ��������������
          mp7_flag:=true;
        end;
    mp7:=mp7+'</table>';

    // �� �������� ����� �������� ��������������
    mp8:='<style>';
    mp8:=mp8+'tr:hover td {background-color: darkgrey;} </style>';
    mp8:=mp8+'<p style="font-family: arial, sans-serif"><b>�� �������� ����� �������� ��������������</b></p>'+sLineBreak;
    mp8:=mp8+'<table style="font-family: arial, sans-serif; background-color: #fff; color: black; display: flex; justify-content: left">'+sLineBreak;
    mp8:=mp8+'<tr><th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp8:=mp8+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��� ��</b></th>'+sLineBreak;
    mp8:=mp8+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>���</b></th>'+sLineBreak;
    mp8:=mp8+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: bisque"><b>��������</b></th>'+sLineBreak;
    mp8:=mp8+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 10%; background-color: bisque"><b>������</b></th>'+sLineBreak;
    mp8:=mp8+'<th style="border: 1px solid black; text-align: left; padding: 8px; width: 16%; background-color: tomato; color: white"><b>����� �������� ��������������</b></th></tr>'+sLineBreak;

    for sr1 := 0 to x-1 do
     if SkynetResult[sr1,6] <> '' then
      if (SkynetResult[sr1,14] = '') and (SkynetResult[sr1,5] = '������') then
        begin
          mp8:=mp8+'<tr><td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,1]+'</td>'+sLineBreak; // �������� �������
          mp8:=mp8+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,2]+'</td>'+sLineBreak; // ��� ��
          mp8:=mp8+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,3]+'</td>'+sLineBreak; // ���
          mp8:=mp8+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,4]+'</td>'+sLineBreak; // ��������
          mp8:=mp8+'<td style="border: 1px black solid; text-align: left">'+SkynetResult[sr1,5]+'</td>'+sLineBreak; // ������
          mp8:=mp8+'<td style="border: 1px black solid; text-align: left; color: white">'+SkynetResult[sr1,14]+'_</td></tr>'+sLineBreak; // ����� �������� ��������������
          mp8_flag:=true;
        end;
    mp8:=mp8+'</table>';


    // �������� � ���� ������ ��� ���������� ���������
    if mp0_flag then mp:=mp+mp0;
    if mp1_flag then mp:=mp+mp1;
    if mp2_flag then mp:=mp+mp2;
    if mp3_flag then mp:=mp+mp3;
    if mp4_flag then mp:=mp+mp4;
    if mp5_flag then mp:=mp+mp5;
    if mp6_flag then mp:=mp+mp6;
    if mp7_flag then mp:=mp+mp7;
    if mp8_flag then mp:=mp+mp8;

    if mp <> '' then
      if (Send_Email(SkynetTheme, SkynetRecipient, mp)) then check_msg:=check_msg+'������ �� �������� - ��'
        else check_msg:=check_msg+'������ �� �������� - ERROR';
    end;
 ShowMessage(check_msg);
end;


function TMainForm.Check_Filial(s: string): Boolean;
var x, c: integer;
begin
  c:=0;
  for x := 0 to FilialsCount-1 do
    begin
       if s = SkynetFilials[x] then c:=1;
       if s = SkynetFilials[x]+' ��' then c:=1;
       if s = SkynetFilials[x]+' ��' then c:=1;
       if s = SkynetFilials[x]+' ��' then c:=1;
    end;
  if c = 1 then result:=true
    else result:=false;
end;

function Cryptor(s, c: string): string;
var
  I, AddKey, StartKey: Integer;
begin
StartKey := 744;
AddKey := 5;
Result := '';
//����������
if c = 'crypt' then
  for I := 1 to Length(s) do
    begin
      if AddKey > 9 then AddKey:=5;
      Result := Result + CHAR(Byte(s[I]) xor (StartKey shr AddKey));
      AddKey:=AddKey+1;
    end;
// ������������
if c = 'decrypt' then
  for I := 1 to Length(s) do
    begin
      if AddKey > 9 then AddKey:=5;
      Result := Result + CHAR(Byte(s[I]) xor (StartKey shr AddKey));
      AddKey:=AddKey+1;
    end;
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


procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: Tinifile;
  i: integer;
begin
  ChanelsFile := '';
  if FileExists('config.ini') then
    begin
      Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini');
      // ������ � �����
      if ini.ReadString('Chanels','Enabled','') = 'true' then
          ChanelsEnabled:='true'
        else
          ChanelsEnabled:='false';
      ChanelsFile:=Ini.ReadString('Chanels','File_name','');
      Theme:=Ini.ReadString('Chanels','Theme','');
      Recipient_address:=Ini.ReadString('Chanels','RecipientAddress','');
      ChanelsDays:=Ini.ReadString('Chanels','ChanelsDays','');
      Mail_server:=Ini.ReadString('Mail','ServerAddress','');
      Mail_port:=Ini.ReadString('Mail','ServerPort','');
      User_name:=Ini.ReadString('Mail','UserName','');
      Password:=Cryptor(Ini.ReadString('Mail','UserPassword',''), 'decrypt');
      Senders_address:=Ini.ReadString('Mail','SenderAddress','');
      Senders_name:=Ini.ReadString('Mail','SenderName','');
      // Skynet
      if ini.ReadString('Skynet','Enabled','') = 'true' then
          SkynetEnabled:='true'
        else
          SkynetEnabled:='false';
      SkynetFile:=Ini.ReadString('Skynet', 'File_name', '');
      SkynetTheme:=Ini.ReadString('Skynet', 'Theme', '');
      SkynetRecipient:=Ini.ReadString('Skynet', 'RecipientAddress', '');
      if Ini.ReadInteger('Skynet', 'FilialsCount', 0) <> 0 then
        begin
          SetLength(SkynetFilials, Ini.ReadInteger('Skynet', 'FilialsCount', 0));
          for i := 0 to Ini.ReadInteger('Skynet', 'FilialsCount', 0)-1 do
            SkynetFilials[i]:=Ini.ReadString('Skynet', IntToStr(i), '');
          FilialsCount:=Ini.ReadInteger('Skynet', 'FilialsCount', 0);
        end;
      Ini.Free;
    end;

end;

function TMainForm.Send_Email(Theme, Recipient, Email_Message: string): Boolean;
var
IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    //�������� SMTP ������.
    IdSMTP.Host:= Mail_server;
    //����
    IdSMTP.Port:= StrToInt(Mail_port);
 {
    if ConfigForm.SSLCheckBox.Checked then   //���� ����� ������������ SSL
      begin
        IdSMTP.AuthType:=satDefault;
        IdSSLIOHandlerSocketOpenSSL:= TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        IdSSLIOHandlerSocketOpenSSL.Destination := IdSMTP.Host+':'+IntToStr(IdSMTP.Port);
        IdSSLIOHandlerSocketOpenSSL.Host := IdSMTP.Host;
        IdSSLIOHandlerSocketOpenSSL.Port := IdSMTP.Port;
        IdSSLIOHandlerSocketOpenSSL.DefaultPort := 0;
        IdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvTLSv1;
        IdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmUnassigned;
        IdSMTP.IOHandler := IdSSLIOHandlerSocketOpenSSL;
        IdSMTP.UseTLS := utUseImplicitTLS;
      end;
  }
    //����� (��� ��������� ���������� ������ � �������).
    IdSMTP.Username:= User_name;
    //������ �� �����.
    IdSMTP.Password:= Password;
    //���� ������.
    IdMessage.Subject:= Theme;
    //����� ����������.
    IdMessage.Recipients.EMailAddresses:= Recipient;
    //��� email � �������� ��� ��������.
    IdMessage.From.Address:= Senders_address;
    //��������� ����� ������
    IdMessage.Body.Text:= Email_Message;
    //����������� ������� (���).
    IdMessage.From.Name:= Senders_name;
    // ��� ���. �����
    IdMessage.ContentType:='text/html; charset=windows-1251';
    IdMessage.ContentTransferEncoding:='8bit';
    //�����������
    IdSMTP.connect;
    //����������
    if idSmtp.Connected = TRUE then
      IdSMTP.Send(IdMessage);
    //�������������
    IdSMTP.Disconnect;
    result:=true;
  except
    result:=false;
  end;
  IdSMTP.Disconnect;
//  IdSMTP.Free;
end;

end.
