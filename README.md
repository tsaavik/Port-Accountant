# Port-Accountant

A lightweight shell script utility for monitoring and tracking network connections to your server ports in real-time.

## Overview

Port-Accountant helps system administrators and security professionals easily identify which hosts are attempting to connect to specific services on their servers. It provides a clean, continuously updating list of connecting hosts with reverse DNS lookups for better visibility into network traffic patterns.

## Features

- **Real-time monitoring** - Continuously tracks and displays new connections
- **Reverse DNS resolution** - Shows both hostname and IP address for each connecting host
- **Multi-homed server support** - Optional destination host specification for servers with multiple IP addresses
- **Lightweight** - Simple shell script with minimal resource usage
- **Clean output** - Easy-to-read format showing connection timestamps and host information

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/tsaavik/Port-Accountant.git
   cd Port-Accountant
   ```

2. Make the script executable:
   ```bash
   chmod +x paccount.sh
   ```

## Usage

### Basic Usage

Monitor connections to a specific port:
```bash
./paccount.sh 80
```

### Multi-homed Servers

For servers with multiple IP addresses, specify the destination host:
```bash
./paccount.sh 80 1.2.3.4
```

### Example Output

```
The following 3 hosts have connected to port 80 of www.hellspark.com since Fri Oct 30 13:46
crawl-66-249-65-124.googlebot.com(66.249.65.124)
msnbot-157-55-39-12.search.msn.com(157.55.39.12)
s420.pingdom.com(72.46.130.42)

The program will continue to run updating the list above until canceled...
```

## Use Cases

- **Security monitoring** - Track unauthorized connection attempts
- **Web server analysis** - Monitor crawler and bot activity
- **Network troubleshooting** - Identify connection patterns and sources
- **Service monitoring** - Verify expected clients are connecting
- **Compliance auditing** - Log and track access to sensitive services

## Requirements

- Unix-like operating system (Linux, macOS, etc.)
- Standard shell utilities (`netstat`, `awk`, `sort`, etc.)
- Appropriate permissions to read network connection information

## How It Works

Port-Accountant uses system networking tools to:
1. Monitor active and recent connections to specified ports
2. Extract source IP addresses and connection information
3. Perform reverse DNS lookups to resolve hostnames
4. Display results in a clean, continuously updating format

## Command Line Parameters

| Parameter | Description | Required |
|-----------|-------------|----------|
| `PORT` | Port number to monitor | Yes |
| `DEST_HOST` | Destination IP address (for multi-homed servers) | No |

## Stopping the Script

To stop monitoring, use `Ctrl+C` (SIGINT) to gracefully exit the program.

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

This project is available under the terms specified in the repository. Please check the license file for details.

## Support

If you encounter any issues or have questions, please open an issue on the GitHub repository.

---

**Note**: This tool is designed for legitimate system administration and security monitoring purposes. Always ensure you have proper authorization before monitoring network traffic on systems you don't own.