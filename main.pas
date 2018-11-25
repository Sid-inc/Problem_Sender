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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function Cryptor(s, c: string):string;

var
  MainForm: TMainForm;
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
  a, i, j, x, y, sr1, sr2: Integer;
  tmparr: array [1..3] of string;
  s: String;
begin
//  s:='';
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
      s:='<table border="1"><tr><th><b>�������� ��</b></th><th><b>��� ������</b></th><th><b>���������� ���� �� � ����</b></th></tr>';
      for a := 0 to j-1 do
        begin
          s:=s+'<tr>';
          s:=s+'<td>'+ChannelsResult[a,0]+'</td><td>'+ChannelsResult[a,1]+'</td><td>'+ChannelsResult[a,2]+'</td>';
          s:=s+'</tr>'+sLineBreak;
        end;
      s:=s+'</table>';
      ChannelsResult:=NIL;
      if (Send_Email(Theme, Recipient_address, s)) then ShowMessage('������ �� ������� - ��')
        else ShowMessage('������ �� ������� - ERROR');
    end
    else ShowMessage('���������� ������, ��� ������� ��� ������� ������� ������');

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
begin
  ChanelsFile := '';
  if FileExists('config.ini') then
    begin
      Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini');
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
      Ini.Free;
    end;

end;

function TMainForm.Send_Email(Theme, Recipient, Email_Message: string): Boolean;
var
IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
//  try
    //�������� SMTP ������.
    IdSMTP.Host:= Mail_server;
    //����
    IdSMTP.Port:= StrToInt(Mail_port);

    if ConfigForm.SSLCheckBox.Checked then   //���� ����� ������������ SSL
      begin
        IdSMTP.AuthType:=satDefault;
        IdSSLIOHandlerSocketOpenSSL:= TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        IdSSLIOHandlerSocketOpenSSL.Destination := IdSMTP.Host+':'+IntToStr(IdSMTP.Port);
        IdSSLIOHandlerSocketOpenSSL.Host := IdSMTP.Host;
        IdSSLIOHandlerSocketOpenSSL.Port := IdSMTP.Port;
        IdSSLIOHandlerSocketOpenSSL.DefaultPort := 0;
        IdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvTLSv1_2;
        IdSSLIOHandlerSocketOpenSSL.SSLOptions.SSLVersions := [sslvSSLv3];
        IdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmUnassigned;
        IdSMTP.IOHandler := IdSSLIOHandlerSocketOpenSSL;
        IdSMTP.UseTLS := utUseImplicitTLS;
      end;

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
//  except
//    result:=false;
//  end;
  IdSMTP.Free;
end;

end.
