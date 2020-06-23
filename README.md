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
    * SDR-PoRep, Poseidon hash function, 32GiB sector-size, circuit-id=`sdr_32gib_poseidon_b288702`
    * SDR-PoRep, 64GiB sector-size, Poseidon hash function, circuit-id=`sdr_64gib_poseidon_b288702`
    * Winning-PoSt, Poseidon hash function, 32GiB sector-size, circuit-id=`winning_32gib_poseidon_b288702`
    * Winning-PoSt, Poseidon hash function, 64GiB sector-size, circuit-id=`winning_64gib_poseidon_b288702`
    * Window-PoSt, Poseidon hash function, 32GiB sector-size, circuit-id=`window_32gib_poseidon_b288702`
    * Window-PoSt, Poseidon hash function, 64GiB sector-size, circuit-id=`window_64gib_poseidon_b288702`

### Mainnet Participation Logistics

The participation requirements for phase2 vary with each circuit, the following table details the
requirements.

| Circuit            | RAM Req | Disk Space Req | Est. Completion Time | Param File Size (Approx.) |
| ------------------ |---------|----------------|----------------------| --------------------------|
| SDR-PoRep 32GiB    | 55GB    | 50GB           | 20 hours             | 25GB |
| SDR-PoRep 64GiB    | 55GB    | 50GB           | 20 hours             | 25GB |
| Winning-PoSt 32GiB | 1GB     | 0.25GB         | 10 minutes           | 90MB |
| Winning-PoSt 64GiB | 1GB     | 0.25GB         | 10 minutes           | 90MB |
| Window-PoSt 32GiB  | 55GB    | 50GB           | 20 hours             | 25GB |
| Window-PoSt 64GiB  | 55GB    | 50GB           | 20 hours             | 25GB |

## Ceremony Coordination

A slack channel has been set up to discuss the ceremony - please join the **#fil-trustedsetup** room in our [Slack](https://join.slack.com/t/filecoinproject/shared_invite/zt-dj58b7fq-weyaTEvjHoYF_ENkQHR6Ig) or email us at trustedsetup@protocol.ai.

## Participant Machine Setup

* Ensure you have a GPG key set up (instructions [here](https://help.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key))

Prior to participation, each participant should:
1. Install the dependencies `git`, `ssh`, `tmux`, `rsync`, `b2sum`, `gpg`
2. Install [`rustup`](https://rustup.rs)
3. Build the Rust crate containing Filecoin's circuits and the phase2 CLI binary [`rust-fil-proofs`](https://github.com/filecoin-project/rust-fil-proofs)

```
# On Ubuntu, you will need to have the `build-essential` package and OpenCL header files installed.
$ sudo apt update
$ sudo apt install build-essential ocl-icd-opencl-dev

# Check for and install missing dependencies:
$ which <git, ssh, tmux, rsync, b2sum, gpg>

# Install rustup (https://rustup.rs):
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Select choice: "1"
$ source $HOME/.cargo/env

# Build the phase2-cli binary:
$ git clone https://github.com/filecoin-project/rust-fil-proofs.git
$ cd rust-fil-proofs
$ git checkout phase2-cli-mainnet
$ RUSTFLAGS="-C target-cpu=native" cargo build --release --bin=phase2
$ cp target/release/phase2 .
```

## Adding a Contribution

At the start of the participant's time window they will recieve a URL from which to download the previous participant's phase2 parameters. 

For non-China based participants, an AWS S3 link to the parameters will be provided. For China based participants, a link to a JDCloud hosted copy of the parameters will be provided. **All phase2 files should be downloaded into the `rust-fil-proofs` directoy that was cloned.**

China-based participants will be given a URL and shell command to download the previous participant's phase2 parameters file. Participant's located outside of China will have access to an S3 bucket from which they can download the previous participant's phase2 parameters file.

Once the phase2 file has been downloaded, the participant should check that its blake2 digest matches the file's published digest.

```
$ tmux new -s phase2
$ b2sum <downloaded phase2 file>
```

After the file's digest has been checked, the participant runs the phase2 contribution code. **You will be asked to randomly press your keyboard at the start of the contribution process, press enter when you have finihsed.** The remainder of your contribution stage will require no further interaction beyond monitoring the phase2 process for completion.

```
# If you exited the above "phase2" tmux session, reattach to it before running `./phase2 contribute`.
[$ tmux attach -t phase2]

# You will be asked to randomly press your keyboard.
$ RUST_BACKTRACE=1 ./phase2 contribute <downloaded phase2 file>
```

The contribution program will write three files to the `rust-fil-proofs` directory. The files do not contain any secret information with respect to the phase2 contribution and do not contain any personal or identifying information of the participant.

1. The phase2 params file containing your contribution (has no file extension), e.g. `winning_poseidon_32gib_b288702_1_small`. These params are not secret.
2. A `.log` file containing a copy of the text that was written to stdout and stderr, e.g. `winning_poseidon_32gib_b288702_1_small.log`. You can `cat` this file to ensure that there is no personal information contained within it. 
3. A `.contrib` file containing the hash of the participant's contribution, e.g. `winning_poseidon_32gib_b288702_1_small.contrib`. This hash is not secret.

Lastly, the participant must GPG sign their contribution using a private-key whose public-key is publicly available and can be used to identify the participant.

To sign the `.contrib` contribution file wrote by `./phase2 contribute`, the participant (who in this example was the contributor 1 to the Winning-PoSt-32GiB circuit) runs: 

```
$ gpg --armor --detach-sign \
      --output winning_poseidon_32gib_b288702_1_small.contrib.sig \
      winning_poseidon_32gib_b288702_1_small.contrib
```

The participant should also fill out and sign an attestation file, a sample is given [here](https://github.com/filecoin-project/phase2-attestations/blob/master/sample-attestation/0000_alice.md).

```
$ gpg --armor --detach-sign --output attestation.md.sig attestation.md
```

Each participant will be given a URL and shell command with which they will upload their files and signatures. **A participant should not delete their files prior to the coordinator communicating that the contribution has been verified.** The coordinator runs a publicly available verification script on the participant's uploaded parameters. Once the participant's parameters are verified, the coordinator will communicate that the contribution has been accepted.
