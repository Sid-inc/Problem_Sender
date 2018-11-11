unit config;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, inifiles,
  Vcl.Mask;

type
  TConfigForm = class(TForm)
    PageControl1: TPageControl;
    Channels_Conf: TTabSheet;
    Save: TButton;
    CloseBtn: TButton;
    Mail_Conf: TTabSheet;
    FileNameEdit: TEdit;
    FileNameLabel: TLabel;
    ServerAddressLabel: TLabel;
    ServerAddressEdit: TEdit;
    PortLabel: TLabel;
    PortEdit: TEdit;
    UserNameLabel: TLabel;
    UserNameEdit: TEdit;
    PasswordLabel: TLabel;
    PasswordEdit: TMaskEdit;
    ThemeLabel: TLabel;
    ThemeEdit: TEdit;
    SenderAddressLabel: TLabel;
    SenderAddressEdit: TEdit;
    SenderNameLabel: TLabel;
    SenderNameEdit: TEdit;
    RecipientAddressLabel: TLabel;
    RecipientAddressEdit: TEdit;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigForm: TConfigForm;

implementation

{$R *.dfm}

uses main;

procedure TConfigForm.CloseBtnClick(Sender: TObject);
begin
  ConfigForm.Close;
end;

procedure TConfigForm.FormShow(Sender: TObject);
var
  Ini: Tinifile;
begin
  if FileExists('config.ini') then
    begin
      Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini');
      FileNameEdit.Text:=Ini.ReadString('Chanels','File_name','');
      ServerAddressEdit.Text:=Ini.ReadString('Mail','ServerAddress','');
      PortEdit.Text:=Ini.ReadString('Mail','ServerPort','');
      UserNameEdit.Text:=Ini.ReadString('Mail','UserName','');
      PasswordEdit.Text:=Ini.ReadString('Mail','UserPassword','');
      ThemeEdit.Text:=Ini.ReadString('Mail','Theme','');
      SenderAddressEdit.Text:=Ini.ReadString('Mail','SenderAddress','');
      SenderNameEdit.Text:=Ini.ReadString('Mail','SenderName','');
      RecipientAddressEdit.Text:=Ini.ReadString('Mail','RecipientAddress','');
      Ini.Free;
    end;
end;

procedure TConfigForm.SaveClick(Sender: TObject);
var
  Ini: Tinifile;
begin
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); // ������� ��� ��������� ��� ����
  if FileNameEdit.Text <> '' then
    begin
      Ini.WriteString('Chanels','File_name',FileNameEdit.Text);
      main.ChanelsFile := FileNameEdit.Text;
    end;
  if ServerAddressEdit.Text <> '' then
    begin
      Ini.WriteString('Mail','ServerAddress',ServerAddressEdit.Text);
      main.Mail_server := ServerAddressEdit.Text;
    end;
  if PortEdit.Text <> '' then
    begin
      Ini.WriteString('Mail','ServerPort',PortEdit.Text);
      main.Mail_port := PortEdit.Text;
    end;
  if UserNameEdit.Text <> '' then
    begin
      Ini.WriteString('Mail','UserName',UserNameEdit.Text);
      main.User_name := UserNameEdit.Text;
    end;
  if PasswordEdit.Text <> '' then
    begin
      Ini.WriteString('Mail','UserPassword',PasswordEdit.Text);
      main.Password := PasswordEdit.Text;
    end;
  if ThemeEdit.Text <> '' then
    begin
      Ini.WriteString('Mail','Theme',ThemeEdit.Text);
      main.Theme := ThemeEdit.Text;
    end;
  if SenderAddressEdit.Text <> '' then
    begin
      Ini.WriteString('Mail','SenderAddress',SenderAddressEdit.Text);
      main.Senders_address := SenderAddressEdit.Text;
    end;
  if SenderNameEdit.Text <> '' then
    begin
      Ini.WriteString('Mail','SenderName',SenderNameEdit.Text);
      main.Senders_name := SenderNameEdit.Text;
    end;
  if RecipientAddressEdit.Text <> '' then
    begin
      Ini.WriteString('Mail','RecipientAddress',RecipientAddressEdit.Text);
      main.Recipient_address := RecipientAddressEdit.Text;
    end;
  Ini.Free;
end;

end.
