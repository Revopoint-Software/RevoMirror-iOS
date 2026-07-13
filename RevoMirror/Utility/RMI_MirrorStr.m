#import "RMI_MirrorStr.h" 



NSString* RMI_MirrorStr_Mirror(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"投屏",
                          @"zh_HK" : @"鏡像投射",
                          @"en_US" : @"Mirroring",
                          @"fr" : @"Miroir d'écran",
                          @"de" : @"Übertragung",
                          @"it" : @"Riprodurre",
                          @"es" : @"Espejado",
                          @"ja" : @"ミラーリング",
                          @"ko" : @"미러링",
                          @"ru" : @"Зеркальное",
                          @"pt" : @"Espelhamento",
                          @"tr" : @"Yansıtma",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_MirrorDevice(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"投屏设备",
                          @"zh_HK" : @"鏡像投射設備",
                          @"en_US" : @"Mirror Device",
                          @"fr" : @"Miroir d'écran dispositif",
                          @"de" : @"Mirroring-Gerät",
                          @"it" : @"Dispositivo da riprodurre",
                          @"es" : @"Dispositivo de espejado",
                          @"ja" : @"ミラーリングデバイス",
                          @"ko" : @"미러링 기기",
                          @"ru" : @"Устройство зеркальное",
                          @"pt" : @"Dispositivo espelho",
                          @"tr" : @"Yansıtma Cihazı",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_Setting(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"设置",
                          @"zh_HK" : @"設定",
                          @"en_US" : @"Settings",
                          @"fr" : @"Paramètres",
                          @"de" : @"Einstellungen",
                          @"it" : @"Impostazioni",
                          @"es" : @"Ajustes",
                          @"ja" : @"設定",
                          @"ko" : @"설정",
                          @"ru" : @"Настройки",
                          @"pt" : @"Configurações",
                          @"tr" : @"Ayarlar",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_UserPolicy(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"用户协议",
                          @"zh_HK" : @"使用者協定",
                          @"en_US" : @"User Agreement",
                          @"fr" : @"Accord de l’utilisateur",
                          @"de" : @"Nutzervereinbarung",
                          @"it" : @"Accordo con l’utente",
                          @"es" : @"Acuerdo de usuario",
                          @"ja" : @"ユーザー契約",
                          @"ko" : @"사용자 동의서",
                          @"ru" : @"Пользовательское соглашение",
                          @"pt" : @"Acordo do usuário",
                          @"tr" : @"Kullanıcı Sözleşmesi",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_PrivatePolicy(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"隐私政策",
                          @"zh_HK" : @"隱私政策",
                          @"en_US" : @"Privacy Policy",
                          @"fr" : @"Politique de confidentialité",
                          @"de" : @"Datenschutzrichtlinie",
                          @"it" : @"Informativa sulla privacy",
                          @"es" : @"Política de privacidad",
                          @"ja" : @"プライバシーポリシー",
                          @"ko" : @"개인정보 처리방침",
                          @"ru" : @"Политика конфиденциальности",
                          @"pt" : @"Política de privacidade",
                          @"tr" : @"Gizlilik Politikası",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_Gplv3(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"GpLv3协议",
                          @"zh_HK" : @"GpLv3協定",
                          @"en_US" : @"GPLv3 Protocol",
                          @"fr" : @"Protocole GPLv3",
                          @"de" : @"GPLv3-Protokoll",
                          @"it" : @"Protocollo GPLv3",
                          @"es" : @"Protocolo GPLv3",
                          @"ja" : @"GPLv3プロトコル",
                          @"ko" : @"GPLv3 프로토콜",
                          @"ru" : @"Протокол GPLv3",
                          @"pt" : @"Protocolo GPLv3",
                          @"tr" : @"GPLv3 Protokolü",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_Language(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"语言设置",
                          @"zh_HK" : @"語言設定",
                          @"en_US" : @"Language Settings",
                          @"fr" : @"Paramètres de langue",
                          @"de" : @"Spracheinstellungen",
                          @"it" : @"Impostazioni lingua",
                          @"es" : @"Configuración de idioma",
                          @"ja" : @"言語設定",
                          @"ko" : @"언어 설정",
                          @"ru" : @"Настройки языка",
                          @"pt" : @"Configurações de idioma",
                          @"tr" : @"Dil Ayarları",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_About(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"关于",
                          @"zh_HK" : @"關於",
                          @"en_US" : @"About",
                          @"fr" : @"À propos",
                          @"de" : @"Über",
                          @"it" : @"Informazioni",
                          @"es" : @"Acerca de",
                          @"ja" : @"情報",
                          @"ko" : @"정보",
                          @"ru" : @"О программе",
                          @"pt" : @"Sobre",
                          @"tr" : @"Hakkında",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_AutoSystem(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"跟随系统",
                          @"zh_HK" : @"跟隨系統",
                          @"en_US" : @"Follow System",
                          @"fr" : @"Suivre le système",
                          @"de" : @"Systemeinstellungen folgen",
                          @"it" : @"Segue il sistema",
                          @"es" : @"Seguir sistema",
                          @"ja" : @"システムに従う",
                          @"ko" : @"시스템 따라가기",
                          @"ru" : @"Следовать системе",
                          @"pt" : @"Seguir o sistema",
                          @"tr" : @"Sistemi Takip Et",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_RemoveHost(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"移除主机",
                          @"zh_HK" : @"移除主機",
                          @"en_US" : @"Remove Host",
                          @"fr" : @"Supprimer l’hôte",
                          @"de" : @"Host entfernen",
                          @"it" : @"Rimuovi host",
                          @"es" : @"Eliminar host",
                          @"ja" : @"ホストを削除",
                          @"ko" : @"호스트 제거",
                          @"ru" : @"Удалить хост",
                          @"pt" : @"Remover host",
                          @"tr" : @"Hostu Kaldır",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_Cancel(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"取消",
                          @"zh_HK" : @"取消",
                          @"en_US" : @"Cancel",
                          @"fr" : @"Annuler",
                          @"de" : @"Abbrechen",
                          @"it" : @"Cancella",
                          @"es" : @"Cancelar",
                          @"ja" : @"キャンセル",
                          @"ko" : @"취소",
                          @"ru" : @"Отмена",
                          @"pt" : @"Cancelar",
                          @"tr" : @"İptal",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_Confirm(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"确定",
                          @"zh_HK" : @"確定",
                          @"en_US" : @"OK",
                          @"fr" : @"OK",
                          @"de" : @"OK",
                          @"it" : @"OK",
                          @"es" : @"OK",
                          @"ja" : @"OK",
                          @"ko" : @"확인",
                          @"ru" : @"ХОРОШО",
                          @"pt" : @"OK",
                          @"tr" : @"Onayla",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_AddDevice(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"设备添加",
                          @"zh_HK" : @"設備添加",
                          @"en_US" : @"Add Device",
                          @"fr" : @"Ajouter un appareil",
                          @"de" : @"Gerät hinzufügen",
                          @"it" : @"Aggiungi dispositivo",
                          @"es" : @"Agregar dispositivo",
                          @"ja" : @"デバイスを追加",
                          @"ko" : @"디바이스 추가",
                          @"ru" : @"Добавить устройство",
                          @"pt" : @"Adicionar dispositivo",
                          @"tr" : @"Cihaz Ekle",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_AddDeviceTip(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"请手动输入电脑IP地址进行设备添加",
                          @"zh_HK" : @"請手動輸入電腦IP地址進行設備添加",
                          @"en_US" : @"Enter the PC's IP address manually to add the device.",
                          @"fr" : @"Saisissez manuellement l’adresse IP du PC pour ajouter l’appareil.",
                          @"de" : @"Geben Sie die IP-Adresse des PCs manuell ein, um das Gerät hinzuzufügen.",
                          @"it" : @"Inserisci manualmente l’indirizzo IP del PC per aggiungere il dispositivo.",
                          @"es" : @"Ingrese manualmente la dirección IP de la PC para agregar el dispositivo.",
                          @"ja" : @"デバイスを追加するには、PC の IP アドレスを手動で入力してください。",
                          @"ko" : @"디바이스를 추가하려면 PC의 IP 주소를 수동으로 입력하세요.",
                          @"ru" : @"Чтобы добавить устройство, введите IP-адрес ПК вручную.",
                          @"pt" : @"Insira o  endereço IP do PC, para adicionar o dispositivo.",
                          @"tr" : @"Cihaz eklemek için PC'nin IP adresini manuel girin.",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_PairDevice(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"设备配对",
                          @"zh_HK" : @"設備配對",
                          @"en_US" : @"Device Pairing",
                          @"fr" : @"Appairage de l’appareil",
                          @"de" : @"Geräte-Kopplung",
                          @"it" : @"Associazione dispositivo",
                          @"es" : @"Emparejamiento de dispositivo",
                          @"ja" : @"デバイスのペアリング",
                          @"ko" : @"디바이스 페어링",
                          @"ru" : @"Сопряжение устройства",
                          @"pt" : @"Emparelhamento de dispositivo",
                          @"tr" : @"Cihaz Eşleştirme",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_PairDeviceTip(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"请在PC端Revo Mirror上输入以下PIN码完成配对，PIN码：",
                          @"zh_HK" : @"請在PC端Revo Mirror上輸入以下PIN碼完成配對，PIN碼：",
                          @"en_US" : @"Enter the PIN on the Revo Mirror PC to finalize pairing. PIN:",
                          @"fr" : @"Saisissez le code PIN sur le PC Revo Mirror pour finaliser l’appairage. PIN :",
                          @"de" : @"Geben Sie die PIN auf dem Revo Mirror-PC ein, um die Kopplung abzuschließen. PIN:",
                          @"it" : @"Inserisci il PIN sul PC Revo Mirror per completare l’associazione. PIN:",
                          @"es" : @"Ingrese el PIN en la PC Revo Mirror para finalizar el emparejamiento. PIN:",
                          @"ja" : @"ペアリングを完了するには、Revo Mirror PC に PIN を入力してください。PIN：",
                          @"ko" : @"페어링을 완료하려면 Revo Mirror PC에 PIN을 입력하세요. PIN:",
                          @"ru" : @"Введите PIN на ПК Revo Mirror для завершения сопряжения. PIN:",
                          @"pt" : @"Insira o PIN no PC Revo Mirror, para finalizar o emparelhamento. PIN:",
                          @"tr" : @"Eşleştirmeyi tamamlamak için Revo Mirror PC'de PIN'i girin. PIN:",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_Back(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"返回",
                          @"zh_HK" : @"返回",
                          @"en_US" : @"Back",
                          @"fr" : @"Retour",
                          @"de" : @"Zurück",
                          @"it" : @"Indietro",
                          @"es" : @"Atrás",
                          @"ja" : @"戻る",
                          @"ko" : @"뒤로",
                          @"ru" : @"Назад",
                          @"pt" : @"Voltar",
                          @"tr" : @"Geri",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_Last(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"最近",
                          @"zh_HK" : @"最近",
                          @"en_US" : @"Recent",
                          @"fr" : @"Récent",
                          @"de" : @"Kürzlich",
                          @"it" : @"Recenti",
                          @"es" : @"Reciente",
                          @"ja" : @"最近",
                          @"ko" : @"최근",
                          @"ru" : @"Недавние",
                          @"pt" : @"Recentes",
                          @"tr" : @"En Son",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_NetNoConnect(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"网络未连接",
                          @"zh_HK" : @"網絡未連接",
                          @"en_US" : @"No Network Connection",
                          @"fr" : @"Aucune connexion réseau",
                          @"de" : @"Keine Netzwerkverbindung",
                          @"it" : @"Nessuna connessione di rete",
                          @"es" : @"Sin conexión de red",
                          @"ja" : @"ネットワーク接続なし",
                          @"ko" : @"네트워크 연결 없음",
                          @"ru" : @"Нет сетевого подключения",
                          @"pt" : @"Sem ligação de rede",
                          @"tr" : @"Ağ bağlantısı yok",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_NetConnectTip(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"请将投屏设备和接收设备连接至同一 Wi-Fi，推荐使用扫描仪 Wi-Fi",
                          @"zh_HK" : @"請將投屏設備和接收設備連接至同一Wi-Fi，推薦使用掃描器Wi-Fi",
                          @"en_US" : @"Connect the mirror device and the receiving device to the same Wi-Fi network. It is recommended to use the scanner's Wi-Fi.",
                          @"fr" : @"Connectez l'appareil miroir et l'appareil récepteur au même réseau Wi-Fi. Il est recommandé d'utiliser le Wi-Fi du scanner.",
                          @"de" : @"Verbinden Sie das Mirroring-Gerät und das Empfangsgerät mit demselben WLAN. Es wird empfohlen, das WLAN des Scanners zu verwenden.",
                          @"it" : @"Collega il dispositivo da riprodurre e quello di ricezione alla stessa rete Wi-Fi. Si consiglia di utilizzare il Wi-Fi dello scanner.",
                          @"es" : @"Conecte el dispositivo de espejado y el dispositivo receptor a la misma red Wi-Fi. Se recomienda usar el Wi-Fi del escáner.",
                          @"ja" : @"ミラーリングデバイスと受信デバイスを同じWi-Fiネットワークに接続してください。スキャナーのWi-Fiの使用を推奨します。",
                          @"ko" : @"미러링 기기와 수신 기기를 동일한 Wi-Fi 네트워크에 연결하세요. 스캐너의 Wi-Fi 사용을 권장합니다.",
                          @"ru" : @"Подключите устройство зеркальное и принимающее устройство к одной Wi-Fi сети. Рекомендуется использовать Wi-Fi сканера.",
                          @"pt" : @"Ligue o dispositivo espelho e o dispositivo recetor à mesma rede Wi-Fi. Recomenda-se usar o Wi-Fi do scanner.",
                          @"tr" : @"Yansıtma cihazını ve alıcı cihazı aynı Wi-Fi ağına bağlayın. Tarayıcının Wi-Fi’sini kullanmanız önerilir.",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_PairingFailed(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"配对失败",
                          @"zh_HK" : @"配對失敗",
                          @"en_US" : @"Pairing Failed",
                          @"fr" : @"Échec de l’appairage",
                          @"de" : @"Koppeln fehlgeschlagen",
                          @"it" : @"Associazione non riuscita",
                          @"es" : @"Falló el emparejamiento",
                          @"ja" : @"ペアリングに失敗しました",
                          @"ko" : @"페어링 실패",
                          @"ru" : @"Не удалось выполнить сопряжение",
                          @"pt" : @"Falha no emparelhamento",
                          @"tr" : @"Eşleştirme başarısız",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_ConnectionInterrupted(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"连接中断",
                          @"zh_HK" : @"連接中斷",
                          @"en_US" : @"Connection Interrupted",
                          @"fr" : @"Connexion interrompue",
                          @"de" : @"Verbindung unterbrochen",
                          @"it" : @"Connessione interrotta",
                          @"es" : @"Conexión interrumpida",
                          @"ja" : @"接続が中断されました",
                          @"ko" : @"연결이 끊어졌습니다",
                          @"ru" : @"Соединение прервано",
                          @"pt" : @"Ligação interrompida",
                          @"tr" : @"Bağlantı kesildi",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_NetworkError(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"网络异常",
                          @"zh_HK" : @"網絡异常",
                          @"en_US" : @"Network Error",
                          @"fr" : @"Erreur réseau",
                          @"de" : @"Netzwerkfehler",
                          @"it" : @"Errore di rete",
                          @"es" : @"Error de red",
                          @"ja" : @"ネットワークエラー",
                          @"ko" : @"네트워크 오류",
                          @"ru" : @"Сетевая ошибка",
                          @"pt" : @"Erro de rede",
                          @"tr" : @"Ağ hatası",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_FailedResolveHost(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"解析失败",
                          @"zh_HK" : @"解析失敗",
                          @"en_US" : @"Failed to resolve host.",
                          @"fr" : @"Impossible de résoudre l’hôte",
                          @"de" : @"Host konnte nicht aufgelöst werden",
                          @"it" : @"Impossibile risolvere l’host",
                          @"es" : @"No se pudo resolver el host",
                          @"ja" : @"ホスト名を解決できませんでした",
                          @"ko" : @"호스트를 확인할 수 없습니다",
                          @"ru" : @"Не удалось найти хост",
                          @"pt" : @"Falha ao resolver o host",
                          @"tr" : @"Ana bilgisayar çözülemedi",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_ConnectionFailed(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"连接中断",
                          @"zh_HK" : @"連接中斷",
                          @"en_US" : @"Connection Failed",
                          @"fr" : @"Connexion échouée",
                          @"de" : @"Verbindung fehlgeschlagen",
                          @"it" : @"Connessione non riuscita",
                          @"es" : @"Conexión fallida",
                          @"ja" : @"接続に失敗しました",
                          @"ko" : @"연결 실패",
                          @"ru" : @"Не удалось подключиться",
                          @"pt" : @"Falha na ligação",
                          @"tr" : @"Bağlantı başarısız",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_DeviceNetworkBlocking(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"您的设备的网络连接正在阻碍“Revo Mirror”服务的运行。若当前处于该网络连接状态下，将无法进行流媒体播放。",
                          @"zh_HK" : @"您的設備的網絡連接正在阻礙“Revo Mirror”服務的運行。 若當前處於該網絡連接狀態下，將無法進行流媒體播放。",
                          @"en_US" : @"Your device's network connection is blocking Revo Mirror. Streaming may not work while connected to this network.",
                          @"fr" : @"La connexion réseau de votre appareil bloque Revo Mirror. Le streaming peut ne pas fonctionner lorsque vous êtes connecté à ce réseau.",
                          @"de" : @"Die Netzwerkverbindung Ihres Geräts blockiert Revo Mirror. Streaming funktioniert möglicherweise nicht, solange Sie mit diesem Netzwerk verbunden sind.",
                          @"it" : @"La connessione di rete del tuo dispositivo sta bloccando Revo Mirror. Lo streaming potrebbe non funzionare mentre sei connesso a questa rete.",
                          @"es" : @"La conexión de red de su dispositivo está bloqueando Revo Mirror. La transmisión puede no funcionar mientras esté conectado a esta red.",
                          @"ja" : @"お使いのデバイスのネットワーク接続がRevo Mirrorをブロックしています。このネットワークに接続中はストリーミングが機能しない場合があります。",
                          @"ko" : @"기기의 네트워크 연결이 Revo Mirror를 차단하고 있습니다. 이 네트워크에 연결된 동안 스트리밍이 작동하지 않을 수 있습니다.",
                          @"ru" : @"Сетевое соединение вашего устройства блокирует Revo Mirror. Вещание может не работать при подключении к этой сети.",
                          @"pt" : @"A conexão de rede do seu dispositivo está bloqueando o Revo Mirror. O streaming pode não funcionar enquanto estiver conectado a esta rede.",
                          @"tr" : @"Cihazınızın ağ bağlantısı Revo Mirror’ı engelliyor. Bu ağa bağlıyken yayın çalışmayabilir.",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_AddHostManually(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"手动添加",
                          @"zh_HK" : @"手動添加",
                          @"en_US" : @"Add Host Manually",
                          @"fr" : @"Ajouter un hôte manuellement",
                          @"de" : @"Host manuell hinzufügen",
                          @"it" : @"Aggiungi host manualmente",
                          @"es" : @"Agregar host manualmente",
                          @"ja" : @"ホストを手動で追加",
                          @"ko" : @"호스트 수동 추가",
                          @"ru" : @"Добавить хост вручную",
                          @"pt" : @"Adicionar host manualmente",
                          @"tr" : @"Ana bilgisayarı manuel ekle",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_ConnectionError(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"连接异常",
                          @"zh_HK" : @"連接异常",
                          @"en_US" : @"Connection Error",
                          @"fr" : @"Erreur de connexion",
                          @"de" : @"Verbindungsfehler",
                          @"it" : @"Errore di connessione",
                          @"es" : @"Error de conexión",
                          @"ja" : @"接続エラー",
                          @"ko" : @"연결 오류",
                          @"ru" : @"Ошибка соединения",
                          @"pt" : @"Erro de ligação",
                          @"tr" : @"Bağlantı hatası",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_CheckYourFirewall(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"检查您的防火墙和端口转发规则",
                          @"zh_HK" : @"檢查您的防火牆和埠轉發規則",
                          @"en_US" : @"Check your firewall and port forwarding rules for port(s)",
                          @"fr" : @"Veuillez vérifier votre pare-feu et les règles de redirection de port pour le(s) port(s)",
                          @"de" : @"Überprüfen Sie Ihre Firewall- und Portweiterleitungsregeln für Port(s)",
                          @"it" : @"Controlla le regole del firewall e del port forwarding per la/le porta/e",
                          @"es" : @"Verifique su firewall y las reglas de reenvío de puertos para el/los puerto(s)",
                          @"ja" : @"ファイアウォールとポート転送の設定を確認してください",
                          @"ko" : @"방화벽 및 포트 포워딩 규칙을 확인하세요.",
                          @"ru" : @"Проверьте настройки брандмауэра и проброса портов для порта(ов)",
                          @"pt" : @"Verifique as regras do firewall e de encaminhamento de portas para a(s) porta(s)",
                          @"tr" : @"Firewall ve port yönlendirme kurallarınızı kontrol edin",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_ReduceVideoBitrate(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"您的网络连接状况不佳。请降低视频比特率设置，或者尝试使用更快速的网络连接。",
                          @"zh_HK" : @"您的網絡連接狀況不佳。 請降低視頻位元速率設定，或者嘗試使用更快速的網絡連接。",
                          @"en_US" : @"Your network connection isn't performing well. Reduce your video bitrate setting or try a faster connection.",
                          @"fr" : @"Votre connexion réseau n’est pas optimale. Réduisez le débit vidéo ou essayez une connexion plus rapide.",
                          @"de" : @"Ihre Netzwerkverbindung ist nicht stabil. Reduzieren Sie die Video-Bitrate oder versuchen Sie eine schnellere Verbindung.",
                          @"it" : @"La tua connessione di rete non funziona bene. Riduci il bitrate video o prova una connessione più veloce.",
                          @"es" : @"Su conexión de red no está funcionando bien. Reduzca la tasa de bits de video o pruebe una conexión más rápida.",
                          @"ja" : @"ネットワーク接続の状態が良くありません。ビデオのビットレートを下げるか、より高速な接続をお試しください。",
                          @"ko" : @"네트워크 연결이 원활하지 않습니다. 비디오 비트레이트를 낮추거나 더 빠른 연결을 시도하세요.",
                          @"ru" : @"Ваша сеть работает нестабильно. Уменьшите битрейт видео или попробуйте более быстрое соединение.",
                          @"pt" : @"A sua ligação de rede não está a funcionar bem. Reduza a taxa de bits do vídeo ou tente uma ligação mais rápida.",
                          @"tr" : @"Ağ bağlantınız iyi çalışmıyor. Video bit hızını azaltın veya daha hızlı bir bağlantı deneyin.",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_SomethingWentWrong(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"在启动时，您的主机电脑出现了故障。\n\n请确保您的主机电脑上没有任何受数字版权管理保护的内容正在运行。您还可以尝试重启您的主机电脑。\n\n如果问题仍然存在，请尝试重新安装您的显卡驱动程序和 GeForce Experience 软件。",
                          @"zh_HK" : @"在啟動時，您的主機電腦出現了故障。 \n\n請確保您的主機電腦上沒有任何受數字版權管理保護的內容正在運行。 您還可以嘗試重啓您的主機電腦。 \n\n如果問題仍然存在，請嘗試重新安裝您的顯卡驅動程序和GeForce Experience軟件。",
                          @"en_US" : @"Something went wrong on your host PC when starting the stream.\n\nMake sure you don't have any DRM-protected content open on your host PC. You can also try restarting your host PC.\n\nIf the issue persists, try reinstalling your GPU drivers and GeForce Experience.",
                          @"fr" : @"Une erreur s’est produite sur votre PC hôte lors du démarrage du streaming.\n\nAssurez-vous qu’aucun contenu protégé par DRM n’est ouvert sur votre PC hôte. Vous pouvez également essayer de redémarrer votre PC hôte.\n\nSi le problème persiste, essayez de réinstaller vos pilotes GPU et GeForce Experience.",
                          @"de" : @"Beim Starten des Streams ist auf Ihrem Host-PC ein Fehler aufgetreten.\n\nStellen Sie sicher, dass auf Ihrem Host-PC keine DRM-geschützten Inhalte geöffnet sind. Sie können auch versuchen, Ihren Host-PC neu zu starten.\n\nWenn das Problem weiterhin besteht, versuchen Sie, Ihre GPU-Treiber und GeForce Experience neu zu installieren.",
                          @"it" : @"Si è verificato un errore sul PC host durante l'avvio dello streaming.\n\nAssicurati che sul PC host non siano aperti contenuti protetti da DRM. Puoi anche provare a riavviare il PC host.\n\nSe il problema persiste, prova a reinstallare i driver della GPU e GeForce Experience.",
                          @"es" : @"Se produjo un error en su PC anfitrión al iniciar la transmisión.\n\nAsegúrese de que no haya contenido protegido por DRM abierto en su PC anfitrión. También puede intentar reiniciar su PC anfitrión.\n\nSi el problema persiste, intente reinstalar los controladores de la GPU y GeForce Experience.",
                          @"ja" : @"ストリームの開始時にホストPCで問題が発生しました。\n\nホストPCでDRM保護されたコンテンツが開かれていないことを確認してください。また、ホストPCの再起動もお試しください。\n\n問題が解決しない場合は、GPUドライバーとGeForce Experienceの再インストールをお試しください。",
                          @"ko" : @"스트림을 시작할 때 호스트 PC에서 문제가 발생했습니다.\n\n호스트 PC에서 DRM으로 보호된 콘텐츠가 열려 있지 않은지 확인하세요. 호스트 PC를 재시작해 보세요.\n\n문제가 계속되면 GPU 드라이버와 GeForce Experience를 재설치해 보세요.",
                          @"ru" : @"При запуске трансляции на вашем хост-компьютере произошла ошибка.\n\nУбедитесь, что на хост-компьютере не открыты материалы, защищённые DRM. Также попробуйте перезагрузить хост-компьютер.\n\nЕсли проблема сохраняется, попробуйте переустановить драйверы видеокарты и GeForce Experience.",
                          @"pt" : @"Ocorreu um erro no seu PC host ao iniciar a transmissão.\n\nCertifique-se de que não há conteúdo protegido por DRM aberto no seu PC host. Você também pode tentar reiniciar o PC host.\n\nSe o problema persistir, tente reinstalar os drivers da GPU e o GeForce Experience.",
                          @"tr" : @"Akış başlatılırken ana bilgisayar PC’nizde bir sorun oluştu.\n\nAna bilgisayar PC’nizde DRM korumalı içeriklerin açık olmadığından emin olun. Ana bilgisayar PC’nizi yeniden başlatmayı da deneyebilirsiniz.\n\nSorun devam ederse, GPU sürücülerinizi ve GeForce Experience’ı yeniden yüklemeyi deneyin.",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_TryDisablingHDR(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"主机电脑报告了一个致命的视频编码错误。\n\n请尝试关闭 HDR 模式、更改流媒体分辨率或者调整主机电脑的显示分辨率。",
                          @"zh_HK" : @"主機電腦報告了一個致命的視頻編碼錯誤。 \n\n請嘗試關閉HDR模式、更改流媒體分辯率或者調整主機電腦的顯示分辯率。",
                          @"en_US" : @"The host PC reported a fatal video encoding error.\n\nTry disabling HDR mode, changing the streaming resolution, or changing your host PC's display resolution.",
                          @"fr" : @"Le PC hôte a signalé une erreur fatale d’encodage vidéo.\n\nEssayez de désactiver le mode HDR, de modifier la résolution de streaming ou la résolution d’affichage de votre PC hôte.",
                          @"de" : @"Der Host-PC hat einen schwerwiegenden Video-Codierungsfehler gemeldet.\n\nVersuchen Sie, den HDR-Modus zu deaktivieren, die Streaming-Auflösung zu ändern oder die Anzeigeauflösung Ihres Host-PCs zu ändern.",
                          @"it" : @"Il PC host ha segnalato un errore fatale di codifica video.\n\nProva a disabilitare la modalità HDR o a cambiare la risoluzione dello streaming o la risoluzione dello schermo del PC host.",
                          @"es" : @"El PC anfitrión informó un error fatal de codificación de video.\n\nIntente desactivar el modo HDR, cambiar la resolución de transmisión o la resolución de pantalla de su PC anfitrión.",
                          @"ja" : @"ホストPCで致命的なビデオエンコードエラーが報告されました。\n\nHDRモードを無効にする、ストリーミング解像度を変更する、またはホストPCの表示解像度を変更してください。",
                          @"ko" : @"호스트 PC에서 치명적인 비디오 인코딩 오류가 보고되었습니다.\n\nHDR 모드를 비활성화하거나 스트리밍 해상도 또는 호스트 PC의 디스플레이 해상도를 변경해 보세요.",
                          @"ru" : @"На хост-компьютере возникла критическая ошибка видеокодирования.\n\nПопробуйте отключить режим HDR, изменить разрешение трансляции или разрешение экрана хост-компьютера.",
                          @"pt" : @"O PC host relatou um erro fatal de codificação de vídeo.\n\nTente desativar o modo HDR, alterar a resolução da transmissão ou a resolução do ecrã do seu PC host.",
                          @"tr" : @"Ana bilgisayar PC’si kritik bir video kodlama hatası bildirdi.\n\nHDR modunu devre dışı bırakmayı, akış çözünürlüğünü veya ana bilgisayar PC’nizin ekran çözünürlüğünü değiştirmeyi deneyin.",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_TerminatedError(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"连接已断开\n\n错误代码：",
                          @"zh_HK" : @"連接已斷開\n\n錯誤代碼：",
                          @"en_US" : @"The connection was terminated.\n\nError code:",
                          @"fr" : @"La connexion a été interrompue. \n\n Code d’erreur :",
                          @"de" : @"Die Verbindung wurde beendet. \n\n Fehlercode:",
                          @"it" : @"La connessione è stata terminata.\n\n Codice di Errore:",
                          @"es" : @"La conexión fue terminada. \n\n Código de error:",
                          @"ja" : @"接続が終了しました。\n\n エラーコード：",
                          @"ko" : @"연결이 종료되었습니다.\n\n오류 코드:",
                          @"ru" : @"Соединение было разорвано. \n\n Код ошибки:",
                          @"pt" : @"A ligação foi encerrada.\n\n Código de erro:",
                          @"tr" : @"Bağlantı sonlandırıldı\n\nHata kodu:",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_FailedWithError(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"%s 出现错误 %d ",
                          @"zh_HK" : @"%s 出現錯誤 %d",
                          @"en_US" : @"%s failed with error %d",
                          @"fr" : @"%s a échoué avec l’erreur %d",
                          @"de" : @"%s ist mit Fehler %d fehlgeschlagen",
                          @"it" : @"%s non riuscito con errore %d",
                          @"es" : @"%s falló con el error %d",
                          @"ja" : @"%s はエラー %d で失敗しました",
                          @"ko" : @"%s가 오류 %d로 실패했습니다",
                          @"ru" : @"%s завершился с ошибкой %d",
                          @"pt" : @"%s falhou com o erro %d",
                          @"tr" : @"%s hatayla başarısız oldu %d",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_CheckYourPort(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"检查您的防火墙和端口转发规则，针对端口：\n%s",
                          @"zh_HK" : @"檢查您的防火牆和埠轉發規則，針對埠：\n%s",
                          @"en_US" : @"Check your firewall and port forwarding rules for port(s):\n%s",
                          @"fr" : @"Vérifiez les règles de pare-feu et de redirection de port pour le(s) port(s) :\n%s",
                          @"de" : @"Überprüfen Sie Ihre Firewall- und Portweiterleitungsregeln für Port(s):\n%s",
                          @"it" : @"Controlla le regole del firewall e del port forwarding per la/le porta/e:\n%s",
                          @"es" : @"Verifique su firewall y las reglas de reenvío de puertos para el/los puerto(s):\n%s",
                          @"ja" : @"ファイアウォールとポート転送のルール（ポート）を確認してください：\n%s",
                          @"ko" : @"방화벽 및 포트 포워딩 규칙(포트)을 확인하세요:\n%s",
                          @"ru" : @"Проверьте настройки брандмауэра и проброса портов для порта(ов):\n%s",
                          @"pt" : @"Verifique as regras de firewall e encaminhamento de porta(s):\n%s",
                          @"tr" : @"Port(lar) için güvenlik duvarınızı ve port yönlendirme kurallarınızı kontrol edin:\n%s",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_EnsureRunningProperly(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"无法连接到 Host。\n\n如果您使用 GeForce Experience 进行 Host 托管，请确保您已在 SHIELD 选项卡中启用了切换。\n\n如果您使用 Mirror 进行 Host 托管，请确保可正常运行。如果您使用的是非默认端口，您需要在此处包含该端口。",
                          @"zh_HK" : @"無法連接到 Host。\n\n如果您使用 GeForce Experience 進行 Host 託管，請確保您已在 SHIELD 選項卡中啟用了切換。\n\n如果您使用 Mirror 進行 Host 託管，請確保可正常運行。如果您使用的是非默認端口，您需要在此處包含該端口。",
                          @"en_US" : @"Could not connect to host.\n\nIf you're hosting using GeForce Experience, make sure you've enabled the toggle on the SHIELD tab.\n\nIf you're hosting using Mirror, ensure it is running properly. If you're using a non-default port, you will need to include that here.",
                          @"fr" : @"Impossible de se connecter à l’hôte.\n\nSi vous hébergez avec GeForce Experience, assurez-vous d’avoir activé l’option dans l’onglet SHIELD. \n\nSi vous hébergez avec Mirror, assurez-vous qu’il fonctionne correctement. Si vous utilisez un port non par défaut, vous devez l’indiquer ici.",
                          @"de" : @"Verbindung zum Host fehlgeschlagen.\n\nWenn Sie GeForce Experience verwenden, stellen Sie sicher, dass Sie den Schalter im SHIELD-Tab aktiviert haben.\n\nWenn Sie Mirror verwenden, stellen Sie sicher, dass es ordnungsgemäß läuft. Wenn Sie einen nicht standardmäßigen Port nutzen, müssen Sie ihn hier angeben.",
                          @"it" : @"Impossibile connettersi all’host.\n\nSe stai ospitando con GeForce Experience, assicurati di aver attivato l’opzione nella scheda SHIELD.\n\nSe stai ospitando con Mirror, verifica che sia in esecuzione correttamente. Se usi una porta diversa da quella predefinita, dovrai indicarla qui.",
                          @"es" : @"No se pudo conectar con el host.\n\nSi está alojando con GeForce Experience, asegúrese de haber activado la opción en la pestaña SHIELD.\n\nSi está alojando con Mirror, asegúrese de que se ejecute correctamente. Si usa un puerto distinto al predeterminado, deberá incluirlo aquí.",
                          @"ja" : @"ホストに接続できませんでした。\n\nGeForce Experienceでホストしている場合は、SHIELDタブの切り替えを有効にしてください。\n\nMirrorでホストしている場合は、正しく実行されているか確認してください。デフォルト以外のポートを使用する場合は、ここに含める必要があります。",
                          @"ko" : @"호스트에 연결할 수 없습니다.\n\nGeForce Experience로 호스팅하는 경우 SHIELD 탭에서 토글을 활성화했는지 확인하세요.\n\nMirror로 호스팅하는 경우 올바르게 실행 중인지 확인하세요. 기본이 아닌 포트를 사용하는 경우 여기에서 포함해야 합니다.",
                          @"ru" : @"Не удалось подключиться к хосту.\n\nЕсли вы используете GeForce Experience для хостинга, убедитесь, что переключатель включён на вкладке SHIELD.\n\nЕсли вы используете Mirror, убедитесь, что он работает корректно. Если вы используете нестандартный порт, его нужно указать здесь.",
                          @"pt" : @"Não foi possível conectar ao host.\n\nSe estiver hospedando com o GeForce Experience, certifique-se de que ativou a opção na guia SHIELD.\n\nSe estiver hospedando com o Mirror, verifique se ele está em execução corretamente. Se estiver usando uma porta diferente da padrão, você precisará incluí-la aqui.",
                          @"tr" : @"Ana bilgisayara bağlanılamadı.\n\nGeForce Experience kullanıyorsanız, SHIELD sekmesinde anahtarı etkinleştirdiğinizden emin olun.\n\nMirror kullanıyorsanız, düzgün çalıştığından emin olun. Varsayılan olmayan bir port kullanıyorsanız, bunu burada belirtmeniz gerekir.",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_OnlySupports(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @" iOS 系统中的 Revo Mirror 仅支持添加本地网络中的电脑",
                          @"zh_HK" : @"iOS 系統中的 Revo Mirror 僅支持添加本地網路中的電腦",
                          @"en_US" : @"Revo Mirror only supports adding PCs on your local network on iOS",
                          @"fr" : @"Revo Mirror prend en charge uniquement l’ajout de PC sur votre réseau local sous iOS.",
                          @"de" : @"Revo Mirror unterstützt unter iOS nur das Hinzufügen von PCs in Ihrem lokalen Netzwerk.",
                          @"it" : @"Revo Mirror supporta solo l’aggiunta di PC sulla rete locale in iOS.",
                          @"es" : @"Revo Mirror solo admite agregar PCs en su red local en iOS.",
                          @"ja" : @"Revo MirrorはiOSでローカルネットワーク上のPC追加のみ対応しています。",
                          @"ko" : @"Revo Mirror는 iOS에서 로컬 네트워크의 PC 추가만 지원합니다.",
                          @"ru" : @"Revo Mirror поддерживает добавление ПК только в локальной сети на iOS.",
                          @"pt" : @"O Revo Mirror só oferece suporte para adicionar PCs na rede local no iOS.",
                          @"tr" : @"Revo Mirror, iOS’ta yalnızca yerel ağınızdaki PC’leri eklemeyi destekler.",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_HostInformationUpdated(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"Host 信息已更新",
                          @"zh_HK" : @"Host 資訊已更新",
                          @"en_US" : @"Host information updated",
                          @"fr" : @"Informations de l’hôte mises à jour",
                          @"de" : @"Hostinformationen aktualisiert",
                          @"it" : @"Informazioni host aggiornate",
                          @"es" : @"Información del host actualizada",
                          @"ja" : @"ホスト情報が更新されました",
                          @"ko" : @"호스트 정보가 업데이트되었습니다",
                          @"ru" : @"Информация о хосте обновлена",
                          @"pt" : @"Informações do host atualizadas",
                          @"tr" : @"Ana bilgisayar bilgileri güncellendi",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_HostUnreachable(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"Host 无法访问",
                          @"zh_HK" : @"Host 無法訪問",
                          @"en_US" : @"Host is unreachable",
                          @"fr" : @"Hôte injoignable",
                          @"de" : @"Host nicht erreichbar",
                          @"it" : @"Host non raggiungibile",
                          @"es" : @"El host no es accesible",
                          @"ja" : @"ホストに接続できません",
                          @"ko" : @"호스트에 연결할 수 없습니다",
                          @"ru" : @"Хост недоступен",
                          @"pt" : @"Host inacessível",
                          @"tr" : @"Ana bilgisayara ulaşılamıyor",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_FailedToPC(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"无法连接到电脑",
                          @"zh_HK" : @"無法連接到電腦",
                          @"en_US" : @"Failed to connect to PC",
                          @"fr" : @"Échec de connexion au PC",
                          @"de" : @"Verbindung zum PC fehlgeschlagen",
                          @"it" : @"Connessione al PC non riuscita",
                          @"es" : @"Error al conectar al PC",
                          @"ja" : @"PCに接続できませんでした",
                          @"ko" : @"PC에 연결하지 못했습니다",
                          @"ru" : @"Не удалось подключиться к ПК",
                          @"pt" : @"Falha ao conectar ao PC",
                          @"tr" : @"PC’ye bağlanılamadı",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_DeviceNotPaired(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"设备与电脑未配对",
                          @"zh_HK" : @"設備與電腦未配對",
                          @"en_US" : @"Device not paired to PC",
                          @"fr" : @"Appareil non appairé au PC",
                          @"de" : @"Gerät nicht mit PC gekoppelt",
                          @"it" : @"Dispositivo non associato al PC",
                          @"es" : @"Dispositivo no emparejado con el PC",
                          @"ja" : @"デバイスがPCとペアリングされていません",
                          @"ko" : @"장치가 PC와 페어링되지 않았습니다",
                          @"ru" : @"Устройство не сопряжено с ПК",
                          @"pt" : @"Dispositivo não pareado ao PC",
                          @"tr" : @"Cihaz PC ile eşleştirilmedi",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_DoesnotSupport4K(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"您的 Host 电脑的 GPU 不支持超过 4K 的流视频分辨率。",
                          @"zh_HK" : @"您的 Host 電腦的 GPU 不支持超過 4K 的流視頻解析度。",
                          @"en_US" : @"Your host PC's GPU doesn't support streaming video resolutions over 4K.",
                          @"fr" : @"Le GPU de votre PC hôte ne prend pas en charge le streaming vidéo au-delà de 4K.",
                          @"de" : @"Die GPU Ihres Host-PCs unterstützt kein Video-Streaming über 4K.",
                          @"it" : @"La GPU del PC host non supporta lo streaming video oltre il 4K.",
                          @"es" : @"La GPU de su PC anfitrión no admite transmisión de video de más de 4K.",
                          @"ja" : @"ホストPCのGPUは4Kを超える動画配信解像度に対応していません。",
                          @"ko" : @"호스트 PC의 GPU는 4K 이상의 영상 스트리밍 해상도를 지원하지 않습니다.",
                          @"ru" : @"GPU вашего ПК не поддерживает потоковое видео выше 4K.",
                          @"pt" : @"A GPU do seu PC host não suporta streaming de vídeo acima de 4K.",
                          @"tr" : @"Ana bilgisayar PC’nizin GPU’su 4K üzerindeki video akışını desteklemiyor.",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_FailedLaunchApp(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"无法启动应用程序",
                          @"zh_HK" : @"無法啟動應用程式",
                          @"en_US" : @"Failed to launch app",
                          @"fr" : @"Échec du lancement de l’application",
                          @"de" : @"App konnte nicht gestartet werden",
                          @"it" : @"Avvio app non riuscito",
                          @"es" : @"Error al iniciar la aplicación",
                          @"ja" : @"アプリを起動できませんでした",
                          @"ko" : @"앱을 실행하지 못했습니다",
                          @"ru" : @"Не удалось запустить приложение",
                          @"pt" : @"Falha ao iniciar o aplicativo",
                          @"tr" : @"Uygulama başlatılamadı",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}

NSString* RMI_MirrorStr_FailedResumeApp(void) {
    NSDictionary *dic = @{
                          @"zh_CN" : @"无法恢复应用程序",
                          @"zh_HK" : @"無法恢復應用程式",
                          @"en_US" : @"Failed to resume app",
                          @"fr" : @"Échec de la reprise de l’application",
                          @"de" : @"App konnte nicht fortgesetzt werden",
                          @"it" : @"Ripresa app non riuscita",
                          @"es" : @"Error al reanudar la aplicación",
                          @"ja" : @"アプリを再開できませんでした",
                          @"ko" : @"앱을 다시 시작하지 못했습니다",
                          @"ru" : @"Не удалось возобновить приложение",
                          @"pt" : @"Falha ao retomar o aplicativo",
                          @"tr" : @"Uygulama devam ettirilemedi",
                          };
    NSString *result = dic[[UIDevice LanguageInter]];
    return result;
}
