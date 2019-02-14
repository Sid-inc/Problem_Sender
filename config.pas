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
    Skynet_Conf: TTabSheet;
    CheckBoxChannels: TCheckBox;
    Save: TButton;
    CheckBoxSkynet: TCheckBox;
    SkynetFileNameLabel: TLabel;
    SkynetFileNameEdit: TEdit;
    FilialNameLabel: TLabel;
    FilialNameEdit: TEdit;
    FilialsListBox: TListBox;
    AddButton: TButton;
    DelButton: TButton;
    SkynetThemeLabel: TLabel;
    SkynetThemeEdit: TEdit;
    SkynetRecipientLabel: TLabel;
    SkynetRecipientEdit: TEdit;
    SkynetOpenBtn: TBitBtn;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBoxChannelsClick(Sender: TObject);
    procedure SkynetOpenBtnClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure CheckBoxSkynetClick(Sender: TObject);
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

procedure TConfigForm.AddButtonClick(Sender: TObject);
begin
if FilialNameEdit.Text <> '' then FilialsListBox.Items.Add(FilialNameEdit.Text);
FilialNameEdit.Text:='';
end;

procedure TConfigForm.Button1Click(Sender: TObject);
begin
ShowMessage(main.ChanelsFile+sLineBreak+main.Theme+sLineBreak+main.Recipient_address+sLineBreak+main.ChanelsDays+sLineBreak+main.Mail_server+sLineBreak+main.Mail_port+sLineBreak+main.User_name+sLineBreak+main.Password+sLineBreak+main.Senders_address+sLineBreak+main.Senders_name);
end;

procedure TConfigForm.CheckBoxChannelsClick(Sender: TObject);
begin
if CheckBoxChannels.Checked then
  begin
    FileNameEdit.Enabled:=true;
    OpenBtn.Enabled:=true;
    DaysEdit.Enabled:=true;
    ThemeEdit.Enabled:=true;
    RecipientAddressEdit.Enabled:=true;
    main.ChanelsEnabled:='true';
  end
  else
  begin
    FileNameEdit.Enabled:=false;
    OpenBtn.Enabled:=false;
    DaysEdit.Enabled:=false;
    ThemeEdit.Enabled:=false;
    RecipientAddressEdit.Enabled:=false;
    main.ChanelsEnabled:='false';
  end;
end;

procedure TConfigForm.CheckBoxSkynetClick(Sender: TObject);
begin
if CheckBoxSkynet.Checked then
  begin
    SkynetFileNameEdit.Enabled:=true;
    SkynetOpenBtn.Enabled:=true;
    FilialNameEdit.Enabled:=true;
    FilialsListBox.Enabled:=true;
    AddButton.Enabled:=true;
    DelButton.Enabled:=true;
    SkynetThemeEdit.Enabled:=true;
    SkynetRecipientEdit.Enabled:=true;
  end
  else
  begin
    SkynetFileNameEdit.Enabled:=false;
    SkynetOpenBtn.Enabled:=false;
    FilialNameEdit.Enabled:=false;
    FilialsListBox.Enabled:=false;
    AddButton.Enabled:=false;
    DelButton.Enabled:=false;
    SkynetThemeEdit.Enabled:=false;
    SkynetRecipientEdit.Enabled:=false;
  end;

end;

procedure TConfigForm.CloseBtnClick(Sender: TObject);
begin
  ConfigForm.Close;
end;

procedure TConfigForm.DelButtonClick(Sender: TObject);
begin
  FilialsListBox.DeleteSelected;
end;

procedure TConfigForm.FormShow(Sender: TObject);
var
  Ini: Tinifile;
  i: integer;
begin
  if FileExists('config.ini') then
    begin
      Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini');
    // Вкладка каналы
      if ini.ReadString('Chanels','Enabled','') = 'true' then
        begin
          FileNameEdit.Enabled:=true;
          OpenBtn.Enabled:=true;
          DaysEdit.Enabled:=true;
          ThemeEdit.Enabled:=true;
          RecipientAddressEdit.Enabled:=true;
          CheckBoxChannels.Checked:=true;
          main.ChanelsEnabled:='true';
        end
        else
        begin
          FileNameEdit.Enabled:=false;
          OpenBtn.Enabled:=false;
          DaysEdit.Enabled:=false;
          ThemeEdit.Enabled:=false;
          RecipientAddressEdit.Enabled:=false;
          CheckBoxChannels.Checked:=false;
          main.ChanelsEnabled:='false';
        end;
    // Вкладка Skynet
      if ini.ReadString('Skynet','Enabled','') = 'true' then
        begin
          SkynetFileNameEdit.Enabled:=true;
          SkynetOpenBtn.Enabled:=true;
          FilialNameEdit.Enabled:=true;
          FilialsListBox.Enabled:=true;
          AddButton.Enabled:=true;
          DelButton.Enabled:=true;
          SkynetThemeEdit.Enabled:=true;
          SkynetRecipientEdit.Enabled:=true;
          CheckBoxSkynet.Checked:=true;
          main.SkynetEnabled:='true';
        end
        else
        begin
          SkynetFileNameEdit.Enabled:=false;
          SkynetOpenBtn.Enabled:=false;
          FilialNameEdit.Enabled:=false;
          FilialsListBox.Enabled:=false;
          AddButton.Enabled:=false;
          DelButton.Enabled:=false;
          SkynetThemeEdit.Enabled:=false;
          SkynetRecipientEdit.Enabled:=false;
          CheckBoxSkynet.Checked:=false;
          main.SkynetEnabled:='false';
        end;
    // Вкладка каналы и почта
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
    // Вкладка Skynet
      SkynetFileNameEdit.Text:=Ini.ReadString('Skynet', 'File_Name', '');
      SkynetThemeEdit.Text:=Ini.ReadString('Skynet', 'Theme', '');
      SkynetRecipientEdit.Text:=Ini.ReadString('Skynet', 'RecipientAddress', '');
      FilialsListBox.Clear;
      if Ini.ReadInteger('Skynet','FilialsCount',0) <> 0 then
        for i := 0 to Ini.ReadInteger('Skynet','FilialsCount',0)-1 do
          FilialsListBox.Items.Add(Ini.ReadString('Skynet', IntToStr(i), ''));
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
  i, j: integer;
begin
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); // Создаем или открываем или файл
  // Каналы + Почта
  if CheckBoxChannels.Checked then
    begin
      Ini.WriteString('Chanels','Enabled','true');
      main.ChanelsEnabled:='true';
    end
    else
    begin
      Ini.WriteString('Chanels','Enabled','false');
      main.ChanelsEnabled:='false';
    end;

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

  // Skynet

  if CheckBoxSkynet.Checked then
    begin
      Ini.WriteString('Skynet','Enabled','true');
      main.SkynetEnabled:='true';
    end
    else
    begin
      Ini.WriteString('Skynet','Enabled','false');
      main.SkynetEnabled:='false';
    end;
  if SkynetFileNameEdit.Text <> '' then
    begin
      Ini.WriteString('Skynet','File_name',SkynetFileNameEdit.Text);
      main.SkynetFile := SkynetFileNameEdit.Text;
    end;
  if SkynetThemeEdit.Text <> '' then
    begin
      Ini.WriteString('Skynet','Theme',SkynetThemeEdit.Text);
      main.SkynetTheme := SkynetThemeEdit.Text;
    end;
  if SkynetRecipientEdit.Text <> '' then
    begin
      Ini.WriteString('Skynet','RecipientAddress',SkynetRecipientEdit.Text);
      main.SkynetRecipient := SkynetRecipientEdit.Text;
    end;
  if FilialsListBox.Items.Count <> 0 then
    begin
     if Ini.ReadInteger('Skynet','FilialsCount',0) <> 0 then   // Если ранее в ини файл уже добавлялись файлы, вычищаем следы их присутствия
       for j := 0 to Ini.ReadInteger('Skynet','FilialsCount',0)-1 do ini.DeleteKey('Skynet', IntToStr(j));
     SetLength(SkynetFilials, FilialsListBox.Items.Count);
     for i := 0 to FilialsListBox.Items.Count-1 do
       begin
         Ini.WriteString('Skynet',IntToStr(i), FilialsListBox.Items[i]);
         main.SkynetFilials[i] := FilialsListBox.Items[i];
       end;
     Ini.WriteInteger('Skynet','FilialsCount',FilialsListBox.Items.Count);
     main.FilialsCount:=FilialsListBox.Items.Count;
    end
    else
    begin
      if Ini.ReadInteger('Skynet','FilialsCount',0) <> 0 then   // Если ранее в ини файл уже добавлялись файлы, вычищаем следы их присутствия
       for j := 0 to Ini.ReadInteger('Skynet','FilialsCount',0)-1 do ini.DeleteKey('Skynet', IntToStr(j));
      ini.DeleteKey('Skynet', 'FilialsCount');
    end;

  Ini.Free;
end;

procedure TConfigForm.SkynetOpenBtnClick(Sender: TObject);
begin
  if OpenDialog.Execute then SkynetFileNameEdit.Text:=OpenDialog.FileName;
end;

end.
