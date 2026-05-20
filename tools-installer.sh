#!/usr/bin/env bash

set -u

SCRIPT_NAME="Tool Installer Menu by Angela"
OS_TYPE=""
ARCH=""
PKG_MANAGER=""

COLOR_RESET="\033[0m"
COLOR_ACCENT="\033[1;36m"
COLOR_INFO="\033[1;32m"

print_section() {
  echo
  printf "${COLOR_INFO}==> %s${COLOR_RESET}\n" "$1"
}

print_banner() {
  clear
  printf "${COLOR_ACCENT}\n"
  echo "   ================================================"
  echo "   =              TOOLS INSTALLER                 ="
  echo "   =             by Angela Tamil                  ="
  echo "   ================================================"
  printf "${COLOR_RESET}"
  echo
}

pause_script() {
  printf "Press Enter to continue..."
  read -r _
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

run_privileged() {
  if [ "$(id -u)" -eq 0 ]; then
    bash -c "$*"
    return $?
  fi

  if command_exists sudo; then
    sudo bash -c "$*"
    return $?
  fi

  echo "This action needs elevated privileges, but sudo is not available."
  return 1
}

detect_environment() {
  case "$(uname -s)" in
    Darwin)
      OS_TYPE="macos"
      ;;
    Linux)
      OS_TYPE="linux"
      ;;
    *)
      echo "Unsupported OS: $(uname -s)"
      exit 1
      ;;
  esac

  ARCH="$(uname -m)"

  if command_exists brew; then
    PKG_MANAGER="brew"
  elif command_exists apt-get; then
    PKG_MANAGER="apt"
  elif command_exists dnf; then
    PKG_MANAGER="dnf"
  elif command_exists yum; then
    PKG_MANAGER="yum"
  elif command_exists pacman; then
    PKG_MANAGER="pacman"
  elif command_exists zypper; then
    PKG_MANAGER="zypper"
  else
    PKG_MANAGER="unknown"
  fi
}

install_homebrew() {
  print_banner
  print_section "Installing Homebrew"
  if command_exists brew; then
    echo "Homebrew is already installed."
    brew --version
    pause_script
    return
  fi

  if ! command_exists curl; then
    echo "curl is required to install Homebrew."
    pause_script
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  echo "Homebrew installation finished."
  pause_script
}

install_package() {
  package_name="$1"

  case "$PKG_MANAGER" in
    brew)
      brew install "$package_name"
      ;;
    apt)
      run_privileged "apt-get update -y && apt-get install -y $package_name"
      ;;
    dnf)
      run_privileged "dnf install -y $package_name"
      ;;
    yum)
      run_privileged "yum install -y $package_name"
      ;;
    pacman)
      run_privileged "pacman -Sy --noconfirm $package_name"
      ;;
    zypper)
      run_privileged "zypper --non-interactive install $package_name"
      ;;
    *)
      echo "No supported package manager found. Install manually."
      return 1
      ;;
  esac
}

install_git() {
  print_banner
  print_section "Installing Git"
  if command_exists git; then
    echo "Git is already installed: $(git --version)"
  else
    install_package git || true
  fi
  pause_script
}

install_python() {
  print_banner
  print_section "Installing Python 3"
  if command_exists python3; then
    echo "Python is already installed: $(python3 --version)"
  else
    case "$PKG_MANAGER" in
      brew) install_package python || true ;;
      *) install_package python3 || true ;;
    esac
  fi
  pause_script
}

install_node() {
  print_banner
  print_section "Installing Node.js"

  if command_exists node && command_exists npm; then
    echo "Node.js is already installed: $(node --version)"
    echo "npm is already installed: $(npm --version)"
    pause_script
    return
  fi

  case "$PKG_MANAGER" in
    brew)
      install_package node || true
      ;;
    apt)
      run_privileged "apt-get update -y && apt-get install -y nodejs npm" || true
      ;;
    dnf)
      run_privileged "dnf install -y nodejs npm" || true
      ;;
    yum)
      run_privileged "yum install -y nodejs npm" || true
      ;;
    pacman)
      run_privileged "pacman -Sy --noconfirm nodejs npm" || true
      ;;
    zypper)
      run_privileged "zypper --non-interactive install nodejs npm" || true
      ;;
    *)
      echo "No supported package manager found. Install Node.js manually."
      ;;
  esac

  pause_script
}

install_docker() {
  print_banner
  print_section "Installing Docker"

  if command_exists docker; then
    echo "Docker is already installed: $(docker --version)"
    pause_script
    return
  fi

  if [ "$OS_TYPE" = "macos" ]; then
    if [ "$PKG_MANAGER" != "brew" ]; then
      echo "Docker Desktop on macOS requires Homebrew in this installer flow."
      echo "Install Homebrew first, then retry."
    else
      brew install --cask docker || true
      echo "Docker Desktop installed. Open Docker app once to finish setup."
    fi
    pause_script
    return
  fi

  case "$PKG_MANAGER" in
    apt)
      run_privileged "apt-get update -y && apt-get install -y docker.io" || true
      ;;
    dnf)
      run_privileged "dnf install -y docker" || true
      ;;
    yum)
      run_privileged "yum install -y docker" || true
      ;;
    pacman)
      run_privileged "pacman -Sy --noconfirm docker" || true
      ;;
    zypper)
      run_privileged "zypper --non-interactive install docker" || true
      ;;
    brew)
      brew install --cask docker || true
      ;;
    *)
      echo "No supported package manager found. Install Docker manually."
      ;;
  esac

  if command_exists systemctl; then
    echo "Enabling Docker service..."
    run_privileged "systemctl enable docker --now" || true
  fi

  echo "If needed, add your user to the docker group:"
  echo "  sudo usermod -aG docker \$USER"
  pause_script
}

install_kubectl() {
  print_banner
  print_section "Installing kubectl"

  if command_exists kubectl; then
    echo "kubectl is already installed: $(kubectl version --client --short 2>/dev/null || kubectl version --client 2>/dev/null)"
    pause_script
    return
  fi

  if ! command_exists curl; then
    echo "curl is required to install kubectl."
    pause_script
    return
  fi

  tmp_dir="$(mktemp -d)"
  version="$(curl -L -s https://dl.k8s.io/release/stable.txt)"

  if [ "$OS_TYPE" = "macos" ]; then
    platform="darwin"
  else
    platform="linux"
  fi

  case "$ARCH" in
    x86_64|amd64) arch="amd64" ;;
    arm64|aarch64) arch="arm64" ;;
    *)
      echo "Unsupported CPU architecture for automated kubectl install: $ARCH"
      rm -rf "$tmp_dir"
      pause_script
      return
      ;;
  esac

  url="https://dl.k8s.io/release/${version}/bin/${platform}/${arch}/kubectl"
  target_file="${tmp_dir}/kubectl"

  echo "Downloading kubectl ${version}..."
  curl -L -o "$target_file" "$url"
  chmod +x "$target_file"

  run_privileged "install -m 0755 '$target_file' /usr/local/bin/kubectl" || true
  rm -rf "$tmp_dir"

  if command_exists kubectl; then
    echo "kubectl installation completed: $(kubectl version --client --short 2>/dev/null || kubectl version --client 2>/dev/null)"
  else
    echo "kubectl install could not be verified automatically."
  fi

  pause_script
}

install_n8n() {
  print_banner
  print_section "Installing n8n"
  if ! command_exists npm; then
    echo "Node.js/npm is required. Installing Node.js first..."
    install_node
  fi

  if command_exists npm; then
    npm install -g n8n@latest || true
    echo "n8n installation finished. Run: n8n"
  else
    echo "npm is still unavailable. Install failed."
  fi
  pause_script
}

install_gemini() {
  print_banner
  print_section "Installing Gemini CLI"
  if ! command_exists npm; then
    echo "Node.js/npm is required. Installing Node.js first..."
    install_node
  fi

  if command_exists npm; then
    npm install -g @google/gemini-cli@latest || true
    echo "Gemini CLI installation finished. Run: gemini"
  else
    echo "npm is still unavailable. Install failed."
  fi
  pause_script
}

install_qwen() {
  print_banner
  print_section "Installing Qwen CLI"
  if ! command_exists npm; then
    echo "Node.js/npm is required. Installing Node.js first..."
    install_node
  fi

  if command_exists npm; then
    npm install -g @qwen-code/qwen-code@latest || true
    echo "Qwen CLI installation finished. Run: qwen"
  else
    echo "npm is still unavailable. Install failed."
  fi
  pause_script
}

install_all_essentials() {
  install_git
  install_python
  install_node
  install_docker
  install_kubectl
}

show_menu() {
  print_banner
  echo "   OS: ${OS_TYPE} | Arch: ${ARCH} | Package Manager: ${PKG_MANAGER}"
  echo
  echo "   [1] Install Homebrew"
  echo "   [2] Install Git"
  echo "   [3] Install Python 3"
  echo "   [4] Install Node.js"
  echo "   [5] Install Docker"
  echo "   [6] Install Kubernetes CLI (kubectl)"
  echo "   [7] Install n8n"
  echo "   [8] Install Gemini CLI"
  echo "   [9] Install Qwen CLI"
  echo "   [A] Install All Essentials"
  echo "   [Z] Exit"
  echo
  printf "   Your choice: "
}

main() {
  detect_environment

  while true; do
    show_menu
    read -r choice
    choice_upper="$(printf '%s' "$choice" | tr '[:lower:]' '[:upper:]')"
    case "$choice_upper" in
      1) install_homebrew ;;
      2) install_git ;;
      3) install_python ;;
      4) install_node ;;
      5) install_docker ;;
      6) install_kubectl ;;
      7) install_n8n ;;
      8) install_gemini ;;
      9) install_qwen ;;
      A) install_all_essentials ;;
      Z)
        echo
        echo "Thanks for using Tool Installer by Angela."
        exit 0
        ;;
      *)
        echo "Invalid choice."
        pause_script
        ;;
    esac
  done
}

main
