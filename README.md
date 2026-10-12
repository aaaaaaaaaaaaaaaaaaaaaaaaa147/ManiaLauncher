# ManiaLauncher v0.2.0 — Minecraft Java Edition launcher

**Projeto aberto (código-fonte completo neste ZIP).** Aplicativo de desktop para contas **Microsoft originais**, com separação de mundos, gerenciamento de modloaders, pesquisa de mods e backup local.

> ⚠️ **Status da entrega:** Código-fonte implementado e testes automatizados executáveis; **não** foi possível testar login real, downloads oficiais ou a inicialização do Minecraft em uma máquina Windows nesta sessão. **Não** acompanha `.exe` pré-compilado. O executável é gerado no Windows pelo `build-windows.ps1` (ou GitHub Actions). Não se deve confundir testes de módulos com testes completos de integração.

## O que existe no código

| Componente | Situação |
|---|---|
| UI Windows Tk/ttk com modo claro/escuro/AMOLED | Implementado; revisão visual em Windows pendente |
| Login OAuth 2.0 Microsoft PKCE, navegador + loopback e validação de estado | Implementado; depende de Azure App autorizado e teste real |
| Múltiplas contas e refresh de tokens | Implementado; teste de integração pendente |
| Credenciais criptografadas via DPAPI do usuário Windows | Implementado; validação Windows pendente |
| Instalação Vanilla, seleção de versões oficiais, jogo original e Java automático | Integrado via minecraft-launcher-lib v8; teste em Windows pendente |
| Fabric, Forge, NeoForge, Quilt | Integrado via API `mod_loader` da biblioteca; teste de instalação pendente |
| Perfis com pasta separada, RAM, Java opcional, duplicação, importar/exportar ZIP | Implementado |
| Busca Modrinth por versão/loader, SHA-512, dependências obrigatórias | Implementado parcialmente; comportamento de dependências complexas pode necessitar intervenção |
| Ativar/desativar mod .jar | Implementado |
| Backup/restauração ZIP de mundos | Implementado com validação de caminhos |
| Servidores favoritos, ping e autoentrada Java | Implementado; integração com servidores reais pendente |
| Estatísticas de tempo jogado e logs por instalação | Implementado |
| Skins e capas oficiais da conta | Exibição textual + visualização PNG 2D local; sem render 3D, edição ou troca |
| Importação/exportação de modpacks, CurseForge, skins e recursos avançados | Não implementado nesta versão |
| Bedrock para Windows | Apenas link oficial; **não** inicia ou gerencia instalação do Bedrock |
| Atualização automática do launcher | Não implementada nesta versão |
| Português / Inglês | Apenas interface principal em português nesta versão |

## Requisitos

- Windows 10/11 x64 (versão prioritária), Python 3.12 ou 3.13, conexão com Internet e **licença Minecraft Java**.
- Pacote `minecraft-launcher-lib` 8.x, instalado automaticamente por `pip`.
- Para **login Microsoft real**, é necessária uma aplicação pública no Microsoft Entra com tipo **Mobile and desktop applications**, URI de redirecionamento `http://localhost:8765/auth` e permissão de usar Minecraft Services, quando exigida. O ID da aplicação não é segredo; **nunca** configure client secret no launcher.
- Requisitos de Java variam conforme a versão do Minecraft. A biblioteca baixa o runtime oficial quando a versão o especifica. Caso contrário, instale Java apropriado ou defina o caminho no perfil.

## Executar via código-fonte

No Windows, abra `run-windows.bat`, ou execute:

```powershell
py -3 -m pip install -r requirements.txt
py -3 main.py
```

## Gerar `ManiaLauncher.exe` Windows

Abra o PowerShell no diretório extraído e execute:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-windows.ps1
```

Saída esperada: `dist\ManiaLauncher.exe` (portátil). Se o [Inno Setup 6](https://jrsoftware.org/isinfo.php) estiver instalado, o script também gera `dist\ManiaLauncher_Setup_0.2.0.exe` (instalador com atalhos e desinstalação). Isso requer Internet para instalar dependências e uma máquina Windows. Você também pode publicar o projeto num repositório GitHub e rodar o workflow em `.github/workflows/windows-build.yml`; o artefato sai como `ManiaLauncher-Windows-x64`, incluindo o instalador Inno Setup.

## Configurar autenticação Microsoft

1. Registre um aplicativo Microsoft Entra (tipo contas pessoais Microsoft suportado, conforme elegibilidade do tenant).
2. Adicione a plataforma **Mobile and desktop applications** e a URL `http://localhost:8765/auth`.
3. Solicite/aprove acesso para autenticação de Minecraft Services, se exigido. Sem esta autorização, a Microsoft pode retornar `AzureAppNotPermitted`.
4. Copie o **Application (client) ID** para Configurações no ManiaLauncher e salve.
5. Abra **Conta → Entrar com Microsoft**. O navegador abrirá; a senha nunca passa pelo launcher.
6. Depois da autorização, o app faz a troca do código PKCE e valida o perfil Minecraft Java.
7. Se houver firewall, libere a conexão localhost. O callback usa a porta 8765; registre exatamente a URL usada.

O login é **intencionalmente bloqueado** sem Client ID registrado. Não há conta offline, login por senha, crack ou bypass de licença. As credenciais só são persistidas no Windows com criptografia DPAPI associada ao usuário.

## Dados e privacidade

Arquivos em `%LOCALAPPDATA%\ManiaLauncher` (configuração, instâncias, Minecraft compartilhado, backups e logs). Tokens no arquivo `accounts.dpapi.json` são criptografados no Windows. No Linux não há persistência de tokens. O launcher não contém anúncios ou telemetria. Evite compartilhar diretórios de dados ou logs sem revisar informações pessoais. A remoção de conta apaga a cópia local, mas não invalida outros dispositivos/sessões Microsoft.

## Testes

```powershell
py -3 -m unittest discover -s tests -v
```

Os testes usam mocks para APIs externas. Para validar funcionalidade end-to-end será necessário realizar, em um Windows real, login licenciado, instalação Vanilla, instalação Fabric, testes de mods e inicialização de versões distintas.

## APIs / dependências

- [minecraft-launcher-lib](https://minecraft-launcher-lib.readthedocs.io/en/latest/) — dependência BSD-2-Clause, fornece downloads/instalações oficiais, Java Runtime e Microsoft auth.
- [Microsoft OAuth 2.0 para desktop](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow)
- [Modrinth API](https://docs.modrinth.com/api/)

`Minecraft`, `Mojang` e `Microsoft` são marcas dos respectivos titulares. ManiaLauncher é um projeto comunitário independente, não oficial.
