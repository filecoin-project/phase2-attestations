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
# Check and install missing dependencies:
$ which <git, ssh, tmux, rsync, b2sum, gpg>

# Install rustup (https://rustup.rs):
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Select choice: 1)
$ source $HOME/.cargo/env

# Build the phase2 binary:
$ git clone https://github.com/filecoin-project/rust-fil-proofs.git
$ cd rust-fil-proofs
$ git checkout phase2-cli-mainnet
$ RUSTFLAGS="-C target-cpu=native" cargo build --release --bin=phase2
# On Ubuntu, this may require you to install the build-essential package and OpenCL header files:
# $ sudo apt update
# $ sudo apt install build-essential ocl-icd-opencl-dev
$ cp target/release/phase2 .
```

## Participation Instructions

At the start of the participant's time window they will recieve a URL from which to download the previous participant's Phase2 parameters. 

For non-China based participants, an AWS S3 link to the parameters will be provided. For China based participants, a link to a JDCloud hosted copy of the parameters will be provided. **All phase2 files should be downloaded into the `rust-fil-proofs` directoy that was cloned.**

Once the phase2 file has been downloaded, the participant should check its blake2 digest against the file's published digest.

```
$ tmux new -s phase2
$ b2sum <downloaded phase2 file>
```

After the downloaded file's digest has been verified, the participant runs the phase2 contribution code. **You will be asked to randomly mash your keyboard upon running the contribution code, press enter when you have finihsed.** Keyboard mashing is not the only source of contribution entropy. The remainder of your contribution stage will require no further interaction beyond occasionally monitoring the phase2 process.

```
$ tmux attach -t phase2
$ RUST_BACKTRACE=1 ./phase2 contribute <downloaded phase2 file>
# Randomly press keyboard.
```

The contribution program will write three files to the `rust-fil-proofs` directory:
1. The phase2 params file containing your contribution (has no file extension)
2. A `.log` file containing a copy of the text written to stdout and stderr by `./phase2 contribute`. This log file file contains the time take for each stage of the contribution process. This file should not contain any information that identifies the participant, if it does please edit it. The `.log` file does not contain any secret information with respect to the phase2 contribution process that the participant ran.
3. A `.contrib` file containing the hash of the participant's contribution. This hash should be made public.

Once this phase is complete, the participant has successfully made their contribution. To upload the output parameters to the rsync box, run the following: 

The participant must send copies of the three files written by `./phase2 contribute` to one of our verification servers via `rsync`.

For, example, if the participant is the first contributor to Filecoin's Winning-PoSt mainnet circuit, they would run the following command to send their files to our server. The participant's SSH privagte-key must correspond to the SSH public-key that the participant provided to the ceremony coordinator. In this example, the three files written by `./phase2 contribute` would be: `winning_poseidon_32gib_b288702_1_small`, `winning_poseidon_32gib_b288702_1_small.log`, and
`winning_poseidon_32gib_b288702_1_small.contrib`.

```
$ tmux attach -t phase2
# If the rsync command fails midway through the file transfer, it can be re-run
# without modification to resume the file transfer from the point of failure.
$ rsync -vP --append -e "ssh -i <path to SSH private-key>" \
      winning_poseidon_32gib_b288702_1* \
      response@rsync.kittyhawk.wtf:/home/response
```

Lastly, the participant must GPG sign their contribution using a private-key whose corresponding public-key is publicly available and which can be used to identify the participant. **This is essential for the credibility of the ceremony, you should not sign-up if you are not comfortable doing this.**

To sign the `.contrib` contribution file wrote by `./phase2 contribute`, the participant (who in this example was the first contributor for the Winning-PoSt circuit) runs: 

```
$ gpg --armor --detach-sign \
      --output winning_poseidon_32gib_b288702_1_small.contrib.sig \
      winning_poseidon_32gib_b288702_1_small
```

The participant should also fill out and sign an attestation file, a sample is given [here](https://github.com/filecoin-project/phase2-attestations/blob/master/sample-attestation/0000_alice.md).

```
$ gpg --armor --detach-sign --output attestation.md.sig attestation.md
```

The participant must send these files and signatures to the coordinator, either by Slack or to [trustedsetup@protocol.ai](mailto:trustedsetup@protocol.ai). The participant should publish their contribution hash `$cat <the .contrib file>` via public channels.
