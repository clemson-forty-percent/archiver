# GitHub Archiver

Archive script to produce an archive of repository data, and commit it.

## Requirements

The following are required:

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
