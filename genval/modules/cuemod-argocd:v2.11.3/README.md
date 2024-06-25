# Genval workspace for managing Kubernertes configuration files


This directory structure serves as a foundational workspace for generating and validating ArgoCD manifests.


├── input
├── policy
└── README.md
```

- `input` Directory: This directory is designated for storing all manifests that users intend to generate from or validate against specific Cuelang policies. When using the `genval cue` command, this directory should be specified with the `--reqinput` flag.

- `policy` Directory: This directory is reserved for maintaining **Cuelang** definitions, referred to as policies in the context of Genval. When executing the `genval cue` command, this directory should be provided with the `--policy` flag.