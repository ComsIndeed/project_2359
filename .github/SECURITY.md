# Security Policy

## Workflow Security

### Implemented Security Measures

This repository implements the following security measures in GitHub Actions workflows:

#### 1. Script Injection Prevention
- **User-controlled data** (PR titles, usernames, etc.) are passed through environment variables and file-based mechanisms instead of being directly interpolated into shell commands
- All version strings are validated against semantic versioning patterns before use
- Changelog extraction uses safe variable passing in AWK scripts

#### 2. Action Version Pinning
- All GitHub Actions are pinned to specific versions with comments for maintainability
- Regular updates to action versions should be performed to get security patches

#### 3. Secure File Operations
- Temporary files use `mktemp -d` for secure directory creation
- File operations are restricted to specific directories with `-maxdepth` flags
- Symlinks are not followed in `find` operations
- Proper cleanup with trap handlers

#### 4. Input Validation
- Version numbers are validated against semantic versioning regex patterns
- File paths are sanitized before use
- Special characters are filtered from user input

#### 5. Secrets Management
- Secrets are only exposed where necessary
- EXPO_TOKEN is passed directly to commands rather than redundantly in environment

### Security Best Practices

When modifying workflows, follow these guidelines:

1. **Never interpolate user-controlled data directly in shell commands**
   - Bad: `echo "Title: ${{ github.event.pull_request.title }}"`
   - Good: Use environment variables and file-based approaches

2. **Always validate input format**
   - Use regex patterns to validate versions, paths, and other inputs
   - Reject invalid input early

3. **Pin action versions**
   - Use specific version tags (e.g., `@v4.2.2`)
   - Consider using commit SHAs for maximum security

4. **Limit permissions**
   - Use minimum required permissions for each job
   - Avoid `permissions: write-all`

5. **Use secure temporary files**
   - Use `mktemp -d` for temporary directories
   - Set up trap handlers for cleanup
   - Avoid predictable paths in `/tmp`

6. **Restrict file operations**
   - Use `-maxdepth` with find commands
   - Don't follow symlinks unless necessary
   - Validate paths before file operations

## Reporting Security Issues

If you discover a security vulnerability, please report it by:
1. Creating a private security advisory on GitHub
2. Emailing the maintainers directly (if configured)

Please do not open public issues for security vulnerabilities.

## Security Update Policy

- Security patches are applied as soon as possible
- Action versions are reviewed quarterly for updates
- Dependencies are monitored for known vulnerabilities
