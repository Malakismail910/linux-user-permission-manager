# Linux User & Permission Manager 🐧

A Bash-based command-line tool for managing Linux users, groups, passwords, file permissions, and basic security auditing.

## Features

- Create and delete users
- Create groups
- Add and remove users from groups
- Lock and unlock user accounts
- Change user passwords
- Change file permissions
- Change file ownership
- Display user information
- Perform a basic security audit

## Security Audit

The security audit checks:

- Users with UID 0
- Users with login shells
- Currently logged-in users
- Recent login history
- World-writable files in `/tmp`

## Technologies

- Bash
- Linux
- Linux User & Group Management
- File Permissions
- Basic Linux Security

## How to Run

Clone the repository:

```bash
git clone https://github.com/YOUR-USERNAME/linux-user-permission-manager.git
cd linux-user-permission-manager
