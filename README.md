# DT's Laser eye Analysis 

### Layout

There are two types of files, data files in data/ and scripts in scripts/. 

### Where to Start

##### GTC Accounts

[gtc_accounts.json](data/gtc_accounts.json) is the master list of all gtc accounts (both seed and ect) fromm this
[gtc_accounts/src/lib.rs](https://gitlab.com/dfinity-lab/public/ic/-/blob/master/rs/nns/gtc_accounts/src/lib.rs?ref_type=heads).
It's currently a json array that does not distinguish between ect and seed neurons, although it can easily be extended 
in the future. 

[gtc_accounts_master.json](data/gtc_accounts_master.json) is the full dump of all accounts from the gtc canister. This was
produced by running the [gtc_neuron_ids.py](scripts/gtc_neuron_ids.py) with the following command

```
$ python3 scripts/gtc_neuron_ids.py
```

This file is very useful since it's a json dump of the state of gtc and can be converted easily to any other format,
and can be used to run simulations on nns governance neurons.

##### Interesting Queries

You can run whatever data analysis tools you like to process the data, but since this is in json format, I'll use 
[jq](https://jqlang.github.io/jq/) to run command line queries against the data.

1. Determine all unclaimed accounts (included all unclaimed + donated + forwarded) [data/unclaimed.json](data/unclaimed.json):

```shell
$ cat data/gtc_accounts_master.json | jq  '.[] | select(.has_claimed == false) | {account} ' | jq --slurp
[
  {
    "account": "83e479fe475b5668882a549552a7d42fbbc786b4"
  },
  ... 
  {
    "account": "ee691e851bdfc37ad8b65f26596d35949aadbf85"
  }
]

```

2. Determine the forwarded accounts [data/forwarded.json](data/forwarded.json):

```shell
$ cat data/gtc_accounts_master.json | jq  '.[] | select(.has_forwarded == true) | {account} ' | jq --slurp

[
  {
    "account": "5a9dac9315fdd1c3d13ef8af7fdfeb522db08f02"
  },
  {
    "account": "7954a09303b1958f65bd1cb48f0d61ce63a9e5ae"
  },
  {
    "account": "b98c1a42aac4cca0581b558f21e3a62fe3d9cd51"
  },
  {
    "account": "e1010ab2dd3974f2dea3a9e271ea70aab079f1f3"
  }
]
```

3. Determine the donated accounts [data/donated.json](data/donated.json)::
```shell
$ cat data/gtc_accounts_master.json | jq  '.[] | select(.has_donated == true) | {account} ' | jq --slurp
[
  {
    "account": "b52c17c8e05daf2048725d60843c8625ce81b2b2"
  },
  {
    "account": "ddab0f08f8557e764fdc04397bf4f1c517339c61"
  },
  {
    "account": "e02eeb65709906cb5ab20b084067984b97d591c2"
  },
  {
    "account": "e6abfef24d51b2591edfb992fb96d4bf6860ffc7"
  }
]
```