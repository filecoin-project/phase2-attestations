# Filecoin Trusted Setup Phase 2 

This repo is a modified structure to the approach the Semaphore team has taken for their Phase 1 of a multi-party trusted setup ceremony based on the Zcash Powers of Tau ceremony for the BN254 curve. We thank them very much for their work and [repo](https://github.com/weijiekoh/perpetualpowersoftau)!

As members of the community might remember, at the end of last year we ran the [first phase](https://github.com/arielgabizon/perpetualpowersoftau) of our trusted setup - securely generate zk-SNARK parameters for circuits of up to 2 ^ 27 (130+ million) constraints, over the [BLS12-381 curve](https://electriccoin.co/blog/new-snark-curve/). We're extremely grateful to all the community members who helped make this possible!

With our powers of tau ceremony complete, we now are ready to generate secure parameters for the circuits we will be using for the Filecoin mainnet launch. For more information, please read our [blog post](https://filecoin.io/blog/trusted-setup-update/) which goes into more detail!

As with the powers of tau ceremony, during this second phase the outputs will be trustworhy as long as one party in the ceremony behaves honestly and is not comprimised.

## Trusted-Setup Phase 1 v.s. Phase 2

In Phase 1, we were effectively running one ceremony to generate a set of secure parameters. After the completion of the ceremony, we ran a transition phase [TODO - @jake for detail]. With the transition phase complete, we begin Phase 2 to generate secure parameters for each of the circuits we plan to use for Filecoin's mainnet. Since we have 6 circuits we'll be using, we'll be running 6 ceremonies in parallel. For each of these ceremonies, the procedure will be roughly the same as in Phase 1.

## Mapping of Filecoin Releases to Attestation Files

A new trusted-setup Phase 2 will occur prior to Filecoin's mainnet launch and each time
Filecoin's zk-SNARKs are upgraded during network upgrades. The following table will be used to track
the contribution attestations of each participant in each trusted-setup.

The `Circuit` column in the table below follows the format: 

| Filecoin Release | Circuit | Directory Containing Attestations |
| :---: | :--- | :--- |
| Mainnet | PoRep-Poseidon-32GiB-e6055a1 | [sdr_porep_poseidon_32gib](/sdr_porep_poseidon_32gib)
| Mainnet | PoRep-Poseidon-64GiB-e6055a1 | [sdr_porep_poseidon_64gib](/sdr_porep_poseidon_64gib)
| Mainnet | Windowed-PoST-Poseidon-32GiB-e6055a1 | [windowed_post_poseidon_32gib](/windowed_post_poseidon_32gib)
| Mainnet | Windowed-PoST-Poseidon-64GiB-e6055a1 | [windowed_post_poseidon_64gib](/windowed_post_poseidon_64gib)
| Mainnet | Winning-PoST-Poseidon-32GiB-e6055a1 | [winning_post_poseidon_32gib](/winning_post_poseidon_32gib)
| Mainnet | Winning-PoST-Poseidon-64GiB-e6055a1 | [winning_post_poseidon_64gib](/winning_post_poseidon_64gib)

## Random Beacon [TODO - do we need this?]

Zcash announced on their ceremony mailing list that they would use the hash of a specific Bitcoin block. They made this announcement before the block was mined. See:

https://github.com/ZcashFoundation/powersoftau-attestations/tree/master/0088

A similar process can be used for this ceremony. Note that mining difficulty has grown since 2018, so there is now slightly less entropy per Bitcoin block hash.

## Procedure [TODO - do we need this?]

There is a coordinator and multiple participants. The ceremony occurs in sequential rounds. Each participant performs one or more rounds at a time. The coordinator decides the order in which the participants act. There can be an indefinite number of rounds.

The ceremony starts with the coordinator generating an initial `challenge` file, and publishing it in a publicly accessible repository.

The first participant downloads `challenge`, runs a computation to produce a `response` file, and sends it to the coordinator.

The coordinator will then produce a `new_challenge` file, and publish it along with the `response`. The next selected participant will then download `new_challenge` and produce a `response`, and the process repeats indefinitely.

Whenever a new zk-SNARK project needs to perform a trusted setup, they can pick the latest `response`, verify the entire chain of challenges and responses up to the selected response, and finally apply a random beacon to it. Next, they can move on to phase 2 of the trusted setup which is circuit-specific and out of scope of phase 1.

To illustrate this process, consider a Coordinator, two participants (Alice and Bob), and a zk-SNARK project author Charlie:

1. Coordinator generates `challenge_0` and publishes it.
2. Alice generates `response_1` and publishes it.
3. Coordinator generates `challenge_1` and publishes it.
4. Bob generates `response_2` and and publishes it.
5. Coordinator generates `challenge_2` and publishes it.
6. Charlie applies the random beacon to `challenge_2` to finalise the setup.

The resulting public transcript should contain:
 1. `challenge_0`
 2. `response_1`
 3. `challenge_1`
 4. `response_2`
 5. `challenge_2`
 6. The random beacon
 7. The final parameters

## The transcript

The transcript can be fully verified as long as it is public and that there are no bugs in the code used to generate challenges and responses.

Participants can choose to be anonymous. If they choose to be publicly known, they should own a GPG keypair whose public key is known to be associated with their real-world identity, socially or via any other means.

Given the above, the transcript should contain all the `challenge` and `response` files, and the Blake2b hash of each file.

It should also contain an attestation for each `response`. This is a text file with:

- Blake2b hashes of the `challenge` received and the `response` generated
- A detailed description of the hardware and software that the participant used to generate the `response`.
- A detailed description of any security and anti-surveillance measures that the partcipant has used.

Additionally, it should contain each participant's GPG signature of their attestation, so as to assure the public that it was generated by the person who had claimed to have done so.

## Logistics

The participation requirements vary for each of the circuits, but the table below details some sample information from our tests.

| Proof | Ram Req | Storage Req | Est. Completion Time | Challenge File Size |
|---|---|---|---|---|
| SDR PoRep 32GB  | 250GiB  | 150GiB | 36 hrs | 70GiB |
| SDR PoRep 64GB  | 250GiB | 150GiB | 36 hrs | 70GiB |
| Windowed Post 32GB | 250GiB | 150GiB | 36 hrs | 70GiB |
| Windowed Post 64GB | 250GiB | 150GiB | 36 hrs | 70GiB |
| Winning Post 32GB | 8GiB | 0.5GiB | 10-15 min. | 0.5GiB |
| Winning Post 64GB | 8GiB | 0.5GiB | 10-15 min. | 0.5GiB |

The coordinator is using AWS compute VMs to generate `new_challenge` files, and Blob Storage to host challenges and responses.

Each participant can transfer their response to the coordinator via `sftp`. This process is semi-interactive as it this requires either the participant to provide their SSH public key in advance, or the coordinator to send them a private key. Alternatively, they can use any of the following interactive methods:

- BitTorrent
- IPFS
- Third-party large-file transfer services like [MASV](https://www.massive.io)

## Coordination

A slack channel has been set up to discuss the ceremony - please join the **#fil-trustedsetup** room in our [Slack](https://join.slack.com/t/filecoinproject/shared_invite/zt-dj58b7fq-weyaTEvjHoYF_ENkQHR6Ig) or email us at trustedsetup@protocol.ai.

## Prereqs for the ceremony

* Set up a Linux machine and install Rust and Cargo following instructions [here](https://www.rust-lang.org).
* Ensure you have at least 110 GB of space free on your machine
* Ensure you have a GPG key set up (instructions [here](https://help.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key))

Prior to their participation window, each participant should install dependencies and build rust-fil-proofs. 

```
# Install dependencies: rustup, git, ssh, tmux, rsync, gpg, b2sum

# Build the phase2 binary for the commit in the participant’s circuit-id:
$ git clone https://github.com/filecoin-project/rust-fil-proofs.git
$ cd rust-fil-proofs

# If the circuit is not in HEAD:
$ git checkout <commit of circuit>
$ RUSTFLAGS="-C target-cpu=native" cargo build --release -p filecoin-proofs --bin=phase2
```
Additionally, the coordinator may be in touch to ensure you are able to smoothly download files for participation. 

## Instructions for each participant

At the start of the participant's window they will recieve a URL from which to download the appropriate Phase 2 parameters. 

For non-China based participants, they should run the following: 
```
$ cd <rust-fil-proofs directory>
$ tmux new -s phase2
$ aws s3 cp <s3 url for previous participant’s params file> .
```

For China based participants, they should run the following: 
```
$ cd <rust-fil-proofs directory>
$ tmux new -s phase2
$ [TODO - do we need a command here for JDCloud?]
```

Once the file has downloaded, check that the blake2 digest matches the digest in the previous participant's attestation file. This file should be the latest entry in your [circuit's folder](https://github.com/filecoin-project/phase2-attestations/#mapping-of-filecoin-releases-to-attestation-files). To generate the blake2 digest, run the following:
`$ b2sum <previous participant’s phase2 file>`

Once it has been validated that the two digests match, the next contribution can proceed. Running the following command will write two files, one file is the parameters generated from the participant’s entropy and the second is a log file (ending in “.log”). __Note__: the participant will be asked to mash the keys on their keyboard when the contribution program begins.

```
$ tmux attach -t phase2
$ RUST_BACKTRACE=1 ./target/release/phase2 contribute <previous participant’s params file>
```

Once this phase is complete, the participant has successfully made their contribution. To upload the output parameters to the rsync box, run the following: 

```
$ tmux attach -t phase2
$ rsync -vP --append -e "ssh -i <path to SSH private key>" <participant’s params file> response@rsync.kittyhawk.wtf:<participant’s params file>

# If the above command fails midway through the transfer, rerunning it will 
# resume the file transfer where it left off.
```

(Note it will only work if the participant has given the coordinator their ssh public key as required)

Lastly, to give credibility to the process, the participant must make an attestation of your participation with some link to your real-world identity; *this is essential for the credibility of the ceremony, and you should not sign-up in case you're not comfortable doing this.* To generate an adequate attestation, do the following: 

```
# Use the following info to fill out the attestation file. If the phase2
# files are large, you should run b2sum from a tmux window:
$ tmux attach -t phase2
$ b2sum <previous participant’s params file>
$ b2sum <participant’s params file>
$ cat <proof>_<hasher>_<sector-size>_<head>_<contribution number>.log
$ free -h
$ nproc
# The attestation file will be named README.md:
$ vim README.md

# Sign the attestation file using a detached signature:
$ gpg --armor --detach-sign --output README.md.sig README.md
```

Once both the README.md and README.md.sig are generated, please send these files to the coordinator (either on Slack or to mailto:trustedsetup@protocol.ai). Optionally also publish your contribution hash and gpg fingerprint via public channels.

**PLEASE NOTE: If you do not submit your attestation we will be unable to use your contribution.**

## Examples of entropy sources

1. `/dev/urandom` from one or more devices
3. The most recent Bitcoin block hash
2. Randomly mashing keys on the keyboard  
5. Asking random people on the street for numbers
6. Geiger readings of radioactive material. e.g. a radioactive object, which can be anything from a [banana](https://en.wikipedia.org/wiki/Banana_equivalent_dose) to a [Chernobyl fragment](https://www.vice.com/en_us/article/gy8yn7/power-tau-zcash-radioactive-toxic-waste).
7. Environmental data (e.g. the weather, seismic activity, or readings from the sun)

