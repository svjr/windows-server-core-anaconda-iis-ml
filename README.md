# Docker - Windows Server Core + Anaconda + IIS
## _Ambiente Base Para Execução Machine Learning_


## Descrição
Este projeto tem como objetivo montar um ambiente base para execução de aplicativos Python em um ambiente Anaconda. Disponibiza também o IIS configurado e com WFASTCGI habilitado para possível integração com biblioteca Flask do Python.

Principais características:
- Imagem Base - mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
- WFASTCGI Configurado e habilitado
- Alteração do Registro do sistema Operacional para já executar o anaconda ao abrir o Command Prompt (CMD)
- Configuração do Enviroment Global (PATH) apontando para o enviroment (base) do Anaconda
- Instala o IIS UrlRewrite e Habilita o .NET 4.5 no IIS 

## Informações Importantes - Versão 1.0
Principais características:
- Versão Anaconda:  4.9.2
- Python : 3.8.5
- Framework .NET : 4.5
- IIS: 10.0

## Informações Importantes - Versão 1.1
- Nesta versão foi adicionado o um novo usuário ( User03 ) com password ( 123XYab ) ao grupo IIS_IUSRS para execução de aplicações via fastCgi

## Informações Importantes - Versão 1.2
- Instalado e Habilitado o IIS Remote Management
- Configurado o usuário iisadmin com senha 'Password~1234'   (com aspas)

## Informações Importantes - Versão 1.3
- Adição do "Application Initialization" (feature) do IIS
