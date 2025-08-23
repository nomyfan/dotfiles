function proxy() {
  local action="on"
  local global=false
  local port=7890
  local enable_socks=true
  local network="Wi-Fi"
  local host="127.0.0.1"

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      on|off)
        action="$1"
        shift
        ;;
      --global)
        global=true
        shift
        ;;
      --port)
        port="$2"
        shift 2
        ;;
      --socks)
        enable_socks="$2"
        shift 2
        ;;
      --network)
        network="$2"
        shift 2
        ;;
      --host)
        host="$2"
        shift 2
        ;;
      *)
        echo "Usage: proxy [on|off] [--global] [--port PORT] [--socks true|false] [--network NETWORK] [--host HOST]"
        echo "  on|off:       Enable or disable proxy (default: on)"
        echo "  --global:     Use system-wide proxy instead of environment variables"
        echo "  --port:       Proxy port (default: 7890)"
        echo "  --socks:      Enable SOCKS proxy (default: true)"
        echo "  --network:    Network interface name (default: Wi-Fi)"
        echo "  --host:       Proxy host address (default: 127.0.0.1)"
        return 1
        ;;
    esac
  done

  if [[ "$action" == "on" ]]; then
    if [[ "$global" == true ]]; then
      # Global proxy (system-wide)
      networksetup -setwebproxy "$network" "$host" "$port"
      networksetup -setwebproxystate "$network" on
      networksetup -setsecurewebproxy "$network" "$host" "$port"
      networksetup -setsecurewebproxystate "$network" on

      if [[ "$enable_socks" == true ]]; then
        networksetup -setsocksfirewallproxy "$network" "$host" "$port"
        networksetup -setsocksfirewallproxystate "$network" on
      else
        networksetup -setsocksfirewallproxystate "$network" off
      fi
    else
      # Environment variable proxy
      export https_proxy="http://$host:$port"
      export HTTPS_PROXY="http://$host:$port"
      export http_proxy="http://$host:$port"
      export HTTP_PROXY="http://$host:$port"

      if [[ "$enable_socks" == true ]]; then
        export all_proxy="socks5h://$host:$port"
        export ALL_PROXY="socks5h://$host:$port"
      else
        unset all_proxy
        unset ALL_PROXY
      fi
    fi
  else
    # Turn off proxy
    if [[ "$global" == true ]]; then
      # Disable global proxy
      networksetup -setwebproxystate "$network" off
      networksetup -setsecurewebproxystate "$network" off
      networksetup -setsocksfirewallproxystate "$network" off
    else
      # Unset environment variables
      unset https_proxy
      unset HTTPS_PROXY
      unset http_proxy
      unset HTTP_PROXY
      unset all_proxy
      unset ALL_PROXY
    fi
  fi
}

alias pon="proxy on"
alias poff="proxy off"
alias gpon="proxy on --global"
alias gpoff="proxy off --global"