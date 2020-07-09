# Filecoin Trusted-Setup Phase2 Attestations

This repo stores the attestation files for participants in Filecoin's Groth16 parameter generation MPC. This repo is specific to the second phase of the MPC, the participant attestations for Filecoin's trusted-setup Phase1/Powers-of-Tau ceremony can be found in this [repo](https://github.com/arielgabizon/perpetualpowersoftau).

## Filecoin Circuit Releases

Each Filecoin circuit release will require a new Phase2 trusted-setup.

| Filecoin Release | Circuit | Attestations Directory |
| :--------------: | :------ | :--------------------- |
| Mainnet | SDR-PoRep, Poseidon, 32GiB | [`sdr_poseidon_32gib_b288702`](/sdr_poseidon_32gib_b288702)
| Mainnet | SDR-PoRep, Poseidon, 64GiB | [`sdr_poseidon_64gib_b288702`](/sdr_poseidon_64gib_b288702)
| Mainnet | Winning-PoSt, Poseidon, 32GiB | [`winning_poseidon_32gib_b288702`](/winning_poseidon_32gib_b288702)
| Mainnet | Winning-PoSt, Poseidon, 64GiB | [`winning_poseidon_64gib_b288702`](/winning_poseidon_64gib_b288702)
| Mainnet | Window-PoSt, Poseidon, 32GiB | [`window_poseidon_32gib_b288702`](/window_poseidon_32gib_b288702)
| Mainnet | Window-PoSt, Poseidon, 64GiB | [`window_poseidon_64gib_b288702`](/window_poseidon_64gib_b288702)

## Mainnet Circuits

* Circuit Freeze Date: Jun-10-2020
* Circuit Freeze Commit: [`b288702362e8f14ee0a68fb030774f339266e9a6`](https://github.com/filecoin-project/rust-fil-proofs/tree/b288702362e8f14ee0a68fb030774f339266e9a6)
* Circuit List:
    * SDR-PoRep, 32GiB sector-size, Poseidon hash function, circuit-id=`sdr_32gib_poseidon_b288702`
    * SDR-PoRep, 64GiB sector-size, Poseidon hash function, circuit-id=`sdr_64gib_poseidon_b288702`
    * Winning-PoSt, Poseidon hash function, 32GiB sector-size, circuit-id=`winning_32gib_poseidon_b288702`
    * Winning-PoSt, Poseidon hash function, 64GiB sector-size, circuit-id=`winning_64gib_poseidon_b288702`
    * Window-PoSt, Poseidon hash function, 32GiB sector-size, circuit-id=`window_32gib_poseidon_b288702`
    * Window-PoSt, Poseidon hash function, 64GiB sector-size, circuit-id=`window_64gib_poseidon_b288702`

### Participation Requirements

The participation requirements for phase2 vary between circuits, the following table details the hardware requirements and participant runtime for each Mainnet circuit. Note that runtime decreases linearly with an increasing number of cores (or threads if is processor has hyperthreading).

| Circuit            | RAM Req. | Disk Space Req. | Runtime (8 v.s. 96 cores) |
| ------------------ | -------- | --------------- | ------------------------- |
| SDR-PoRep-32GiB    | 6GB      | 52GB            | 6h25m, 45m                |
| SDR-PoRep-64GiB    | 6GB      | 52GB            | 6h25m, 45m                |
| Window-PoSt-32GiB  | 6GB      | 52GB            | 6h25m, 45m                |
| Window-PoSt-64GiB  | 6GB      | 52GB            | 6h25m, 45m                |
| Winning-PoSt-32GiB | 1GB      | 0.25GB          | 1m, 10s                   |
| Winning-PoSt-64GiB | 1GB      | 0.25GB          | 1m, 10s                   |

## Ceremony Coordination

A slack channel has been set up to discuss the ceremony - please join the **#fil-trustedsetup** room in our [Slack](https://join.slack.com/t/filecoinproject/shared_invite/zt-dj58b7fq-weyaTEvjHoYF_ENkQHR6Ig) or email us at trustedsetup@protocol.ai.

## Participant Machine Setup

* Ensure you have a GPG key set up (instructions [here](https://help.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key))

Prior to participation, each participant should:
1. Install the dependencies `rustup`, `git`, `ssh`, `tmux`, `rsync`, `b2sum`, `gpg`, OpenCL header files
2. Build [`rust-fil-proofs`](https://github.com/filecoin-project/rust-fil-proofs), the Rust crate containing Filecoin's circuits and trusted-setup CLI

```
# On Ubuntu, you will need to have the `build-essential` package and OpenCL header files installed.
$ sudo apt update
$ sudo apt install build-essential ocl-icd-opencl-dev

# Check for and install missing dependencies:
$ which <git, ssh, tmux, rsync, b2sum, gpg>

# Install rustup:
# Installation instructions are taken from the rustup website: https://rustup.rs.
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Select choice: "1"
$ source $HOME/.cargo/env

# Build rust-fil-proofs:
$ git clone https://github.com/filecoin-project/rust-fil-proofs.git
$ cd rust-fil-proofs
$ git checkout 4e4f766
$ RUSTFLAGS="-C target-cpu=native" cargo build --release --bin=phase2
$ cp target/release/phase2 .
```

## Participation Steps

At the start of each participant's contribution time-window, the participant will receive one URL and/or shell command for each circuit that they are contributing to. The link or command is used to download the previous participant's phase2 parameters.

Once the phase2 file or files have been downloaded, the participant must check that each downloaded file's blake2 digest matches the file's published digest.

```
# Enter a tmux session only if you are not in one.
[$ tmux new -s phase2] or [$tmux attach -t phase2]
$ b2sum <downloaded phase2 file>
```

After each downloaded file's digest has been verified, the participant runs the phase2 contribution code. **You will be asked to randomly press your keyboard at the start of the contribution process, press "enter" when you have finished pressing keys.**

```
# Enter a tmux session only if you are not in one.
[$ tmux new -s phase2] or [$tmux attach -t phase2]
$ RUST_BACKTRACE=1 ./phase2 contribute <downloaded phase2 file>
```

The contribution program will write three files to the `rust-fil-proofs` directory. The files do not contain any secret information with respect to the phase2 contribution and do not contain any personal or identifying information of the participant.

1. A phase2 parameters file containing your contribution. This file has no file extension, e.g.
`winning_poseidon_32gib_b288702_1_small`. This file is not secret.
2. A `.log` file containing a copy of the text that was written to stdout and stderr, e.g.`winning_poseidon_32gib_b288702_1_small.log`. You can `cat` this file to ensure that there is no personal information contained within it. This file is not secret.
3. A `.contrib` file containing the hash of the participant's contribution, e.g. `winning_poseidon_32gib_b288702_1_small.contrib`. This file is not secret.

The participant must hash the parameters file that was written by `phase2 contribute` using `b2sum`. The participant will send the cordinator this digest via Slack. For example, if the participant was contributor #1 to the Winning-PoSt-32GiB circuit, they run the commaind:

```
$ b2sum winning_poseidon_32gib_b288702_1_small
```

Lastly, the participant must GPG sign their contribution using a private-key whose public-key is publicly available and can be used to identify the participant.

To sign the `.contrib` contribution file output by `phase2 contribute`, the participant (who in this example is Contributor #1 to the Winning-PoSt-32GiB circuit) runs:

```
$ gpg --armor --detach-sign \
      --output winning_poseidon_32gib_b288702_1_small.contrib.sig \
      winning_poseidon_32gib_b288702_1_small.contrib
```

Each participant will be given a shell command with which to upload their files and signatures (4 files per circuit contributed to, one of the four files is a `.sig` signature file). **A participant should not delete their files prior to the coordinator communicating that the contribution has been verified.** The coordinator runs a publicly available verification script on the participant's uploaded parameters. Once the participant's parameters are verified, the coordinator will communicate that the contribution has been accepted.
