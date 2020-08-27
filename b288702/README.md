# Mainnet Circuits

Circuits frozen at `rust-fil-proofs` commit: `b288702`

1. SDR-PoRep-32GiB (Poseidon)
2. SDR-PoRep-64GiB (Poseidon)
3. Winning-PoSt-32GiB (Poseidon)
4. Winning-PoSt-64GiB (Poseidon)
5. Window-PoSt-32GiB (Poseidon)
6. Window-PoSt-64GiB (Poseidon)

### Contribution Requirements

The following are requirements for participating in Filecoin's mainnet Phase 2. Note that runtime varies inversely with the number of CPU threads available.

| Circuit            | RAM Req. | Disk Space Req. | Runtime 96 CPU Threads | Runtime 8 CPU Threads |
| :------------------ | :--------: | :---------------: | :-----------------------: | :---------------------: |
| SDR-PoRep-32GiB    | 6GB      | 52GB            | 45m                    | 6h                    |
| SDR-PoRep-64GiB    | 6GB      | 52GB            | 45m                    | 6h                    |
| Window-PoSt-32GiB  | 6GB      | 52GB            | 45m                    | 6h                    |
| Window-PoSt-64GiB  | 6GB      | 52GB            | 45m                    | 6h                    |
| Winning-PoSt-32GiB | 1GB      | 250MB          | 10s                    | 1m                    |
| Winning-PoSt-64GiB | 1GB      | 250MB          | 10s                    | 1m                    |

## Phase 1

The Phase 1 output used as input to Phase 2 was derived from the [Perpetual Powers of
Tau](https://github.com/arielgabizon/perpetualpowersoftau), by running the
[`create_lagrange`](https://github.com/filecoin-project/powersoftau/blob/master/src/bin/create_lagrange.rs) program on
[Challenge 19](http://trusted-setup.filecoin.io/phase1/challenge_19) ([challenge_19
summary](https://github.com/arielgabizon/perpetualpowersoftau/blob/master/0018_GolemFactory_response/README.md)).

For this ceremony, no random beacon was used, and the `phase1radix` files used as input to phase 2 were derived
directly from the selected challenge.

> Applying the random beacon, enables proving security of the MPC under the Knowledge of Exponent assumption as shown in
> the [paper of Bowe, Gabizon and Miers](https://eprint.iacr.org/2017/1050.pdf). However, there is no known attack when
> the random beacon is omitted; and in fact, Mary Maller showed (see [A Proof of Security for the Sapling Generation of
> zk-SNARK Parameters in the Generic Group
> Model](https://github.com/zcash/sapling-security-analysis/blob/master/MaryMallerUpdated.pdf) and [Reinforcing the
> Security of the Sapling MPC](https://electriccoin.co/blog/reinforcing-the-security-of-the-sapling-mpc/)) that the MPC
> can be proven secure in the generic group model even when the random beacon is not used. Though the generic group
> model is a stronger assumption than the knowledge of exponent, this is arguably not a big issue in this context, as
> the generic group model is needed in any case for the security of the Groth16 zk-SNARK [—Ariel
> Gabizon](https://github.com/arielgabizon/perpetualpowersoftau)

Instructions for verifying Phase 1 will be published separately.

## Phase 2 Validation

**Note: The verification process is very computationally intensive. Verifying a *single* large-circuit contribution requires a peak 230GiB of memory and takes about 30 cpu-hours of single-threaded and another 200 cpu-hours of multi-threaded computation on a 2020-era cloud platform (r5a.8xlarge / AMD EPYC 7571)**

1. Build `rust-fil-proofs`, please also check its [Rust installation/build instructions](https://github.com/filecoin-project/rust-fil-proofs/blob/6e38487293a2ec063688acb4a414600b1c0654f9/README.md#install-and-configure-rust):

You will check out the commit corresponding to the [filecoin-proofs-v5.1.1](https://github.com/filecoin-project/rust-fil-proofs/releases/tag/filecoin-proofs-v5.1.1) tag, named explicitly below to ensure you are using the authoritative verification code.
```bash
$ git clone https://github.com/filecoin-project/rust-fil-proofs.git
$ cd rust-fil-proofs
$ git checkout a700f68
$ RUSTFLAGS="-C target-cpu=native" cargo build --release --bin phase2 && cp target/release/phase2 .
```

2. Download checksums file and verification script:

```bash
$ curl -O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/7112e23/b288702/verify_all.sh \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/7112e23/b288702/download_prereqs_for_initial_generation.sh \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/7112e23/b288702/generate_initial.sh \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/7112e23/b288702/download_prereqs_for_contrib.sh \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/7112e23/b288702/verify_contrib.sh \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/7112e23/b288702/download_prereqs_for_final.sh \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/7112e23/b288702/verify_final.sh \
&& chmod +x verify_all.sh download_prereqs_for_initial_generation.sh generate_initial.sh download_prereqs_for_contrib.sh download_prereqs_for_final.sh verify_contrib.sh verify_final.sh
```

3. Verify Phase2 contributions:

In order to run the verifcation, you will need to download the relevant [Phase 1](#phase-1) file for the circuit and run
the verification script for that specific circuit. The verification script will verify all Phase 2 contributions made to
the Groth16 parameters for a circuit of that specific size and check that the verified Groth16 parameters are being used
by the Filecoin network. The commands and associated Phase 1 file for each circuit are listed below.

All files that need to be downloaded for the verification process are stored on IPFS with root hash `QmNwDj9iUY3yJyDUP9yGagF6vFiorXEqx74pGn6RH2uTnz` and are also available at https://trusted-setup.filecoin.io/.

Running `verify_all.sh` as illustrated here is very time-consuming, especially for the large circuits (SDR-PoRep and
Window-PoSt). These commands are provided for reference, to clarify what must be verified. In practice, we recommend
that verifiers follow the instructions in the next section, **Verify all contributions individually**.


**Winning-PoSt**

```console
$ ./verify_all.sh winning 32
$ ./verify_all.sh winning 64
```

**SDR-PoRep**

```console
$ ./verify_all.sh sdr 32
$ ./verify_all.sh sdr 64
```

**Window-PoSt**

```console
$ ./verify_all.sh window 32
$ ./verify_all.sh window 64
```


### Verify contributions individually (suggested alternative to section 3. above)

If run sequentially, as presented below, the following command will take a very long time (months).

We encourage verifiers to split the command into smaller pieces and run them in parallel on multiple machines. Each
sub-command can be run independently, and each must be run at least once. Every sub-command must succeed for the
verification to succeed.

No precautions have been taken to ensure multiple processes running against the same storage will not clash with each
other. Because each verification step requires two sequential contribution files, groups of contributions verified using
the same storage should be verified sequentially. Otherwise, you risk two adjacent verifications simultaneously
requesting the same file.

```bash
bash -c '
  set -e

  ./download_prereqs_for_initial_generation.sh winning 32 && ./generate_initial.sh winning 32 && ./download_prereqs_for_contrib.sh winning 32 1 && ./verify_contrib.sh winning 32 1
  ./download_prereqs_for_contrib.sh winning 32 2 && ./verify_contrib.sh winning 32 2
  ./download_prereqs_for_contrib.sh winning 32 3 && ./verify_contrib.sh winning 32 3
  ./download_prereqs_for_contrib.sh winning 32 4 && ./verify_contrib.sh winning 32 4
  ./download_prereqs_for_contrib.sh winning 32 5 && ./verify_contrib.sh winning 32 5
  ./download_prereqs_for_contrib.sh winning 32 6 && ./verify_contrib.sh winning 32 6
  ./download_prereqs_for_contrib.sh winning 32 7 && ./verify_contrib.sh winning 32 7
  ./download_prereqs_for_contrib.sh winning 32 8 && ./verify_contrib.sh winning 32 8
  ./download_prereqs_for_contrib.sh winning 32 9 && ./verify_contrib.sh winning 32 9
  ./download_prereqs_for_contrib.sh winning 32 10 && ./verify_contrib.sh winning 32 10
  ./download_prereqs_for_contrib.sh winning 32 11 && ./verify_contrib.sh winning 32 11
  ./download_prereqs_for_contrib.sh winning 32 12 && ./verify_contrib.sh winning 32 12
  ./download_prereqs_for_contrib.sh winning 32 13 && ./verify_contrib.sh winning 32 13
  ./download_prereqs_for_contrib.sh winning 32 14 && ./verify_contrib.sh winning 32 14
  ./download_prereqs_for_contrib.sh winning 32 15 && ./verify_contrib.sh winning 32 15
  ./download_prereqs_for_contrib.sh winning 32 16 && ./verify_contrib.sh winning 32 16
  ./download_prereqs_for_contrib.sh winning 32 17 && ./verify_contrib.sh winning 32 17
  ./download_prereqs_for_contrib.sh winning 32 18 && ./verify_contrib.sh winning 32 18
  ./download_prereqs_for_contrib.sh winning 32 19 && ./verify_contrib.sh winning 32 19
  ./download_prereqs_for_contrib.sh winning 32 20 && ./verify_contrib.sh winning 32 20
  ./download_prereqs_for_final.sh winning 32 && ./verify_final.sh winning 32

  ./download_prereqs_for_initial_generation.sh winning 64 && ./generate_initial.sh winning 64 && ./download_prereqs_for_contrib.sh winning 64 1 && ./verify_contrib.sh winning 64 1
  ./download_prereqs_for_contrib.sh winning 64 2 && ./verify_contrib.sh winning 64 2
  ./download_prereqs_for_contrib.sh winning 64 3 && ./verify_contrib.sh winning 64 3
  ./download_prereqs_for_contrib.sh winning 64 4 && ./verify_contrib.sh winning 64 4
  ./download_prereqs_for_contrib.sh winning 64 5 && ./verify_contrib.sh winning 64 5
  ./download_prereqs_for_contrib.sh winning 64 6 && ./verify_contrib.sh winning 64 6
  ./download_prereqs_for_contrib.sh winning 64 7 && ./verify_contrib.sh winning 64 7
  ./download_prereqs_for_contrib.sh winning 64 8 && ./verify_contrib.sh winning 64 8
  ./download_prereqs_for_contrib.sh winning 64 9 && ./verify_contrib.sh winning 64 9
  ./download_prereqs_for_contrib.sh winning 64 10 && ./verify_contrib.sh winning 64 10
  ./download_prereqs_for_contrib.sh winning 64 11 && ./verify_contrib.sh winning 64 11
  ./download_prereqs_for_contrib.sh winning 64 12 && ./verify_contrib.sh winning 64 12
  ./download_prereqs_for_contrib.sh winning 64 13 && ./verify_contrib.sh winning 64 13
  ./download_prereqs_for_contrib.sh winning 64 14 && ./verify_contrib.sh winning 64 14
  ./download_prereqs_for_contrib.sh winning 64 15 && ./verify_contrib.sh winning 64 15
  ./download_prereqs_for_contrib.sh winning 64 16 && ./verify_contrib.sh winning 64 16
  ./download_prereqs_for_contrib.sh winning 64 17 && ./verify_contrib.sh winning 64 17
  ./download_prereqs_for_contrib.sh winning 64 18 && ./verify_contrib.sh winning 64 18
  ./download_prereqs_for_contrib.sh winning 64 19 && ./verify_contrib.sh winning 64 19
  ./download_prereqs_for_contrib.sh winning 64 20 && ./verify_contrib.sh winning 64 20
  ./download_prereqs_for_final.sh winning 64 && ./verify_final.sh winning 64

  ./download_prereqs_for_initial_generation.sh sdr 32 && ./generate_initial.sh sdr 32 && ./download_prereqs_for_contrib.sh sdr 32 1 && ./verify_contrib.sh sdr 32 1
  ./download_prereqs_for_contrib.sh sdr 32 2 && ./verify_contrib.sh sdr 32 2
  ./download_prereqs_for_contrib.sh sdr 32 3 && ./verify_contrib.sh sdr 32 3
  ./download_prereqs_for_contrib.sh sdr 32 4 && ./verify_contrib.sh sdr 32 4
  ./download_prereqs_for_contrib.sh sdr 32 5 && ./verify_contrib.sh sdr 32 5
  ./download_prereqs_for_contrib.sh sdr 32 6 && ./verify_contrib.sh sdr 32 6
  ./download_prereqs_for_contrib.sh sdr 32 7 && ./verify_contrib.sh sdr 32 7
  ./download_prereqs_for_contrib.sh sdr 32 8 && ./verify_contrib.sh sdr 32 8
  ./download_prereqs_for_contrib.sh sdr 32 9 && ./verify_contrib.sh sdr 32 9
  ./download_prereqs_for_contrib.sh sdr 32 10 && ./verify_contrib.sh sdr 32 10
  ./download_prereqs_for_contrib.sh sdr 32 11 && ./verify_contrib.sh sdr 32 11
  ./download_prereqs_for_contrib.sh sdr 32 12 && ./verify_contrib.sh sdr 32 12
  ./download_prereqs_for_contrib.sh sdr 32 13 && ./verify_contrib.sh sdr 32 13
  ./download_prereqs_for_contrib.sh sdr 32 14 && ./verify_contrib.sh sdr 32 14
  ./download_prereqs_for_contrib.sh sdr 32 15 && ./verify_contrib.sh sdr 32 15
  ./download_prereqs_for_contrib.sh sdr 32 16 && ./verify_contrib.sh sdr 32 16
  ./download_prereqs_for_contrib.sh sdr 32 17 && ./verify_contrib.sh sdr 32 17
  ./download_prereqs_for_final.sh sdr 32 && ./verify_final.sh sdr 32

  ./download_prereqs_for_initial_generation.sh sdr 64 && ./generate_initial.sh sdr 64 && ./download_prereqs_for_contrib.sh sdr 64 1 && ./verify_contrib.sh sdr 64 1
  ./download_prereqs_for_contrib.sh sdr 64 2 && ./verify_contrib.sh sdr 64 2
  ./download_prereqs_for_contrib.sh sdr 64 3 && ./verify_contrib.sh sdr 64 3
  ./download_prereqs_for_contrib.sh sdr 64 4 && ./verify_contrib.sh sdr 64 4
  ./download_prereqs_for_contrib.sh sdr 64 5 && ./verify_contrib.sh sdr 64 5
  ./download_prereqs_for_contrib.sh sdr 64 6 && ./verify_contrib.sh sdr 64 6
  ./download_prereqs_for_contrib.sh sdr 64 7 && ./verify_contrib.sh sdr 64 7
  ./download_prereqs_for_contrib.sh sdr 64 8 && ./verify_contrib.sh sdr 64 8
  ./download_prereqs_for_contrib.sh sdr 64 9 && ./verify_contrib.sh sdr 64 9
  ./download_prereqs_for_contrib.sh sdr 64 10 && ./verify_contrib.sh sdr 64 10
  ./download_prereqs_for_contrib.sh sdr 64 11 && ./verify_contrib.sh sdr 64 11
  ./download_prereqs_for_contrib.sh sdr 64 12 && ./verify_contrib.sh sdr 64 12
  ./download_prereqs_for_contrib.sh sdr 64 13 && ./verify_contrib.sh sdr 64 13
  ./download_prereqs_for_contrib.sh sdr 64 14 && ./verify_contrib.sh sdr 64 14
  ./download_prereqs_for_contrib.sh sdr 64 15 && ./verify_contrib.sh sdr 64 15
  ./download_prereqs_for_contrib.sh sdr 64 16 && ./verify_contrib.sh sdr 64 16
  ./download_prereqs_for_final.sh sdr 64 && ./verify_final.sh sdr 64

  ./download_prereqs_for_initial_generation.sh window 32 && ./generate_initial.sh window 32 && ./download_prereqs_for_contrib.sh window 32 1 && ./verify_contrib.sh window 32 1
  ./download_prereqs_for_contrib.sh window 32 2 && ./verify_contrib.sh window 32 2
  ./download_prereqs_for_contrib.sh window 32 3 && ./verify_contrib.sh window 32 3
  ./download_prereqs_for_contrib.sh window 32 4 && ./verify_contrib.sh window 32 4
  ./download_prereqs_for_contrib.sh window 32 5 && ./verify_contrib.sh window 32 5
  ./download_prereqs_for_contrib.sh window 32 6 && ./verify_contrib.sh window 32 6
  ./download_prereqs_for_contrib.sh window 32 7 && ./verify_contrib.sh window 32 7
  ./download_prereqs_for_contrib.sh window 32 8 && ./verify_contrib.sh window 32 8
  ./download_prereqs_for_contrib.sh window 32 9 && ./verify_contrib.sh window 32 9
  ./download_prereqs_for_contrib.sh window 32 10 && ./verify_contrib.sh window 32 10
  ./download_prereqs_for_contrib.sh window 32 11 && ./verify_contrib.sh window 32 11
  ./download_prereqs_for_contrib.sh window 32 12 && ./verify_contrib.sh window 32 12
  ./download_prereqs_for_contrib.sh window 32 13 && ./verify_contrib.sh window 32 13
  ./download_prereqs_for_contrib.sh window 32 14 && ./verify_contrib.sh window 32 14
  ./download_prereqs_for_contrib.sh window 32 15 && ./verify_contrib.sh window 32 15
  ./download_prereqs_for_final.sh window 32 && ./verify_final.sh window 32

  ./download_prereqs_for_initial_generation.sh window 64 && ./generate_initial.sh window 64 && ./download_prereqs_for_contrib.sh window 64 1 && ./verify_contrib.sh window 64 1
  ./download_prereqs_for_contrib.sh window 64 2 && ./verify_contrib.sh window 64 2
  ./download_prereqs_for_contrib.sh window 64 3 && ./verify_contrib.sh window 64 3
  ./download_prereqs_for_contrib.sh window 64 4 && ./verify_contrib.sh window 64 4
  ./download_prereqs_for_contrib.sh window 64 5 && ./verify_contrib.sh window 64 5
  ./download_prereqs_for_contrib.sh window 64 6 && ./verify_contrib.sh window 64 6
  ./download_prereqs_for_contrib.sh window 64 7 && ./verify_contrib.sh window 64 7
  ./download_prereqs_for_contrib.sh window 64 8 && ./verify_contrib.sh window 64 8
  ./download_prereqs_for_contrib.sh window 64 9 && ./verify_contrib.sh window 64 9
  ./download_prereqs_for_contrib.sh window 64 10 && ./verify_contrib.sh window 64 10
  ./download_prereqs_for_contrib.sh window 64 11 && ./verify_contrib.sh window 64 11
  ./download_prereqs_for_contrib.sh window 64 12 && ./verify_contrib.sh window 64 12
  ./download_prereqs_for_contrib.sh window 64 13 && ./verify_contrib.sh window 64 13
  ./download_prereqs_for_contrib.sh window 64 14 && ./verify_contrib.sh window 64 14
  ./download_prereqs_for_contrib.sh window 64 15 && ./verify_contrib.sh window 64 15
  ./download_prereqs_for_final.sh window 64 && ./verify_final.sh window 64
'
```

## Participants

A keyring with all keys linked below can be created directly from this file via `grep '^\['|cut -d ' ' -f 2|xargs -n 1 sh -c 'echo $0 && curl --silent --location $0| gpg --no-default-keyring --keyring ./keyring.gpg --import`.

### Winning PoSt 32

| Participant number | Identity      | GPG key                                    | Attestation                                                                                                                                                                                                    |
| -: | ----------------------------- | ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  1 | Aztec / Ariel Gazibon         | Unsigned                                   | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_1_small_raw.contrib)                                                                                                                                                                                               |
|  2 | Sigma Prime                   | [DCF37E025D6C9D42EA795B119E7C6CF9988604BE] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_2_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_2_small_raw.contrib.sig)  |
|  3 | Secbit                        | [2DEC9079A3CD683D5960179490BB8DF9A0EC8CEB] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_3_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_3_small_raw.contrib.sig)  |
|  4 | IPFSMain / Neo                | [81A43F8212A74D1CD4F0A5EBE4069A8862148F3C] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_4_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_4_small_raw.contrib.sig)  |
|  5 | Brian Nguyen                  | [C692A56364D320463435392AAC3BFB01C9F0F90E] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_5_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_5_small_raw.contrib.sig)  |
|  6 | Filecoin / Why                | [9995C13232D69152E3272478D672BC9070F89B55] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_6_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_6_small_raw.contrib.sig)  |
|  7 | DecentralTech                 | [51B541DC1545368EE13D16690D5AABE39555537E] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_7_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_7_small_raw.contrib.sig)  |
|  8 | Filecoin / Nemo               | [FE2C636C05D4EB47B05032289116924305EE3036] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_8_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_8_small_raw.contrib.sig)  |
|  9 | BoringWang                    | [BA526F73D477EF6A7382FA468138E2AD3A996138] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_9_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_9_small_raw.contrib.sig)  |
| 10 | Benjamin H                    | [FDABB36AD8F8DB202E651DFAFDEA6BC9A35D28E3] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_10_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_10_small_raw.contrib.sig) |
| 11 | Supranational                 | [5EE6C970F17007BFC927F14D689F78063991F488] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_11_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_11_small_raw.contrib.sig) |
| 12 | Coinsummer                    | [7E50322678BE644032B7E22C13FCA3A10CDA4C00] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_12_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_12_small_raw.contrib.sig) |
| 13 | Hashquark / Allen             | [40B8506807F1712B58F546C9AAAE14FFF3FB4FFB] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_13_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_13_small_raw.contrib.sig) |
| 14 | Factor8 Solutions / Patrick   | [490B12E912D4DD6F00CB0F02A7E566E186C99D5D] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_14_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_14_small_raw.contrib.sig) |
| 15 | Filecoin / DrPeterVanNostrand | [EA3C4C2614419DEEB24CDFF5CE747682112116CC] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_15_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_15_small_raw.contrib.sig) |
| 16 | Finality Labs / Keyvan        | [07D08516B86F86F75CCC1279F44DB155D555DE17] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_16_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_16_small_raw.contrib.sig) |
| 17 | Justin Drake                  | [0904B53E09B60248702F6125186C53583A3C1588] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_17_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_17_small_raw.contrib.sig) |
| 18 | Filecoin / Porcuquine         | [D921AFAFAAAB09E01D304152BF109CFF8075B4EF] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_18_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_18_small_raw.contrib.sig) |
| 19 | Consensys / Joseph Chow       | [99C059B41A1F453FAC0EFCFC85DBA4632A551FBD] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_19_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_19_small_raw.contrib.sig) |
| 20 | Aztec / Ariel Gazibon         | [220978D0CA4CE826D01BE8013318E7A87167141F] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_32gib_b288702_20_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-32/winning_poseidon_32gib_b288702_20_small_raw.contrib.sig) |


### Winning PoSt 64


| Participant number | Identity      | GPG key                                    | Attestation                                                                                                                                                                                                    |
| -: | ----------------------------- | ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  1 | Aztec / Ariel Gazibon         | Unsigned                                   | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_1_small_raw.contrib)                                                                                                                                                                                               |
|  2 | Sigma Prime                   | [DCF37E025D6C9D42EA795B119E7C6CF9988604BE] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_2_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_2_small_raw.contrib.sig)  |
|  3 | Secbit                        | [2DEC9079A3CD683D5960179490BB8DF9A0EC8CEB] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_3_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_3_small_raw.contrib.sig)  |
|  4 | IPFSMain / Neo                | [81A43F8212A74D1CD4F0A5EBE4069A8862148F3C] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_4_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_4_small_raw.contrib.sig)  |
|  5 | Brian Nguyen                  | [C692A56364D320463435392AAC3BFB01C9F0F90E] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_5_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_5_small_raw.contrib.sig)  |
|  6 | Filecoin / Why                | [9995C13232D69152E3272478D672BC9070F89B55] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_6_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_6_small_raw.contrib.sig)  |
|  7 | DecentralTech                 | [51B541DC1545368EE13D16690D5AABE39555537E] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_7_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_7_small_raw.contrib.sig)  |
|  8 | Filecoin / Nemo               | [FE2C636C05D4EB47B05032289116924305EE3036] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_8_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_8_small_raw.contrib.sig)  |
|  9 | BoringWang                    | [BA526F73D477EF6A7382FA468138E2AD3A996138] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_9_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_9_small_raw.contrib.sig)  |
| 10 | Benjamin H                    | [FDABB36AD8F8DB202E651DFAFDEA6BC9A35D28E3] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_10_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_10_small_raw.contrib.sig) |
| 11 | Supranational                 | [5EE6C970F17007BFC927F14D689F78063991F488] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_11_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_11_small_raw.contrib.sig) |
| 12 | Coinsummer                    | [7E50322678BE644032B7E22C13FCA3A10CDA4C00] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_12_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_12_small_raw.contrib.sig) |
| 13 | Hashquark / Allen             | [40B8506807F1712B58F546C9AAAE14FFF3FB4FFB] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_13_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_13_small_raw.contrib.sig) |
| 14 | Factor8 Solutions / Patrick   | [490B12E912D4DD6F00CB0F02A7E566E186C99D5D] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_14_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_14_small_raw.contrib.sig) |
| 15 | Filecoin / DrPeterVanNostrand | [EA3C4C2614419DEEB24CDFF5CE747682112116CC] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_15_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_15_small_raw.contrib.sig) |
| 16 | Finality Labs / Keyvan        | [07D08516B86F86F75CCC1279F44DB155D555DE17] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_16_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_16_small_raw.contrib.sig) |
| 17 | Justin Drake                  | [0904B53E09B60248702F6125186C53583A3C1588] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_17_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_17_small_raw.contrib.sig) |
| 18 | Filecoin / Porcuquine         | [D921AFAFAAAB09E01D304152BF109CFF8075B4EF] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_18_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_18_small_raw.contrib.sig) |
| 19 | Consensys / Joseph Chow       | [99C059B41A1F453FAC0EFCFC85DBA4632A551FBD] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_19_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_19_small_raw.contrib.sig) |
| 20 | Aztec / Ariel Gazibon         | [220978D0CA4CE826D01BE8013318E7A87167141F] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/winning_poseidon_64gib_b288702_20_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/winning-64/winning_poseidon_64gib_b288702_20_small_raw.contrib.sig) |


### Window PoSt 32

| Participant number | Identity | GPG key                                    | Attestation                                                                                                                                                                                                 |
| -: | ------------------------ |------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  1 | IPFSMain / Neo           | [81A43F8212A74D1CD4F0A5EBE4069A8862148F3C] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_1_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_1_small_raw.contrib.sig)  |
|  2 | Grandhelmsmen            | [1E4A13157FFD78D9111D7E2C466A69E6726183AC] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_2_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_2_small_raw.contrib.sig)  |
|  3 | DianCun                  | [7AEDD14FDBDD8D4124688822D5C8387E21DEF0D0] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_3_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_3_small_raw.contrib.sig)  |
|  4 | BoringWang               | [BA526F73D477EF6A7382FA468138E2AD3A996138] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_4_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_4_small_raw.contrib.sig)  |
|  5 | DecentralTech            | [51B541DC1545368EE13D16690D5AABE39555537E] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_5_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_5_small_raw.contrib.sig)  |
|  6 | IPFS-Force               | [68D78BA5A310333B683E868B05FF7B692BA59330] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_6_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_6_small_raw.contrib.sig)  |
|  7 | Cobo                     | [2DC71276BCF749F9650C6095B509689DE72DF5B4] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_7_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_7_small_raw.contrib.sig)  |
|  8 | Ocean / Alex Corseru     | [E7DC101F62593420770DD4396B2BB688242684A7] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_8_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_8_small_raw.contrib.sig)  |
|  9 | Filecoin / Why           | [9995C13232D69152E3272478D672BC9070F89B55] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_9_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_9_small_raw.contrib.sig)  |
| 10 | Supranational            | [5EE6C970F17007BFC927F14D689F78063991F488] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_10_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_10_small_raw.contrib.sig) |
| 11 | Filecoin / Porcuquine    | [D921AFAFAAAB09E01D304152BF109CFF8075B4EF] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_11_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_11_small_raw.contrib.sig) |
| 12 | Troels Henriksen         | [EF4B78D52412EC137593B76C9C694EF92FDC6BD7] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_12_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_12_small_raw.contrib.sig) |
| 13 | Vulcanize / A. F. Dudley | [43C0815DD3EE62AF3A17A78E8B803A0DEF1F5BF2] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_13_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_13_small_raw.contrib.sig) |
| 14 | Filecoin / Nemo          | [FE2C636C05D4EB47B05032289116924305EE3036] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_14_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_14_small_raw.contrib.sig) |
| 15 | Aztec / Ariel Gazibon    | [220978D0CA4CE826D01BE8013318E7A87167141F] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_32gib_b288702_15_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-32/window_poseidon_32ib_b288702_15_small_raw.contrib.sig) |


### Window PoSt 64

| Participant number | Identity | GPG key                                    | Attestation                                                                                                                                                                                                  |
| -: | ------------------------ |------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
|  1 | IPFSMain / Neo           | [81A43F8212A74D1CD4F0A5EBE4069A8862148F3C] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_1_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_1_small_raw.contrib.sig)  |
|  2 | DianCun                  | [7AEDD14FDBDD8D4124688822D5C8387E21DEF0D0] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_2_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_2_small_raw.contrib.sig)  |
|  3 | Kikakkz                  | [A5D873EC002CFBC089F94AD18E2E12B117C86AA2] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_3_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_3_small_raw.contrib.sig)  |
|  4 | Secbit                   | [2DEC9079A3CD683D5960179490BB8DF9A0EC8CEB] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_4_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_4_small_raw.contrib.sig)  |
|  5 | BoringWang               | [BA526F73D477EF6A7382FA468138E2AD3A996138] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_5_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_5_small_raw.contrib.sig)  |
|  6 | DecentralTech            | [51B541DC1545368EE13D16690D5AABE39555537E] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_6_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_6_small_raw.contrib.sig)  |
|  7 | Grandhelmsmen            | 3B32CC835F1AB9CC1144851E4952E3E5CB67BCD1   | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_7_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_7_small_raw.contrib.sig)  |
|  8 | IPFS-Force               | [68D78BA5A310333B683E868B05FF7B692BA59330] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_8_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_8_small_raw.contrib.sig)  |
|  9 | Filecoin / Magik         | [F91D16FC1ABB4DAE9CE7898A950EFDA643B35B2B] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_9_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_9_small_raw.contrib.sig)  |
| 10 | Supranational            | [5EE6C970F17007BFC927F14D689F78063991F488] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_10_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_10_small_raw.contrib.sig) |
| 11 | Filecoin / Porcuquine    | [D921AFAFAAAB09E01D304152BF109CFF8075B4EF] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_11_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_11_small_raw.contrib.sig) |
| 12 | Vulcanize / A. F. Dudley | [43C0815DD3EE62AF3A17A78E8B803A0DEF1F5BF2] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_12_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_12_small_raw.contrib.sig) |
| 13 | Troels Henriksen         | [EF4B78D52412EC137593B76C9C694EF92FDC6BD7] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_13_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_13_small_raw.contrib.sig) |
| 14 | Filecoin / Nemo          | [FE2C636C05D4EB47B05032289116924305EE3036] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_14_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_14_small_raw.contrib.sig) |
| 15 | Aztec / Ariel Gazibon    | [220978D0CA4CE826D01BE8013318E7A87167141F] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/window_poseidon_64gib_b288702_15_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/window-64/window_poseidon_64gib_b288702_15_small_raw.contrib.sig) |


### SDR PoRep 32

| Participant number | Identity      | GPG key                                    | Attestation                                                                                                                                                                                            |
| -: | ----------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
|  1 | IPFSMain / Neo                | [81A43F8212A74D1CD4F0A5EBE4069A8862148F3C] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_1_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_1_small_raw.contrib.sig)  |
|  2 | Brian Nguyen                  | [C692A56364D320463435392AAC3BFB01C9F0F90E] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_2_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_2_small_raw.contrib.sig)  |
|  3 | Benjamin H                    | [FDABB36AD8F8DB202E651DFAFDEA6BC9A35D28E3] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_3_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_3_small_raw.contrib.sig)  |
|  4 | Supranational                 | [5EE6C970F17007BFC927F14D689F78063991F488] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_4_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_4_small_raw.contrib.sig)  |
|  5 | Sigma Prime                   | [DCF37E025D6C9D42EA795B119E7C6CF9988604BE] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_5_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_5_small_raw.contrib.sig)  |
|  6 | Angelov                       | [546B352AFEB9765C2397051E366166F0FD0EA3AD] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_6_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_6_small_raw.contrib.sig)  |
|  7 | Factor8 Solutions / Patrick   | [490B12E912D4DD6F00CB0F02A7E566E186C99D5D] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_7_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_7_small_raw.contrib.sig)  |
|  8 | Filecoin / DrPeterVanNostrand | [EA3C4C2614419DEEB24CDFF5CE747682112116CC] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_8_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_8_small_raw.contrib.sig)  |
|  9 | Cobo                          | [2DC71276BCF749F9650C6095B509689DE72DF5B4] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_9_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_9_small_raw.contrib.sig)  |
| 10 | Filecoin / Magik              | [0AEC3BE0254BAEC79D9A2EF7490B4DFEC69885A9] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_10_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_10_small_raw.contrib.sig) |
| 11 | Filecoin / Porcuquine         | [D921AFAFAAAB09E01D304152BF109CFF8075B4EF] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_11_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_11_small_raw.contrib.sig) |
| 12 | Filecoin / Dignifiedquire     | [6849A7A2125487AC272843E0AC5EA47B6D50F36A] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_12_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_12_small_raw.contrib.sig) |
| 13 | Ocean / Alex Coseru           | [E7DC101F62593420770DD4396B2BB688242684A7] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_13_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_13_small_raw.contrib.sig) |
| 14 | Zcash / Benjamin Winston      | [482711C3E31380855F733C79D49EB2E3D9B26644] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_14_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_14_small_raw.contrib.sig) |
| 15 | Consensys / Alexander Wade    | [C34D81388094DEDF9D8BACB8BC959DFAAF5870F2] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_15_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_15_small_raw.contrib.sig) |
| 16 | Filecoin / Nemo               | [FE2C636C05D4EB47B05032289116924305EE3036] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_16_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_16_small_raw.contrib.sig) |
| 17 | Aztec / Ariel Gazibon         | [220978D0CA4CE826D01BE8013318E7A87167141F] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_32gib_b288702_17_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-32/sdr_poseidon_32gib_b288702_17_small_raw.contrib.sig) |


### SDR PoRep 64

| Participant number | Identity      | GPG key                                    | Attestation                                                                                                                                                                                            |
| -: | ----------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
|  1 | IPFSMain / Neo                | [81A43F8212A74D1CD4F0A5EBE4069A8862148F3C] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_1_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_1_small_raw.contrib.sig)  |
|  2 | DecentralTech                 | AC41FCDC3603C3E94A11FA73D9C52C2892D7364A   | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_2_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_2_small_raw.contrib.sig)  |
|  3 | DianCun                       | [7AEDD14FDBDD8D4124688822D5C8387E21DEF0D0] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_3_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_3_small_raw.contrib.sig)  |
|  4 | Coinsummer                    | [7E50322678BE644032B7E22C13FCA3A10CDA4C00] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_4_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_4_small_raw.contrib.sig)  |
|  5 | Factor8 Solutions / Patrick   | [490B12E912D4DD6F00CB0F02A7E566E186C99D5D] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_5_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_5_small_raw.contrib.sig)  |
|  6 | Supranational                 | [5EE6C970F17007BFC927F14D689F78063991F488] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_6_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_6_small_raw.contrib.sig)  |
|  7 | James Hanson                  | [8C637AE7F87593A3EB77BD01B95BBD5E7C7FBCC7] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_7_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_7_small_raw.contrib.sig)  |
|  8 | Angelov                       | [546B352AFEB9765C2397051E366166F0FD0EA3AD] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_8_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_8_small_raw.contrib.sig)  |
|  9 | Filecoin / Dignifiedquire     | [6849A7A2125487AC272843E0AC5EA47B6D50F36A] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_9_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_9_small_raw.contrib.sig)  |
| 10 | Filecoin / DrPetervanNostrand | [EA3C4C2614419DEEB24CDFF5CE747682112116CC] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_10_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_10_small_raw.contrib.sig) |
| 11 | Filecoin / Why                | [9995C13232D69152E3272478D672BC9070F89B55] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_11_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_11_small_raw.contrib.sig) |
| 12 | Filecoin / Porcuquine         | [D921AFAFAAAB09E01D304152BF109CFF8075B4EF] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_12_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_12_small_raw.contrib.sig) |
| 13 | Ocean / Alex Coseru           | [E7DC101F62593420770DD4396B2BB688242684A7] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_13_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_13_small_raw.contrib.sig) |
| 14 | JP Aumussen                   | [B98E940A863AD00331D277F62C393D4AD070AF18] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_14_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_14_small_raw.contrib.sig) |
| 15 | Filecoin / Nemo               | [FE2C636C05D4EB47B05032289116924305EE3036] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_15_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_15_small_raw.contrib.sig) |
| 16 | Aztec / Ariel Gazibon         | [220978D0CA4CE826D01BE8013318E7A87167141F] | [Contribution](https://trusted-setup.filecoin.io/phase2/v28/sdr_poseidon_64gib_b288702_16_small_raw.contrib) [Signature](https://github.com/filecoin-project/phase2-attestations/blob/0fa121e02fcef3a74b90e489b18dfff85af79c42/b288702/sdr-64/sdr_poseidon_64gib_b288702_16_small_raw.contrib.sig) |


[DCF37E025D6C9D42EA795B119E7C6CF9988604BE]: https://keybase.io/sigp/pgp_keys.asc
[2DEC9079A3CD683D5960179490BB8DF9A0EC8CEB]: https://gist.githubusercontent.com/p0n1/bb1731b9719212e251e510341659e625/raw/abd7762df2a33459c300d8458335ad74d8688351/pubkey.gpg
[81A43F8212A74D1CD4F0A5EBE4069A8862148F3C]: https://github.com/NeoGe-IPFSMain.gpg
[C692A56364D320463435392AAC3BFB01C9F0F90E]: http://filecoin-vietnam.com/pub_key.asc
[9995C13232D69152E3272478D672BC9070F89B55]: https://gist.githubusercontent.com/whyrusleeping/0180604d35da0d54875b22a72b125046/raw/2b5e83ba55b1cab25361c68a36f806581fa87287/filecoin%2520phase2%2520gpg%2520public%2520key
[FE2C636C05D4EB47B05032289116924305EE3036]: https://gist.githubusercontent.com/cryptonemo/c3e3a120199de6c015d09709a6ef03f5/raw/8adfcbd060a9f58964f65fa5d081a8b84b26352e/Filecoin%2520phase2%2520signing%2520public%2520key
[BA526F73D477EF6A7382FA468138E2AD3A996138]: https://gist.githubusercontent.com/pulupulu01/9567509de8adae4a18a59e9ff8089226/raw/49304b32be64a8a1183861e299da96953ecbda62/pub_key.asc
[FDABB36AD8F8DB202E651DFAFDEA6BC9A35D28E3]: https://github.com/benjaminh83.gpg
[5EE6C970F17007BFC927F14D689F78063991F488]: https://gist.githubusercontent.com/simonatsn/b7834bc727ec98e2953e678beffd1ee8/raw/5dfbf809065108a1ac57d32c9961e8c7de53373a/pl_mpc_pubkey.txt
[40B8506807F1712B58F546C9AAAE14FFF3FB4FFB]: https://gist.githubusercontent.com/FlankerSea/a18664b4227bfbda4a7c4d324ceb16ff/raw/e5b2230f5660ffb76c0d51a8817910c76b75db59/pub_key.asc
[490B12E912D4DD6F00CB0F02A7E566E186C99D5D]: https://cloud.factor8.io/s/FHfEi4trFqqFPHX/download?path=/&files=fc_tsp2_f8_gpg.pub
[EA3C4C2614419DEEB24CDFF5CE747682112116CC]: https://gist.githubusercontent.com/DrPeterVanNostrand/8cabcd16165a589a5b598bc697d1fa44/raw/455e8054f0fb901591ea99aa53f6e9837c041e31/pub_key.asc
[07D08516B86F86F75CCC1279F44DB155D555DE17]: https://gist.githubusercontent.com/keyvank/ce17951a4dceb9b6365c2af55f841bd4/raw/090f991466ce669bb6584c435f44c512ef934b2f/filecoin_trusted_setup_keyvan.asc
[0904B53E09B60248702F6125186C53583A3C1588]: https://gist.githubusercontent.com/JustinDrake/311885f40be1523f433c6ee6808c994e/raw/dfc43bd21e789db8e60444edc88d723adc382710/pub_key
[D921AFAFAAAB09E01D304152BF109CFF8075B4EF]: https://keybase.io/porcuquine/pgp_keys.asc
[99C059B41A1F453FAC0EFCFC85DBA4632A551FBD]: https://keybase.io/cdili/pgp_keys.asc?fingerprint=99c059b41a1f453fac0efcfc85dba4632a551fbd
[220978D0CA4CE826D01BE8013318E7A87167141F]: https://drive.google.com/uc?id=1mEoBDniy60zWkAC07n5VHw8YjSjAewc6
[1E4A13157FFD78D9111D7E2C466A69E6726183AC]: https://gist.githubusercontent.com/chenzhi201901/2dd49120717a7c9c0c0798841c22c3a0/raw/cdc7a4ba1a36eb0ce8ffa3bc1e3b3570a1fd69e9/GPG%2520pub
[7AEDD14FDBDD8D4124688822D5C8387E21DEF0D0]: https://gist.githubusercontent.com/wangyancun/98952c06e8382f0b868f3d2af62f7bb2/raw/3cc834e901cf745baa41443174bbc93e4d15c286/pub_key.asc
[68D78BA5A310333B683E868B05FF7B692BA59330]: https://gist.githubusercontent.com/steven004/1caead397993ac6f8f12efaa0e5ab870/raw/d6609cf5df739b9f08524006cef02c8831831356/pgp_public_key.asc
[E7DC101F62593420770DD4396B2BB688242684A7]: https://github.com/alexcos20.gpg
[EF4B78D52412EC137593B76C9C694EF92FDC6BD7]: https://sigkill.dk/pubkey.asc
[A5D873EC002CFBC089F94AD18E2E12B117C86AA2]: https://gist.githubusercontent.com/kikakkz/66d94944cc23eb66286140c359ada379/raw/8cd5873cd042863cd19efb5e8cb3befd7b0f39cf/A5D873EC002CFBC089F94AD18E2E12B117C86AA2
[F91D16FC1ABB4DAE9CE7898A950EFDA643B35B2B]: https://gist.githubusercontent.com/magik6k/46cdb2019d4ed7d013c1e58c8026b9bc/raw/0b0643df6daa74a7cf01325f3012fa6902a2ded2/pub_key.asc
[0AEC3BE0254BAEC79D9A2EF7490B4DFEC69885A9]: https://gist.githubusercontent.com/magik6k/2cefeb4a4bab1a618acf695113a98764/raw/b55fd174797667a29808421940f58d5fa28e0ecc/pub_key.asc
[546B352AFEB9765C2397051E366166F0FD0EA3AD]: https://gist.githubusercontent.com/angelov81/f2a2b1ded4605976e40729a42d43d4e5/raw/ee543086d862563bde6aa931d6664e9142465648/pub_key.asc
[6849A7A2125487AC272843E0AC5EA47B6D50F36A]: https://keybase.io/dignifiedquire/pgp_keys.asc?fingerprint=6849a7a2125487ac272843e0ac5ea47b6d50f36a
[482711C3E31380855F733C79D49EB2E3D9B26644]: https://gist.githubusercontent.com/zebambam/48113535c9a9ced938348d375478a6ab/raw/8237d0296a29f48057406aa0a5fc7ed2b81176f4/bambam@z.cash.gpg
[C34D81388094DEDF9D8BACB8BC959DFAAF5870F2]: https://raw.githubusercontent.com/wadeAlexC/GPG/f211807195de4d34790019918e0901e4dbd6f089/README.md
[8C637AE7F87593A3EB77BD01B95BBD5E7C7FBCC7]: https://github.com/druktsal.gpg
[B98E940A863AD00331D277F62C393D4AD070AF18]: https://gist.githubusercontent.com/veorq/c29a9ba387e06a6efd37d81cb78e25d0/raw/b7fef9b6a54d83989395beedec6f2504eebcb29a/keys.keys
[43C0815DD3EE62AF3A17A78E8B803A0DEF1F5BF2]: https://gist.githubusercontent.com/AFDudley/f35be37fb27661880d8ad1bc45b8a4b7/raw/a2610a38fd11dce4524cb5e072291dafb4deb761/A887B036F9E93223-public.gpg
[2DC71276BCF749F9650C6095B509689DE72DF5B4]: https://gist.githubusercontent.com/cobogithub/186b7bcd682a79ddbbbfa5fb4d6d5e88/raw/a10b6621a7f4f68591ead2ab9e342389401d32b1/gistfile1.txt
[51B541DC1545368EE13D16690D5AABE39555537E]: https://gist.githubusercontent.com/DecentralTech/c2619d383f9892ebcb2a1c0f0769db23/raw/9c5326a4fbfaef0ea183fa8d439f3cde63588c79/decentral_pubkey.txt
[7E50322678BE644032B7E22C13FCA3A10CDA4C00]: https://gist.githubusercontent.com/ksaynice/24421bae8194bc3cf3cd3e671c1293c2/raw/02ddd0e4b264f8dd9683e87ecd93430f902056dc/pub_key.asc
