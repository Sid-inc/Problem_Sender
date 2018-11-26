unit config;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, inifiles,
  Vcl.Mask, Vcl.Buttons;

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
    SenderAddressLabel: TLabel;
    SenderAddressEdit: TEdit;
    SenderNameLabel: TLabel;
    SenderNameEdit: TEdit;
    ThemeLabel: TLabel;
    ThemeEdit: TEdit;
    RecipientAddressLabel: TLabel;
    RecipientAddressEdit: TEdit;
    DaysLabel: TLabel;
    DaysEdit: TEdit;
    OpenDialog: TOpenDialog;
    OpenBtn: TBitBtn;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
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

procedure TConfigForm.Button1Click(Sender: TObject);
begin
ShowMessage(main.ChanelsFile+sLineBreak+main.Theme+sLineBreak+main.Recipient_address+sLineBreak+main.ChanelsDays+sLineBreak+main.Mail_server+sLineBreak+main.Mail_port+sLineBreak+main.User_name+sLineBreak+main.Password+sLineBreak+main.Senders_address+sLineBreak+main.Senders_name);
end;

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
      ThemeEdit.Text:=Ini.ReadString('Chanels','Theme','');
      RecipientAddressEdit.Text:=Ini.ReadString('Chanels','RecipientAddress','');
      DaysEdit.Text:=Ini.ReadString('Chanels','ChanelsDays','');
      ServerAddressEdit.Text:=Ini.ReadString('Mail','ServerAddress','');
      PortEdit.Text:=Ini.ReadString('Mail','ServerPort','');
      UserNameEdit.Text:=Ini.ReadString('Mail','UserName','');
      PasswordEdit.Text:=main.Cryptor(Ini.ReadString('Mail','UserPassword',''), 'decrypt');
      SenderAddressEdit.Text:=Ini.ReadString('Mail','SenderAddress','');
      SenderNameEdit.Text:=Ini.ReadString('Mail','SenderName','');
      Ini.Free;
    end;
end;

procedure TConfigForm.OpenBtnClick(Sender: TObject);
begin
 if OpenDialog.Execute then FileNameEdit.Text:=OpenDialog.FileName;

end;

procedure TConfigForm.SaveClick(Sender: TObject);
var
  Ini: Tinifile;
begin
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); // Создаем или открываем ини файл
  if FileNameEdit.Text <> '' then
    begin
      Ini.WriteString('Chanels','File_name',FileNameEdit.Text);
      main.ChanelsFile := FileNameEdit.Text;
    end;
  if ThemeEdit.Text <> '' then
    begin
      Ini.WriteString('Chanels','Theme',ThemeEdit.Text);
      main.Theme := ThemeEdit.Text;
    end;
  if RecipientAddressEdit.Text <> '' then
    begin
      Ini.WriteString('Chanels','RecipientAddress',RecipientAddressEdit.Text);
      main.Recipient_address := RecipientAddressEdit.Text;
    end;
  if DaysEdit.Text <> '' then
    begin
      Ini.WriteString('Chanels','ChanelsDays',DaysEdit.Text);
      main.ChanelsDays := DaysEdit.Text;
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
      Ini.WriteString('Mail','UserPassword', main.Cryptor(PasswordEdit.Text, 'crypt'));
      main.Password := PasswordEdit.Text;
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
  Ini.Free;
end;

end.
