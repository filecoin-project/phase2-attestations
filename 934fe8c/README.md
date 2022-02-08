# EmptySectorUpdate/SnapDeals Trusted-Setup

Filecoin ran a phase2 trusted-setup from December-2021 to January-2022 generating Groth16 parameters for four new Filecoin proofs: EmptySectorUpdate and EmptySectorUpdate-Poseidon (also called SnapDeals) for 32GiB and 64GiB sector sizes. This trusted-setup is distinct from Filecoin's Mainnet trusted-setup which generated Groth16 parameters for proofs: SDR-PoRep, Winning-PoSt, and Window-PoSt.

## Circuits

- EmptySectorUpdate (32GiB and 64GiB)
- EmptySectorUpdate-Poseidon (32GiB and 64GiB)

Circuits were frozen at [`rust-fil-proofs`](https://github.com/filecoin-project/rust-fil-proofs) commit [`4d743cf`](https://github.com/filecoin-project/rust-fil-proofs/commit/4d743cf6f5a66aa27b6953588585c99df61fdd21) and [`filecoin-phase2`](https://github.com/filecoin-project/filecoin-phase2) commit [`934fe8c`](https://github.com/filecoin-project/filecoin-phase2/commit/934fe8c6d2df2589644302579838976d070c48a7).

## Participant List

The following tables list the participants for each circuit's trusted-setup. Each trusted-setup participant is required to sign their contribution and to publish their signing public-key to a publicly accessible location. The following public-keys can be used to verify each participant's signature. We have also stored a backup copy of each participant's signing public-key within this repo.

A keyring with all keys linked below can be created directly from this file via `grep '^\['|cut -d ' ' -f 2|xargs -n 1 sh -c 'echo $0 && curl --silent --location $0|gpg --no-default-keyring --keyring ./keyring.gpg --import'`.

### EmptySectorUpdate 32GiB and 64GiB Circuits

| Participant Number | Participant Name | Published Signing Public-Key | Backup Copy of Public-Key |
| :-----: | :------: | :------: | :-----: |
| 0 | Jake ([@drpetervannostrand](https://github.com/drpetervannostrand)) | [729AFE30F8A2252FB161116CD23461A3F65ECA9A] | [00_jake.asc](update-keys/00_jake.asc) |
| 1 | Jake ([@drpetervannostrand](https://github.com/drpetervannostrand)) | [729AFE30F8A2252FB161116CD23461A3F65ECA9A] | [01_jake.asc](update-keys/01_jake.asc) |
| 2 | Nemo ([@cryptonemo](https://github.com/cryptonemo)) | [FE2C636C05D4EB47B05032289116924305EE3036] | [02_nemo.asc](update-keys/02_nemo.asc) |
| 3 | Dig ([@dignifiedquire](https://github.com/dignifiedquire)) | [2E35D133E063A218EDD0D30F23C5881C65EF08A4] | [03_dig.asc](update-keys/03_dig.asc) |
| 4 | Magik ([@magik6k](https://github.com/magik6k)) | [895F425CB320E9442DAA492DEA571D1207C1F47B] | [04_magik.asc](update-keys/04_magik.asc) |
| 5 | Why ([@whyrusleeping](https://github.com/whyrusleeping)) | [431623AFFE611C75D0362ACF85E5064D34D4A903] | [05_why.asc](update-keys/05_why.asc) |
| 6 | Grandhelmsman ([@IPFS-grandhelmsman](https://github.com/IPFS-grandhelmsman)) | [EC9ECA728FC616EEF7800D80E9659C3B605D94EA] | [06_grandhelmsman.asc](update-keys/06_grandhelmsman.asc) |
| 7 | IPFS-Force ([@force_ipfs](https://twitter.com/force_ipfs)) | [F6EA556B12C97AE73E94BE62FD392097D41D0F73] | [07_ipfs_force.asc](update-keys/07_ipfs_force.asc) |
| 8 | DC Tech ([@wangyancun](https://github.com/wangyancun)) | [BD9388D2AF0C6F88AFB161257E6702539B0AD989] | [08_dc_tech.asc](update-keys/08_dc_tech.asc) |
| 9 | Gegezai (@mingzhutek) | [9EC26496FF2A468E813A1E569D50130A8AF7F8DA] | [09_gegezai.asc](update-keys/09_gegezai.asc) |
| 10 | Lanzafame ([@lanzafame](https://github.com/lanzafame)) | [61983CF78FF7E8862DF698B3412C59E7B21C4CAA] | [10_lanzafame.asc](update-keys/10_lanzafame.asc) |
| 11 | BenjaminH ([@benjaminh83](https://github.com/benjaminh83)) | [482C86524ABF01070B0C7100746EBAC19A93BABC] | [11_benjaminh.asc](update-keys/11_benjaminh.asc) |
| 12 | 1475 Tech ([@joyceqingling](https://github.com/joyceqingling)) | [196B0D8AAF8D011F83FB7DEA0F6B73CC688F45D9] | [12_1475_tech.asc](update-keys/12_1475_tech.asc) |
| 13 | Factor8 Solutions ([@factor8solutions](https://github.com/Factor8Solutions)) | [E2815BCF1FA14ACDF85937998D797C669183C5AA] | [13_factor8.asc](update-keys/13_factor8.asc) |
| 14 | Zondax ([@zondax](https://github.com/Zondax)) | [B44CCE9C47715B00D169600602EB7F6D56F2C6BB] | [14_zondax.asc](update-keys/14_zondax.asc) |
| 15 | Linix ([@angelo_schalley](https://twitter.com/angelo_schalley)) | [7AC6E2026575537A225F2344F064D400BF00A7E1] | [15_linix.asc](update-keys/15_linix.asc) |

### EmptySectorUpdate-Poseidon 32GiB and 64GiB Circuits

| Participant Number | Participant Name | Published Signing Public-Key | Backup Copy of Public-Key |
| :-----: | :------: | :------: | :-----: |
| 0 | Jake ([@drpetervannostrand](https://github.com/drpetervannostrand)) | [729AFE30F8A2252FB161116CD23461A3F65ECA9A] | [00_jake.asc](updatep-keys/00_jake.asc) |
| 1 | Jake ([@drpetervannostrand](https://github.com/drpetervannostrand)) | [729AFE30F8A2252FB161116CD23461A3F65ECA9A] | [01_jake.asc](updatep-keys/01_jake.asc) |
| 2 | Nemo ([@cryptonemo](https://github.com/cryptonemo)) | [FE2C636C05D4EB47B05032289116924305EE3036] | [02_nemo.asc](updatep-keys/02_nemo.asc) |
| 3 | Grandhelmsman ([@IPFS-grandhelmsman](https://github.com/IPFS-grandhelmsman)) | [EC9ECA728FC616EEF7800D80E9659C3B605D94EA] | [03_grandhelmsman.asc](updatep-keys/03_grandhelmsman.asc) |
| 4 | IPFS-Force ([@force_ipfs](https://twitter.com/force_ipfs)) | [F6EA556B12C97AE73E94BE62FD392097D41D0F73] | [04_ipfs_force.asc](updatep-keys/04_ipfs_force.asc) |
| 5 | DC Tech ([@wangyancun](https://github.com/wangyancun)) | [BD9388D2AF0C6F88AFB161257E6702539B0AD989] | [05_dc_tech.asc](updatep-keys/05_dc_tech.asc) |
| 6 | Gegezai (@mingzhutek) | [9EC26496FF2A468E813A1E569D50130A8AF7F8DA] | [06_gegezai.asc](updatep-keys/06_gegezai.asc) |
| 7 | Lanzafame ([@lanzafame](https://github.com/lanzafame)) | [61983CF78FF7E8862DF698B3412C59E7B21C4CAA] | [07_lanzafame.asc](updatep-keys/07_lanzafame.asc) |
| 8 | BenjaminH ([@benjaminh83](https://github.com/benjaminh83)) | [482C86524ABF01070B0C7100746EBAC19A93BABC] | [08_benjaminh.asc](updatep-keys/08_benjaminh.asc) |
| 9 | 1475 Tech ([@joyceqingling](https://github.com/joyceqingling)) | [196B0D8AAF8D011F83FB7DEA0F6B73CC688F45D9] | [09_1475_tech.asc](updatep-keys/09_1475_tech.asc) |
| 10 | Factor8 Solutions ([@factor8solutions](https://github.com/Factor8Solutions)) | [E2815BCF1FA14ACDF85937998D797C669183C5AA] | [10_factor8.asc](updatep-keys/10_factor8.asc) |
| 11 | Zondax ([@zondax](https://github.com/Zondax)) | [B44CCE9C47715B00D169600602EB7F6D56F2C6BB] | [11_zondax.asc](updatep-keys/11_zondax.asc) |
| 12 | Linix ([@angelo_schalley](https://twitter.com/angelo_schalley)) | [7AC6E2026575537A225F2344F064D400BF00A7E1] | [12_linix.asc](updatep-keys/12_linix.asc) |

## Participant Attestation Files

Each participant in a circuit's trusted-setup downloads the previous participant's Groth16 parameters then runs the `phase2` program to contribute randomness to those parameters resulting in a new parameters file. Additionally, each contribution process writes a `.contrib` file which is used to validate the participant's contribution. Participants sign their Groth16 parameters and their `.contrib` file using GPG and publish their GPG public-key to a publicly accessible location. A backup of each participant's GPG public-key is also stored in this repo.

Each circuit's `.contrib ` files, participant signatures, and backup GPG public-keys are stored within this repo in the following folders:

| Circuit | Sector-Size | Contributions | Signatures | Signing Keys |
| :-----: | :---------: | :-----------: | :--------: | :----------: |
| EmptySectorUpdate | 32GiB | [`update-32/contribs`](update-32/contribs) | [`update-32/sigs`](update-32/sigs) | [`update-keys`](update-keys) |
| EmptySectorUpdate | 64GiB | [`update-64/contribs`](update-64/contribs) | [`update-64/sigs`](update-64/sigs) | [`update-keys`](update-keys) |
| EmptySectorUpdate-Poseidon | 32GiB | [`updatep-32/contribs`](updatep-32/contribs) | [`updatep-32/sigs`](updatep-32/sigs) | [`updatep-keys`](updatep-keys) |
| EmptySectorUpdate-Poseidon | 64GiB | [`updatep-64/contribs`](updatep-64/contribs) | [`updatep-64/sigs`](updatep-64/sigs) | [`updatep-keys`](updatep-keys) |

The file [`b2sums`](b2sums) stores the BLAKE2 digest of each file generated during these circuits' trusted-setups; this checksums file can be used to verify the integrity of files downloaded by participants or by parties validating Filecoin's trusted-setup.

## Hardware Requirements

Hardware requirements for participating in each circuit's trusted-setup are provided in the following table. Note that participants do not need to generate each circuit's initial phase2 parameters nor verify their own contributions (although they can if they would like). Each circuit's initial parameters are generated by the trusted-setup coordinator; similarly each participant's contributions are verified by the trusted-setup coordinator upon receiving them. Both initial parameter generation and contribution verification are deterministic and have significant hardware requirements, because of this Filecoin chooses to perform those actions rather than requiring participants to. All stages of the trusted-setup can be independently verified by parties outside of Filecoin.

| Circuit | Initial Param-Gen | Contributing | Contribution Verification | 
| :-----: | :------: | :------: | :------: |
| EmptySectorUpdate <br /> (32GiB and 64GiB) | RAM: 155GiB <br /> Disk: 125GiB <br /> Runtime: 2h | RAM: 1GiB <br /> Disk: 40GiB <br /> Runtime: 30min | RAM: 40GiB <br /> Disk: 40GiB <br /> Runtime: 1h |
| EmptySectorUpdate-Poseidon <br /> (32GiB and 64GiB) | RAM: 50GiB <br /> Disk: 35GiB <br /> Runtime: 1h10min | RAM: 1GiB <br /> Disk: 12GiB <br /> Runtime: 10min | RAM: 12GiB <br /> Disk: 12GiB <br /> Runtime: 10min |

- **Note:** the above runtimes were measured on a computer utilizing 64 CPUs, however 64 cores is not a hardware requirement. For all parts of phase2 (initial param-gen, contribution, verification) runtime is inversely correlated with the number of CPUs available, i.e. fewer cores result in a slower runtimes, whereas more cores result in faster runtimes.

### Participant File Sizes

The following table gives the size of each circuit's trusted-setup parameters file. Each participant is required to download one parameters file for each circuit they are contributing to, then to generate and upload a new parameters file for each circuit they are contributing to.

| Circuit | File Size |
| :-----: | :-------: |
| EmptySectorUpdate <br /> (32GiB and 64GiB) | 20GiB |
| EmptySectorUpdate-Poseidon <br /> (32GiB and 64GiB) | 5GiB |

### Initial Param-Gen and Full Trusted-Setup Verification

Generating initial parameters for each circuit is a deterministic process, i.e. a circuit's initial parameters are constant and do not change based upon who generates them or when they are generated.

The initial param-gen for large circuits requires significant computational resources; out of convenience Filecoin's trusted-setup coordinator generated each circuit's initial params.

In order to validate the full trusted-setup, a validator should generate their own copy of each circuit's initial parameters then compare digests of the independently generated initial parameters against those of the published initial parameters.

Before generating initial parameters for each circuit, a phase1.5 file corresponding to each circuit's size must be downloaded. These phase1.5 files were generated during phase1 of Filecoin's first trusted-setup.

| Circuit | Phase1.5 File | File Size
| :-----: | :------: | :------: |
| EmptySectorUpdate <br /> (32GiB and 64GiB) | [`phase1radix2m27`](https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m27) | 72GiB |
| EmptySectorUpdate-Poseidon <br /> (32GiB and 64GiB) | [`phase1radix2m25`](https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m25) | 18GiB |

## Participant Instructions

**Note:** the following commands were run on Ubuntu.

### Before Participating

#### 0.1. Send SSH Public-Key to Coordinator

Each participant must have an SSH keypair which they can use to download and upload files from the trusted-setup file server. Each Participant must send their SSH public-key to the trusted-setup coordinator.

If a participant does not have an SSH keypair, one can be generated by running the following command; note that the SSH private-key file is `~/ssh_key` and public-key file is `~/ssh_key.pub`:
```
$ ssh-keygen -t rsa -f ~/ssh_key -N '' -C ''
```

#### 0.2. Publish GPG Public-Key

Each participant must sign their contribution using GPG. Each participant's signing public-key must be stored in a publicly accessible location, [for example using a GitHub Gist](https://gist.github.com/DrPeterVanNostrand/94c7cc9cfc80dee29f99d97b7cc4f68a#file-pubkey-asc).

Each participant may use either a preexisting GPG signing keypair, for example a keypair that was generated during Filecoin's Mainnet trusted-setup, or may generate a new signing keypair (which should be used exclusively for Filecoin's trusted-setup). 

##### Generating a GPG Signing Keypair

If a participant does not already have a GPG signing keypair, one can be generated using the following command; note that the participant should update the `participant_name='...'` variable to contain their own name, handle, or pseudonym:
```
$ participant_name='...'; \
      mkdir keyring
      && chmod 700 keyring \
      && gpg --homedir keyring --pinentry-mode loopback --passphrase '' --quick-generate-key "Filecoin trusted-setup esu ${participant_name}" ed25519 default none \
      && gpg --homedir keyring --armor --export > sig_pubkey.asc \
      && gpg --homedir keyring --armor --export-secret-key > sig_seckey.asc
```
In the above command, the file `sig_seckey.asc` is the signing private-key and the file `sig_pubkey.asc` is the signing public-key; the public-key should be copied to a public location.

#### 0.3. Install Dependencies and Build `phase2`

Check for missing dependencies:
```
$ for bin in curl git gpg b2sum rsync pkg-config rustup; do \
      if ! command -v ${bin} >/dev/null 2>&1; then echo "missing: ${bin}"; fi; \
  done; \
  for pkg in build-essential libssl-dev; do \
      if ! dpkg -s ${pkg} >/dev/null 2>&1; then echo "missing: ${pkg}"; fi; \
  done
```

Install missing dependencies; note that the following does not reinstall or upgrade dependencies which already exist:
```
$ sudo apt update
$ sudo apt install --no-upgrade curl git gpg b2sum rsync build-essential pkg-config libssl-dev
```

If it's not already installed, install Rust via Rustup:
```
# Installation instructions were copied from Rustup's website: https://www.rust-lang.org/tools/install
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
> 1
$ source $HOME/.cargo/env
```

Build `phase2`:
```
$ git clone https://github.com/filecoin-project/filecoin-phase2.git
$ cd filecoin-phase2
$ cargo build --release --bins && mv target/release/filecoin-phase2 phase2
```

Check that the `phase2` binary works:
```
$ ./phase2 help
```

### Example Participant Instructions

At the start of their timeslot, each participant will be sent exact instructions on how to run the trusted-setup; the following commands are meant to serve only as an example of what participants will run during their trusted-setup timeslot.

#### 1. Receive Access to the Trusted-Setup File Server

At the start of their timeslot each participant will be given commands to download and upload files to Filecoin's trusted-setup file server.

#### 2. Start a `tmux` Session

Some trusted-setup commands take hours to finish; running those commands in a `tmux` session ensures that long-running processes will not be preemptively stopped, for example if your computer goes to sleep.

```
$ tmux new -s phase2
```

- You can detach from the `tmux` session during long-running processes (specifically file downloading/uploading and running when `phase2 contribute`) without stopping those processes by pressing the keys: `ctrl+b d`.
- You can reattach to the `tmux` session by running: `$ tmux a -t phase2`.

#### 3. Download the Previous Participant's Parameters

Each participant will be given a `download url` where they can download the previous participant's parameters.

```
$ rsync -vP --append -e 'ssh -i <path to SSH private-key>' <download url> .
```

#### 4. Verify Checksums of Downloaded Files

The participant will either download a checksums file `b2sums` from our [GitHub repo](https://raw.githubusercontent.com/filecoin-project/phase2-attestations/934fe8c/b2sums), trusted-setup file server, or will be sent to the participant by the trusted-setup coordinator.

The participant should run the following command to ensure the integrity of their downloaded files:
```
$ grep -E '<downloaded file 1>|<downloaded file 2>' b2sums | b2sum -c
```
which will output the following if the file digests are correct.
```
<downloaded file 1>: OK
<downloaded file 2>: OK
```

#### 5. Make Contribution

Remember to randomly press keyboard keys after running `./phase2 contribute`; when finished randomly pressing keys press `Enter`/`Return`.

```
$ ./phase2 contribute <previous participant's parameters>
```

After successfully contributing you should see the log:

```
[INFO] successfully made contribution
```

You should also see files in the current directory which have names similar to:

```
update_poseidon_32gib_934fe8c_1_small
update_poseidon_32gib_934fe8c_1_small.contrib
update_poseidon_32gib_934fe8c_1_small.log
```

#### 6. Compute Checksums

Hash the parameters file written by `./phase2 contribute`; note that this file has no file extension (e.g. `.contrib` or `.log`).

```
$ b2sum <parameters file>
```

Send the computed checksum to the trusted-setup coordinator (probably via Slack).

#### 7. Sign Files

Create a directory to store a temporary GPG keyring.

```
$ mkdir keyring && chmod 700 keyring
```

Either import a previously generated GPG signing key (i.e. private-key) or generate a single-use GPG signing keypair:
- **Option 1)** Import a previously generated GPG signing key:
```
$ gpg --homedir keyring --import <path to GPG private-key file>
```
- **Option 2)** Generate a new signing keypair by following the instructions in the above section [Generating a GPG Signing Keypair](#generating-a-gpg-signing-keypair)

Remember to upload your GPG public-key to a publicly accessible location so that your signature can be validated.

Send the trusted-setup coordinator a link to the signing public-key.

Sign your contribution files using:

```
$ gpg --homedir keyring --armor -o <params>.sig --detach-sign <params> \
    && gpg --homedir keyring --armor -o <params>.contrib.sig --detach-sign <params>.contrib
```

#### 8. Upload Files

The trusted-setup coordinator will give each participant an `upload_url` which can be used to upload files to the trusted-setup file server.

```
$ rsync -vP --append -e 'ssh -i <path to SSH private-key>' <files> <upload url>
```

[729AFE30F8A2252FB161116CD23461A3F65ECA9A]: https://gist.githubusercontent.com/DrPeterVanNostrand/94c7cc9cfc80dee29f99d97b7cc4f68a/raw/2f2623c4de38a17c1334e3da5972b5b64d70715f/pubkey.asc
[FE2C636C05D4EB47B05032289116924305EE3036]: https://gist.githubusercontent.com/cryptonemo/c3e3a120199de6c015d09709a6ef03f5/raw/8adfcbd060a9f58964f65fa5d081a8b84b26352e/Filecoin%2520phase2%2520signing%2520public%2520key
[2E35D133E063A218EDD0D30F23C5881C65EF08A4]: https://gist.githubusercontent.com/dignifiedquire/a7a5a95bd3b43261c94024253a7b8482/raw/bc2397db14c02ca9f7b9f2664af239f098f0eee6/trusted-setup-2-public-key-dignifiedquire.asc
[895F425CB320E9442DAA492DEA571D1207C1F47B]: https://gist.githubusercontent.com/magik6k/eb94516a2404f7aefd1e881deb866705/raw/dafb9a85aa5ffddb09b37ae6dd26c9172892d178/snappub.asc
[431623AFFE611C75D0362ACF85E5064D34D4A903]: https://gist.githubusercontent.com/whyrusleeping/f6d21d8968107d2b61676bdb154095fc/raw/1515b21f537d90aa0bd6965261a95ac5e1972776/celebii-key.asc
[EC9ECA728FC616EEF7800D80E9659C3B605D94EA]: https://gist.githubusercontent.com/IPFS-grandhelmsman/be1a3cc62d43da2e70d089c1c491fdd7/raw/7c75b85d4d2bb7a3fddefc791e759100c851e46f/pubkey.asc
[F6EA556B12C97AE73E94BE62FD392097D41D0F73]: https://gist.githubusercontent.com/leone-Y/080a7c8c3c479d249de35eeadd6081a4/raw/e27bb8fc1098acd3e163f18ac67fca4f4f41c042/pubkey.asc
[BD9388D2AF0C6F88AFB161257E6702539B0AD989]: https://gist.githubusercontent.com/wangyancun/453300b6fffadc561aa71d2448d259ab/raw/c1feb6d2811c2b12515509fe3b8384d80e260b91/pubkey.asc
[9EC26496FF2A468E813A1E569D50130A8AF7F8DA]: https://webb_wang.keybase.pub/public-webb.asc
[61983CF78FF7E8862DF698B3412C59E7B21C4CAA]: https://gist.githubusercontent.com/lanzafame/0b37a6e2b60e66899bf9e655a3f35e37/raw/92cd15e80fc90e0fc18a1c39ab1feec9c7dddd12/sig_pubkey.asc
[482C86524ABF01070B0C7100746EBAC19A93BABC]: https://gist.githubusercontent.com/benjaminh83/2fbff10a745ce236649d25ef5d258619/raw/d870569e41d5c4f58302cc0a1332a0a68fbbf6d8/pubkey.asc
[196B0D8AAF8D011F83FB7DEA0F6B73CC688F45D9]: https://gist.githubusercontent.com/joyceqingling/16e939177b4b9a6346106830f06c885a/raw/f5f9633b5edc8e4304d4bc83021d47a9faa37e38/pubkey.asc
[E2815BCF1FA14ACDF85937998D797C669183C5AA]: https://gist.githubusercontent.com/f8-ptrk/9e1b10c21b902282ca3ab86617c9934d/raw/6868c27782d13f8f3d28a25a76bebe7046974ee6/li_tsp2_snap_pubkey
[B44CCE9C47715B00D169600602EB7F6D56F2C6BB]: https://gist.githubusercontent.com/pecorino-bot/4db4e259bd0864ae6912863eef572b19/raw/977050de66afb4c4228eba687d0f183343330091/pubkey.asc
[7AC6E2026575537A225F2344F064D400BF00A7E1]: https://gist.githubusercontent.com/Angelo-gh3990/39c5a2c7020ebae90a5fe4998ac5f22e/raw/5179a26da6c7c2d6ac5af1250940be56fe79c13d/sig_pubkey.asc
