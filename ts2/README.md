# Filecoin Trusted-Setup #2

Filecoin's second trusted-setup (run Dec-2021 - Jan-2022) generates Groth16 keys for four new Filecoin proofs.

| Circuit | Sector-Size | Contributions | Signatures | Signing Keys |
| :-----: | :---------: | :-----------: | :--------: | :----------: |
| EmptySectorUpdate | 32GiB | [`update-32/contribs`](update-32/contribs) | [`update-32/sigs`](update-32/sigs) | [`update-keys`](update-keys) |
| EmptySectorUpdate | 64GiB | [`update-64/contribs`](update-64/contribs) | [`update-64/sigs`](update-64/sigs) | [`update-keys`](update-keys) |
| EmptySectorUpdate-Poseidon | 32GiB | [`updatep-32/contribs`](updatep-32/contribs) | [`updatep-32/sigs`](updatep-32/sigs) | [`updatep-keys`](updatep-keys) |
| EmptySectorUpdate-Poseidon | 64GiB | [`updatep-64/contribs`](updatep-64/contribs) | [`updatep-64/sigs`](updatep-64/sigs) | [`updatep-keys`](updatep-keys) |

## Hardware Requirements

| Circuit | Initial Param-Gen | Contributing | Contribution Verification | 
| :-----: | :------: | :------: | :------: |
| EmptySectorUpdate <br /> (32GiB and 64GiB) | RAM: 155GiB <br /> Disk: 125GiB <br /> Runtime (64 cores): 2h | RAM: 1GiB <br /> Disk: 40GiB <br /> Runtime (64 cores): 30min | RAM: 40GiB <br /> Disk: 40GiB <br /> Runtime (64 cores): 1h |
| EmptySectorUpdate-Poseidon <br /> (32GiB and 64GiB) | RAM: 50GiB <br /> Disk: 35GiB <br /> Runtime (64 cores): 1h10min | RAM: 1GiB <br /> Disk: 12GiB <br /> Runtime (64 cores): 10min | RAM: 12GiB <br /> Disk: 12GiB <br /> Runtime (64 cores): 10min |

Each participant for the EmptySectorUpdate circuits (32GiB and 64GiB) must download one 20GiB file, then generate and upload a second 20GiB file.

Each participant for the EmptySectorUpdate-Poseidon circuits (32GiB and 64GiB) must download one 5GiB file, then generate and upload a second 5GiB file.

### Initial Param-Gen and Full Trusted-Setup Validation

Generating initial parameters for each circuit is a deterministic process, i.e. a circuit's initial parameters are constant and do not change based upon who generates them or when they are generated.

The intial param-gen for large circuits requires significant computational resources; out of convenience Filecoin's trusted-setup coordinator generated each circuit's initial params.

In order to validate the full trusted-setup, a validator should generate their own copy of each circuit's initial parameters then compare digests of the independently generated initial parameters against those of the published initial parameters.

Before generating initial parameters for each circuit, a phase1.5 file corresponding to each circuit's size must be downloaded. These phase1.5 files were generated during phase1 of Filecoin's first trusted-setup.

| Circuit | Phase1.5 File | File Size
| :-----: | :------: | :------: |
| EmptySectorUpdate <br /> (32GiB and 64GiB) | [`phase1radix2m27`](https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m27) | 72GiB |
| EmptySectorUpdate-Poseidon <br /> (32GiB and 64GiB) | [`phase1radix2m25`](https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m25) | 18GiB |

## Participant Signing Keys

Each trusted-setup participant is required to sign their contribution using GPG and to publish their signing public-key to a publicly accessible location. The following public-keys can be used to verify each participant's signature.

### EmptySectorUpdate Circuits (32GiB and 64GiB)

| Participant Num. | Participant Name | Link to Key | Backup Copy of Key |
| :-----: | :------: | :------: | :-----: |
| 0 | Jake ([@drpetervannostrand](https://github.com/drpetervannostrand)) | [Gist](https://gist.github.com/DrPeterVanNostrand/94c7cc9cfc80dee29f99d97b7cc4f68a) | [00_jake.asc](update-keys/00_jake.asc) |
| 1 | Jake ([@drpetervannostrand](https://github.com/drpetervannostrand)) | [Gist](https://gist.github.com/DrPeterVanNostrand/94c7cc9cfc80dee29f99d97b7cc4f68a) | [01_jake.asc](update-keys/01_jake.asc) |
| 2 | Nemo ([@cryptonemo](https://github.com/cryptonemo)) | [Gist](https://gist.github.com/cryptonemo/c3e3a120199de6c015d09709a6ef03f5) | [02_nemo.asc](update-keys/02_nemo.asc) |
| 3 | Dig ([@dignifiedquire](https://github.com/dignifiedquire)) | [Gist](https://gist.github.com/dignifiedquire/a7a5a95bd3b43261c94024253a7b8482) | [03_dig.asc](update-keys/03_dig.asc) |
| 4 | Magik ([@magik6k](https://github.com/magik6k)) | [Gist](https://gist.github.com/magik6k/eb94516a2404f7aefd1e881deb866705) | [04_magik.asc](update-keys/04_magik.asc) |
| 5 | Why ([@whyrusleeping](https://github.com/whyrusleeping)) | [Gist](https://gist.github.com/whyrusleeping/f6d21d8968107d2b61676bdb154095fc) | [05_why.asc](update-keys/05_why.asc) |

### EmptySectorUpdate-Poseidon Circuits (32GiB and 64GiB)

| Participant Num. | Participant Name | Link to Key | Backup Copy of Key |
| :-----: | :------: | :------: | :-----: |
| 0 | Jake ([@drpetervannostrand](https://github.com/drpetervannostrand)) | [Gist](https://gist.github.com/DrPeterVanNostrand/94c7cc9cfc80dee29f99d97b7cc4f68a) | [00_jake.asc](updatep-keys/00_jake.asc) |
| 1 | Jake ([@drpetervannostrand](https://github.com/drpetervannostrand)) | [Gist](https://gist.github.com/DrPeterVanNostrand/94c7cc9cfc80dee29f99d97b7cc4f68a) | [01_jake.asc](updatep-keys/01_jake.asc) |
| 2 | Nemo ([@cryptonemo](https://github.com/cryptonemo)) | [Gist](https://gist.github.com/cryptonemo/c3e3a120199de6c015d09709a6ef03f5) | [02_nemo.asc](updatep-keys/02_nemo.asc) |

## Participant Instructions

Each participant must have an SSH keypair which they can use to download and upload files from the trusted-setup coordinator.

Each Participant must send the trusted-setup coordinator their SSH public-key.
-  If a participant does not have an SSH keypair, one can be generated by running:
```
$ ssh-keygen -t rsa -f ~/ssh_key -N '' -C ''
```
- Note that the SSH private-key file is `~/ssh_key` and public-key file is `~/ssh_key.pub`.

Each participant must sign their trusted-setup contribution using GPG. Each participant's signing public-key must be stored in a publicly accessible location, for example a GitHub Gist ([example](https://gist.githubusercontent.com/DrPeterVanNostrand/94c7cc9cfc80dee29f99d97b7cc4f68a/raw/2f2623c4de38a17c1334e3da5972b5b64d70715f/pubkey.asc)).

Each participant may use a preexisting GPG signing key, or may generate a signing key exclusively for Filecoin's trusted-setup.
- If a participant does not already have a GPG signing keypair, the trusted-setup coordinator will send the participant commands to generate a single-use signing keypair.

Each participant will receive URLs where they can download the previous participant's contribution and upload their own contribution.

**1. Install dependencies**

Note that the following commands were run on Ubuntu.

Check for missing dependencies using:

```
$ if ! command -v curl >/dev/null 2>&1; then 'missing: curl'; fi; \
      if ! command -v git >/dev/null 2>&1; then 'missing: git'; fi; \
      if ! command -v gpg >/dev/null 2>&1; then 'missing: gpg'; fi; \
      if ! command -v b2sum >/dev/null 2>&1; then 'missing: b2sum'; fi; \
      if ! command -v rsync >/dev/null 2>&1; then 'missing: rsync'; fi; \
      if ! command -v pkg-config >/dev/null 2>&1; then 'missing: pkg-config'; fi; \
      if ! command -v rustup >/dev/null 2>&1; then 'missing: rustup'; fi; \
      if ! dpkg -s build-essential >/dev/null 2>&1; then 'missing: build-essential'; fi; \
      if ! dpkg -s hwloc >/dev/null 2>&1; then 'missing: hwloc'; fi; \
      if ! dpkg -s libhwloc-dev >/dev/null 2>&1; then 'missing: libhwloc-dev'; fi; \
      if ! dpkg -s libssl-dev >/dev/null 2>&1; then 'missing: libssl-dev'; fi; \
      if ! dpkg -s ocl-icd-opencl-dev >/dev/null 2>&1; then 'missing: ocl-icd-opencl-dev'; fi
```

Install missing dependencies using:

```
$ sudo apt update
# Doesn't reinstall or upgrade dependencies which already exist:
$ sudo apt install --no-upgrade curl git gpg b2sum rsync build-essential hwloc libhwloc-dev pkg-config libssl-dev ocl-icd-opencl-dev

# If it's not already installed, install Rustup (https://www.rust-lang.org/tools/install):
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
> 1
$ source $HOME/.cargo/env
```

**2. Build `phase2`**
 
```
$ git clone https://github.com/filecoin-project/filecoin-phase2.git
$ cd filecoin-phase2
$ git checkout empty-sector-update
$ cargo build --release --bins && mv target/release/filecoin-phase2 phase2
# Check that the binary works using:
$ ./phase2 --help
```

**3. Start a `tmux` session**

Some trusted-setup commands take hours to finish; running those commands in a `tmux` session ensures that long-running processes will not be preemptively stopped, for example if your computer goes to sleep.

```
$ tmux new -s phase2
```

- You can detach from the `tmux` session during long-running processes (specifically file downloading/uploading and running when `phase2 contribute`) without stopping those processes by pressing the keys: `ctrl+b d`.
- You can reattach to the `tmux` session by running: `$ tmux a -t phase2`.

**4. Download the previous participant's contribution**

```
$ rsync -vP --append [-e 'ssh -i <path to SSH private-key>']  <download url>
```

**5. Verify checksums**

```
$ cat b2sums | grep <previous participant's files> | b2sum -c
```

**6. Make contribution**

- Remember to randomly mash keyboard after running `./phase2 contribute`.
- Press Enter/Return once you've finished pressing random keys.

```
$ ./phase2 contribute <previous participant's params>
```

After successfully contributing you should see the log:

```
[INFO] successfully made contribution
```

You should also see files in the current directory which have names similar to:

```
update_poseidon_32gib_8413077_1_small
update_poseidon_32gib_8413077_1_small.contrib
update_poseidon_32gib_8413077_1_small.log
```

**7. Compute checksum of contribution**

Hash the file written by `./phase2 contribute` which does not have a `.contrib` or `.log` extension.

```
$ b2sum <participant's contribution>
```

Send the computed checksum to the trusted-setup coordinator (probably via Slack)

**8. Sign files**

Create a directory to store a termporary GPG keyring.

```
$ mkdir keyring
```

Either generate a single-use GPG signing keypair or import a previously generated GPG (private) signing key.

- Option 1) Generate a new signing keypair:

```
$ gpg --homedir keyring --pinentry-mode loopback --passphrase '' --quick-generate-key "Filecoin trusted-setup #2 <participant's name>" ed25519 default none
$ gpg --homedir keyring --armor --export-secret-key > keyring/seckey.asc
$ gpg --homedir keyring --armor --export > keyring/pubkey.asc
```

- Option 2) Import a previously generated GPG signing key:

```
$ gpg --homedir keyring --import <private key>
```

Remember to upload your GPG public-key to a publicly accessible location so that your signature can be validated.

Send the trusted-setup coordinator a link to the signing public-key.

Sign your contribution files using:

```
$ gpg --homedir keyring --armor -o <params>.sig --detach-sign <params> \
    && gpg --homedir keyring --armor -o <params>.contrib.sig --detach-sign <params>.contrib
```

**9. Upload files**

```
$ rsync -vP --append [-e 'ssh -i <path to SSH private-key>'] <participant's files> <upload url>
```
