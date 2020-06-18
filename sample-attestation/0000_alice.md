
# Participant Attestation

Name: Alice

Organization: Filecoin

Attestation Signing Key: https://keybase.io/alice_filecoin

Circuit ID: PoRep-Poseidon-32GiB-e6055a1

Participant Number: 0

### Hardware

Instance Type (optional, if applicable): Aliyun ECS (ecs.c5.8xlarge) HK region

Processor (`lscpu | grep "Model name"`): Intel(R) Xeon(R) Platinum 8275CL CPU @ 3.00GHz

Available RAM (optional, `free -g`): 182GiB

Nuber of Processors (optional, `nproc`): 96

### Files

#### Phase1.5 File

- Download URL: https://trusted-setup.s3.eu-central-1.amazonaws.com/phase1radix2m27

- BLAKE2 Digest: ae2b5dd4dfafeb8f90491fa5567c4177f4e60f15bed429c6fbe892dacb128eedb9b8978706b906ff633193fe3f0ea9d3856982c047a24af82bd6feda522afd2b

#### Phase2 File Containing The Circuit's Initial Parameters

- Upload URL: https://trusted-setup.s3.eu-central-1.amazonaws.com/porep_poseidon_32gib_e6055a1_0

- BLAKE2 Digest: ffffffffdfafeb8f90491fa5567c4177f4e60f15bed429c6fbe892dacb128eedb9b8978706b906ff633193fe3f0ea9d3856982c047a24af82bd6feda12345678

### Log

```
$ RUST_BACKTRACE=1 RUST_LOG=info ./target/release/phase2 new --porep --poseidon --32gib
18:49:43 [ INFO] creating new params for circuit: PoRep Poseidon 32GiB e6055a1
18:55:54 [ INFO] successfully created params for circuit, dt_create_circuit=2s, dt_create_params=368s
18:55:54 [ INFO] writing params to file: porep_poseidon_32gib_e6055a1_0
18:55:59 [ INFO] successfully created params for circuit: PoRep Poseidon 32GiB, dt=375s
```
