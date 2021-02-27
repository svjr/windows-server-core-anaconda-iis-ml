############################################################################################
#															 
#  				 Windows Server Core + Anaconda + IIS 10                           
#  					Criado por Sérgio Valle Júnior                               
#  						Data: 28/02/2021                                       
#															 
############################################################################################
#															 
# Definição da Imagem Base a Ser Utilizada - Imagem da Microsoft Já com IIS Instalado	 
#															 
############################################################################################
FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
############################################################################################
#															 
# Adiciona o Label a nova imagem                                                    	 
#									                                     
############################################################################################
LABEL key="svj-windows-server-core-anaconda-iis-ml"
############################################################################################
#														       
# Cria os diretórios                                    			 
#															 
############################################################################################
RUN powershell.exe -Command \
    New-Item -ItemType Directory -Force -Path c:\anaconda ; \
    New-Item -ItemType Directory -Force -Path c:\msi ;
############################################################################################
#															 
# Seta as permissões nos diretórios criados                                			 
#															 
############################################################################################
RUN icacls c:\inetpub\wwwroot /grant IIS_IUSRS:(OI)(CI)F & \
    icacls c:\anaconda /grant  IIS_IUSRS:(OI)(CI)F &\
    icacls c:\msi /grant IIS_IUSRS:(OI)(CI)F  
############################################################################################
#															 
# Instala Ambiente Conda                                        					 
#															 
############################################################################################
RUN powershell Set-Location -Path C:\anaconda ; \
    (New-Object System.Net.WebClient).DownloadFile('https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe', 'c:\anaconda\Miniconda3.exe') ; \
    Unblock-File Miniconda3.exe ; \
    Start-Process "Miniconda3.exe" '/InstallationType=AllUsers /RegisterPython=1 /S /D=C:\anaconda' -Wait  ; \
    Remove-Item Miniconda3.exe
############################################################################################
#															 
# Instala o IIS UrlRewrite e Habilita o .NET 4.5 no IIS                                    
############################################################################################
RUN powershell -Command \
    Set-Location -Path c:\msi ; \
    Invoke-WebRequest 'http://download.microsoft.com/download/C/F/F/CFF3A0B8-99D4-41A2-AE1A-496C08BEB904/WebPlatformInstaller_amd64_en-US.msi' -OutFile c:/msi/WebPlatformInstaller_amd64_en-US.msi ; \
    Start-Process 'c:/msi/WebPlatformInstaller_amd64_en-US.msi' '/qn' -PassThru -Wait ; \
    Start-Process "C:/Program` Files/Microsoft/Web` Platform` Installer/WebpiCmd-x64.exe" -Args '/Install /Products:IIS-StaticContent,UrlRewrite2 /AcceptEULA /Log:c:/msi/WebpiCmd.log' -Wait ; \
    Remove-Item c:/msi/WebPlatformInstaller_amd64_en-US.msi ; \
    dism /online /enable-feature /featurename:IIS-ASPNET45 /all;
############################################################################################
#															 
# Seta variável o caminho do miniconda na variável PATH do sistema                         
#															 
############################################################################################
RUN setx /M PATH "%PATH%;C:\anaconda;C:\anaconda\Scripts;C:\anaconda\Library\bin"
############################################################################################
#																						   
# Expõe as porta                             				                   
#																						   
############################################################################################
EXPOSE 80
############################################################################################
#																						   
# Instalando o wfastcgi                                                                    
#																						   
############################################################################################
RUN conda install -n base -c conda-forge wfastcgi
############################################################################################
#																						   
# Altera o Identity Type do Pool de Aplicação do IIS
# e padroniza o terminal para que já abra o anaconda como default                                       
#																						   
############################################################################################
RUN powershell -Command \
    New-Item 'HKCU:\SOFTWARE\Microsoft\Command Processor' ; \
    Get-Item 'HKCU:\SOFTWARE\Microsoft\Command Processor' ; \
    New-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Command Processor' -Name 'AutoRun'  -value 'C:\anaconda\Scripts\activate.bat C:\anaconda' -Type ExpandString ; \
    Get-Item 'HKLM:\SOFTWARE\Microsoft\Command Processor' ; \
    New-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Command Processor' -Name 'AutoRun'  -value 'C:\anaconda\Scripts\activate.bat C:\anaconda' -Type ExpandString ; \
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-CGI ; \
    Import-Module WebAdministration; Set-ItemProperty IIS:\AppPools\DefaultAppPool -name processModel -value @{identitytype=0} ; \
    Import-Module WebAdministration; Get-ItemProperty IIS:\AppPools\DefaultAppPool -name processModel ;\
    Get-WebHandler -PsPath 'IIS:\Sites\Default Web Site';
############################################################################################
#																						   
# Configura o FASTCGI               				                                       
#																						   
############################################################################################
RUN powershell -Command \
    Import-Module WebAdministration;Add-WebConfiguration -Filter '/system.webServer/fastCgi' -Value @{fullPath='C:\anaconda\python.exe'; arguments='C:\anaconda\Lib\site-packages\wfastcgi.py'}
############################################################################################
#																						   
# Altera permissionamento da pasta wwwroot                				                   
#																						   
############################################################################################
RUN icacls c:\inetpub\wwwroot /grant IIS_IUSRS:(OI)(CI)F
