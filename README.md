# Assembler

`assembler.sh` is a bash script designed to streamline the process of cloning or updating repositories and deploying projects.

## Prerequisites

- **Git**: Ensure you have Git installed to clone or update repositories.
- **Docker**: Docker is required to deploy the projects.
- **Docker Compose**: Docker Compose should be installed to manage multi-container Docker applications.

## Usage

The script provides two main commands: `clone` and `deploy`, each with its own set of options. Below are detailed instructions on how to use each command.

### Basic Syntax

```bash
./assembler.sh [command] [options]
```

### Commands

- **`clone`**: Clone or update the specified repositories.
- **`deploy`**: Deploy the specified projects.

### Global Options

- **`--project PROJECT`**: Specify a particular project to clone/update or deploy. This option is optional for both commands. If not provided, the script operates on all projects.

### Command-Specific Options

#### `clone` Command

This command is used to clone repositories or update existing ones.

- **Usage**:

  ```bash
  ./assembler.sh clone [options]
  ```

- **Options**:

  - **`--branch BRANCH`**: Specify a branch to clone or update. If not provided, the default branch is used.
  - **`--project PROJECT`**: (Optional) Specify a project to clone or update. If omitted, all projects are cloned or updated.

- **Example**:

  ```bash
  ./assembler.sh clone --branch develop --project my-repo
  ```

  This command clones or updates the `my-repo` repository on the `develop` branch.

#### `deploy` Command

This command is used to deploy the projects, with optional reverse proxy and management tools.

- **Usage**:

  ```bash
  ./assembler.sh deploy [options]
  ```

- **Options**:

  - **`--proxy`**: Use a reverse proxy (e.g., Nginx Proxy Manager). This option binds the projects behind a proxy.
  - **`--management`**: Include management tools (e.g., Portainer, Nginx Manager) in the deployment.
  - **`--project PROJECT`**: (Optional) Specify a project to deploy. If omitted, all projects are deployed.

- **Example**:

  ```bash
  ./assembler.sh deploy --proxy --management --project my-repo
  ```

  This command deploys the `my-repo` project, using a reverse proxy and including management tools.

## Example Scenarios

1. **Clone a specific branch for all projects**:

   ```bash
   ./assembler.sh clone --branch feature-branch
   ```

2. **Update a specific project on the default branch**:

   ```bash
   ./assembler.sh clone --project my-repo
   ```

3. **Deploy all projects behind a reverse proxy**:

   ```bash
   ./assembler.sh deploy --proxy
   ```

4. **Deploy a specific project with management tools included**:
   ```bash
   ./assembler.sh deploy --project my-repo --management
   ```

## Contributions

Feel free to fork this repository and submit pull requests if you have any improvements or additional features to contribute.
