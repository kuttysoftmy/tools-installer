# **Tools Installer**

🚀 A cross-platform installer toolkit with interactive menus for Windows (PowerShell) and Linux/macOS (Bash).
It simplifies initial machine setup for dev, automation, and AI workflows.

## Run in CMD
```
curl -o tools-installer.ps1 https://raw.githubusercontent.com/kuttysoftmy/tools-installer/main/tools-installer.ps1 && powershell -ExecutionPolicy Bypass -File tools-installer.ps1

```

## Run on Linux / macOS
```bash
curl -fsSL -o tools-installer.sh https://raw.githubusercontent.com/kuttysoftmy/tools-installer/main/tools-installer.sh && chmod +x tools-installer.sh && ./tools-installer.sh
```

<details>
  <summary>Other commands</summary>
  
## **Curl Command**
```
curl -o tools-installer.cmd https://raw.githubusercontent.com/kuttysoftmy/tools-installer/main/tools-installer.cmd && tools-installer.cmd

```
## **Run in PowerShell or CMD 🖥️**
```
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/kuttysoftmy/tools-installer/main/tools-installer.cmd?$(Get-Date -Format yyyyMMddHHmmss)' -OutFile tools-installer.cmd; Start-Process tools-installer.cmd"

```
## **To Run Strictly in Powershell**
```

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/kuttysoftmy/tools-installer/main/tools-installer.cmd?$(Get-Date -Format yyyyMMddHHmmss)" -OutFile "$env:TEMP\tools-installer.cmd";
Start-Process "$env:TEMP\tools-installer.cmd" -Verb RunAs

```
</details>

## **✨ Features**

*   **🧭 Interactive Menu**: Select categories and install tools with single-key choices.
*   **🛠️ Developer Essentials**: Install Chocolatey, Node.js LTS, OpenClaw (AutoClaw), Docker Desktop, and Kubernetes CLI (`kubectl`).
*   **🤖 AI + Automation**: Install Gemini CLI, Qwen CLI, n8n, and run LLM helper tools.
*   **⚙️ Script Shortcuts**: Launch useful tools like Chris Titus, MassGrave, Coporton, Sparkle, and GHGrab.
*   **🔐 PowerShell Policy Helpers**: Quickly view and update execution policy.
*   **🐧🍎 Linux/macOS Support**: Use `tools-installer.sh` for Bash-based installation flow across Linux and macOS.

## **📋 Key Menu Options**

1.  **[Essential] Install Chocolatey**: Installs the Chocolatey package manager.
2.  **[Essential] Install Node.js LTS**: Installs the LTS version of Node.js.
3.  **[Essential] Install OpenClaw (AutoClaw)**: Installs OpenClaw via winget package `ZhipuAI.AutoClaw`.
4.  **[Essential] Install Docker Desktop**: Installs Docker Desktop via winget.
5.  **[Essential] Install Kubernetes CLI (`kubectl`)**: Installs `kubectl` via winget.
6.  **[PowerShell Tweaks] See Policy**: Displays current PowerShell execution policy.
7.  **[PowerShell Tweaks] Unrestrict Policy**: Sets execution policy to Unrestricted.
8.  **[Run Scripts] Chris Titus / MassGrave / Coporton / Sparkle / GHGrab**: Launches common helper scripts.
9.  **[Recommended Tools] Git / Python / .NET / FFmpeg / 7-Zip / WinDirStat / yt-dlp / ngrok**: Installs dev and utility tools.
10. **[AI in PC] Gemini CLI / Qwen CLI / Ollama / LLM-Checker**: Installs and runs local AI tooling.

## **Prerequisites**

*   Windows, Linux, or macOS.
*   Administrative privileges (`Run as Administrator` / `sudo`) to install packages.
*   Internet connection for downloading tools and scripts.

## **🧪 Usage**

1.  Choose the installer script for your OS.
2.  On Windows, run `tools-installer.ps1` in elevated PowerShell.
3.  On Linux/macOS, run `tools-installer.sh` in terminal (use `sudo` when prompted).
4.  Use the interactive menu and press the shown keys.
5.  Follow on-screen prompts to install tools or run scripts.
6.  For CLI tools (`n8n`, `gemini`, `qwen`, `kubectl`, `docker`), open a new terminal after installation.

## **Linux / macOS Steps**

1.  Download the script:
```bash
curl -fsSL -o tools-installer.sh https://raw.githubusercontent.com/kuttysoftmy/tools-installer/main/tools-installer.sh
```
2.  Make it executable:
```bash
chmod +x tools-installer.sh
```
3.  Run it:
```bash
./tools-installer.sh
```
4.  If a package needs elevated permission, enter your `sudo` password when prompted.

## **Installation Notes**

*   **Chocolatey**: Required for installing Node.js, Python, and Git. Ensure option 3 is run before options 4, 8, or 9 if Chocolatey is not already installed.
*   **PowerShell Policy**: Options 1 and 2 help manage PowerShell execution policies, which may be required for some scripts.
*   **CLI Tools**: After installing n8n, Gemini CLI, Qwen CLI, OpenClaw (AutoClaw), Docker, or kubectl, open a new command prompt and run their commands (`n8n`, `gemini`, `qwen`, `autoclaw`, `docker`, `kubectl`).

## **License**

This project is licensed under the MIT License. See the [LICENSE](https://github.com/kuttysoftmy/tools-installer/blob/main/LICENSE) file for details.

## **Contributing**

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes with clear messages.
4. Open a pull request.

Please review [CONTRIBUTING.md](https://github.com/kuttysoftmy/tools-installer/blob/main/CONTRIBUTING.md), [CODE_OF_CONDUCT.md](https://github.com/kuttysoftmy/tools-installer/blob/main/CODE_OF_CONDUCT.md), and [CITATION.cff](https://github.com/kuttysoftmy/tools-installer/blob/main/CITATION.cff) before submitting.

## **Author**

Created by Angela Tamil. Follow me on Instagram: [@kuttysoftmy](https://instagram.com/kuttysoftmy).

## **Disclaimer**

This script downloads and executes third-party tools and scripts. Use at your own risk. Ensure you understand the purpose of each tool/script before running. The author is not responsible for any damages or issues caused by the use of this script.

Once you get addicted to winning, no chance you would lose
Work 24/7 and when you start see yourself going up, you would see that the before was boring
The first time win is difficult once you won you would see that it is not that difficult i have done it before 
