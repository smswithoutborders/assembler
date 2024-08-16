# Assembler Documentation

**Assembler** is a bash script designed to streamline the setup, cloning, and deployment of the RelaySMS units. It automates the process of bringing together all the components and starting the project.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Configuration](#configuration)
   - [Setting Up the Configuration](#setting-up-the-configuration)
3. [Script Installation](#script-installation)
   - [Installation Steps](#installation-steps)
4. [Usage](#usage)
   - [Basic Syntax](#basic-syntax)
   - [Commands](#commands)
     - [Clone Command](#clone-command)
     - [Deploy Command](#deploy-command)
     - [Certs Command](#certs-command)
     - [Drop Command](#drop-command)
5. [Example Scenarios](#example-scenarios)
6. [Contributions](#contributions)

---

**Assembler** is a versatile tool for setting up and deploying the RelaySMS units. By automating the tasks of cloning repositories, configuring environments, and deploying services, Assembler ensures a smooth and efficient deployment process.

---

## Prerequisites

Before using Assembler, make sure you have the following dependencies installed on your system:

- **Git**: Required for cloning and updating repositories.
- **Docker**: Essential for deploying the projects.
- **Docker Compose**: Necessary for managing multi-container Docker applications.

---

## Configuration

To configure your deployment, you'll need to set up environment variables in a `.env` file. These variables control various aspects of your application's behavior, such as the hosts, credentials, encryption keys, and third-party services.

### Setting Up the Configuration

1. **Copy the Example File**:
   Start by copying the `.env.example` file to `.env`:

   ```bash
   cp .env.example .env
   ```

2. **Edit the `.env` File**:
   Open the `.env` file in a text editor and configure the necessary variables. Below is a detailed explanation of each configuration variable:

   **Description of Configurations:**

   - **HOMEPAGE_HTTP_HOST**: Set this to the base URL or IP address where the homepage service will be accessible.
   - **VAULT_HTTP_HOST** & **VAULT_gRPC_HOST**: These should point to the URLs or IP addresses where the Vault service is hosted, using HTTP and gRPC protocols respectively.
   - **PUBLISHER_HTTP_HOST** & **PUBLISHER_gRPC_HOST**: Define the HTTP and gRPC hosts for the Publisher service.
   - **GATEWAY_SERVER_HTTP_HOST**: Set this to the base URL or IP address for the Gateway server.
   - **GATEWAY_SERVER_FTP\_\* variables**: Configure the FTP access details for file transfer operations on the Gateway server.
   - **GATEWAY_SERVER_IMAP\_\* variables**: Set up the IMAP server details for email retrieval and processing on the Gateway server.
   - **GATEWAY_CLIENT_REMOTE_HTTP_HOST**: Specify the HTTP host for the remote client that interacts with the Gateway server.
   - **PUBLISHER_ENCRYPTION_KEY**: A secure key for encrypting data within the Publisher service `(Will be deprecated in V3)`.
   - **HASHING_SALT**: Path to a file containing a random value used to hash data.
   - **SHARED_KEY**: Path to a file containing a random value used to encrypt data.
   - **SSL_CERTIFICATE\_\* variables**: Paths to your SSL/TLS certificates, which are necessary for securing your application with HTTPS.
   - **MYSQL\_\* variables**: MySQL database credentials for accessing the database securely.
   - **RABBITMQ\_\* variables**: RabbitMQ broker credentials, essential for message queuing between services.
   - **RECAPTCHA\_\* variables**: Keys for integrating Google reCAPTCHA into your application for bot protection.
   - **THIRD_PARTY_CREDENTIALS_PATH**: Path to a directory containing credentials for third-party services.
   - **KEYSTORE_PATH**: Path to a directory where vault keypairs are stored.
   - **BROADCAST_WHITELIST**: Path to a file containing IP addresses allowed to send broadcast messages within your network `(Will be deprecated in V3)`.
   - **TWILIO\_\* variables**: Twilio API credentials for managing OTP services, including account SID, authentication token, and service SID.
   - **MOCK_OTP**: (Optional) A static OTP value used for testing environments without real OTPs.
   - **DEKU_CLOUD\_\* variables**: Configuration for connecting to Deku Cloud services, including authentication details and service references.

---

## Script Installation

### Installation Steps

1. **Clone the Assembler Repository**:
   Begin by cloning the Assembler repository:

   ```bash
   git clone https://github.com/smswithoutborders/assembler.git
   cd assembler
   ```

2. **Install the Script**:
   Run the following command to install the script and create a symbolic link:

   ```bash
   ./assembler.sh install
   ```

   This command will allow you to run `assembler` from any directory on your system.

---

## Usage

Assembler offers a variety of commands to manage the setup and deployment of RelaySMS units.

### Basic Syntax

```bash
assembler [command] [options]
```

### Commands

#### Clone Command

The `clone` command is used to clone repositories or update existing ones.

- **Usage**:

  ```bash
  assembler clone [options]
  ```

- **Options**:

  - **`--branch BRANCH`**: Specify the branch to clone or update.
  - **`--project PROJECT`**: (Optional) Specify a project to clone or update. If omitted, all projects are cloned or updated.

- **Example**:

  ```bash
  assembler clone --branch develop --project my-repo
  ```

#### Deploy Command

The `deploy` command is used to deploy the projects, optionally using a reverse proxy and management tools.

- **Usage**:

  ```bash
  assembler deploy [options]
  ```

- **Options**:

  - **`--proxy`**: Use a reverse proxy (Nginx).
  - **`--management`**: Include management tools (Portainer).
  - **`--project PROJECT`**: (Optional) Specify a project to deploy.

- **Example**:

  ```bash
  assembler deploy --proxy --management --project my-repo
  ```

#### Certs Command

The `certs` command is used to copy SSL certificates from Let's Encrypt.

- **Usage**:

  ```bash
  assembler certs --letsencrypt example.com --destination mydomain.com
  ```

- **Options**:

  - **`--letsencrypt DOMAIN`**: Specifies the domain name associated with Let's Encrypt certificates. The domain name is used to locate the certificate files in the directory path `/etc/letsencrypt/live/DOMAIN/`. This directory contains the necessary certificate files for the specified domain.

  - **`--destination DOMAIN`**: Defines the destination domain name for the certificates. The domain name is appended to the `/etc/ssl/certs/DOMAIN/` path, where the certificate files will be stored. This directory will hold the certificates required for secure communication for the specified domain.

#### Drop Command

The `drop` command stops and removes containers, with an optional flag to delete their images.

- **Usage**:

  ```bash
  assembler drop [options]
  ```

- **Options**:

  - **`--remove-images`**: Remove Docker images after stopping and removing containers.
  - **`--project PROJECT`**: (Optional) Specify a project to drop.

---

## Example Scenarios

Here are some example scenarios that demonstrate how to use Assembler:

1. **Clone a specific branch for all projects**:

   ```bash
   assembler clone --branch feature-branch
   ```

2. **Update a specific project on the default branch**:

   ```bash
   assembler clone --project my-repo
   ```

3. **Deploy all projects behind a reverse proxy**:

   ```bash
   assembler deploy --proxy
   ```

4. **Deploy a specific project with management tools included**:

   ```bash
   assembler deploy --project my-repo --management
   ```

---

## Contributions

Contributions to the Assembler project are welcome! If you have any improvements or additional features to contribute, feel free to fork the repository and submit a pull request.
