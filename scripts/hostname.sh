
# ================ FROM `scripts/hostname.sh` ==================

ensure_host_entry() {
  # Adds an entry to /etc/hosts
  # $1 - The IP address for which to set a hosts entry
  # $* - The domain name(s) which should resolve to the IP address
  local -r ip_address="$1"; shift

  if [ -z "$ip_address" -o "$#" -lt 1 ]; then
    printf 'IP address and/or domain is not defined\n'
    return 1;
  fi

  for host in "$@"; do
    # Overwrite hosts entry if exists
    if grep -qEe '^'"$ip_address"'\s+' /etc/hosts; then
      # Only add it if it's not already set
      if ! grep -qEe '^'"$ip_address"'\s+(.+\s+)*'"$host"'(\s+|$)' /etc/hosts; then
        perl -i -pe's/^('"$ip_address"'\s+.*)$/\1 '"$host"'/g' /etc/hosts 1>/dev/null
      fi
    else
      # Is not set so let's add it
      printf '%s %s\n' "$ip_address" "$host" >> /etc/hosts
    fi
  done
}

printf '>>>  Reading the nameserver entries from /etc/resolv.conf in case Linode injects it directly\n'
NS=`awk '/^nameserver/ { print $2 }' /etc/resolv.conf | tr '\n' ' ' | sed -e 's/ *$//g'`

printf '>>>  Setting hostname\n'
hostnamectl set-hostname "${hostname}.${domain}"

printf '>>>  Correcting the search domain from %s to %s\n' "members.linode.com" "${domain}"
nmcli connection modify eth0 +ipv4.dns-search "${domain}"
nmcli connection modify eth0 -ipv4.dns-search 'members.linode.com'

printf '>>>  Translating misconfigured resolv.conf settings to NetworkManager\n'
nmcli connection modify eth0 ipv4.dns "$NS"
nmcli connection up eth0

printf '>>>  Setting FQDN and hostname of self in /etc/hosts\n'
ensure_host_entry '127.0.0.1' 'localhost' "${hostname}.${domain}" "${hostname}"
ensure_host_entry '::1' 'localhost' "${hostname}.${domain}" "${hostname}"
