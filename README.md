# GitHub Archiver

Archive script to produce an archive of public and private repositories, and commit it to a destination repository elsewhere on GitHub.

## Requirements

The following are required:

- A source GitHub organization
- A destination GitHub repository that already exists
- A GitHub Personal-Access-Token with repo:commit access
- SSH-PublicKey Auth setup with GitHub
- An SSH client
- Bash
- Curl
- Git
- jq
- mktemp from GNU CoreUtils

## Usage

```bash
bash archive.sh "<GitHub_Token>" "<Source_Org>" "<Archive_User>" "<Archive_Repo>"
```
