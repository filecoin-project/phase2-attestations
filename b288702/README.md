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

**Note: We recommend you use a machine with 96 cores and 120GB of RAM for running verification**

1. Build `rust-fil-proofs`, please also check its [Rust installation/build instructions](https://github.com/filecoin-project/rust-fil-proofs/blob/6e38487293a2ec063688acb4a414600b1c0654f9/README.md#install-and-configure-rust):

```bash
$ git clone https://github.com/filecoin-project/rust-fil-proofs.git
$ cd rust-fil-proofs
$ git checkout 6e38487
$ cargo build --release --bin phase2 && cp target/release/phase2 .
```

2. Download checksums file and verification script:

```bash
$ curl -O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/b80d1f8/b288702/b288702.b2sums \
-O https://raw.githubusercontent.com/filecoin-project/phase2-attestations/b80d1f8/b288702/verify_all.sh && chmod +x verify_all.sh
```

3. Verify Phase2 contributions:

In order to run the verifcation, you will need to download the relevant Phase 1 file for the circuit and run the verification script for that specific circuit. The verification script will verify all Phase 2 contributions made to the Groth16 parameters for a circuit of that specific size and check that the verified Groth16 parameters are being used by the Filecoin network. The commands and associated Phase 1 file for each circuit are listed below.

**Winning-PoSt**

* Download the Phase 1 file `phase1radix2m19`.

```
$ curl -O https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m19
$ ./verify_all.sh winning 32
…
$ ./verify_all.sh winning 64
```

**SDR-PoRep and Window-PoSt**

* Download the Phase 1 file `phase1radix2m27`.

```bash
$ curl -O https://trusted-setup.s3.amazonaws.com/challenge19/phase1radix2m27
$ ./verify_all.sh sdr 32
…
$ ./verify_all.sh sdr 64
…
$ ./verify_all.sh window 32
…
$ ./verify_all.sh window 64
```
