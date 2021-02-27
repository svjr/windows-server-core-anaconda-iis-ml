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
