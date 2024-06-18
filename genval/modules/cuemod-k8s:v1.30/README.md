# Genval workspace for managing Kubernertes configuration files

This directory structure contains a bare bone workspace for users to generate and validate Kubernetes manifesdts.

```shell
.
├── cue.mod
├── input
├── policy
└── README.md
```

The `input` directory is a placeholder directory for housing all the manifests a user wants to generate from or validate against certain **Cuelang** policies. This is the directory that needs to be supplied to the `genval cue` commands `--reqinput` flag.

The `policy` directory is a placeholder directory for manintaining **Cuelang** definitions — policies in Genval's terms. This is the directory that needs to be provided to the `--policy` flag of `genval cue` command.