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

## Phase 2 Validation

**Note: We recommend you use a machine with 96 cores, 180GB of RAM, and 50GB swap for running verification**

1. Build `rust-fil-proofs`, please also check its [Rust installation/build instructions](https://github.com/filecoin-project/rust-fil-proofs/blob/6e38487293a2ec063688acb4a414600b1c0654f9/README.md#install-and-configure-rust):

You will check out the commit corresponding to the [filecoin-proofs-v5.1.1](https://github.com/filecoin-project/rust-fil-proofs/releases/tag/filecoin-proofs-v5.1.1) tag, named explicitly below to ensure you are using the authoritative verification code.
```bash
$ git clone https://github.com/filecoin-project/rust-fil-proofs.git
$ cd rust-fil-proofs
$ git checkout a700f68
$ cargo build --release --bin phase2 && cp target/release/phase2 .
```

2. Download checksums file and verification script:

```bash
$ curl -O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/108b5af/b288702/b288702.b2sums \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/108b5af/b288702/verify_all.sh \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/108b5af/b288702/verify_initial.sh \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/108b5af/b288702/verify_contrib.sh \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/108b5af/b288702/verify_final.sh \
&& chmod +x verify_all.sh verify_initial.sh verify_contrib.sh verify_final.sh
```

3. Verify Phase2 contributions:

In order to run the verifcation, you will need to download the relevant Phase 1 file for the circuit and run the
verification script for that specific circuit. The verification script will verify all Phase 2 contributions made to the
Groth16 parameters for a circuit of that specific size and check that the verified Groth16 parameters are being used by
the Filecoin network. The commands and associated Phase 1 file for each circuit are listed below.

Running `verify_all.sh` as illustrated here is very time-consuming, especially for the large circuits (SDR-PoRep and
Window-PoSt). These commands are provided for reference, to clarify what must be verified. In practice, we recommend
that verifiers follow the instructions in the next section, **Verify all contributions individually**.


**Winning-PoSt**

* Download the Phase 1 file `phase1radix2m19`.

```
$ curl -O https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m19
$ ./verify_all.sh winning 32
$ ./verify_all.sh winning 64
```

**SDR-PoRep and Window-PoSt**

* Download the Phase 1 file `phase1radix2m27`.

```bash
$ curl -O https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m27
$ ./verify_all.sh sdr 32
$ ./verify_all.sh sdr 64
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

There is one additional dependency: `verify_initial.sh` must be run before `verify_contrib.sh` for the first contrib of
every circuit. This is because the 'before' parameters for the first transition cannot be downloaded: they must be
deterministically generated from the target circuit.

```bash
bash -c '
  set -e
  curl -O https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m19

  ./verify_initial.sh winning 32
  ./verify_contrib.sh winning 32 1
  ./verify_contrib.sh winning 32 2
  ./verify_contrib.sh winning 32 3
  ./verify_contrib.sh winning 32 4
  ./verify_contrib.sh winning 32 5
  ./verify_contrib.sh winning 32 6
  ./verify_contrib.sh winning 32 7
  ./verify_contrib.sh winning 32 8
  ./verify_contrib.sh winning 32 9
  ./verify_contrib.sh winning 32 10
  ./verify_contrib.sh winning 32 11
  ./verify_contrib.sh winning 32 12
  ./verify_contrib.sh winning 32 13
  ./verify_contrib.sh winning 32 14
  ./verify_contrib.sh winning 32 15
  ./verify_contrib.sh winning 32 16
  ./verify_contrib.sh winning 32 17
  ./verify_contrib.sh winning 32 18
  ./verify_contrib.sh winning 32 19
  ./verify_contrib.sh winning 32 20
  ./verify_final.sh winning 32

  ./verify_initial.sh winning 64
  ./verify_contrib.sh winning 64 1
  ./verify_contrib.sh winning 64 2
  ./verify_contrib.sh winning 64 3
  ./verify_contrib.sh winning 64 4
  ./verify_contrib.sh winning 64 5
  ./verify_contrib.sh winning 64 6
  ./verify_contrib.sh winning 64 7
  ./verify_contrib.sh winning 64 8
  ./verify_contrib.sh winning 64 9
  ./verify_contrib.sh winning 64 10
  ./verify_contrib.sh winning 64 11
  ./verify_contrib.sh winning 64 12
  ./verify_contrib.sh winning 64 13
  ./verify_contrib.sh winning 64 14
  ./verify_contrib.sh winning 64 15
  ./verify_contrib.sh winning 64 16
  ./verify_contrib.sh winning 64 17
  ./verify_contrib.sh winning 64 18
  ./verify_contrib.sh winning 64 19
  ./verify_contrib.sh winning 64 20
  ./verify_final.sh winning 64

  curl -O https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m27

  ./verify_initial.sh sdr 32
  ./verify_contrib.sh sdr 32 1
  ./verify_contrib.sh sdr 32 2
  ./verify_contrib.sh sdr 32 3
  ./verify_contrib.sh sdr 32 4
  ./verify_contrib.sh sdr 32 5
  ./verify_contrib.sh sdr 32 6
  ./verify_contrib.sh sdr 32 7
  ./verify_contrib.sh sdr 32 8
  ./verify_contrib.sh sdr 32 9
  ./verify_contrib.sh sdr 32 10
  ./verify_contrib.sh sdr 32 11
  ./verify_contrib.sh sdr 32 12
  ./verify_contrib.sh sdr 32 13
  ./verify_contrib.sh sdr 32 14
  ./verify_contrib.sh sdr 32 15
  ./verify_contrib.sh sdr 32 16
  ./verify_contrib.sh sdr 32 17
  ./verify_final.sh sdr 32

  ./verify_initial.sh sdr 64
  ./verify_contrib.sh sdr 64 1
  ./verify_contrib.sh sdr 64 2
  ./verify_contrib.sh sdr 64 3
  ./verify_contrib.sh sdr 64 4
  ./verify_contrib.sh sdr 64 5
  ./verify_contrib.sh sdr 64 6
  ./verify_contrib.sh sdr 64 7
  ./verify_contrib.sh sdr 64 8
  ./verify_contrib.sh sdr 64 9
  ./verify_contrib.sh sdr 64 10
  ./verify_contrib.sh sdr 64 11
  ./verify_contrib.sh sdr 64 12
  ./verify_contrib.sh sdr 64 13
  ./verify_contrib.sh sdr 64 14
  ./verify_contrib.sh sdr 64 15
  ./verify_contrib.sh sdr 64 16
  ./verify_final.sh sdr 64

  ./verify_initial.sh window 32
  ./verify_contrib.sh window 32 1
  ./verify_contrib.sh window 32 2
  ./verify_contrib.sh window 32 3
  ./verify_contrib.sh window 32 4
  ./verify_contrib.sh window 32 5
  ./verify_contrib.sh window 32 6
  ./verify_contrib.sh window 32 7
  ./verify_contrib.sh window 32 8
  ./verify_contrib.sh window 32 9
  ./verify_contrib.sh window 32 10
  ./verify_contrib.sh window 32 11
  ./verify_contrib.sh window 32 12
  ./verify_contrib.sh window 32 13
  ./verify_contrib.sh window 32 14
  ./verify_contrib.sh window 32 15
  ./verify_final.sh window 32

  ./verify_initial.sh window 64
  ./verify_contrib.sh window 64 1
  ./verify_contrib.sh window 64 2
  ./verify_contrib.sh window 64 3
  ./verify_contrib.sh window 64 4
  ./verify_contrib.sh window 64 5
  ./verify_contrib.sh window 64 6
  ./verify_contrib.sh window 64 7
  ./verify_contrib.sh window 64 8
  ./verify_contrib.sh window 64 9
  ./verify_contrib.sh window 64 10
  ./verify_contrib.sh window 64 11
  ./verify_contrib.sh window 64 12
  ./verify_contrib.sh window 64 13
  ./verify_contrib.sh window 64 14
  ./verify_contrib.sh window 64 15
  ./verify_final.sh window 64
'
```

