# Secure Generic Remote Workflow Execution with TEEs

Our reference paper is [this](https://doi.org/10.1145/3642978.3652834), to cite us use the following:

`@inproceedings{10.1145/3642978.3652834,
author = {Brescia, Lorenzo and Aldinucci, Marco},
title = {Secure Generic Remote Workflow Execution with TEEs},
year = {2024},
isbn = {9798400705465},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/3642978.3652834},
doi = {10.1145/3642978.3652834},
abstract = {In scientific environments, the frequent need to process substantial volumes of data poses a common challenge. Individuals tasked with executing these computations frequently encounter a deficit in local computational resources, leading them to opt for the facilities of a Cloud Service Provider (CSP) for data processing. However, the data subjected to these calculations may be subject to confidentiality constraints. This paper introduces a proof-of-concept framework that leverages Gramine LibOS and Intel SGX, enabling the protection of generic remote workflow computations through SGX enclaves as Trusted Execution Environments (TEEs). The framework entails the delineation of user and CSP behavior and has been implemented using Bash scripts. Furthermore, an infrastructure has been designed for the Data Center Attestation Primitives (DCAP) remote attestation mechanism, wherein the user gains trust in the proper instantiation of the enclave within the CSP. To assess the framework efficacy, it has been tested on two distinct workflows, one trivial and the other involving real-world bioinformatics applications for processing DNA data. The performance study revealed that the framework incurred an acceptable overhead, ranging from a factor of x1.4 to x1.8 compared to unsafe execution practice.},
booktitle = {Proceedings of the 2nd Workshop on Workflows in Distributed Environments},
pages = {8–13},
numpages = {6},
keywords = {trusted execution environment, workflow, Intel SGX, gramine, privacy-preserving, confidential computing},
location = {Athens, Greece},
series = {WiDE '24}
}`

## Prerequisites
1. Gramine in both User and CSP machines
2. A DCAP remote attestation infrastructure. It is not an easy task, you can refer to this our complete [guide](https://github.com/lorenzobrescia/sgx)


## How To Use
In the `user/examples/C-PY` folder there are all the necessary Bash scripts to run a workflow. In the `pipeline.sh` file is possible to customize some envirnonment variables such as the ssh CSP machine and starting folder.

Also it is necessary to customize and fill files on the CSP machine. In particular all the `manifest.template` files:
- `/csp/CSP_BASE_PATH/c/manifest.template`
- `/csp/CSP_BASE_PATH/py/manifest.template`

**Note the TRIM-BOW workflow is not implemented as example because require to publicize confidential DNA reads data**